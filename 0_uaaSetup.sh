#!/bin/sh
# set some variables
. ./setVars.sh
# This script - adds a new uaac client, and uses this client to create new groups in UAA - which will correspond to granted authorities in our apps
uaac target $UAA_ENDPOINT --skip-ssl-validation
uaac token client get $UAA_ADMIN_CLIENT_ID -s $UAA_ADMIN_CLIENT_SECRET
uaac client add $UAA_ZONEADMIN_CLIENT_ID --authorities zones.write,scim.zones,zones.$UAA_IDENTITY_ZONE_ID.admin --scope zones.$UAA_IDENTITY_ZONE_ID.admin --authorized_grant_types client_credentials,password -s $UAA_ZONEADMIN_CLIENT_SECRET

uaac target $UAA_ENDPOINT --skip-ssl-validation
uaac token client get $UAA_ZONEADMIN_CLIENT_ID -s $UAA_ZONEADMIN_CLIENT_SECRET
uaac group add pivotal.bank -z pivotal-bank-sso
uaac group add trade -z pivotal-bank-sso
uaac group add account -z pivotal-bank-sso
uaac group add portfolio -z pivotal-bank-sso
