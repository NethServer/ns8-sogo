*** Settings ***
Library    SSHLibrary
Resource    api.resource
Resource    sogo.resource

*** Variables ***
${mail_domain}    domain.test
${smtp_url}    smtp://127.0.0.1:10587

*** Keywords ***
Inbox should list
    [Arguments]    ${subject}
    ${url} =    Sogo backend URL
    ${out}    ${err}    ${rc} =    Execute Command
    ...    bash /tmp/sogo-inbox.sh ${url} ${dav_user} '${dav_password}'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}
    Should Contain    ${out}    ${subject}

*** Test Cases ***
Log in to the web interface
    ${url} =    Sogo backend URL
    ${out}    ${err}    ${rc} =    Execute Command
    ...    curl -sS -f -H 'Content-Type: application/json' -d '{"userName":"${dav_user}","password":"${dav_password}"}' ${url}/SOGo/connect
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}
    Should Contain    ${out}    "username"

A wrong password is refused by the web interface
    ${url} =    Sogo backend URL
    ${rc} =    Execute Command
    ...    curl -sS -f -o /dev/null -H 'Content-Type: application/json' -d '{"userName":"${dav_user}","password":"wrong"}' ${url}/SOGo/connect
    ...    return_rc=True    return_stdout=False
    Should Not Be Equal As Integers    ${rc}    0

Save a contact
    ${stamp} =    Evaluate    time.time_ns()    modules=time
    Save contact    contact-${stamp}    Contact ${stamp}
    Contact should exist    contact-${stamp}    Contact ${stamp}

Read the inbox through the web interface
    ${stamp} =    Evaluate    time.time_ns()    modules=time
    ${subject} =    Set Variable    inbox-${stamp}
    ${out}    ${err}    ${rc} =    Execute Command
    ...    printf 'From: <u1@${mail_domain}>\\r\\nTo: <${dav_user}@${mail_domain}>\\r\\nSubject: ${subject}\\r\\nMessage-ID: <${subject}@${mail_domain}>\\r\\nDate: %s\\r\\n\\r\\nRead through SOGo.\\r\\n' "$(date -R)" | curl -s --url ${smtp_url} --mail-from u1@${mail_domain} --mail-rcpt ${dav_user}@${mail_domain} --upload-file -
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}
    Put File    ${CURDIR}/sogo-inbox.sh    /tmp/sogo-inbox.sh
    Wait Until Keyword Succeeds    60 seconds    3 seconds    Inbox should list    ${subject}

ActiveSync answers
    ${url} =    Sogo backend URL
    # A device asks for the protocol versions with OPTIONS before any sync.
    ${out}    ${err}    ${rc} =    Execute Command
    ...    curl -sS -f -i -X OPTIONS -u ${dav_user}:'${dav_password}' '${url}/Microsoft-Server-ActiveSync?User=${dav_user}&DeviceId=robot1234&DeviceType=robot'
    ...    return_rc=True    return_stderr=True
    Should Be Equal As Integers    ${rc}    0    ${err}
    Should Contain    ${out}    MS-ASProtocolVersions    ignore_case=True
