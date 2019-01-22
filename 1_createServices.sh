#!/bin/sh

# This script:
#   1) Reads PCFServices.list
#   2) Creates the Services
#      a) Hack 1 - handle the correct quotations for Github URI
#      b) Hack 2 - handles changed name of MySQL plan between PCF versions

#set -x
source ./commons.sh

checkEnvHasSCS(){
  DiscovInstalled=`cf marketplace | grep p-service-registry`
  if [[ -z $DiscovInstalled ]]
  then
    echo "The targeted PCF environment does not have Service Discovery in the marketplace, installation will now halt."
    exit 1
  fi
}


create_single_service()
{
  line="$@"
  SI=`echo "$line" | cut -d " " -f 3`
  EXISTS=`cf services | grep ${SI} | wc -l | xargs`
  if [ $EXISTS -eq 0 ]
  then
    echo "About to create: $line"
    if [[ $line == *"p-config-server"*  &&  ! -z "$GITHUB_URI" ]]
    then
      #Annoying hack because of quotes, single quotes etc ....
      GIT=`printf '{"git":{"uri":"%s","label":"%s"}}\n' "${GITHUB_URI}" ${GITHUB_BRANCH}`
      cf create-service $line -c ''$GIT''
    elif [[ $line == *"p-mysql"* ]]
    then
      #Yet another annoying hack ....
      PCF_PLAN=`cf marketplace -s p-mysql | grep 100mb | cut -d " " -f1 | xargs`
      cf create-service p-mysql $PCF_PLAN $SI
    elif [[ $line == *"uaa-admin"* ]]
    then
      UAA_ADMIN_CREDENTIALS=`printf '{"client-id":"%s","client-secret":"%s"}\n' "${UAA_ZONEADMIN_CLIENT_ID}" ${UAA_ZONEADMIN_CLIENT_SECRET}`
      cf create-user-provided-service uaa-admin -p ''$UAA_ADMIN_CREDENTIALS''
    elif [[ $line == *"newrelic"* ]]
    then
      cf create-service newrelic ''$NEW_RELIC_SERVICE_PLAN'' newrelic
    else
      cf create-service $line
    fi
    scs_service_created=1
    echo "Created: $line"
  else
    echo_msg "${SI} already exists"
  fi
}

create_all_services()
{
  scs_service_created=0

  # Read all the services that need to be created
  file="./PCFServices.list"
  while IFS= read -r line 
  do
    if [ ! "${line:0:1}" == "#" ]   #Skip comments
    then
      create_single_service "$line" 
    fi
  done < "$file"
  echo_msg "Services created, bear in mind Spring Cloud Services need about a minute to fully initialise."


  # Sleep while services are being created
  IN_PROGRESS=$(cf s | grep progress | wc -l | xargs )
  while [ $IN_PROGRESS -gt 0 ]
  do
    echo "Pausing to allow Services to Initialise - Remaining services to create $IN_PROGRESS"
    sleep 10
    IN_PROGRESS=$(cf s | grep progress | wc -l | xargs )
  done

}

main()
{
  checkEnvHasSCS
  create_all_services
  summaryOfServices
}

trap 'abort $LINENO' 0
SECONDS=0
SCRIPTNAME=`basename "$0"`

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0
