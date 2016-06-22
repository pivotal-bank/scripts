#!/bin/sh

# set some variables
. ./setVars.sh

# Work out the CF_TARGET
CF_TARGET=`cf target | grep "API" | cut -d" " -f5| xargs`
# Disable PWS because of SCS Tile
PWS=`echo $CF_TARGET | grep "run.pivotal.io" | wc -l`
if [ $PWS -ne 0 ]
then
  echo "This won't run on PWS, please use another environment"
  exit 1
fi

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

