"""
analysis_parameters.py
author: sami turbeville @smturbev

file names saved as variables and easier to call in methods
especially if file names change
"""

import numpy as np
import xarray as xr
import json

# Color scheme from dyamond
COLOR_JSON = "/home/b/b380883/dyamond2/dyamond_colors.json"
def js_r(filename):
    with open(filename) as f_in:
        return(json.load(f_in))
COLORS = js_r(COLOR_JSON)

# processed output #
WRK = "/work/bb1153/b380883/"

## Regions ##
GT  = WRK+"GT/"
TWP = WRK+"TWP/"
DY1 = WRK+"dyamond1/"
TWP1 = DY1+"TWP/"

# data #
CERES_SYN1_1H = "/work/bb1153/b380883/TWP/CERES_SYN1deg-1H_Terra-Aqua-MODIS_Ed4.1_Subset_20200101-20200331.nc"
CERES_SYN1_ANN_MEAN_DY1 = "/work/bb1153/b380883/dyamond1/TWP/CERES_SYN1_3H_mean_JAS_2001-2019.nc"
CERES_SYN1_ANN_MEAN_DY2 = "/work/bb1153/b380883/TWP/CERES_SYN1_3H_mean_JFM_2002-2019.nc"
CCCM_JAS = TWP+"CERES_CCCM_JAS_2007-2011.nc"
CCCM_JFM = TWP+"CERES_CCCM_JFM_2007-2011.nc"
ERA5_TWP = "/work/bb1153/b380887/10x10/TWP/"
ERA5_TWP_zg = ERA5_TWP + "ERA5_geopotential_50-200mb_winter_TWP.nc"
ERA5_TWP_ta = ERA5_TWP + "ERA5_temp_50-200mb_winter_TWP.nc"
CERES_SYN1_DY1 = "/work/bb1153/b380883/dyamond1/TWP/TWP_CERES_20000801-20190910.nc"
CERES_YM_DY1 = "/work/bb1153/b380883/dyamond1/TWP/TWP_CERES_yearmean_20000801-20190910.nc"
DARDAR_GT_IWPHIST = "/work/bb1153/b380883/GT/stats/IWPonly_iwphist_2007-2017_DARDARv3.nc"
DARDAR_GT_IWPHISTe3 = "/work/bb1153/b380883/GT/stats/IWP1e-3only_iwphist_2007-2017_DARDARv3.nc"
## time mean ##
TIMMEAN_GT = GT+"timmean/"
UM_PFULL_MEAN = TWP+"mean/fldmean_TWP_3D_UM_pfull_20200130-20200228.nc"
UM_PHALF_MEAN = TWP+"mean/fldmean_TWP_3D_UM_phalf_20200130-20200228.nc"
UM_PFULL = TWP+"TWP_3D_pfull_3hr_UM_20200130-20200228.nc"
UM_PHALF = TWP+"TWP_3D_phalf_3hr_UM_20200130-20200228.nc"

## stats ##
STATS=WRK+"stats/"
TWP_MEANOLR_DY1=STATS+"TWP/dyamond1/TWP_meanOLR_DY1_models.nc"
TWP_MEANOLR_DY2=STATS+"TWP/dyamond2/TWP_meanOLR_DY2_models.nc"
TWP_MEANSWU_DY1=STATS+"TWP/dyamond1/TWP_meanSWU_DY1_models.nc"
TWP_MEANSWU_DY2=STATS+"TWP/dyamond2/TWP_meanSWU_DY2_models.nc"


def get_file(model, region="TWP", var="rlut"):
    """ returns file path for given variable, region and model
    
        Input:
            - model  (str) : model name - case sensitive
            - var    (str) : variable name - case sensitive
            - region (str) : region (accepts 'TWP' and 'GT' or 'tropics') - not case sensitive
                             default is TWP region (143-153E,5N-5S)
                             Tropics or GT is equitorial belt from 30N to 30S
        Output:
            - filename(str): returns a string of the file name for given input
    """
    if model.lower()=="data" or model.lower()=="ceres":
        if var.lower()=="olr" or var.lower()=="rlut" or var.lower()=="rad" or var.lower()=="sw":
            if region.lower()[:3]=="twp":
                return CERES_SYN1_1H
            elif region.lower()=="gt" or region.lower()=="tropics":
                return
            else:
                raise Exception("region not valid, try TWP or GT")
    elif region.lower()[:3]=="twp":
        return TWP+region+"_"+model+"_"+var+"_20200130-20200228.nc"
    elif region.lower()[:2]=="gt":
        return GT+region+"_"+model+"_"+var+"_20200130-20200228.nc"
    else:
        raise Exception("region {} or model {} or var {} not valid".format(region, model, var))
        return
    return

def get_dyamond1(model, region="TWP", var="rlt"):
    """ returns file path for given variable, region and model
    
        Input:
            - model  (str) : model name - case sensitive
            - var    (str) : variable name - case sensitive
            - region (str) : region (accepts 'TWP' and 'GT' or 'tropics') - not case sensitive
                             default is TWP region (143-153E,5N-5S)
                             Tropics or GT is equitorial belt from 30N to 30S
        Output:
         - filename(str): returns a string of the file name for given input
    """
    return TWP1+region+"_"+model+"_"+var+"_20160810-20160910.nc"

def get_timmean_file(model, region="twp", var="clt"):
    if model=="CERES":
        return WRK+region.upper()+"/"+region+"_"+model+"_"+var+".nc"
    if region.lower()=="twp":
        return TWP+"mean/timmean_TWP_"+model+"_"+var+"_20200130-20200228.nc"
    elif region.lower()=="gt" or region.lower()=="tropics":
        return GT+"timmean/timmean_GT_"+model+"_"+var+"_20200130-20200228.nc"
    elif region.lower()=="gt_14-18km":
        return GT+"timmean/timmean_GT_14-18km_"+model+"_"+var+"_20200130-20200228.nc"
    else:
        raise Exception("region {} not valid".format(region))
    return
    
def get_fldmean_file(model, region="twp", var="pr"):
    if var=="zg":
        return TWP+"mean/fldmean_"+region+"_3D_"+model+"_zg_20200130-20200228.nc"
    if region.lower()=="gt" or region.lower()=="tropics":
        if model=="CERES":
            return GT+"fldmean/fldmean_GT_CERES_rad_toa_1hm_JFM.nc"
        else:
            return GT+"fldmean/fldmean_GT_{m}_{v}_20200130-20200228.nc".format(m=model, v=var)
    elif region.lower()=="twp":
        return TWP+"mean/fldmean_TWP_3D_"+model+"_"+var.lower()+"_20200130-20200228.nc"
    return

def get_mermean_file(model, region="gt", var="rlt"):
    if model=="CERES":
        return GT+"fldmean/mermean_GT_CERES_rad_toa_1hm_JFM.nc"
    else:
        return GT+"fldmean/mermean_GT_{m}_{v}_20200130-20200228.nc".format(m=model, v=var)

def get_timcumsum_file(model, region="gt", var="pracc"):
    """Returns cumulative precip endvalue on 2020-02-28T23:45:00 from the start on 2020-01-30T00:00:00"""
    if region.lower()=="gt":
        return GT+"timmean/timcumsum_GT_{}r1deg_{}_20200228T234500.nc".format(model, var)
    else:
        raise Exception("only works for tropical band (GT)")

def get_daymean_file(model, region="gt", var="pracc"):
    """Returns precip rate over last 30 days as daily means"""
    if region.lower()=="gt":
        return GT+"timmean/daymean_GT_{}r1deg_{}_20200130-20200228.nc".format(model, var)
    else:
        raise Exception("only works for tropical band (GT)")

def get_xytmean_file(model, region="TWP", var="zg"):
    return TWP+"mean/xytmean_"+region+"_3D_"+model+"_zg_20200130-20200228.nc"
    
def get_fldmedian_file(model, region="TWP", var="pr"):
    return TWP+"mean/fldmedian_TWP_3D_"+model.upper()+"_"+var.lower()+"_20200130-20200228.nc"

def open_file(model, region="TWP", var="rlut", timmean=False, fldmean=False, fldmedian=False):
    if timmean:
        return xr.open_dataset(get_timmean_file(model, region, var))
    elif fldmean:
        return xr.open_dataset(get_fldmean_file(model, region, var))
    elif fldmedian:
        return xr.open_dataset(get_fldmedian_file(model, region, var))
    else:
        return xr.open_dataset(get_file(model, region, var))

def open_dyamond1(model, region="TWP", var="rlut"):
    return xr.open_dataset(get_dyamond1(model, region, var))


##############################################################################
### Load modules
##############################################################################
def load_iwp(model, region, total=True, chunks=None):
    """Returns the total or ice only integrated water path for the given region"""
    if model[:6]=="SCREAM" or model[:2]=="UM":
        iwp = xr.open_dataset(WRK+region+\
                              "/{}_{}_clivi_20200130-20200228.nc".format(region, model), 
                              chunks=chunks).clivi
        print("returning", WRK+region+\
                              "/{}_{}_clivi_20200130-20200228.nc".format(region, model))
    elif total:
        try:
            iwp = xr.open_dataset(WRK+region+\
                          "/{}_{}_iwp_20200130-20200228.nc".format(region, model), 
                          chunks=chunks).iwp
            print("returned ice + snow + graupel", model, region)
        except:
            # print(WRK+region+"/{}_{}_iwp_20200130-20200228.nc".format(region, model))
            iwp = xr.open_dataset(WRK+region+\
                          "/{}_{}_clivi_20200130-20200228.nc".format(region, model), 
                          chunks=chunks).clivi
            qg = xr.open_dataset(WRK+region+\
                          "/{}_{}_qgvi_20200130-20200228.nc".format(region, model), 
                          chunks=chunks).qgvi
            qs = xr.open_dataset(WRK+region+\
                          "/{}_{}_qsvi_20200130-20200228.nc".format(region, model), 
                          chunks=chunks).qsvi
            iwp = iwp + qg + qs
            print("iwp = clivi + qsvi + qgvi calculated here", model, region)
    else:
        try:
            iwp = xr.open_dataset(WRK+region+\
                          "/{}_{}_clivi_20200130-20200228.nc".format(region, model), 
                          chunks=chunks).clivi
            print("returned ice only", model, region)
        except:
            print("download clivi for {} in the {} region".format(model, region))
    return iwp
                


def load_olr(model, region="TWP",r=0):
    """ get the OLR radiation variable in W/m2 for given model and region for specified regridded resolution
        r=0 for native grid, r=0.1 for 0.1 deg remapcon, r=1 for 1 deg remapcon
    """
    chunk_dict = {"time":500, "lat":400, "lon":1440} # "grid_size":500000}
    if (model=="CERES"):
        olr = xr.open_dataset(get_file("DATA", "TWP", "rad"), chunks=chunk_dict).adj_atmos_lw_up_all_toa_1h
    elif (model=="CCCM"):
        olr = xr.open_dataset(CCCM_JFM).CERES_LW_TOA_flux___upwards
    else: #model
        if r>0:
            # housekeeping - make sure r=0.1 for TWP region, and set up chunk dictionary for dask
            if (region=="TWP") & (r!=0.1):
                raise Exception("r={} not defined for {} region.".format(r,region))
            # models
            if (model=="SCREAM") or (model=="ARP") or (model=="SAM"):
                # rlt r0.1 deg
                olr = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rlt"), chunks=chunk_dict).rlt
            elif (model=="GEOS") or (model=="SHiELD"):
                # rlut r0.1 deg
                olr = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rlut"), chunks=chunk_dict).rlut
            elif (model=="ICON"):
                # ICON needs extra care due to first hour messed up from accumulation
                olr = xr.open_dataset(get_file("ICONr{}deg".format(r), region, "rlt"), chunks=chunk_dict).rlt
                olr = olr.where(olr.time.dt.hour!=0) # first hour is messed up b/c of accumulation
            elif (model=="UM"):
                # native grid coarsened to 0.1 deg to match other models
                olr = xr.open_dataset(get_file("UM",region,"rlut"), 
                                      chunks=chunk_dict).rlut.coarsen(latitude=int(214/100), longitude=int(142/100), boundary='trim').mean()
            elif (model=="MPAS"):
                # native grid coarsened to 0.1 deg to match other models
                olr = xr.open_dataset(get_file("{}r{}deg".format(model, r),region,"rlt"), 
                                      chunks=chunk_dict).rlt.rename({"xtime":"time"})
                olr['time'] = olr.time.astype('datetime64[ns]')
            elif (model=="IFS"):
                olr = xr.open_dataset(get_file("{}r{}deg".format(model, r),region,"rlt"), 
                                      chunks=chunk_dict).rlt
            else:
                raise Exception("model or region not defined properly. Try 'TWP' or 'SCREAM', 'UM', 'GEOS', etc.")
        else: #native grid
            if (model=="SCREAM"):
                olr = xr.open_dataset(get_file(model, region, "rlt"), chunks={"time":500, "ncol":1000, "grid_size":1000}).rlt
            elif (model=="ARP") or (model=="IFS"): #rlt native grid
                olr = xr.open_dataset(get_file(model, region, "rlt"), chunks={"time":500,"rgrid":1000}).rlt
            elif (model=="SAM"):
                olr = xr.open_dataset(get_file(model, region, "rlt"), chunks={"time":500,"latlon":1000}).rlt
            elif (model=="GEOS") or (model=="SHiELD"): #rlut native grid
                olr = xr.open_dataset(get_file(model, region, "rlut"), chunks={"time":500,"Xdim":1000}).rlut
            elif (model=="UM"):
                olr = xr.open_dataset(get_file(model,region,"rlut"), chunks=chunk_dict).rlut
            elif (model=="ICON"):
                # ICON needs extra care due to first hour messed up from accumulation
                olr = xr.open_dataset(get_file("ICON", region, "rlt"), chunks={"time":500, "ncell":1000}).rlt
                olr = olr.where(olr.time.dt.hour!=0) # first hour is messed up b/c of accumulation
            elif (model=="MPAS"):
                olr = xr.open_dataset(get_file("MPAS", region, "rlt"), chunks={"xtime":500, "ncols":1000}).rlt.rename({"xtime":"time"})
                olr['time'] = olr.time.astype('datetime64[ns]')
            else:
                raise Exception("model or region not defined properly. Try 'TWP' or 'SCREAM', 'UM', 'GEOS', etc.")
    return olr

def load_swu_swd(model, region="TWP", r=0, clearsky=False):
    """ returns a tuple of xarrays of (SW upward, SW downward) radiation variable in W/m2 for given model and region for specified regridded resolution
        r=0 for native grid, r=0.1 for 0.1 deg remapcon, r=1 for 1 deg remapcon
        
        clearsky only matters for SCREAM
    """
    print(clearsky)
    chunk_dict = {"time":500, "lat":400, "lon":1440} # "grid_size":500000}
    if (model=="CERES"):
        ds = xr.open_dataset(get_file("DATA", "TWP", "rad"), chunks=chunk_dict)
        swu = ds.adj_atmos_sw_up_all_toa_1h
        swd = ds.adj_atmos_sw_down_all_toa_1h
    elif (model=="CCCM"):
        ds = xr.open_dataset(CCCM_JFM)
        swu = ds.CERES_SW_TOA_flux___upwards
        swd = ds.TOA_Incoming_Solar_Radiation
    else: # models
        if r>0:
            # housekeeping - make sure r=0.1 for TWP region, and set up chunk dictionary for dask
            if (region=="TWP") & (r!=0.1):
                raise Exception("r={} not defined for {} region.".format(r,region))
            # models
            if (model=="SCREAM"):
                if clearsky:
                    swn = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rstcs"), 
                                      chunks={"time":500, "ncol":1000, "grid_size":1000}).rstcs
                    print("returning clear sky swu\n\n")
                else:
                    swn = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rst"), 
                                      chunks={"time":500, "ncol":1000, "grid_size":1000}).rst
                swd = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rsdt"), 
                                      chunks={"time":500, "ncol":1000, "grid_size":1000}).rsdt
                swu = swd-swn
            
            elif (model=="ARP") or (model=="SAM"):
                # rst r0.1 deg
                swn = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rst"), chunks=chunk_dict).rst
                swd_ex = xr.open_dataset(get_file("GEOSr{}deg".format(r), region, "rsdt"), 
                                         chunks=chunk_dict).rsdt
                swd = swd_ex.interp(time=swn.time,
                           lat=swn.lat, lon=swn.lon,
                           method="nearest",
                           kwargs={"fill_value": np.nan})
                swu = (swd[:swn.shape[0]] - swn[:swd.shape[0]])
            elif (model=="GEOS") or (model=="SHiELD"):
                # rlst r0.1 deg
                if clearsky:
                    swu = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rsutcs"), chunks=chunk_dict).rsutcs
                else:
                    swu = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rsut"), chunks=chunk_dict).rsut
                swd = xr.open_dataset(get_file("{}r{}deg".format(model, r), region, "rsdt"), chunks=chunk_dict).rsdt
            elif (model=="ICON"):
                # ICON needs extra care due to first hour messed up from accumulation
                swu = xr.open_dataset(get_file("ICONr{}deg".format(r), region, "rsut"), chunks=chunk_dict).rsut
                swn = xr.open_dataset(get_file("ICONr{}deg".format(r), region, "rst"), chunks=chunk_dict).rst
                swu = swu.where(swu.time.dt.hour!=0) # first hour is messed up b/c of accumulation
                swn = swn.where(swn.time.dt.hour!=0)
                swd = swn + swu.values
            elif (model=="IFS"):
                swn = xr.open_dataset(get_file("{}r{}deg".format(model, r),region,"rst"), chunks=chunk_dict).rst
                swd = xr.open_dataset(get_file("{}r{}deg".format(model, r),region,"rsdt"), chunks=chunk_dict).rsdt
                swu = (swd - swn)
            elif (model=="UM"):
                # native grid coarsened to 0.1 deg to match other models
                swu = xr.open_dataset(get_file(model, region, "rsut"), chunks=chunk_dict).rsut.coarsen(latitude=int(214/100*(r*10)), longitude=int(142/100*(r*10)), boundary='trim').mean()
                swd = xr.open_dataset(get_file(model, region, "rsdt"), chunks=chunk_dict).rsdt.coarsen(latitude=int(214/100*(r*10)), longitude=int(142/100*(r*10)), boundary='trim').mean()
            elif (model=="MPAS"):
                swn = xr.open_dataset(get_file("MPASr0.1deg", region, "rst"), chunks={"xtime":500, "lat":100, "lon":500}).rst.rename({"xtime":"time"})
                swd_ex = xr.open_dataset(get_file("GEOSr0.1deg", region, "rsdt"), 
                                         chunks={"time":500,"lat":200, "lon":500}).rsdt
                swn['time'] = swn.time.astype('datetime64[ns]')
                swd = swd_ex.sel(time=swn.time)
                swu = (swd.values - swn)
            else:
                raise Exception("model or region not defined properly. Try 'TWP' or 'SCREAM', 'UM', 'GEOS', etc.")
        else: #native grid
            if (model=="SCREAM"):
                if clearsky:
                    print('returning cs swu')
                    swn = xr.open_dataset(get_file(model, region, "rstcs"), chunks={"time":500, "ncol":1000, "grid_size":1000}).rstcs
                else:
                    print('returning swn all sky')
                    if region=="TWP":
                        swn = xr.open_dataset(get_file(model, region, "rst"), chunks={"time":500, "ncol":1000, "grid_size":1000}).rst.rename({"grid_size":"ncol"})
                    else:
                        swn = xr.open_dataset(get_file(model, region, "rst"), chunks={"time":500, "ncol":1000, "grid_size":1000}).rst.rename({"grid_size":"ncol"})
                swd = xr.open_dataset(get_file("SCREAM", region, "rsdt"), chunks=chunk_dict).rsdt
                swu = swd-swn
            elif (model=="ARP") or (model=="IFS"): # 
                swn = xr.open_dataset(get_file(model, region, "rst"), 
                                      chunks={"time":500,"rgrid":1000}).rst
                swd_ex = xr.open_dataset(get_file("GEOS", region, "rsdt"), 
                                         chunks={"time":500,"Xdim":1000}).rsdt.rename({"Xdim":"rgrid"})
                swd = swd_ex.interp(time=swn.time,
                           rgrid=swn.rgrid, 
                           method="nearest",
                           kwargs={"fill_value": np.nan})
                swu = (swd - swn)
            elif (model=="SAM"):
                swn = xr.open_dataset(get_file(model, region, "rst"), 
                                      chunks={"time":500,"latlon":1000}).rst
                swd_ex = xr.open_dataset(get_file("GEOS", region, "rsdt"), 
                                         chunks={"time":500,"Xdim":1000}).rsdt.rename({"Xdim":"latlon"})
                swd = swd_ex.interp(time=swn.time,
                           rgrid=swn.lonlat, 
                           method="nearest",
                           kwargs={"fill_value": np.nan})
                swu = (swd - swn)
            elif (model=="GEOS") or (model=="SHiELD"): #rlut native grid
                if clearsky:
                    swu = xr.open_dataset(get_file(model, region, "rsutcs"), chunks={"time":500,"Xdim":1000}).rsutcs
                else:
                    swu = xr.open_dataset(get_file(model, region, "rsut"), chunks={"time":500,"Xdim":1000}).rsut
                swd = xr.open_dataset(get_file(model, region, "rsdt"), chunks={"time":500,"Xdim":1000}).rsdt
            elif (model=="UM"):
                swu = xr.open_dataset(get_file(model,region,"rsut"), chunks=chunk_dict).rsut
                swd = xr.open_dataset(get_file(model,region,"rsdt"), chunks=chunk_dict).rsdt
            elif (model=="ICON"):
                # ICON needs extra care due to first hour messed up from accumulation
                swu = xr.open_dataset(get_file("ICON", region, "rsut"), chunks=chunk_dict).rsut
                swn = xr.open_dataset(get_file("ICON", region, "rst"), chunks=chunk_dict).rst
                swu = swu.where(swu.time.dt.hour!=0) # first hour is messed up b/c of accumulation
                swn = swn.where(swn.time.dt.hour!=0)
                swd = swn + swu.values
            elif (model=="IFS"):
                swn = xr.open_dataset(get_file(model,region,"rst"), chunks=chunk_dict).rst
                swd = xr.open_dataset(get_file(model,region,"rsdt"), chunks=chunk_dict).rsdt
                swu = (swd - swn)
            elif (model=="MPAS"):
                swn = xr.open_dataset(get_file("MPAS", region, "rst"), chunks={"xtime":500, "nCells":1000}).rst.rename({"xtime":"time", "nCells":"ncol"})
                swn['time'] = swn.time.astype('datetime64[ns]')
                swd_ex = xr.open_dataset(get_file("GEOS", region, "rsdt"), 
                                         chunks={"time":500,"Xdim":1000}).rsdt.rename({"Xdim":"ncol"})
                swd = swd_ex.interp(time=swn.time,
                           ncol=swn.ncol, 
                           method="nearest",
                           kwargs={"fill_value": np.nan})
                swu = (swd - swn)
            else:
                raise Exception("model or region not defined properly. Try 'TWP' or 'SCREAM', 'UM', 'GEOS', etc.")
    return (swu, swd)

def load_alb(model, region="TWP", r=0, clearsky=False, near_noon=True):
    """ returns albedo of a given model and region for specified resolution (r=0 is native grid) 
        near_noon : returns values only between 8am-4pm (gets rid of dusk/dawn problem) """
    swu, swd = load_swu_swd(model, region, r, clearsky)
    if swu.shape == swd.shape:
        alb = swu/swd.where(swd>100).values
    elif swu.shape[0]>swd.shape[0]:
        alb = swu[:swd.shape[0]]/swd.where(swd>100).values
    elif swu.shape[0]<swd.shape[0]:
        alb = swu/swd[:swu.shape[0]].where(swd>100).values
    else:
        raise Exception("shape of swu and swd don't match:",swu.shape, swd.shape)
    if near_noon:
        if region.lower()=="twp":
            alb = alb.where((alb.time.dt.hour>=22)|(alb.time.dt.hour<=6))
        else:
            raise Exception("define hours near noon for this region",region)
    return alb

def load_olr_alb_dy1(model, region="TWP", near_noon=True):
    if model[:2]=="CC":
        ds = xr.open_dataset(CCCM_JAS)
        olr = ds.CERES_LW_TOA_flux___upwards
        swu = ds.CERES_SW_TOA_flux___upwards
        swd = ds.TOA_Incoming_Solar_Radiation
        alb = swu/swd.values
    else:
        if model[:2]=="MP":
            print("... dy1 getting sw mpas for",model)
            swn = xr.open_dataset(get_dyamond1(model, region, "rst"), chunks={"time":100}).rst
            swd = xr.open_dataset(get_dyamond1("NICAM",region,"rsdt"), chunks={"time":100}).rsdt.isel(lev=0).isel(time=slice(0,len(swn.xtime))).values
            swu = (swd - swn)
        elif model[:2]=="IC":
            swn = xr.open_dataset(get_dyamond1(model, region, "rst"), chunks={"time":100}).rst
            swu = xr.open_dataset(get_dyamond1(model, region, "rsut"), chunks={"time":100}).rsut
            swd = swu + swn.values
        elif (model[:2] == "AR") or (model[:2] == "GE") or (model[:2] == "IF") or (model[:2] == "SA"):
            print("... dy1 getting sw for",model)
            swn = xr.open_dataset(get_dyamond1(model, region, "rst"), chunks={"time":100}).rst
            swd = xr.open_dataset(get_dyamond1("NICAM",region,"rsdt"), chunks={"time":100}).rsdt.isel(lev=0).sel(time=swn.time, method="nearest").values
            swu = (swd - swn)
        elif (model[:2] == "FV") or (model[:2] == "NI") or (model[:2] == "UM"):
            swu = xr.open_dataset(get_dyamond1(model, region, "rsut"), chunks={"time":100}).rsut
            swd = xr.open_dataset(get_dyamond1(model, region, "rsdt"), chunks={"time":100}).rsdt
        else:
            return (None, None)
        print("... got sw")
        alb = swu/swd
        if near_noon:
            if region.lower()=="twp":
                if model=="SAM":
                    alb = alb.where((alb.time.dt.hour>=2)&(alb.time.dt.hour<=6))
                elif model=="MPAS":
                    print("MPAS not near noon only, plotting all time for dy1")
                else:
                    alb = alb.where((alb.time.dt.hour<=4))
        print("... got alb")
        olr = xr.open_dataset(get_dyamond1(model, region, "rlt"), chunks={"time":100}).rlt
        print("... got olr")
    return olr, alb

def load_height_full(model, region="TWP", r=0, chunks=None):
    """ get full height in meters varies in time and space """
    if model=="SAM":
        zg = xr.open_dataset(get_file(model, region+"_3D","ta")).z
    else:
        if chunks is None:
            zg = xr.open_dataset(get_file(model, region+"_3D", "zg")).zg
        else:
            zg = xr.open_dataset(get_file(model, region+"_3D", "zg"), chunks=chunks).zg
    return zg

def load_height_easy(model, region="TWP", r=0):
    """ for plotting """
    if model=="SAM":
        zg = xr.open_dataset(get_file(model, region+"_3D","ta")).z
    else:
        zg = xr.open_dataset(get_xytmean_file(model, region+"_3D", "zg")).zg
    return zg

def load_3dvar(model, region="TWP", var="ta", r=0, chunks=None):
    """ get native grid 3d variable """
    if chunks is None:
        var = xr.open_dataset(get_file(model, region+"_3D", var))[var]
    else:
        var = xr.open_dataset(get_file(model, region+"_3D", var), chunks=chunks)[var]
    var = var.where(var<1e20)
    return var
