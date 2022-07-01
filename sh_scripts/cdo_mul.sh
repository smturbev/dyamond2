#!/bin/bash
#SBATCH --job-name=cdo_mul
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_mul%j.eo
#SBATCH --error=err_mul%j.eo

set -evx # verbose messages and crash message

cdo -mul -addc,1 -mulc,0.61 /work/bb1153/b380883/TWP/TWP_3D_SCREAM_hus_20200130-20200228.nc /work/bb1153/b380883/TWP/TWP_3D_SCREAM_ta_20200130-20200228.nc /work/bb1153/b380883/TWP/TWP_3D_SCREAM_Tv_20200130-20200228.nc

# cdo -mul -addc,1 -mulc,0.61 /work/bb1153/b380883/TWP/TWP_3D_UM_hus_20200130-20200228.nc /work/bb1153/b380883/TWP/TWP_3D_UM_ta_20200130-20200228.nc /work/bb1153/b380883/TWP/TWP_3D_UM_Tv_20200130-20200228.nc


echo "done"