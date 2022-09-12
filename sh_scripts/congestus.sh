#!/bin/bash
#SBATCH --job-name=congestus
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_con%j.eo
#SBATCH --error=err_con%j.eo

set -evx

olr=/work/bb1153/b380883/TWP/TWP_GEOS_rlut_20200130-20200228.nc
swd=/work/bb1153/b380883/TWP/TWP_GEOS_rsdt_20200130-20200228.nc
swu=/work/bb1153/b380883/TWP/TWP_GEOS_rsut_20200130-20200228.nc
alb=/work/bb1153/b380883/TWP/TWP_GEOS_alb_20200130-20200228.nc

clf=/work/bb1153/b380883/TWP/TWP_3D_GEOS_cltotal_20200130-20200228.nc
clf_sub=/scratch/b/b380883/TWP_3D_GEOS_clf_alb0.6_20200130-20200228.nc
clf_sub2=/scratch/b/b380883/TWP_3D_GEOS_clf_alb0.6_olr200_20200130-20200228.nc
clf_submean=/scratch/b/b380883/TWP_3D_GEOS_clfmean_alb0.6_olr200_20200130-20200228.nc
clf_subcf=/scratch/b/b380883/TWP_3D_GEOS_clfcf_alb0.6_olr200_20200130-20200228.nc

# calculate albedo (one time)
# cdo -div $swu $swd $alb
# calculate clf mean and cld frac
# cdo -ifthen -gec,0.6 $alb $clf $clf_sub
cdo -ifthen -gec,200 $olr $clf_sub $clf_sub2
cdo -fldmean $clf_sub2 $clf_submean
cdo -fldmean -gec,1e-5 $clf_sub2 $clf_subcf

clw=/work/bb1153/b380883/TWP/TWP_3D_GEOS_clw_20200130-20200228.nc
clw_sub=/scratch/b/b380883/TWP_3D_GEOS_clw_alb0.6_20200130-20200228.nc
clw_sub2=/scratch/b/b380883/TWP_3D_GEOS_clw_alb0.6_olr200_20200130-20200228.nc
clw_submean=/scratch/b/b380883/TWP_3D_GEOS_clwmean_alb0.6_olr200_20200130-20200228.nc
clw_subcf=/scratch/b/b380883/TWP_3D_GEOS_clwcf_alb0.6_olr200_20200130-20200228.nc

# calc flw mean and cld frac
# cdo -ifthen -gec,0.6 $alb $clw $clw_sub
cdo -ifthen -gec,200 $olr $clw_sub $clw_sub2
cdo -fldmean $clw_sub2 $clw_submean
cdo -fldmean -gec,1e-5 $clw_sub2 $clw_subcf
