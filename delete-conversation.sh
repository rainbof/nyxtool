#!/usr/bin/env bash

declare -a all_postid
#discussionId="284395" #zejtra to smazu
discussionId="284489" #jede bagr

source functions/load_functions.shl
load_functions

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

message='Krleš'
nyx_discussion_send "${message}" "${discussionId}" "text"
