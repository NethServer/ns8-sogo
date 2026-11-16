*** Settings ***
Library    SSHLibrary
Resource    api.resource
Resource    sogo.resource
# 20_sogo installed the stable release in this scenario; move it to the image
# under test and check the calendar data is still there.
Suite Setup    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}, nothing to update

*** Variables ***
${SCENARIO}    install

*** Test Cases ***
Save an event with the stable release
    ${stamp} =    Evaluate    time.time_ns()    modules=time
    Set Suite Variable    ${uid}    pre-update-${stamp}
    Save event    ${uid}    Saved before the update
    Event should exist    ${uid}    Saved before the update

Update to the image under test
    ${rc} =    Execute Command
    ...    api-cli run update-module --data '{"module_url":"${IMAGE_URL}","instances":["${sogo_module_id}"],"force":true}'
    ...    return_rc=True    return_stdout=False
    Should Be Equal As Integers    ${rc}    0
    ${image} =    Module environment    IMAGE_URL
    Should Be Equal    ${image}    ${IMAGE_URL}

Sogo runs after the update
    Wait Until Keyword Succeeds    120 seconds    5 seconds    Sogo answers

The event is still there after the update
    Event should exist    ${uid}    Saved before the update

A new event is saved after the update
    Save event    ${uid}-after    Saved after the update
    Event should exist    ${uid}-after    Saved after the update
