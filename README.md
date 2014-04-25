# robust-eeg-beamforming-paper

# Description

This project contains a full out analysis of a robust beamforming algorithm for EEG data that accounts for anisotropic uncertainties in the head model. 

# Running simulations

1. Run startup.m. This checks for dependencies and notifies you if they are missing. I do not attempt to install all of them for you. (I wish there was an easy way in Matlab)
2. Run run_all. It contains a bunch of scripts that are all run, you can comment out any that you don't want to run.

Beware, this project can generate a lot of data and it takes a while. I've tried to parallelize as much as possible.


## Running on blade16

1. Configure upload.txt with your credentials
2. Run upload.bat

## Downloading output data from blade16

1. Configure sync_output.txt with your credentials
2. Run sync_output.bat

## Importing data to Brainstorm

NOTE: It uses an existing Brainstorm database that I had, not sure if it will work with an out of the box set up...

1. Start brainstorm or run brainstorm.bstcust_start
2. Configure options in brainstorm.bst_import_auto, namely the following variables
- sim_vars_name 
- cfg_data.sim_name
- cfg_data.source_name
- cfg_data.snr
3. Run brainstorm.bst_import_auto

# Dependencies

## Related projects by Phil

- head-models
- advanced-eeg-toolbox (aet)

## Open source Matlab packages

### Optimization packages
- yalmip
- cvx

## Other programs

- WinSCP (for FTP transfers)
- Brainstorm (creating head models and visualizations)

# Architecture

Each analysis requires a few configuration files which can be roughly divided into simulation data generation configurations and beamformer analysis configurations. sim_data_bem_1_100t.m is an example of a simulation data configuration which specifies parameters used to generate the ERP data, noise levels, head model and brain source configurations. An example of beamformer analysis configuration is run_sim_vars_single_bem_paper.m. This configures a bunch of different beamformers to be run on a particular set of data files, snr values, beamformer types, etc. It was meant to abstract a lot of the details and reuse a lot of the code but it may have added to the complexity of the project instead. 

Note for the future, consider using a different programming language to do large scale analyses and use matlab for the core functionality.

## Data simulation

simulation_data() is the workhorse for creating data and all the specifics can be found there. Makes use of the aet toolbox.

## Beamformer analysis

beamformer_analysis() is the function where the beamforming is done. Also makes use of the aet toolbox.






