#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=06:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat%j.eo
#SBATCH --error=err_cat%j.eo

set -evx # verbose messages and crash message

# cdo -cat /scratch/b/b380883/r0.25deg_TWP_clt_15min_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_SCREAMr0.25deg_clt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/r0.25deg_TWP_rlt_15min_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_SCREAMr0.25deg_rlt_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/r0.25deg_TWP_rst_15min_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_SCREAMr0.25deg_rst_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/r0.25deg_TWP_rlut_15min_GEOS*.nc /work/bb1153/b380883/TWP/TWP_GEOSr0.25deg_rlut_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/r0.25deg_TWP_rst_15min_GEOS*.nc /work/bb1153/b380883/TWP/TWP_GEOSr0.25deg_rst_20200130-20200301.nc
cdo -cat /scratch/b/b380883/r0.25deg_TWP_rsut_15min_GEOS*.nc /work/bb1153/b380883/TWP/TWP_GEOSr0.25deg_rsut_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/GT_pr_15min_SCREAM*.nc /work/bb1153/b380883/GT/GT_SCREAM_pr_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/GT_pr_15min_UM*.nc /work/bb1153/b380883/GT/GT_UM_pr_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/GT_pracc_15min_SAM*.nc /work/bb1153/b380883/GT/GT_SAM_pracc_20200130-20200301.nc
# cdo -cat /scratch/b/b380883/pr_15min_NICAM*.nc /work/bb1153/b380883/GT/GT_NICAM_pr_20200130-20200301.nc

echo "done"
