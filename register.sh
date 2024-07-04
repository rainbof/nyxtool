#!/usr/bin/env bash

username="rainbof"
app_name="mazac diskuse"
config_file="config.conf"
token=""

source functions/load_functions.shl
load_functions

function save_config()
{
    printf "username=\"${username}\"\napp_name=\"${app_name}\"\ntoken=\"${token}\"\n" > "${config_file}"
}

function get_nyx_auth_token()
{
    local response
    local confirmation_code
    local token

    response_json="$(curl -sS --location --request POST "https://nyx.cz/api/create_token/${username}" -A "${app_name}")"
    confirmation_code="$(jq -r '.confirmation_code' <<<${response_json})"
    token="$(jq -r '.token' <<<${response_json})"

    printf "Nyni jdi na URL https://nyx.cz/profile/${username}/settings/authorizations a vloz nasledujici token k aplikaci ${app_name}:\n"
    printf "${confirmation_code}\n"
    save_config "${config_file}"

    echo "response: ${response_json}"
}


function check_token()
{

    local msg
    msg="${app_name} otestoval token v $(date)"
    
    response=$(nyxapi_send "api/mail/send" "recipient=${username}&message=${msg}&format=text")
    error="$(jq -r '.error.code' <<< "${response}")"

    if [[ "${error}" == "401" ]] ; then
        printf "autorizace jeste neni dokoncena. Pokud jsi potvrzovaci kod ztratil, smaz soubor ${config_file} a spust znovu tento skript.\n"
    fi
}
if ! load_config "${config_file}" || [[ -z "${token}" ]]; then
    printf 'zda se ze nemas token, takze ho ziskam\n'
    get_nyx_auth_token
    load_config
fi
check_token
