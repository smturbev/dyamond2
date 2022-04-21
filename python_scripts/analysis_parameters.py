# analysis_parameters.py
# Sami Turbeville
# b380883

DYAMOND2 = "/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/"
SCREAM = DYAMOND2 + "LLNL/SCREAM-3KM/"
ARP    = DYAMOND2 + "METEOFR/ARPEGE-NH-2km/"
UM     = DYAMOND2 + "MetOffice/UM-5KM/"
ICON2  = DYAMOND2 + "MPIM-DWD-DKRZ/ICON-NWP-2km/"
ICON5  = DYAMOND2 + "MPIM-DWD-DKRZ/ICON-SAP-5km/"
GEOS1  = DYAMOND2 + "NASA/GEOS-1km/"
GEOS3  = DYAMOND2 + "NASA/GEOS-3km/"
GEOS6  = DYAMOND2 + "NASA/GEOS-6km/"
MPAS   = DYAMOND2 + "NCAR/MPAS-3KM/"
ECMWF  = DYAMOND2 + "NextGEMS/ECMWG-AWI/"
SHIELD = DYAMOND2 + "NOAA/SHiELD-3km/"
SAM    = DYAMOND2 + "SBU/SAM2-4km/"
IFS4   = DYAMOND2 + "ECMWF/IFS-4km/"
IFS9   = DYAMOND2 + "ECMWF/IFS-9km/"
NICAM  = DYAMOND2 + "AORI/NICAM-3km/"
GEM    = DYAMOND2 + "CMC/GEM/"


MODELS = {"SCREAM":SCREAM, "ARP":ARP, "UM":UM, "ICON":ICON2, "ICON5":ICON5, "GEOS1":GEOS1, "GEOS":GEOS3, "GEOS6":GEOS6, "MPAS":MPAS, "ECMWF":ECMWF, "SHEILD":SHIELD, "SAM":SAM, "IFS4":IFS4, "IFS9":IFS9, "NICAM":NICAM}


def get_tropics(mode, var):
    if model=="NICAM":
        if var=="OLR":
            return "/scratch/b/b380887/global_tropics/NICAM/NICAM_OLR_winter_GT.nc"
        elif var=="clivi":
            return "/scratch/b/b380887/global_tropics/NICAM/NICAM_int_froz_winter_GT.nc"
        elif var=="precip":
            return "/scratch/b/b380887/global_tropics/NICAM/NICAM_precip_winter_GT.nc"
        else:
            raise Exception("var not defined for nicam global tropics")
    elif (model=="SHiELD") or (model=="SHIELD"):
        cur_dir = "scratch/b/b380887/global_tropics/SHiELD/"
        if var=="OLR":
            return cur_dir + ""
        elif var=="clivi":
            return cur_dir + ""
        elif var=="precip":
            return cur_dir + ""
        else:
            raise Exception("var not defined for shield global tropics")
    elif (model=="GEOS"):
        cur_dir = "scratch/b/b380883/dyamond2/GEOS/GT/"
        if var=="OLR":
            return cur_dir + "rlt/"
        elif var=="clivi":
            return cur_dir + "clivi/"
        elif var=="precip":
            return cur_dir + "pr/"
        else:
            raise Exception("var not defined for shield global tropics")
    else:
        raise Exception("model not definied for global tropics")
        

def get_global(model, var):
    """Returns global model regridded"""
    if model=="SCREAM":
        return "/scratch/b/b380883/dyamond2/SCREAM/global/regridded_SCREAM-3km_0.25deg_20200130-0301.nc"
    

def get_filename(model, var, day="01-30", is2d=True, isNative=True):
    """Returns file of var for model"""
    mo = day.split("-")[0]
    d = day.split("-")[-1]
    mo1 = int(mo)+1 if (int(d)==31) else int(mo)
    mo1 = "{:02d}".format(mo1)
    if (model=="SHIELD") or (model=="UM"):
        d1 = "{:02d}".format(int(d)+1)
    else:
        d1 = "{:02d}".format(int(d))
    date = "2020{}{}000000-2020{}{}".format(mo, d, mo1, d1)
    if is2d:
        if (model=="GEOS"):
            if isNative:
                # GEOS native
                model2D = MODELS[model] + \
                    "DW-ATM/atmos/15min/{var}/r1i1p1f1/2d/gn/".format(var=var)
                file = model2D + \
                "{var}_15min_GEOS-3km_DW-ATM_r1i1p1f1_2d_gn_{d}234500.nc".format(var=var,
                                                                           d=date)
            else:
                # GEOS coarsened
                model2D = MODELS[model] + \
                    "atmos/15min/cin/r1i1p1f1/2d/global05/".format(var=var)
                file = model2D + \
                "{var}_15min_GEOS-3km_DW-ATM_r1i1p1f1_2d_global05_{d}234500.nc".format(var=var,
                                                                                 d=date)
                print("missing some data")
        elif (model=="IFS4") or (model=="IFS9"):
            # IFS 4/9 or GEM
            model2D = MODELS[model] + "DW-CPL/atmos/1hr/{var}/r1i1p1f1/2d/gn/".format(var=var)
            file = model2D + "{var}_1hr_{m}_DW-CPL_r1i1p1f1_2d_gn_{d}230000.nc".format(var=var, m=MODELS[model].split("/")[-1], d=date)
        elif (model=="GEM") or (model=="MPAS"):
            raise Exception("no data yet")
        else:
            if (model=="SHIELD") or (model=="UM"):
                # SHIELD, UM
                model2D = MODELS[model] + "DW-ATM/atmos/15min/{var}/r1i1p1f1/2d/gn/".format(var=var)
                file = model2D + "{var}_15min_{m}_DW-ATM_r1i1p1f1_2d_gn_{d}000000.nc".format(var=var, m=MODELS[model].split("/")[-2], d=date)
            elif (model=="NICAM"):
                model2D = "/scratch/b/b380887/global_tropics/NICAM/"
                file = model2D + "NICAM_int_froz_winter_GT.nc" # NICAM_OLR_winter_GT.nc, NICAM_int_froz_winter_GT.nc, NICAM_precip_winter_GT.nc
            else:
                # SCREAM, ARP, ICON, SAM, NICAM
                model2D = MODELS[model] + "DW-ATM/atmos/15min/{var}/r1i1p1f1/2d/gn/".format(var=var)
                file = model2D + "{var}_15min_{m}_DW-ATM_r1i1p1f1_2d_gn_{d}234500.nc".format(var=var, m=MODELS[model].split("/")[-2], d=date)
            #clt_15min_ARPEGE-NH-2km_DW-ATM_r1i1p1f1_2d_gn_20200220000000-20200220234500.nc
    else:
        return
    return file

def get_gridfile(model, isNative=True):
    """Returns grid file for model
        - NICAM, GEOS, SAM, and UM have lat/lon info in var file
    """
    if (model=="NICAM") or (model=="GEOS") or (model=="UM") or (model=="SAM") or (model=="SHIELD"):
        print("Lat/lon included in variable file, no need to get a grid")
        return
    elif model=="SCREAM":
        file = MODELS[model] + "DW-ATM/atmos/fx/grid.nc"
    elif (model=="ECMWF") or (model=="GEM") or (model=="MPAS"):
        print("No data yet for {}".format(model))
        return
    else:
        # ARP, IFS4, IFS9, ICON
        file = MODELS[model] + "DW-ATM/atmos/fx/gn/grid.nc" # radian
        # file = MODELS[model] + "DW-ATM/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_ARPEGE-NH-2km_DW-CPL_r1i1p1f1_2d_gn_fx.nc" # what is the difference? for ARP 
    return file
