#!/bin/sh
find . -name "fitnesse-standalone.jar"
su -c "java -jar /opt/fitnesse/fitnesse-standalone.jar -d /opt/fitnesse -p 9090" - fitnesse
