*** Settings ***
Library    SSHLibrary
Resource    api.resource

*** Variables ***
${curl_timeout}    9

*** Keywords ***
Retry test
    [Arguments]    ${keyword}
    Wait Until Keyword Succeeds    60 seconds    1 second    ${keyword}

Backend URL is reachable
    ${rc} =    Execute Command    curl -f ${backend_url}/SOGo/
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0


*** Test Cases ***
Check if sogo is installed correctly
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Global Variable    ${sogo_module_id}    ${output.module_id}

Check if we can retrieve the mail module ID
    FOR    ${i}    IN RANGE    30
        ${ocfg} =   Run task    module/${sogo_module_id}/get-configuration    {}
        Log    ${ocfg}
        Run Keyword If    ${ocfg}    Exit For Loop
        Sleep    2s
    END
    Set Suite Variable     ${mail_modules_id}    ${ocfg['mail_server_URL'][0]['value']}
    Should Not Be Empty    ${mail_modules_id}

Check if sogo can be configured
    ${mail_server_uuid}    ${mail_domain}=    Evaluate    "${mail_modules_id}".split(",")
    ${rc} =    Execute Command    api-cli run module/${sogo_module_id}/configure-module --data '{"activesync": true,"admin_users": "administrator","auxiliary_account": true,"dav": true,"host": "sogo.domain.org","lets_encrypt": false,"mail_domain": "${mail_domain}","mail_server": "${mail_server_uuid}","workers_count": "3"}'
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Retrieve sogo backend URL
    # Assuming the test is running on a single node cluster
    ${response} =    Run task     module/traefik1/get-route    {"instance":"${sogo_module_id}"}
    Set Suite Variable    ${backend_url}    ${response['url']}

Check if sogo works as expected
    Retry test    Backend URL is reachable

Verify sogo frontend title
    ${output} =    Execute Command    curl -s ${backend_url}/SOGo/
    Should Contain    ${output}    <title sg-default="SOGo">SOGo</title>

Login to SOGo as user u3@domain.test via the calendar
    ${output}    ${err}    ${rc} =    Execute Command
    ...    curl -sS -u u3:'Nethesis,1234' -X PROPFIND -H "Depth: 1" ${backend_url}/SOGo/dav/u3/Calendar/personal/
    ...    return_rc=True
    ...    return_stdout=True
    ...    return_stderr=True
    Log    Curl stdout: ${output}
    Log    Curl stderr: ${err}
    Log    Curl rc: ${rc}
    Should Contain    ${output}    <D:status>HTTP/1.1 200 OK</D:status>
    Should Contain    ${output}    <D:href>/SOGo/dav/u3/Calendar/personal/</D:href>
