"""
analysis_parameters.py
author: sami turbeville @smturbev

file names saved as variables and easier to call in methods
especially if file names change
"""
import numpy as np
import xarray as xr


home_dir = "/home/disk/eos12/hillmanb/scream/dyamond2/"
native_dir = home_dir + "native/"
coarse_dir = home_dir + "256x512/"
ceres_dir = "/home/disk/eos15/smturbev/SAT_DATA/JanFeb2020/"

# processed output #
SCR2 = "/scratch/b/b380883/dyamond2/"
GEOS = SCR2 + "GEOS/"
NICAM = SCR2 + "NICAM/"
SAM = SCR2 + "SAM/"
SCREAM = SCR2 + "SCREAM/"

## Global Tropics ##
GE_GT=GEOS+"GT/"
NI_GT=NICAM+"GT/"
NI_IT=NICAM+"ITCZ/"
SA_GT=SAM+"GT/"
SC_GT=SCREAM+"GT/"
## TWP ##
GE_TWP=GEOS+"TWP/"
NI_TWP=NICAM+"TWP/"
SA_TWP=SAM+"TWP/"
SC_TWP=SCREAM+"TWP/"
## time mean ##
TIMMEAN = "/scratch/b/b380883/dyamond2/timmean_GT/"

### variable files ###
#### GEOS ####
GE_CLIVI=GE_GT+"clivi_GT_GEOS-6km_20200120-20200229.nc"
GE_RLUT =GE_GT+"rlut_GEOS-6km_GT_20200120-20200229.nc"
GE_RLUTCS=GE_GT+"rlutcs_GEOS-6km_GT_20200120-20200229.nc"
GE_RSDT=GE_GT+"rsdt_GEOS-6km_GT_20200120-20200229.nc"
GE_RSUT=GE_GT+"rsut_GEOS-6km_GT_20200120-20200229.nc"
#### NICAM ####
NI_CLIVI = NI_GT + "clivi_GT_NICAM-3km_20200120-20200228.nc"
NI_RLUT = NI_GT + "rlut_GT_NICAM-3km_20200120-20200228.nc"
NI_RSDT = NI_GT + "rsdt_GT_NICAM-3km_20200120-20200228.nc"
NI_RSUT = NI_GT + "rsut_GT_NICAM-3km_20200120-20200228.nc"
#### SAM ####
SA_CLIVI = SA_GT + "clivi_SAM2-4km_20200120-20200229.nc"
SA_RLUTACC = SA_GT + "GT_SAM_rlutacc_20200120-20200229.nc"
SA_RSUTACC = SA_GT + ""
SA_RSDTACC = SA_GT + ""
#### SCREAMregridded ####
SC_CLIVI = SC_GT + "GT_regridded_clivi_20200120-20200301.nc"
SC_RLT = SC_GT + "GT_regridded_rlt_20200120-20200301.nc"
SC_RLTCS = SC_GT + "GT_regridded_rltcs_20200120-20200301.nc"
SC_RST = SC_GT + "GT_regridded_rst_20200120-20200301.nc"

def get_var_file(model, var):
    if model.lower()=="geos":
        if (var.lower()=="clivi") or (var.lower()=="iwp"):
            return GE_CLIVI
        elif (var.lower()=="rlut") or (var.lower()=="rlt"):
            return GE_RLUT
        elif (var.lower()=="rlutcs") or (var.lower()=="rltcs"):
            return GE_RLUTCS
        elif (var.lower()=="rsut"):
            return GE_RSUT
        elif (var.lower()=="rsdt"):
            return GE_RSDT
    elif model.lower()=="nicam":
        if (var.lower()=="clivi") or (var.lower()=="iwp"):
            return NI_CLIVI
        elif (var.lower()=="rlut") or (var.lower()=="rlt"):
            return NI_RLUT
        elif (var.lower()=="rsut"):
            return NI_RSUT
        elif (var.lower()=="rsdt"):
            return NI_RSDT
    elif model.lower()=="sam":
        if (var.lower()=="clivi") or (var.lower()=="iwp"):
            return SA_CLIVI
        elif (var.lower()=="rlut") or (var.lower()=="rlt") or (var.lower()=="rltacc"):
            print("Accumulated OLR")
            return SA_RLTACC
        elif (var.lower()=="rsut") or (var.lower()=="rsutacc"):
            print("Accumulated RSUT")
            return SA_RSUTACC
        elif (var.lower()=="rsdt") or (var.lower()=="rsdtacc"):
            print("Accumulated RSDT")
            return SA_RSDTACC
    elif model.lower()=="scream":
        if (var.lower()=="clivi") or (var.lower()=="iwp"):
            return SC_CLIVI
        elif (var.lower()=="rlut") or (var.lower()=="rlt"):
            return SC_RLT
        elif (var.lower()=="rlutcs") or (var.lower()=="rltcs"):
            return SC_RLTCS
        elif (var.lower()=="rst"):
            return GE_RST
    else:
        raise Exception("model {} or variable {} input incorrect".format(model, var))
        return

def get_timmean_file(model, var, gt=True):
    if gt:
        if (model.lower()=="geos") or (model.lower()=="sam"):
            return TIMMEAN+"timmean_GT_{m}_{v}_20200120-20200229.nc".format(m=model, v=var)
        elif (model.lower()=="nicam"):
            return TIMMEAN+"timmean_GT_{m}_{v}_20200120-20200228.nc".format(m=model, v=var)
        elif (model.lower()=="scream"):
            return TIMMEAN+"timmean_GT_{m}_{v}_20200120-20200301.nc".format(m=model, v=var)
        else:
            raise Exception("timemean for "+model+" & "+var+" for GT not accepted.")
            return
    else:
        if (model.lower()=="nicam"):
            return TIMMEAN+"timmean_ITCZ_{m}_{v}_20200120-20200228.nc".format(m=model, v=var)
        else:
            raise Exception("timemean for "+model+" & "+var+" for GT not accepted.")
            return

def test_data_file_name(var, date=None, native=False):
    """returns file name of desired file from test data

    Input:
        - var (str): h1-9
        - date(str): format mm-dd ranges from 01-20 to 03-01 

    h0 : 15 min : CAPE, CIN, CLDHGH, CLDLOW, CLDMED, CLDTOT,
    TMCLDICE (INT CLD ICE), TMCLDRIM (?), TMQ (?), TMRAINQM (INT RAIN)
    h1 : 15 min : LHFLX, PRECSL (large scale precip m/s), PRECT (tot precip m/s), PS (surf pressure Pa), 
    QREFHT (reference), TAUX and TAUY (windstress), TREFHT, TS, WINDSPD_10M
    h2 : 15 min : FLDS (downwelling lw sfc), FLNS (net lw sfc), FLNT (net lw toa), 
    FLNTC (clearsky lw toa), FSDS (sw downwelling sfc), FSNS (net sw sfc), 
    FSNTOA (sw net toa), FSNTOAC (clearsky sw toa)
    h3 : 15 min : OMEGA200, 500, 700, 850; RH200, 500, 700, 850; Z200, 500, 700,850
    h4 : 3 hrly : TMNUMICE, TMNUMLIQ, TMNUMRAI
    h5 : 3 hrly : U, V
    h6 : 3 hrly : Q (mixing ratio vapor kg/kg), T (temp K)
    h7 : 3 hrly : CLDICE (kg/kg), CLDLIQ (kg/kg)
    h8 : 3 hrly : CLOUD (fraction), OMEGA (Pa/s)
    h9 : 3 hrly : EMIS (cloud emissivity?), TOT_CLD_VISTAU (cloud optical depth in the visual)
    swd: 15 min : incoming solar radiaiton
    native only has two possible dates available 
    2020-01-20-00000 and 2020-02-17-00000 for h0 and h9 respectively
    """
    if native:
        # only two possible dates available 2020-01-20-00000 and 2020-02-17-00000 for h0 and h9 respectively
        if var=="h0":
            return native_dir + "SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.h0.2020-01-20-00000.nc"
        elif var=="h9":
            return native_dir + "SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.h9.2020-02-17-00000.nc"
        else:
            raise Exception("exploratory data only use var = 'h0' or 'h9', date can be None")
    else:
        if date is None:
            raise Exception("Must include a date as a string in the format of mm-dd in range 01-20 to 03-01 (Jan 20 to March 1)")
        elif date=="all":
            if (var=="swd") or (var=="solin"):
                return "/home/disk/eos12/hillmanb/scream/dyamond2/ne30pg2_256x512/SCREAMv0.SCREAM-DY2.ne30pg2_ne30pg2.20220208.eam.h2.2020*.256x512.nc"
            else:
                return coarse_dir + f"SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.{var}.2020*00000.nc".format(var=var)
        else:
            if (var=="swd") or (var=="solin"):
                return f"/home/disk/eos12/hillmanb/scream/dyamond2/ne30pg2_256x512/SCREAMv0.SCREAM-DY2.ne30pg2_ne30pg2.20220208.eam.h2.2020-{date}-00000.256x512.nc".format(date=date)
            else:
                return coarse_dir + f"SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.{var}.2020-{date}-00000.nc".format(var=var, date=date)
        
def return_ceres(time="hourly"):
    if time=="hourly":
        return ceres_dir + "CERES_SYN1deg-1H_Terra-Aqua-MODIS_Ed4.1_Subset_20200101-20200331.nc"
    elif time=="daily":
        return ceres_dir + "CERES_SYN1deg-Day_Terra-Aqua-MODIS_Ed4.1_Subset_20200101-20200331.nc"
    else:
        raise Exception("only have 'hourly' or 'daily' data available for ceres syn 1")
        
def load_dates(h, lats=(-30, 30), lons=(None, None)):
    lat0, lat1 = lats
    lon0, lon1 = lons               
    feb = [ "02-%02d"%(i+1) for i in range(28) ]
    dates = ["01-30", "01-31"]+ feb
    if h!="swd":
        ds = xr.open_dataset(test_data_file_name(h, dates[0])).drop(["P3_input_dim","P3_output_dim","ilev","lev","swband","lwband", "slat","slon"])
    else:
        ds = xr.open_dataset(test_data_file_name(h, dates[0]))
    if lon0 is None:
        ds = ds.sel(lat=slice(lat0, lat1))
    else:
        ds = ds.sel(lat=slice(lat0, lat1)).sel(lon=slice(lon0,lon1))

    for date in dates[1:]:
        file = test_data_file_name(h, date)
        print(date, end=", ")
        if h!="swd":
            ds_1 = xr.open_dataset(file).drop(["P3_input_dim","P3_output_dim","swband","lwband", "slat","slon"])
        else:
            ds_1 = xr.open_dataset(file)
        if lon0 is None:
            ds_1 = ds_1.sel(lat=slice(lat0, lat1))
        else:
            ds_1 = ds_1.sel(lat=slice(lat0, lat1)).sel(lon=slice(lon0,lon1))
        ds = xr.combine_by_coords([ds, ds_1])
    return ds
