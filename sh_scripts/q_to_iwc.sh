#!/bin/bash
#SBATCH --job-name=iwc
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_iwc%j.eo
#SBATCH --error=err_iwc%j.eo

set -evx # verbose messages and crash message

# Tv = (1 + 0.61*qv)*t
# rho = p / (287*Tv)
# iwc = q * rho

twp=/work/bb1153/b380883/TWP
temp=/scratch/b/b380883/temp
declare -a ModelArray=(
SHiELD
) 
# ARP
# SHiELD
# ICON
# SCREAM
# UM
# GEOS

# cloud fraction is 1 where CLI is greater than or equal to 1e-5 kg/kg
for m in "${ModelArray[@]}"; do
    cdo -mul -addc,1 -mulc,0.61 $twp/TWP_3D_${m}_hus_20200130-20200228.nc $twp/TWP_3D_${m}_ta_20200130-20200228.nc $temp/TWP_3D_${m}_tv_20200130-20200228.nc
    cdo -div $twp/TWP_3D_${m}_pa_20200130-20200228.nc -mulc,287 $temp/TWP_3D_${m}_tv_20200130-20200228.nc $temp/TWP_3D_${m}_rho_20200130-20200228.nc 
    # cdo -setname,totalwater -setunit,"kg m-3" -mul $temp/TWP_3D_${m}_rho_20200130-20200228.nc $twp/TWP_3D_${m}_cltotal_20200130-20200228.nc $twp/TWP_3D_${m}_totalwater_20200130-20200228.nc
    cdo -setname,iwc -setunit,"kg m-3" -mul -add -add $temp/TWP_3D_${m}_rho_20200130-20200228.nc $twp/TWP_3D_${m}_cli_20200130-20200228.nc $twp/TWP_3D_${m}_grplmxrat_20200130-20200228.nc $twp/TWP_3D_${m}_snowmxrat_20200130-20200228.nc $twp/TWP_3D_${m}_iwc_20200130-20200228.nc
done