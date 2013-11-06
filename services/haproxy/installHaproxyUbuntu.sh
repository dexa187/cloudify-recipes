#!/bin/bash

# args:
# $1 the error code of the last command (should be explicitly passed)
# $2 the message to print in case of an error
# 
# an error message is printed and the script exists with the provided error code
function error_exit {
        echo "$2 : error code: $1"
        exit ${1}
}


export PATH=$PATH:/usr/sbin:/sbin || error_exit $? "Failed on: export PATH=$PATH:/usr/sbin:/sbin"

# The existence of the usingAptGet file in the ext folder will later serve as a flag that "we" are on Ubuntu or Debian or Mint
echo "Using apt-get. Updating apt-get on one of the following : Ubuntu, Debian, Mint" > usingAptGet
sudo apt-get -y -q update || error_exit $? "Failed on: sudo apt-get -y update"
# Removing previous haproxy installation if exist
sudo apt-get -y -q purge haproxy* || error_exit $? "Failed on: sudo apt-get -y -q purge haproxy*"

# The following statements are used since in some cases, there are leftovers after uninstall
sudo rm -rf /etc/haproxy || error_exit $? "Failed on: sudo rm -rf /etc/haproxy"
sudo rm -rf /usr/sbin/haproxy || error_exit $? "Failed on: sudo rm -rf /usr/sbin/haproxy"
sudo rm -rf /usr/lib/haproxy || error_exit $? "Failed on: sudo rm -rf /usr/lib/haproxy"
sudo rm -rf /usr/share/haproxy || error_exit $? "Failed on: sudo rm -rf /usr/share/haproxy"

echo "Using apt-get. Installing haproxy on one of the following : Ubuntu, Debian, Mint"
sudo apt-get install -y -q haproxy || error_exit $? "Failed on: sudo apt-get install -y -q haproxy"

#sudo /etc/init.d/haproxy stop
# Just in case the above doesn't work
echo "installOnUbuntu.sh: Looking for haproxy to kill them..."
ps -ef | grep -iE "haproxy" | grep -vi grep
if [ $? -eq 0 ] ; then 
  echo "installOnUbuntu.sh: About to kill haproxy"
  ps -ef | grep -iE "haproxy" | grep -vi grep | awk '{print $2}' | xargs sudo kill -9
fi  


echo "end of installHaproxyUbuntu.sh"
