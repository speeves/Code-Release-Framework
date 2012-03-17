#!/bin/bash
####################
#
#     Copyright 2011 Shannon Eric Peevey <speeves@erikin.com>
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#####################
#
# Common Function Library
# This script contains functions to be called in the deployment process
# 
####################

# loop through a non-contiguous range of boxes
function createstartend()
{
    HOST_LIST=$RANGE_OF_BOXES

    HOST_ARRAY=$(echo $HOST_LIST | tr , " ")

    for RANGE in $HOST_ARRAY
      do
      START=$(echo $RANGE | cut -d- -f1)
      MATCH=`expr index "$RANGE" -` 
      if [ "$MATCH" = 0 ]; then
	  END=$START
      else
	  END=$(echo $RANGE | cut -d- -f2)        
      fi      
      for b in $(seq $START $END)
	do 
          performaction
      done
    done
}

function performaction()
{
	    echo "[$(date)] - INFO - ${ME} - ${COMMAND_DESCRIPTION}${b}" >> $DEPLOYMENT_LOG
	    eval $COMMAND 2>/dev/null 
	    if [ $? -eq 0 ]; then
		echo "[$(date)] - SUCCESS - ${ME} - ${COMMAND_DESCRIPTION}${b} completed" >> $DEPLOYMENT_LOG
	    else
		echo "[$(date)] - FAIL - ${ME} - ${COMMAND_DESCRIPTION}${b} failed " >> $DEPLOYMENT_LOG
	    fi
	    echo "-------------------------------------------"
}

### deploy functions
function stage_all()
{
    COMMAND_DESCRIPTION="staging $filename to ${hostname_prefix}${b}"
    COMMAND='echo "copying $filename to ${hostname_prefix}${b}" ; scp $filename ${hostname_prefix}${b}:${STAGINGDIR}${filename_removeprefix}'
}

function stage2_all()
{
    COMMAND_DESCRIPTION="imping staged file ${filename} on ${hostname_prefix}${b}"
    COMMAND='echo "imping staged file ${filename} on ${hostname_prefix}${b}" ; ssh ${hostname_prefix}${b} "rm -rf ${BACKUPDIR}${APPFILENAME}.oldest ; mv ${BACKUPDIR}${APPFILENAME}.{old,oldest};  mv ${WEBROOT}${APPFILENAME} ${BACKUPDIR}${APPFILENAME}.old ; mv ${STAGINGDIR}${APPFILENAME}.tar ${WEBROOT}${APPFILENAME}.tar ; cd ${WEBROOT}; tar -xvf ${WEBROOT}${APPFILENAME}.tar ; rm ${WEBROOT}${APPFILENAME}.tar"'
}

function update_all()
{
    COMMAND_DESCRIPTION="deploying $filename ${hostname_prefix}${b}"
    COMMAND='echo "copying $filename to ${hostname_prefix}${b}" ; scp $filename ${hostname_prefix}${b}:${STAGINGDIR}${filename_removeprefix} ; ssh ${hostname_prefix}${b} "rm -rf ${BACKUPDIR}${APPFILENAME}.oldest ; mv ${BACKUPDIR}${APPFILENAME}.{old,oldest}; mv ${WEBROOT}${APPFILENAME} ${BACKUPDIR}${APPFILENAME}.old ; mv ${STAGINGDIR}${APPFILENAME}.tar ${WEBROOT}${APPFILENAME}.tar; cd ${WEBROOT}; tar -xvf ${WEBROOT}${APPFILENAME}.tar ; rm ${WEBROOT}${APPFILENAME}.tar"'
}

## verification functions
# additional variables for logging functions
function check_templates_old_new_diff()
{
    COMMAND_DESCRIPTION="list changed templates on ${hostname_prefix}${b}"
    COMMAND='echo "list changed templates on ${hostname_prefix}${b}"; ssh ${hostname_prefix}${b} "echo ${hostname_prefix}${b}; if [ -e "${BACKUPDIR}${APPFILENAME}.old" ]; then cd ${BACKUPDIR}${APPFILENAME}.old;  find . -type f | xargs cksum | sort  > ${TMPDIR}${APPFILENAME}.old.log ; else touch ${TMPDIR}${APPFILENAME}.old.log ; fi ; cd ${WEBROOT}${APPFILENAME} ; find . -type f |xargs cksum | sort   > ${TMPDIR}${APPFILENAME}.log ; diff ${TMPDIR}${APPFILENAME}.old.log ${TMPDIR}${APPFILENAME}.log ; rm ${TMPDIR}${APPFILENAME}.old.log ${TMPDIR}${APPFILENAME}.log"'
}

function check_templates_cksum()
{
    COMMAND_DESCRIPTION="cksum templates on ${hostname_prefix}${b}"
    COMMAND='echo "cksum templates on ${hostname_prefix}${b}"; ssh ${hostname_prefix}${b} "echo ${hostname_prefix}${b};cd ${WEBROOT}${APPFILENAME}; find . -type f | xargs cksum  | sort > ${TMPDIR}${APPFILENAME}.log ; cksum ${TMPDIR}${APPFILENAME}.log ; rm ${TMPDIR}${APPFILENAME}.log"'
}

### restore functions
function restore_from_last()
{
    COMMAND_DESCRIPTION="restore from ${APPFILENAME}.old on ${hostname_prefix}${b}"
    COMMAND='echo "restore from ${APPFILENAME}.old on ${hostname_prefix}${b}" ; ssh ${hostname_prefix}${b} "mv ${WEBROOT}${APPFILENAME} ${BACKUPDIR}${APPFILENAME}.bad ; mv ${BACKUPDIR}${APPFILENAME}.old ${WEBROOT}${APPFILENAME} ; mv ${BACKUPDIR}${APPFILENAME}.{oldest,old}"'
}

### checkout and package functions
function build_from_tag()
{
    COMMAND_DESCRIPTION="build app from ${TAG}"
    COMMAND='echo "build app from ${TAG}" ; rm -rf ${PROJECTBUILDAREA}/ ; mkdir ${PROJECTBUILDAREA} ; cd ${PROJECTBUILDAREA} ; git clone ${REPO}${PROJECT} ; mkdir build ; cd ${PROJECT} ; git checkout ${TAG} ; cd ../build/ ; mkdir ${APPFILENAME} ; cp -R ../${PROJECT}/php/* ${APPFILENAME} ; tar cf ${APPFILENAME}.tar --exclude-vcs ${APPFILENAME}'
    performaction
}


### logging functions
function log_deploy()
{
    echo "[$(date)] - ${COMMAND_DESCRIPTION}" >> $DEPLOYMENT_LOG
}

# output the user who is running the script
who_is_running_the_script()
{
    # find out the uid that is running the script
    user=${ME}
    echo "You are currently logged in as: $user"
}

# check if there are supposed to be two arguments, then bail
two_arguments_needed()
{
    # check to see if either of the variables is blank, if so, exit
    if [ $# != 2 ]; then
	echo
	echo "No information provided...  Bailing out!!"
	echo
	echo "$usage"
	exit 1
    fi
}
