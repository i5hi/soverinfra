#!/bin/bash -e

# IF dockerd fails to start KILL ALL
ps axf | grep docker | grep -v grep | awk '{print "kill -9 " $1}' | sudo sh 