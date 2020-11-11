#!/bin/bash

##Script to generate, push and connect using SSH Keys.

##Usage:
## ss generate --> generate Keys
## ss push {target} --> push Keys
## ss connect {target} --> connect using SSH Keys
## ss install --> install script to /usr/bin to allow you to connect without ./ or pointing location.

## To add domain

#user = `whoami`
echo "This script is run as $USER"
echo "Please note, that keys are being generated for ROOT user on target server"
case $1 in
  "generate")
      echo "Generating SSH Keys. Please answer for few questions, DO NOT CHANGE the SSH Keys location"
      /usr/bin/ssh-keygen -t rsa
      echo "Keys have been generated, do you want to push them to the first server? (y/n)"
      read -p pushdecision
      case $pushdecision in
        "y")  echo "Please enter IP or FQDN of Server/Machine"
              read -p host
              echo "Pushing Keys. Please provide password when prompted"
              /usr/bin/ssh-copy-id -i /home/$USER/.ssh/srvkey.pub root@$host
              echo "Keys pushed successfully, testing connection. Hostname in output below means connection is fiine"
              for srv in $host; do echo $host:; ssh -i /home/$USER/.ssh/srvkey root@$srv hostname; done
              echo "Action completed, exiting. "
              exit 1;;
        "n")  exit 1;;
        "*")  echo "Unknown option, exiting"
              exit 1;;
      esac ;;

  "push")
    if [ -f /home/$USER/.ssh/srvkey ];
      then
          echo "Please enter IP or FQDN of Server/Machine"
          read -p host
          echo "Pushing Keys. Please provide password when prompted"
          /usr/bin/ssh-copy-id -i /home/$USER/.ssh/srvkey.pub root@$host
          echo "Keys pushed successfully, testing connection."
          for srv in $host; do echo $host:; ssh -i /home/$USER/.ssh/srvkey root@$srv hostname; done
          echo "Action completed, exiting. "
          exit 1
        else
          echo "Keys not found. Please run this script with parameter GENERATE"
    fi
    exit 1;;
  "connect")
      /usr/bin/ssh -i /home/$USER/.ssh/srvkey root@$2
      exit 1;;
  *) echo "Unknown Option. USAGE:"
        echo "ss <generate|push|connect>"
        echo "ss <connect> <host>"
        exit 1;;
  esac
