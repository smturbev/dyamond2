#!/bin/bash
#SBATCH --job-name=fldmean
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_fldmean.eo
#SBATCH --error=err_fldmean.eo

set -evx # verbose messages and crash message
twp=/work/bb1153/b380883/TWP

cdo -fldmean $twp/TWP_3D_UM_totalwater_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_UM_totalwater_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_SCREAM_totalwater_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_SCREAM_totalwater_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_ARP_totalwater_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_ARP_totalwater_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_SHiELD_totalwater_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_SHiELD_totalwater_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_ICON_totalwater_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_ICON_totalwater_20200130-20200228.nc

cdo -fldmean $twp/TWP_3D_UM_cl_5e-7kgm-3_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_UM_cl_5e-7kgm-3_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_SCREAM_cl_5e-7kgm-3_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_SCREAM_cl_5e-7kgm-3_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_ARP_cl_5e-7kgm-3_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_ARP_cl_5e-7kgm-3_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_SHiELD_cl_5e-7kgm-3_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_SHiELD_cl_5e-7kgm-3_20200130-20200228.nc
cdo -fldmean $twp/TWP_3D_ICON_cl_5e-7kgm-3_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_ICON_cl_5e-7kgm-3_20200130-20200228.nc

echo "done"