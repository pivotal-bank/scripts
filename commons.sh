#!/bin/sh

# set some variables
. ./setVars.sh

checkEnvHasSCS(){
  DiscovInstalled=`cf marketplace | grep p-service-registry`
  if [[ -z $DiscovInstalled ]]
  then
    echo "The targeted PCF environment does not have Sercvice Discovery in the marketplace, installation will now halt."
    exit 1
  fi
}

abort()
{
    if [ "$?" = "0" ]
    then
        return
    else
      echo >&2 '
      ***************
      *** ABORTED ***
      ***************
      '
      echo "An error occurred on line $1. Exiting..." >&2
      exit 1
    fi
}

summaryOfServices()
{
  echo_msg "Current Services in CF_SPACE"
  cf services | tail -n +4
}

summaryOfApps()
{
  echo_msg "Current Apps in CF_SPACE"
  cf apps | tail -n +4
}

echo_msg()
{
  echo ""
  echo "************** ${1} **************"
}

trap 'abort $LINENO' 0
SECONDS=0
SCRIPTNAME=`basename "$0"`

checkEnvHasSCS
