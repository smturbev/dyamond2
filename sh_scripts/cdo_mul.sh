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
scr="/scratch/b/b380883"
twp="/work/bb1153/b380883/TWP"
gt="/work/bb1153/b380883/GT"
wrk="/work/bb1153/b380883"
var="iwc"
# set model in below code for each var

##################
####   mean   ####
##################
# Calculate IWP (kg/m2) from ice snow and graupel (kg/m2)
if [ $var = 'mean' ]; then
    for m in "${ModelArray[@]}"; do
        echo $m
        in_file=$twp/TWP_3D_${m}_iwc_20200130-20200228.nc
        cdo -fldmean -timmean $in_file $twp/mean/mean_xyt_${m}_iwc_20200130-20200228.nc
    done
fi

##################
####    IWP   ####
##################
# Calculate IWP (kg/m2) from ice snow and graupel (kg/m2)
if [ $var = 'iwp' ]; then
    for m in "${ModelArray[@]}"; do
        echo $m
        grpl=$twp/TWP_${m}_qgvi_20200130-20200228.nc
        snow=$twp/TWP_${m}_qsvi_20200130-20200228.nc
        cldi=$twp/TWP_${m}_clivi_20200130-20200228.nc
        iwp=$twp/TWP_${m}_iwp_20200130-20200228.nc
        cdo -setname,iwp -setattribute,"long_name"="total ice water path (ice + snow + graupel)" -add -add $grpl $snow $cldi $iwp
    done
fi



###############################
###  SAM pressure field     ###
###############################
if [ $var = 'pres' ]; then
    model="SAM"
    
    pres=$gt/TTL_SAM_pres.nc
    ta=$gt/GT_TTL_SAM_ta_20200130-20200228.nc
    tmp1=$scr/SAM_pa_empty.nc
    tmp2=$scr/SAM_pa_same.nc
    tmp3=$scr/SAM_pa_coslat
    out=$scr/GT_${model}_pres_test.nc
    
    cdo -gec,0 $ta $tmp1 
    cdo -ifthen $tmp1 $pres $tmp2
    cdo -cos -clat $tmp2 $tmp3
    cdo -mul $tmp3 $tmp2 $out
fi

#################
###  hist     ###
#################
if [ $var = 'hist' ]; then
    model="SCREAM"
    
    clivi=$gt/GT_${model}_clivi_20200130-20200228.nc
    out=$scr/GT_${model}_clivi_histcount_test.nc
    bins=1e-7,5.4e-7,2.8e-6,1.5e-5,8.1e-5,4.3e-4,2.3e-3,1.2e-2,6.6e-2,3.5e-1,1.8,10
    
    cdo -histcount,$bins $clivi $out
fi

#################
###    Tv     ###
#################
if [ $var = 'tv' ]; then
    model="ARP"
    
    hus=$twp/TWP_3D_${model}_hus_20200130-20200228.nc
    ta=$twp/TWP_3D_${model}_ta_20200130-20200228.nc
    tv=$twp/TWP_3D_${model}_Tv_20200130-20200228.nc
    
    cdo -mul -addc,1 -mulc,0.61 $hus $ta $tv
fi

##################
####    IWC   ####
##################
# Calculate IWC (kg/m3) from mixing ratio (kg/kg)
# rho = p / (287*(1 + 0.61*(qv))*(t)
# iwc = qi.values * rho
if [ $var = 'iwc' ]; then

    m='SAM'
    region='twp'
    type='tot' # type: 'tot'=total or 'ice'=ice only
    if [ $type = 'tot' ]; then
        p=$twp/TWP_3D_${m}_pa_20200130-20200228.nc # Pa
        t=$twp/TWP_3D_${m}_ta_20200130-20200228.nc # K
        hus=$twp/TWP_3D_${m}_hus_20200130-20200228.nc # kg/kg
        rho_d=$scr/temp/rhod_${m}.nc
        rho=$scr/temp/rho_${m}.nc
        qf=$twp/TWP_3D_${m}_cltotal_20200130-20200228.nc # kg/kg
    else
        p=$twp/TWP_3D_${m}_pa_20200130-20200228.nc
        t=$twp/TWP_3D_${m}_ta_20200130-20200228.nc
        hus=$twp/TWP_3D_${m}_hus_20200130-20200228.nc
        rho_d=$scr/rhod_${m}.nc
        rho=$scr/rho_${m}.nc
        qf=$twp/TWP_3D_${m}_cli_20200130-20200228.nc
    
    fi
    # qf=$scr/qf_${m}.nc
    # qi=$twp/TWP_3D_${m}_cli_20200130-20200228.nc
    # qs=$twp/TWP_3D_${m}_snowmxrat_20200130-20200228.nc
    # qg=$twp/TWP_3D_${m}_grplmxrat_20200130-20200228.nc
    iwc=$twp/TWP_3D_${m}_iwc_20200130-20200228.nc
    
    cdo -mul -mulc,287 -addc,1 -mulc,0.61 $hus $t $rho_d 
    cdo -div $p $rho_d $rho
    # cdo -add -add $qi $qs $qg $qf
    cdo -setname,iwc -setunit,"kg/m3" -mul $rho $qf $iwc
fi


##################
####  RHice   ####
##################
# e_si = np.exp(9.550426 - 5723.265/T + 3.53068*np.log(T) - 0.00728332*T)
# w_si = 0.622 * e_si / p
# w_i  = qv / (1 - qv)
# rh_ice = w_i/w_si * 100
# return rh_ice

if [ $var = 'rhice' ]; then
    m="ICON"

    ta=$twp/TWP_3D_${m}_ta_20200130-20200228.nc
    qv=$twp/TWP_3D_${m}_hus_20200130-20200228.nc
    p=$twp/TWP_3D_${m}_pa_20200130-20200228.nc

    out2=$scr/"temp2.nc"
    out3=$scr/"temp3.nc"
    out4=$scr/"temp4.nc"
    esi=$scr/"esi_temp.nc"
    num=$scr/"temp5.nc"
    dom=$scr/"temp6.nc"
    wsi=$scr/"wsi_temp.nc"
    dom_qv=$scr/"temp7.nc"
    wi=$scr/"wi_temp.nc"
    rhice=$twp/TWP_3D_${m}_rhice_20200130-20200228.nc

    cdo -mulc,-5723.265 -reci $ta $out2
    cdo -mulc,3.53068 -ln $ta $out3
    cdo -mulc,-0.00728332 $ta $out4
    cdo -exp -addc,9.550426 -add -add $out2 $out3 $out4 $esi
    cdo -mulc,0.622 -div $esi $p $wsi
    cdo -addc,1 -mulc,-1 $qv $dom_qv
    cdo -div $qv $dom_qv $wi
    cdo -setname,"rhice" -setunit,"%" -mulc,100 -div $wi $wsi $rhice
fi


########################
###     Theta e      ###
########################
# e_si = np.exp(9.550426 - 5723.265/T + 3.53068*np.log(T) - 0.00728332*T)
# w_si = 0.622 * e_si / p
# theta = T (p_0/p)^(R_d/c_p) = T (1000 hPa/p)^(0.286)
# theta_e = theta exp(Lv*w_si/c_p/T)

if [ $var = 'thetae' ]; then
    m="UM"

    ta=$twp/TWP_3D_${m}_ta_20200130-20200228.nc
    p=$twp/TWP_3D_${m}_pfull_20200130-20200228.nc

    out2=$scr/"temp2.nc"
    out3=$scr/"temp3.nc"
    out4=$scr/"temp4.nc"
    out5=$scr/"temp5.nc"
    out6=$scr/"temp6.nc"
    esi=$scr/"esi_temp.nc"
    wsi=$scr/"wsi_temp.nc"
    theta=$scr/"theta.nc"
    thetae=$twp/TWP_3D_${m}_thetae_20200130-20200228.nc

    cdo -mulc,-5723.265 -reci $ta $out2
    cdo -mulc,3.53068 -ln $ta $out3
    cdo -mulc,-0.00728332 $ta $out4
    cdo -exp -addc,9.550426 -add -add $out2 $out3 $out4 $esi
    cdo -mulc,0.622 -div $esi $p $wsi
    cdo -mul -pow,0.286 -mulc,100000 -reci $p $ta $theta
    cdo -mulc,2491.0359 -div $wsi $ta $out5
    cdo -exp $out5 $out6
    cdo -setname,"thetae" -setunit,"K" -mul $out5 $theta $thetae
fi

echo "done"
