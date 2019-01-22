#!/bin/sh
source ./commons.sh

IFS=' '

delete()
{
  cf delete-service -f $1
}

file="./PCFServices.list"
while read service plan si
do
  if [ ! "${service:0:1}" == "#" ]
  then
    delete $si &
  fi
done < "$file"
wait

IN_PROGRESS=$(cf s | grep progress | wc -l | xargs )
while [ $IN_PROGRESS -gt 0 ]
do
  echo "Pausing to allow Services to Delete - Remaining services to delete $IN_PROGRESS"
  sleep 10
  IN_PROGRESS=$(cf s | grep progress | wc -l | xargs )
done

summaryOfServices
exit 0
