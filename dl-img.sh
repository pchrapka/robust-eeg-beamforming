DIR=output/sim_data_bem_1_100t/
rsync -rvz --progress --include='*/' --include='*.eps' --include='*.png' --exclude='*' chrapkpk@blade16:Documents/projects/robust-eeg-beamforming-paper/$DIR ~/projects/robust-eeg-beamforming-paper/$DIR

DIR=output/sim_data_bemhd_1_100t/
rsync -rvz --progress --include='*/' --include='*.eps' --include='*.png' --exclude='*' chrapkpk@blade16:Documents/projects/robust-eeg-beamforming-paper/$DIR ~/projects/robust-eeg-beamforming-paper/$DIR
