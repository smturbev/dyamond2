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

TWP="/work/bb1153/b380883/TWP"
scr="/scratch/b/b380883"
# cdo -cat /scratch/b/b380883/TWP_3D_cli_3hr_UM*.nc /work/bb1153/b380883/TWP/TWP_3D_UM_cli_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_clw_3hr_UM*.nc /work/bb1153/b380883/TWP/TWP_3D_UM_clw_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_cldnvi_3hr_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_3D_SCREAM_cldnvi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_icenvi_3hr_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_3D_SCREAM_icenvi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_cli_3hr_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_3D_SCREAM_cli_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_clw_3hr_SCREAM*.nc /work/bb1153/b380883/TWP/TWP_3D_SCREAM_clw_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/cli_3hr_NICAM*.nc /work/bb1153/b380883/TWP/TWP_3D_NICAM_cli_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/clw_3hr_NICAM*.nc /work/bb1153/b380883/TWP/TWP_3D_NICAM_clw_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_clw_3hr_SAM*.nc /work/bb1153/b380883/TWP/TWP_3D_SAM_clw_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_cli_3hr_SAM*.nc /work/bb1153/b380883/TWP/TWP_3D_SAM_cli_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_phalf_3hr_UM*.nc /work/bb1153/b380883/TWP/TWP_3D_phalf_3hr_UM_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_pfull_3hr_UM*.nc /work/bb1153/b380883/TWP/TWP_3D_pfull_3hr_UM_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/*qvi*SAM* /work/bb1153/b380883/TWP/TWP_SAM_qvi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/*qvi*SCREAM* /work/bb1153/b380883/TWP/TWP_SCREAM_qvi_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/*prw*NICAM* /work/bb1153/b380883/TWP/TWP_NICAM_prw_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/*prw*UM* /work/bb1153/b380883/TWP/TWP_UM_prw_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_hus_3hr_SCREAM* /work/bb1153/b380883/TWP/TWP_3D_SCREAM_hus_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_ta_3hr_SCREAM* /work/bb1153/b380883/TWP/TWP_3D_SCREAM_ta_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_hus_3hr_UM* /work/bb1153/b380883/TWP/TWP_3D_UM_hus_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_ta_3hr_UM* /work/bb1153/b380883/TWP/TWP_3D_UM_ta_20200130-20200228.nc
cdo -cat /scratch/b/b380883/hus_3hr_NICAM* /work/bb1153/b380883/TWP/TWP_3D_NICAM_hus_20200130-20200228.nc
cdo -cat /scratch/b/b380883/ta_3hr_NICAM* /work/bb1153/b380883/TWP/TWP_3D_NICAM_ta_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_hus_3hr_SAM2* /work/bb1153/b380883/TWP/TWP_3D_SAM_hus_20200130-20200228.nc
# cdo -cat /scratch/b/b380883/TWP_3D_ta_3hr_SAM2* /work/bb1153/b380883/TWP/TWP_3D_SAM_ta_20200130-20200228.nc

# cdo -cat /scratch/b/b380883/clw_3hr_NICAM-3km_DW-ATM_r1i1p1f1_zl_gn*.nc /work/bb1153/b380883/TWP/TWP_3D_NICAM_clw_30days.nc
# cdo -cat /scratch/b/b380883/TWP_3D_ta_3hr_SAM2-4km_DW-ATM*.nc /work/bb1153/b380883/TWP/TWP_3D_SAM_ta_30days.nc
# cdo -seltimestep,1/241 $TWP/TWP_3D_UM_hus_20200130-20200228.nc $TWP/TWP_3D_UM_hus_30days.nc
# cdo -seltimestep,0,240 $TWP/TWP_3D_UM_ta_20200130-20200228.nc $TWP/TWP_3D_UM_ta_30days.nc
# cdo -cat $scr/TWP_3D_phalf_3hr_UM-5km*.nc $TWP/TWP_3D_UM_phalf_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_pfull_3hr_UM-5km*.nc $TWP/TWP_3D_UM_pfull_20200130-20200228.nc

echo "done"
