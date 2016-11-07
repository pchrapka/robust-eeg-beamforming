#!/usr/bin/env bash

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-t FILETYPE]
Sync output files from blade16 to local comp
     
    -h            display this help and exit
    -t FILETYPE   choose to include or exclude certain file types
                  options: csv, mat or img
                  - csv includes only csv files no mat or image files
                  - mat includes only mat files no csv or image files
                  - img includes only eps files no csv or mat files
                  default: all files
EOF
}  

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell

INCLUDES=()
EXCLUDES=()
function exclude
{
  while
    (( $# ))
  do
    EXCLUDES+=(--exclude="$1")
    shift
  done
}

function include
{
  while
    (( $# ))
  do
    INCLUDES+=(--include="$1")
    shift
  done
}

#INCLUDES="--include='*.csv' --include='*.mat' --include='*.eps'" 
#EXCLUDES=""

# Parse inputs
while getopts "t:h" opt; do
    case "$opt" in
	h)
	    show_help
	    exit 0 
	    ;;
	t) 
	    if [ "$OPTARG" = "csv" ]; then
		include "*.csv"
		exclude "*.mat"
		#INCLUDES="--include='*.csv'"
		#EXCLUDES="--exclude='*.mat'"
	    elif [ "$OPTARG" = "mat" ]; then
		include "*.mat"
		exclude "*.csv"
		#INCLUDES="--include='*.mat'"
		#EXCLUDES="--exclude='*.csv'"
	    elif [ "$OPTARG" = "img" ]; then
		include "*.eps"
		exclude "*.csv" "*.mat"
		#exclude "*.mat"
		#INCLUDES="--include='*.eps'"
		#EXCLUDES="--exclude='*.csv' --exclude='*.mat'"
	    else
		include "*.csv" "*.mat" "*.eps"
	    fi
	    ;;
    esac
done

shift $((OPTIND-1))

# The include/exclude doesn't seem to work

#echo "${INCLUDES[@]}"
#echo "${EXCLUDES[@]}"

rsync -rvz --progress "${INCLUDES[@]}" "${EXCLUDES[@]}" chrapkpk@blade16:Documents/projects/robust-eeg-beamforming-paper/output/sim_data_bem_1_100t_1000s/ ~/projects/robust-eeg-beamforming-paper/output/sim_data_bem_1_100t_1000s/

#rsync -rvz --include='*1-100.mat' chrapkpk@blade16:Documents/projects/robust-eeg-beamforming-paper/output/sim_data_bem_100_100t/ ~/projects/robust-eeg-beamforming-paper/output/sim_data_bem_100_100t/
