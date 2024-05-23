#!/usr/bin/env bash

discussionId="284489" #jede bagr

source functions/load_config.shl
source functions/nyx_discussion_send.shl
config_file="config.conf"

set -x
set -e
load_config

txt="Krleš in $(date)"
nyx_discussion_send "${txt}" "${discussionId}" "text"
