#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

if [ ! -z ${SERVER_AUTO_UPDATE} || ${SERVER_AUTO_UPDATE} == 'true' ]; then
    echo 'Checking is update available'
    ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 402370 validate +quit
fi

# Fixing silent server crash ...
mkdir ${SERVER_NAME}/gamedir

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}