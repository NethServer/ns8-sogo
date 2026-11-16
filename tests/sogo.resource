*** Settings ***
Library    SSHLibrary
Resource    api.resource

*** Variables ***
${dav_user}        u3
${dav_password}    Nethesis,1234

*** Keywords ***
Sogo backend URL
    ${node} =    Execute Command    runagent -m ${sogo_module_id} printenv NODE_ID
    ${traefik} =    Execute Command    redis-cli get node/${node.strip()}/default_instance/traefik
    ${route} =    Run task    module/${traefik.strip()}/get-route    {"instance":"${sogo_module_id}"}
    RETURN    ${route}[url]

Sogo answers
    ${url} =    Sogo backend URL
    ${out} =    Execute Command    curl -s ${url}/SOGo/
    Should Contain    ${out}    <title sg-default="SOGo">SOGo</title>

Calendar URL
    ${url} =    Sogo backend URL
    RETURN    ${url}/SOGo/dav/${dav_user}/Calendar/personal

Save event
    [Arguments]    ${uid}    ${summary}
    ${calendar} =    Calendar URL
    ${out}    ${err}    ${rc} =    Execute Command
    ...    printf 'BEGIN:VCALENDAR\\r\\nVERSION:2.0\\r\\nPRODID:-//ns8-sogo//tests//EN\\r\\nBEGIN:VEVENT\\r\\nUID:${uid}\\r\\nDTSTAMP:20300101T000000Z\\r\\nDTSTART:20300101T100000Z\\r\\nDTEND:20300101T110000Z\\r\\nSUMMARY:${summary}\\r\\nEND:VEVENT\\r\\nEND:VCALENDAR\\r\\n' | curl -sS -f -u ${dav_user}:'${dav_password}' -X PUT -H 'Content-Type: text/calendar; charset=utf-8' --data-binary @- ${calendar}/${uid}.ics
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}

Event should exist
    [Arguments]    ${uid}    ${summary}
    ${calendar} =    Calendar URL
    ${out}    ${err}    ${rc} =    Execute Command
    ...    curl -sS -f -u ${dav_user}:'${dav_password}' ${calendar}/${uid}.ics
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}
    Should Contain    ${out}    SUMMARY:${summary}

Contacts URL
    ${url} =    Sogo backend URL
    RETURN    ${url}/SOGo/dav/${dav_user}/Contacts/personal

Save contact
    [Arguments]    ${uid}    ${name}
    ${contacts} =    Contacts URL
    ${out}    ${err}    ${rc} =    Execute Command
    ...    printf 'BEGIN:VCARD\\r\\nVERSION:3.0\\r\\nUID:${uid}\\r\\nFN:${name}\\r\\nN:${name};;;;\\r\\nEND:VCARD\\r\\n' | curl -sS -f -u ${dav_user}:'${dav_password}' -X PUT -H 'Content-Type: text/vcard; charset=utf-8' --data-binary @- ${contacts}/${uid}.vcf
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}

Contact should exist
    [Arguments]    ${uid}    ${name}
    ${contacts} =    Contacts URL
    ${out}    ${err}    ${rc} =    Execute Command
    ...    curl -sS -f -u ${dav_user}:'${dav_password}' ${contacts}/${uid}.vcf
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}
    Should Contain    ${out}    FN:${name}

Module environment
    [Arguments]    ${name}
    ${out} =    Execute Command    runagent -m ${sogo_module_id} printenv ${name}
    RETURN    ${out.strip()}
