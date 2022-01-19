"""
analysis_parameters.py
author: sami turbeville @smturbev

file names saved as variables and easier to call in methods
especially if file names change
"""

home_dir = "/home/disk/eos12/hillmanb/scream/dyamond2/"
native_dir = home_dir + "native/"
coarse_dir = home_dir + "256x512/"

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
    FLNTC (clearsky lw toa), FSDS (lw downwelling sfc), FSNS (net sw sfc), 
    FSNTOA (sw net toa), FSNTOAC (clearsky sw toa)
    h3 : 15 min : OMEGA200, 500, 700, 850; RH200, 500, 700, 850; Z200, 500, 700,850
    h4 : 3 hrly : TMNUMICE, TMNUMLIQ, TMNUMRAI
    h5 : 3 hrly : U, V
    h6 : 3 hrly : Q (mixing ratio vapor kg/kg), T (temp K)
    h7 : 3 hrly : CLDICE (kg/kg), CLDLIQ (kg/kg)
    h8 : 3 hrly : CLOUD (fraction), OMEGA (Pa/s)
    h9 : 3 hrly : EMIS (cloud emissivity?), TOT_CLD_VISTAU (cloud optical depth in the visual)

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
            return coarse_dir + f"SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.{var}.2020*00000.nc".format(var=var)
        else:
            return coarse_dir + f"SCREAMv0.SCREAM-DY2.ne1024pg2.20201127.eam.{var}.2020-{date}-00000.nc".format(var=var, date=date)
