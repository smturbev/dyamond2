#!/bin/bash
#SBATCH --job-name=seldate
#SBATCH --partition=shared
#SBATCH --account=bb1153
#SBATCH --time=02:00:00
#SBATCH --error=err_30days.eo
#SBATCH --output=out_30days.eo
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu

set -evx # verbose messages and crash message
wrk=/work/bb1153/b380883/TWP

declare -a fileArray=(
# TWP_3D_GEOS_pthick_20200130-20200228.nc
TWP_3D_GEOS_grplmxrat_20200130-20200228.nc
)


for file in "${fileArray[@]}"; do
    in_file=$wrk/$file
    out_file=$wrk/${file%.*}"new.nc"
    echo $in_file" "$out_file
    # cdo -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $in_file $out_file
    # cdo -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $in_file $out_file
    # for ICON... 2020-02-28T16:30:00
    cdo -seltimestep,1/720 $in_file $out_file
    # cdo -seltimestep,1,2880 $in_file $out_file
    rm $in_file
    mv $out_file $in_file
done

# cdo -setname,"pa" $wrk/TWP_3D_GEOS_pa_20200130-20200228.nc $wrk/TWP_3D_GEOS_pa_20200130-20200228new.nc 
# cdo -setname,"rst" -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $wrk/TWP_GEOS-3.25km_SWTNET_0.10deg.nc $wrk/TWP_GEOS_rst_20160810-20160910.nc
# cdo -setname,"rlt" -seldate,2016-08-10T00:00:00,2016-09-10T23:59:00 $wrk/TWP_GEOS-3.25km_OLR_0.10deg.nc $wrk/TWP_GEOS_rlt_20160810-20160910.nc

echo "done"
