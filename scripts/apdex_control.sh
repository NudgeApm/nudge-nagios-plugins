#!/bin/bash

# This script uses Nudge APM to control APDEX of an application.
# Requirements:
# - bc (https://www.gnu.org/software/bc/)

# Expected parameters are :
# $1: Nudge API Token
# $2: Application ID (you can get it with api request https://monitor.nudge-apm.com/api/apps)
#     warning: this ID differs from the probe token

# service URL, this should be changed in on-prem environments
NUDGE_URL="https://monitor.nudge-apm.com"

# authentification
API_TOKEN="${1}"

# application ID
APP_ID="${2}"

# time frame
TIME_FRAME="-10m"

# warn threashold
WARN_THRES="0.9"

# crit threashold
CRIT_THRES="0.8"

## Processing

API_COMMAND="apps/$APP_ID/metrics/summary?metrics=apdex&from=$TIME_FRAME"
json=`curl -s $NUDGE_URL/api/$API_COMMAND -H "Authorization: Bearer $API_TOKEN"`
apdex=${json:9:5}
if (( $(echo "$apdex < $CRIT_THRES" | bc -l) )); then
  echo "CRITICAL"
  exit 2
elif (( $(echo "$apdex < $WARN_THRES" | bc -l) )); then
  echo "WARNING"
  exit 1
fi
echo "OK"
exit 0
