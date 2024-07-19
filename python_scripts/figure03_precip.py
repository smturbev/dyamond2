import dask
import numpy as np
import pandas as pd
import xarray as xr
import matplotlib.pyplot as plt
from matplotlib import ticker, cm
from scipy.stats import linregress
from utility import analysis_parameters as ap, util

COLORS = ap.COLORS
MODELS = ["IMERG", "ARP", "GEOS", "ICON", "IFS", "MPAS", "SAM", "SCREAM", "SHiELD", "UM"]
MARKERS = ['o','D','v','^','s','<','>','.','*','p','P']

STRAT2CONV_DF_FILE = "/work/bb1153/b380883/stats/GT/strat-conv-tot_precip.csv"
OLR_VALS = [258,253,269,266,269,250,272,268,262,264]
PR_VALS = [99,107,112,115,117,82,127,125,112,124]

def abline(slope, intercept, xlim):
    """Plot a line from slope and intercept"""
    x_vals = np.array(xlim)
    y_vals = intercept + slope * x_vals
    return x_vals, y_vals

def first_time_get_precip():
    """if it is the first time running this script then do this"""
    models = ["IMERG", "SAM", "SCREAM", "UM", "IFS","ICON", "GEOS", "SHiELD", "ARP", "MPAS"]
    df = pd.DataFrame({"Data":np.array([0,0,0])}, index=["strat","conv","tot"])

    for i, m in enumerate(models):
        print(i, m[:3], end="\t")
        if m[:3]=="IME":
            pr = xr.open_dataset("/scratch/b/b380883/GPM_3IMERG_precip_20200120-20200228.nc", 
                                 chunks={"time":400,"lat":300,"lon":300}).precipitation
        else:
            pr = xr.open_dataset(ap.get_file(m+"r1deg", "GT", "pr")).pr
        print(pr.shape)

        # convert to mm/hr
        pr_coeff = 3600
        pr=pr*pr_coeff
        strat = np.sum(pr.where(pr<1, 1, 0))
        conv = np.prod(pr.shape)-strat
        df[m] = np.array([strat, conv, np.prod(pr.shape)])
    # save the pandas dataframe
    df.to_csv(STRAT2CONV_DF_FILE)
    return df

def get_strat_to_conv_precip():
    try:
        df = pd.read_csv(STRAT2CONV_DF_FILE, index_col=0)
        print("reading the strat to conv ratio DataFrame")
    except:
        df = first_time_get_precip()
        print("first time!!! generated the strat to conv ratio DataFrame")
    return df

def plot_both():
    fig, [ax0, ax1] = plt.subplots(1,2, figsize=(10,4))
    # plt.rcParams["font.size"]=13
    # plt.rcParams["axes.labelsize"]=13
    # Fit a linear regression model using linregress
    slope, intercept, r_value, p_value, std_err = linregress(OLR_VALS, PR_VALS)
    r_squared = r_value**2
    print(f'R-squared for OLR v precip: {r_squared:.4f}')
    
    for i,m in enumerate(MODELS):
        if m[:3]=="IME":
            cm="OBS"
        else:
            cm=m
        ax0.scatter(OLR_VALS[i], PR_VALS[i], c=COLORS[cm], s=80, marker=MARKERS[i])
        ax0.text(OLR_VALS[i], PR_VALS[i]+1.3, m, ha="center")
    x, y = abline(slope, intercept, ax0.get_xlim())
    ax0.plot(x,y,'--', label=f"Fit (r$^2=${r_squared:0.3f})")
    ax0.legend(loc="lower right")
    ax0.set(ylabel="Precipitation (mm/hr)", xlabel="OLR (W/m$^2$)")
    ax0.grid(True)

    # plot fraction of stratiform to convective precipitation
    df = get_strat_to_conv_precip()
    for i, m in enumerate(MODELS):
        print(i,m)
        if m=="IMERG":
            cm="OBS"
        else:
            cm=m
        ax1.bar(i+0.5, df[m].strat/df[m].conv*100, color=COLORS[cm])
    models=MODELS
    for i in range(len(MODELS)):
        if i%2==1:
            models[i] = "|\n"+MODELS[i]
    ax1.set_xticks(ticks=np.arange(0.5,len(MODELS)), labels=models)
    ax1.grid(axis='y')
    ax1.set(ylim=[0,18], yticks=np.arange(0,19,2), axisbelow=True)
    ax1.tick_params(axis='x', labelrotation=0)
    ax1.set_ylabel("Strat-to-conv precip (%)")
    
    print("saving as ../plots/figure03_precip.png")
    plt.savefig("../plots/figure03_precip.png", dpi=140)
    plt.show()

if __name__=="__main__":
    plot_both()
        
