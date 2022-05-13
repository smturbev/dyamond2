#!/bin/bash
#SBATCH --job-name=timmean
#SBATCH --partition=prepost
#SBATCH --ntasks=8
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_timmean_%j.eo
#SBATCH --error=err_timmean_%j.eo

# set -evx # verbose messages and crash message

IN_PATH=/scratch/b/b380883/dyamond2
declare -a MODELS=("GEOS") # "SAM" "NICAM" "SCREAM")

# for m in "${MODELS[@]}"; do
#     for f in $IN_PATH/$m/GT/*.nc; do
#         fname=$(basename $f)
#         out_file=$IN_PATH/hourmean_$fname
#         echo $fname
#         cdo -timmean $f $out_file # computes the mean over each timestep output=[0,nlat,nlon]
#         cdo -hourmean $f $out_file # computes the mean of each hour for all timesteps [24,nlat,nlon]
#     done
# done

# cdo -timmean /scratch/b/b380883/dyamond2/GEOS/GT/GT_GEOS_clivi_20200120-20200229.nc /scratch/b/b380883/dyamond2/timmean_GT/timmean_GT_GEOS_clivi_20200120-20200229.nc 
# cdo -timmean /scratch/b/b380883/dyamond2/SAM/GT/GT_SAM_rlt_20200120-20200229.nc /scratch/b/b380883/dyamond2/timmean_GT/timmean_GT_SAM_rlt_20200120-20200229.nc
# cdo -timmean /scratch/b/b380883/dyamond2/SCREAM/GT/GT_SCREAM_clivi_20200120-20200229.nc /scratch/b/b380883/dyamond2/timmean_GT/timmean_GT_SCREAM_clivi_20200120-20200229.nc 
