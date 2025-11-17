*** Settings ***
Library    SSHLibrary
Resource    api.resource

*** Keywords ***
Retry test
    [Arguments]    ${keyword}
    Wait Until Keyword Succeeds    60 seconds    1 second    ${keyword}

Backend URL is reachable
    ${rc} =    Execute Command    curl -f ${backend_url}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0


*** Test Cases ***
Check if sogo is installed correctly
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Suite Variable    ${module_id}    ${output.module_id}

Check if sogo can be configured
    ${rc} =    Execute Command    api-cli run module/${module_id}/configure-module --data '{"activesync": true,"admin_users": "administrator","auxiliary_account": true,"dav": true,"host": "sogo.domain.org","lets_encrypt": false,"mail_domain": "domain.org","mail_server": "cb473352-dfcf-420e-89c5-54aeee478a68","workers_count": "3"}'
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

Retrieve sogo backend URL
    # Assuming the test is running on a single node cluster
    ${response} =    Run task     module/traefik1/get-route    {"instance":"${module_id}"}
    Set Suite Variable    ${backend_url}    ${response['url']}

Check if sogo works as expected
    Retry test    Backend URL is reachable

Verify sogo frontend title
    ${output} =    Execute Command    curl -s ${backend_url}/SOGo/
    Should Contain    ${output}    <title sg-default="SOGo">SOGo</title>

Check if sogo is removed correctly
    ${rc} =    Execute Command    remove-module --no-preserve ${module_id}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0
