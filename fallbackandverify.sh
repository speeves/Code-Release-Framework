#!/bin/bash

MYBOXES=${1}

usage="
Usage: ${0} [box-range] 

Example: ${0} 1-4

Notes:
  - Boxes are passed in a comma-delimited list, (ie 1,2,3), with ranges of contiguous boxes separated 
    by hyphens, (ie 1-4,10-15). One may mix single boxes and ranges of boxes in the following fashion, 300-302,307,420-421.
  - The box number is designated with the variable \${b}: 'ssh targetdev\${b}'

---------------------------

"
while getopts "h" OPT
do
    case $OPT in
	h )
	    echo "$usage"
	    exit 1
	    ;;
	\?) 
	    echo "$usage"
            exit 1;;
	esac
done
# remove the flags from $@
shift $((${OPTIND} - 1))
# If MYBOXES is not defined 
if [ "$MYBOXES" == "" ] ; then
     echo
     echo "$usage"
     exit 1
fi

cd deploymentscript/
./runme -qr ${MYBOXES} -f
./runme -qvr ${MYBOXES}  t_old
./runme -qvr ${MYBOXES} t
