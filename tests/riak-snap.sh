#!/bin/bash

HOSTLIST="ppriakops01-sc9 \
  ppriakops02-sc9 ppriakops03-sc9"

case $1 in

  remove)
    for host in $HOSTLIST ; do
      printf "\nREMOVING\nHOST: $host\n"
      ssh -q -t $host "sudo yum -y remove riak erlang-rebar ; sudo rm -fr /etc/riak /var/lib/riak"
    done
    ;;

  check)
    for host in $HOSTLIST ; do
      printf "\nCHECKING\nHOST: $host\n"
      ssh -q -t $host "/sbin/service riak status; ls /var/lib/riak"
      ssh -q -t $host "sudo /usr/sbin/riak-admin test"
      ssh -q -t $host "sudo /usr/sbin/riak-admin status | grep ring_creation_size"
      ssh -q -t $host "sudo /usr/sbin/riak-admin status | grep ring_ownership"
    done
    ;;

  *)
    echo "give me something. 1 arg needed."
    ;;

esac
