#!/bin/bash

# This script uses Nudge APM to control if a specific transaction
# identified by its name has been executed recently

# Expected parameters are :
# $1: Nudge login allowed to allowed to view the application
# $2: Nudge password of user $1
# $3: Application ID (you can get it with api request https://monitor.nudge-apm.com/api/apps)
#     warning: this ID differs from the probe token
# $4: Transaction name to check
# $5: Number of minutes without execution before WARNING nagios status
# $6: Number of minutes without execution before CRITICAL nagios status

# service URL, this should be changed in on-prem environments
NUDGE_URL="https://monitor.nudge-apm.com"

# authentification
LOGIN="${1}"
PASSWORD="${2}"

# application ID
APP_ID="${3}"

# transaction name expected
TRANSACTION_REQUIRED="${4}"

# query delay
WARN_THRES="-${5}m"
CRIT_THRES="-${6}m"

## Processing

# authentication
cookie=`curl -s -X POST "$NUDGE_URL/login/usrpwd" -d "id=$LOGIN&pwd=$PASSWORD" -i|awk '{if($1=="Set-Cookie:"){c=c $2;}}END{print c;}'`

# API verify status function
nudge_status() {
  API_COMMAND="apps/$APP_ID/rawdata?from=$WARN_THRES"
  status_result=`curl -s $NUDGE_URL/api/$API_COMMAND -b "$cookie"|grep "collecte"`
}


# API query function
request() {
  # query the API and filter the result (grep) to check if expected transaction is there
  API_COMMAND="apps/$APP_ID/transactions?from=$1"
  result=`curl -s $NUDGE_URL/api/$API_COMMAND -b "$cookie"|grep "\"code\":\"$TRANSACTION_REQUIRED\""`
}

# Control for warning and critical threashold then echo message and exit with nagios status
nudge_status
if [ "$status_result" != "" ]; then
  request $WARN_THRES
  if [ "$result" == "" ]; then
    request $CRIT_THRES
    if [ "$result" == "" ]; then
      echo CRICITAL - transaction $TRANSACTION_REQUIRED not launched during last $CRIT_THRES
      exit 2
    fi
    echo WARNING - transaction $TRANSACTION_REQUIRED not launched during last $WARN_THRES
    exit 1
  fi
fi

echo OK - transaction $TRANSACTION_REQUIRED launched during last $WARN_THRES
exit 0


