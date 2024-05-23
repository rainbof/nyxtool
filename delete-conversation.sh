#!/usr/bin/env bash

declare -a all_postid
discussionId="284395" #zejtra to smazu
#discussionId="284489" #jede bagr

source functions/load_config.shl
source functions/nyx_discussion_send.shl

config_file="config.conf"

load_config
response=$(curl -s -X GET "https://nyx.cz/api/discussion/${discussionId}" -H "Authorization: Bearer ${token}" -H 'accept: application/json')

readarray -t all_postid < <(jq '.posts[] | select(.discussion_id == '${discussionId}') | .id' <<< "${response}")

for id in "${all_postid[@]}"; do
    printf 'Post ID: %s' "${id} ... "
    out=$(curl -s -X DELETE "https://nyx.cz/api/discussion/${discussionId}/delete/${id}" -H "Authorization: Bearer ${token}" -H 'accept: application/json')
    if [[ "${out}" == "{}" ]] ; then
        printf 'ok - ' 
    else 
        printf '%s' "${out}"
    fi
    printf 'deleted\n'
done

    nyx_discussion_send "Mam na vas otazku: mam diskusi i nadale zacinat nejakou uvodni vetou ? Nebo to mam nechat jentak ? Nabizi se i moznost ze by se tahle veta vylosovala. Ovsem je otazkou zda to nevybocuje ze zamysleneho ramce Zitra to smazu..." "${discussionId}" "text"
