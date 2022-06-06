#!/bin/bash
#SBATCH --job-name=timmean
#SBATCH --partition=compute
#SBATCH --account=bb1153
#SBATCH --time=04:30:00
#SBATCH --error=err_timmean_%j.eo
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu

module load cdo
set -evx # verbose messages and crash message

IN_PATH=/work/bb1153/b380883/GT
OUT_PATH=/scratch/b/b380883
declare -a MODELS=("SAM" "NICAM" ) # "GEOS" "SCREAM"

for m in "${MODELS[@]}"; do
    for f in $IN_PATH/*clt*.nc; do
        fname=$(basename $f)
        out_file=$OUT_PATH/timmean_$fname
        echo $fname
        cdo -timmean $f $out_file # computes the mean over each timestep output=[0,nlat,nlon]
        # cdo -hourmean $f $out_file # computes the mean of each hour for all timesteps [24,nlat,nlon]
    done
done

