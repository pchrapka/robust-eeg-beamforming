DIR=projects/robust-eeg-beamforming-paper/output
OUTDIR=projects/robust-eeg-beamforming-paper

rsync -rvz --progress \
      --include='output' \
      --include='output/sim_data_bem_1_100t/' \
      --include='output/sim_data_bem_1_100t/**/' \
      --include='output/sim_data_bem_1_100t_5000s/' \
      --include='output/sim_data_bem_1_100t_5000s/**/' \
      --include='output/sim_data_bem_1_500t/' \
      --include='output/sim_data_bem_1_500t/**/' \
      --include='output/sim_data_bemhd_1_100t/' \
      --include='output/sim_data_bemhd_1_100t/**/' \
      --include='*.eps' \
      --include='*.png' \
      --exclude='*' \
      chrapkpk@blade16:Documents/$DIR ~/$OUTDIR
