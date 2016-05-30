#!/bin/bash
# This script is supposed to be run inside the container and to create a backup file for non binded volumes.
cd /var
if [ -f jenkins_home.zip ]; then
	rm jenkins_home.zip
fi

# This is just an example of zip command that copies symlinks as symlinks (-y) and excludes some file patterns. tar.gz works well too.
zip -ry jenkins_home.zip jenkins_home -x jenkins_home/workspace/\* jenkins_home/jobs/\*/builds/\*
