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

# cdo -fldmean /work/bb1153/b380883/GT/GT_SCREAM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_SCREAM_pr_20200130-20200301.nc
# cdo -fldmean /work/bb1153/b380883/GT/GT_UM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_UM_pr_20200130-20200301.nc
# cdo -fldmean /work/bb1153/b380883/GT/GT_SAM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_SAM_pr_20200130-20200301.nc
# cdo -fldmean /work/bb1153/b380883/GT/GT_NICAM_pr_20200130-20200301.nc /work/bb1153/b380883/GT/fldmean/fldmean_GT_NICAM_pr_20200130-20200301.nc
##### 3D #####
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_NICAM_cli_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_NICAM_cli_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_NICAM_clw_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_NICAM_clw_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_SAM_cli_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_SAM_cli_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_SAM_clw_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_SAM_clw_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_SCREAM_cli_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_SCREAM_cli_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_SCREAM_clw_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_SCREAM_clw_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_UM_cli_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_UM_cli_20200130-20200228.nc
# cdo -fldpctl,50 /work/bb1153/b380883/TWP/TWP_3D_UM_clw_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_UM_clw_20200130-20200228.nc
# cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_pfull_3hr_UM_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_UM_pfull_20200130-20200228.nc

cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_SCREAM_ta_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_SCREAM_ta_20200130-20200228.nc
cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_UM_ta_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_UM_ta_20200130-20200228.nc
cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_SAM_ta_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_SAM_ta_20200130-20200228.nc
cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_NICAM_ta_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_NICAM_ta_20200130-20200228.nc
cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_SCREAM_hus_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_SCREAM_hus_20200130-20200228.nc
cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_UM_hus_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_UM_hus_20200130-20200228.nc
# cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_SAM_hus_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_SAM_hus_20200130-20200228.nc
cdo -fldmean /work/bb1153/b380883/TWP/TWP_3D_NICAM_hus_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmean_TWP_3D_NICAM_hus_20200130-20200228.nc

# cdo -fldpctl,50 --percentile,numpy /work/bb1153/b380883/TWP/TWP_3D_NICAM_cli_20200130-20200228.nc /work/bb1153/b380883/TWP/mean/fldmedian_TWP_3D_NICAM_cli_20200130-20200228.nc


echo "done"