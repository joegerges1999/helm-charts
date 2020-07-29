#!/bin/sh

team=$1
upgrade_to=$2

#scale down to 0 to avoid conflicts and add ingress rules again
helm upgrade $team-fitnesse .. -f myvals.yaml --set fitnesse.image.tag="$upgrade_to"

