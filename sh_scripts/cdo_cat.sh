#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=prepost
#SBATCH --ntasks=8
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat_%j.eo
#SBATCH --error=err_cat_%j.eo

set -evx # verbose messages and crash message

cdo -cat /scratch/b/b380883/dyamond2/SAM/rltacc/*.nc GT_SAM_rlutacc_20200120-20200229.nc
echo "done"
