#!/usr/bin/env bash

discussionId="284489" #jede bagr

source functions/load_config.shl
source functions/nyx_discussion_send.shl
config_file="config.conf"

set -x
set -e
nyx_discussion_send "Ahoj lamo" "${discussionId}"

