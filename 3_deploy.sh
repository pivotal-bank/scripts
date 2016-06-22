#!/bin/sh

# set some variables
. ./setVars.sh

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

summary()
{
  echo_msg "Current Apps & Services in CF_SPACE"
  cf apps
  cf services
}

echo_msg()
{
  echo ""
  echo "************** ${1} **************"
}

deploy()
{
  echo_msg "Deploying $1"
  cd $BASE_DIR/$1
  cf push -f build/manifest.yml
  if [ $? -eq 0 ]
  then
    echo "Successfully deployed $1"
  else
    echo "Could not deploy $1" >&2
    exit 1
  fi
}

main()
{
  APPS=`cat microServices.list`

  for app in ${APPS[@]}
  do
    deploy $app &
    sleep 8
  done
  wait
  
  summary
}

trap 'abort $LINENO' 0
SECONDS=0
SCRIPTNAME=`basename "$0"`

main

printf "\nExecuted $SCRIPTNAME in $SECONDS seconds.\n"
exit 0
