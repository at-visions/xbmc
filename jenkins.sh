#!/bin/bash

JENKINS_COMMAND=$(git log -n1 | grep "JENKINS:")

# Settings for each deployment type

REPO_SERVER="192.168.249.17"
REPO_USER="root"
REPO_DIR="/var/www/vhosts/ofrepo/repo/XBMC/latest/."

if [[ $JENKINS_COMMAND == *intern* ]]
then
  ##################################
  # Handle the command intern here #
  #            START               #
  ##################################

  exit 0

  ##################################
  #             STOP               #
  ##################################

elif [[ $JENKINS_COMMAND == *release* ]]
then
  ###################################
  # Handle the command release here #
  #             START               #
  ###################################

  echo "Deploying build to release server"
  scp 200gz-xbmc*.lzm $REPO_USER@$REPO_SERVER:$REPO_DIR

  ##################################
  #             STOP               #
  ##################################
fi

exit 0
