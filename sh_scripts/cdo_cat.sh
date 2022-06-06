#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat%j.eo
#SBATCH --error=err_cat%j.eo

set -evx # verbose messages and crash message

cdo -cat /scratch/b/b380883/regrid*rlt*.nc /scratch/b/b380883/GT_SCREAMr1deg_rlt_20200130-20200301.nc
cdo -cat /scratch/b/b380883/regrid*rst*.nc /scratch/b/b380883/GT_SCREAMr1deg_rst_20200130-20200301.nc

echo "done"
