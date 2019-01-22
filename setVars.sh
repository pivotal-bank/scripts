#!/bin/sh

# set some variables

# Location of you cf-SpringBootTrader project, e.g. /Users/skazi/GitHub/cf-SpringBootTrader
export BASE_DIR=/Users/srowe/workspace/pivotal-bank/cf-SpringBootTrader
# This shouldn't need changing, it is the URL used for Config Server
GITHUB_URI=https://github.com/simonrowe-pivotal/cf-SpringBootTrader-config.git
GITHUB_BRANCH=development


UAA_ENDPOINT=https://uua-endpoint-replace-me
UAA_ADMIN_CLIENT_ID=replace-me
UAA_ADMIN_CLIENT_SECRET=replace-me
UAA_IDENTITY_ZONE_ID=replace-me
UAA_ZONEADMIN_CLIENT_ID=pivotal-bank-admin
UAA_ZONEADMIN_CLIENT_SECRET=pivotal-bank-admin-secret

NEW_RELIC_SERVICE_PLAN=UK-PA-Team-plan
