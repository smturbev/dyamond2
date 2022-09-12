#!/bin/bash
#SBATCH --job-name=timmean
#SBATCH --partition=compute
#SBATCH --account=bb1153
#SBATCH --time=04:30:00
#SBATCH --error=err_timmean_%j.eo
#SBATCH --output=out_timmean_%j.eo
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu

module load cdo
set -evx # verbose messages and crash message

IN_PATH=/work/bb1153/b380883/GT
OUT_PATH=/work/bb1153/b380883/GT/timmean
declare -a MODELS=("SHiELDr0.25deg") # done: "NICAM" "UM" "SAM" "SCREAMr0.25deg", "ARPr0.25deg"

for v in "${MODELS[@]}"; do
    for f in $IN_PATH/GT_${v}_rlut_20200130-20200228.nc; do
        fname=$(basename $f)
        out_file=$OUT_PATH/timmean_$fname
        echo $fname
        cdo -timmean $f $out_file # computes the mean over each timestep output=[0,nlat,nlon]
        # cdo -hourmean $f $out_file # computes the mean of each hour for all timesteps [24,nlat,nlon]
    done
done

# cdo -timmean $IN_PATH/GT_NICAM_clt_20200130-20200301.nc $OUT_PATH/timmean_GT_NICAM_clt_20200130-20200301.nc
# cdo -select,name="adj_atmos_sw_up_all_toa_1hm","adj_atmos_sw_down_all_toa_1hm","adj_atmos_lw_up_all_toa_1hm","adj_atmos_sw_up_clr_toa_1hm","adj_atmos_sw_down_clr_toa_1hm","adj_atmos_lw_up_all_toa_1hm" $IN_PATH/GT_CERES_rad.nc $IN_PATH/GT_CERES_rad_toa_1hm.nc
# cdo -selseason,JFM $IN_PATH/GT_CERES_rad_toa_1hm.nc $IN_PATH/GT_CERES_rad_toa_1hm_JFM.nc
# cdo -timmean $IN_PATH/GT_CERES_rad_toa_1hm_JFM.nc $OUT_PATH/timmean_GT_CERES_rad_toa_1hm_JFM.nc

echo "done"
