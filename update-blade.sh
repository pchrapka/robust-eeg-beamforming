#!/bin/bash

CURDIR=$(pwd)

# Upload robust-eeg-beamforming-paper
./upload.sh

# Upload head-models
cd ../head-models
./upload.sh

# Upload advanced eeg toolbox
cd ../advanced-eeg-toolbox
./upload.sh

cd $CURDIR
