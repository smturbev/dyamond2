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
#SBATCH --output=out_scream_%j.eo
#SBATCH --error=err_scream_%j.eo

# set -evx # verbose messages and crash message

IN_PATH=/scratch/b/b380883/dyamond2
declare -a MODELS=("SAM") # "GEOS/GT" "NICAM" "SCREAM"

for m in "${MODELS[@]}"; do
    for f in $IN_PATH/$m/*.nc; do
        fname=$(basename $f)
        out_file=$IN_PATH/timmean_$fname
        echo $fname
        cdo -timmean $f $out_file
    done
done