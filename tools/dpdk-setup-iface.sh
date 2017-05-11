#!/bin/bash

function usage {
            echo "This script is used to setup a network adapter for a DPDK managed network interface."
            echo "If you run ifconfig after using this script, there will be an entry for a DPDK interface. The interface will look similar to one managed by the kernel, but instead, this interface is managed by DPDK."
            echo ""
            echo "Usage:"
            echo "sudo $0 <interface name> <ip address> <netmask> up"
            echo "sudo $0 <interface name> down"
            exit 1
}

# Check if you are root
user=`whoami`
if [ "root" != "$user" ]
then
    echo "You are not root!"
    exit 1
fi

# check command line arguments
if [ $# == 2 ]
then
        if [ $2 == "down" ];
        then
                echo "/sbin/ifconfig $1 down"
                /sbin/ifconfig $1 down
                exit 1
        else
                usage
        fi

elif [ $# -ne 4 ]
        then
        usage
fi

# Create & configure /dev/dpdk-iface
rm -rf /dev/dpdk-iface
mknod /dev/dpdk-iface c 1110 0
chmod 666 /dev/dpdk-iface

# First check whether igb_uio module is already loaded
MODULE="igb_uio"

if lsmod | grep "$MODULE" &> /dev/null ; then
  echo "$MODULE is loaded!"
else
  echo "$MODULE is not loaded!"
  exit 1
fi

echo "/sbin/ifconfig $1 $2 netmask $3 $4"
/sbin/ifconfig $1 $2 netmask $3 $4

