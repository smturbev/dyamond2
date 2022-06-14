#!/bin/bash
#SBATCH --job-name=fldmean
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=06:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_fldmean.eo
#SBATCH --error=err_fldmean.eo

set -evx # verbose messages and crash message

cdo -fldmean /work/bb1153/b380883/GT/GT_SCREAM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_SCREAM_pr_20200130-20200301.nc
cdo -fldmean /work/bb1153/b380883/GT/GT_UM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_UM_pr_20200130-20200301.nc
cdo -fldmean /work/bb1153/b380883/GT/GT_SAM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_SAM_pr_20200130-20200301.nc
cdo -fldmean /work/bb1153/b380883/GT/GT_NICAM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_NICAM_pr_20200130-20200301.nc

echo "done"