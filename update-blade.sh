#!/bin/bash

CURDIR=$(pwd)

# Update robust-eeg-beamforming-paper
git pull

# Update head-models
cd ../head-models
git pull

# Update advanced eeg toolbox
cd ../advanced-eeg-toolbox
git pull

cd ../lumberjack
git pull

cd $CURDIR
