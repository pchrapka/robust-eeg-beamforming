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
PKG_DIR=YALMIP
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

## Phase reset
PKG_NAME="Phase reset"
PKG_DIR=phasereset
# Check if the dir exists
if [ ! -d "$PKG_DIR" ]; then
    FILE=phase.zip
    # Check if the zip file exists
    if [ ! -f "$FILE" ]; then
	# Download pkg
	echo "Downloading $PKG_NAME"
	wget http://www.cs.bris.ac.uk/~rafal/phasereset/phase.zip
    fi
    # Unzip the file
    unzip -q -d phasereset $FILE

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

echo "If everything went well startup.m should work"

cd $CUR_DIR


