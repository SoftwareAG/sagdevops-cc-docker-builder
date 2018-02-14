#!/bin/sh

# if managed image (SPM is present)
if [ -d $SAG_HOME/profiles/SPM/bin ]; then
    # self-register
    $SAG_HOME/profiles/SPM/bin/register.sh
    # start SPM in background
    $SAG_HOME/profiles/SPM/bin/startup.sh
fi

echo "Remove old logs"
rm -rf $SAG_HOME/profiles/IS_$INSTANCE_NAME/logs/*.log

# start in background
$SAG_HOME/profiles/IS_$INSTANCE_NAME/bin/startup.sh

echo "IS process started. Waiting ..."
# wait until IS server.log comes up
while [  ! -f $SAG_HOME/IntegrationServer/instances/$INSTANCE_NAME/logs/server.log ]; do
    # tail $SAG_HOME/profiles/IS_$INSTANCE_NAME/logs/wrapper.log
    sleep 5
done

echo "IS process successfully started. Waiting for HTTP stack ..."
until curl Administrator:manage -s http://`hostname`:5555/
do
    sleep 5
    tail $SAG_HOME/IntegrationServer/instances/$INSTANCE_NAME/logs/server.log
done

# this is our main container process
echo "Integration Server is ONLINE at http://`hostname`:5555/"
tail -f $SAG_HOME/IntegrationServer/instances/$INSTANCE_NAME/logs/server.log
