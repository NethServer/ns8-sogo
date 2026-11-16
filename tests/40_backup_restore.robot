*** Settings ***
Library    SSHLibrary
Resource    api.resource
Resource    sogo.resource

*** Keywords ***
The restore has run
    # Without it the checks below would pass against the old module.
    Should Be True    ${restored}    the restore did not complete

*** Test Cases ***
Save an event before the backup
    ${stamp} =    Evaluate    time.time_ns()    modules=time
    Set Suite Variable    ${uid}    pre-backup-${stamp}
    Save event    ${uid}    Saved before the backup
    Event should exist    ${uid}    Saved before the backup
    ${uuid} =    Module environment    MODULE_UUID
    ${node} =    Module environment    NODE_ID
    ${host} =    Module environment    TRAEFIK_HOST
    ${mail} =    Module environment    MAIL_SERVER
    Set Suite Variable    ${module_uuid}    ${uuid}
    Set Suite Variable    ${module_node}    ${node}
    Set Suite Variable    ${traefik_host}    ${host}
    Set Suite Variable    ${mail_server}    ${mail}
    Set Suite Variable    ${old_module_id}    ${sogo_module_id}
    Set Suite Variable    ${restored}    ${FALSE}

Use the node local backup repository
    # A repository URL must be unique: reuse the node's one if it exists.
    ${ip} =    Execute Command    redis-cli hget node/${module_node}/vpn ip_address
    ${url} =    Set Variable    webdav:http://${ip.strip()}:4694
    ${repos} =    Run task    cluster/list-backup-repositories    {}
    ${found} =    Evaluate    [r['id'] for r in $repos['repositories'] if r['url'] == $url]
    IF    ${found}
        Set Suite Variable    ${repository}    ${found}[0]
        Set Suite Variable    ${repository_created}    ${FALSE}
    ELSE
        ${out} =    Run task    cluster/add-backup-repository
        ...    {"provider":"cluster","name":"sogo-test","url":"${url}","password":"","parameters":{}}
        Set Suite Variable    ${repository}    ${out}[id]
        Set Suite Variable    ${repository_created}    ${TRUE}
    END

Back up sogo
    # run-backup skips a disabled backup, so enable it on a far schedule.
    ${bid} =    Run task    cluster/add-backup
    ...    {"name":"sogo-test","instances":["${sogo_module_id}"],"repository":"${repository}","schedule":"*-12-31 03:17:00","retention":1,"enabled":true}
    Set Suite Variable    ${backup_id}    ${bid}
    # Synchronous: it returns once every node has finished its part.
    Run task    cluster/run-backup    {"id":${backup_id}}
    ${snapshots} =    Run task    cluster/read-backup-snapshots
    ...    {"repository":"${repository}","path":"sogo/${module_uuid}"}
    Should Not Be Empty    ${snapshots}
    Set Suite Variable    ${snapshot}    ${snapshots}[-1][id]

Restore sogo in place
    ${out} =    Run task    cluster/restore-module
    ...    {"repository":"${repository}","path":"sogo/${module_uuid}","snapshot":"${snapshot}","node":${module_node},"replace":true}
    Should Be Equal    ${out}[module_uuid]    ${module_uuid}
    Should Not Be Equal    ${out}[module_id]    ${old_module_id}
    # 90__uninstall removes the module by this name.
    Set Global Variable    ${sogo_module_id}    ${out}[module_id]
    Set Suite Variable    ${restored}    ${TRUE}
    ${rc} =    Execute Command    runagent -m ${old_module_id} true
    ...    return_rc=True    return_stdout=False
    Should Not Be Equal As Integers    ${rc}    0    ${old_module_id} must be gone after a replace

Sogo runs again after the restore
    [Setup]    The restore has run
    # The restore runs configure-module again, which recreates the route.
    Wait Until Keyword Succeeds    120 seconds    5 seconds    Sogo answers

The configuration is restored as it was
    [Setup]    The restore has run
    ${host} =    Module environment    TRAEFIK_HOST
    Should Be Equal    ${host}    ${traefik_host}
    ${mail} =    Module environment    MAIL_SERVER
    Should Be Equal    ${mail}    ${mail_server}

The event is restored
    [Setup]    The restore has run
    Event should exist    ${uid}    Saved before the backup

A new event is saved after the restore
    [Setup]    The restore has run
    Save event    ${uid}-after    Saved after the restore
    Event should exist    ${uid}-after    Saved after the restore

Remove the test backup
    Run task    cluster/remove-backup    {"id":${backup_id}}
    IF    ${repository_created}
        Run task    cluster/remove-backup-repository    {"id":"${repository}"}
    END
