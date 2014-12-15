#!/bin/sh
# Set up dependencies for robust-eeg-beamforming-paper

## Set up vars
CUR_DIR=$pwd
MATLAB_DIR=~/Documents/MATLAB

# Switch to the matlab dir to avoid issues
cd $MATLAB_DIR

## SDPT3
PKG_NAME=SDPT3-4.0
PKG_DIR=SDPT3-4.0
# Check if the dir exists
if [ ! -d "$PKG_DIR" ]; then
    FILE=SDPT3-4.0.zip
    # Check if the zip file exists
    if [ ! -f "$FILE" ]; then
	# Download pkg
	echo "Downloading $PKG_NAME"
	wget http://www.math.nus.edu.sg/~mattohkc/SDPT3-4.0.zip
    fi
    # Unzip the file
    unzip -q $FILE

    # Print confirmation
    echo "***************"
    echo "$PKG_NAME ready"
    echo "***************"
else
    # Print confirmation
    echo "***************"
    echo "$PKG_NAME already exists"
    echo "***************"
fi

## YALMIP
PKG_NAME=YALMIP
PKG_DIR=yalmip
# Check if the dir exists
if [ ! -d "$PKG_DIR" ]; then
    FILE=YALMIP.zip
    # Check if the zip file exists
    if [ ! -f "$FILE" ]; then
	# Download pkg
	echo "Downloading $PKG_NAME"
	wget http://www.control.isy.liu.se/~johanl/YALMIP.zip
    fi
    # Unzip the file
    unzip -q $FILE

    # Print confirmation
    echo "***************"
    echo "$PKG_NAME ready"
    echo "***************"
else
    # Print confirmation
    echo "***************"
    echo "$PKG_NAME already exists"
    echo "***************"
fi

## CVX
PKG_NAME="CVX"
PKG_DIR=cvx
# Check if the dir exists
if [ ! -d "$PKG_DIR" ]; then
    FILE=cvx-a64.tar.gz
    # Check if the zip file exists
    if [ ! -f "$FILE" ]; then
	# Download pkg
	echo "Downloading $PKG_NAME"
	wget http://web.cvxr.com/cvx/cvx-a64.tar.gz
    fi
    # Untar the file
    tar -xzf $FILE

    # Print confirmation
    echo "***************"
    echo "$PKG_NAME ready"
    echo "***************"
else
    # Print confirmation
    echo "***************"
    echo "$PKG_NAME already exists"
    echo "***************"
fi

## phasereset
PKG_NAME="Phase reset"
PKG_DIR=phasereset
# Check if the dir exists
if [ ! -d "$PKG_DIR" ]; then
    FILE=master.tar.gz
    # Check if the zip file exists
    if [ ! -f "$FILE" ]; then
	# Download pkg
	echo "Downloading $PKG_NAME"
	wget https://github.com/pchrapka/phasereset/tarball/master
	mv master $FILE
    fi
    mkdir $PKG_DIR
    # Untar the file
    tar -C $PKG_DIR -xzf $FILE
    # Save subfolder to be removed
    RM_DIR=$(find $PKG_DIR -mindepth 1 -maxdepth 1 -type d)
    # Move contents up a level
    find $PKG_DIR -mindepth 2 -maxdepth 2 -exec mv -t $PKG_DIR \{\} +
    rm -rf $RM_DIR

    # Print confirmation
    echo "***************"
    echo "$PKG_NAME ready"
    echo "***************"
else
    # Print confirmation
    echo "***************"
    echo "$PKG_NAME already exists"
    echo "***************"
fi

## Brainstorm
# TODO http://stackoverflow.com/questions/1324421/how-to-get-past-the-login-page-with-wget
PKG_NAME="Brainstorm"
PKG_DIR=brainstorm3
# Check if the dir exists
if [ ! -d "$PKG_DIR" ]; then
    echo
    echo "Missing Brainstorm"
    echo "********************"
    echo "Download Brainstorm from http://neuroimage.usc.edu/bst/download.php"
    echo "The site will ask you to register"
    echo "Place the zip file in your MATLAB user directory (typically ~/Documents/MATLAB)"
    echo "Unzip"
    echo "Follow the installation instructions: http://neuroimage.usc.edu/brainstorm/Installation"

#     FILE=brainstorm_141204.zip
#     # Check if the zip file exists
#     if [ ! -f "$FILE" ]; then
# 	# Download pkg
# 	echo "Downloading $PKG_NAME"
# 	wget -O $FILE --ignore-length "http://neuroimage.usc.edu/bst/download.php?file=brainstorm_141204.zip"
#     fi
#     # Unzip the file
#     unzip -q $FILE

#     # Print confirmation
#     echo "***************"
#     echo "$PKG_NAME ready"
#     echo "***************"
else
    # Print confirmation
    echo "***************"
    echo "$PKG_NAME already exists"
    echo "***************"
fi

echo
echo "If everything went well startup.m should work"

cd $CUR_DIR

