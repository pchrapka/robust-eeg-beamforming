#!/bin/sh

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-t FILETYPE]
Sync output files from blade16 to local comp
     
    -h            display this help and exit
    -t FILETYPE   choose to include or exclude certain file types
                  options: csv or mat
                  - csv includes only csv files no mat files
                  - mat includes only mat files no csv files
                  default: all files
EOF
}  

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell

INCLUDES="--include='*.csv' --include='*.mat'"
EXCLUDES=""

# Parse inputs
while getopts "t:h" opt; do
    case "$opt" in
	h)
	    show_help
	    exit 0 
	    ;;
	t) 
	    if [ "$OPTARG" = "csv" ]; then
		INCLUDES="--include='*.csv'"
		EXCLUDES="--exclude='*.mat'"
	    elif [ "$OPTARG" = "mat" ]; then
		INCLUDES="--include='*.mat'"
		EXCLUDES="--exclude='*.csv'"
	    else
		:		
	    fi
	    ;;
    esac
done

shift $((OPTIND-1))

# The include/exclude doesn't seem to work

rsync -rvz --progress $INCLUDES $EXCLUDES chrapkpk@blade16:Documents/projects/robust-eeg-beamforming-paper/output/sim_data_bem_1_100t/ ~/projects/robust-eeg-beamforming-paper/output/sim_data_bem_1_100t/

#rsync -rvz --include='*1-100.mat' chrapkpk@blade16:Documents/projects/robust-eeg-beamforming-paper/output/sim_data_bem_100_100t/ ~/projects/robust-eeg-beamforming-paper/output/sim_data_bem_100_100t/
