#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=prepost
#SBATCH --mem=20GB
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat%j.eo
#SBATCH --error=err_cat%j.eo

set -evx # verbose messages and crash message

# cdo -cat /scratch/b/b380883/dyamond2/SCREAM/GT_clivi_15min_SCREAM-3km*.nc GT_SCREAM_clivi_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/SCREAM/GT_rlt_15min_SCREAM-3km*.nc GT_SCREAM_rlt_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/SCREAM/TWP_rlt_15min_SCREAM-3km*.nc TWP_SCREAM_rlt_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/GT/rlut_15min_GEOS-3km*.nc GT_GEOS_rlut_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/GEOS/GT/clivi_15min_GEOS-3km*.nc GT_GEOS_clivi_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/SAM/TWP/clivi*.nc /scratch/b/b380883/dyamond2/SAM/TWP/TWP_clivi_SAM_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/SAM/TWP/rltacc*.nc /scratch/b/b380883/dyamond2/SAM/TWP/TWP_rltacc_SAM_20200120-20200229.nc
# cdo -cat /scratch/b/b380883/dyamond2/SAM/TWP/rstacc*.nc /scratch/b/b380883/dyamond2/SAM/TWP/TWP_rstacc_SAM_20200120-20200229.nc
cdo -cat /scratch/b380833/dyamond2/ICON/GT/rltacc*.nc /scratch/b/b380883/dyamond2/ICON/GT/GT_ICON_rltacc_20200130-20200301.nc
cdo -cat /scratch/b380833/dyamond2/ICON/GT/clt*.nc /scratch/b/b380883/dyamond2/ICON/GT/GT_ICON_clt_20200130-20200301.nc

echo "done"
