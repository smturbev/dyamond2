import xarray as xr
import matplotlib.pyplot as plt
from matplotlib import ticker, cm
from utility import analysis_parameters as ap, util
import numpy as np
import dask


colors=ap.COLORS
region="TWP"
chunks={"time": 5, "ncol":1200, "Xdim":1000, "cell":1000, "rgrid":1000}
ndays = 5
MODELS = ["UM"]
plt.rcParams["font.size"]=12
zbins = np.arange(0,20)


def plot_utlsprofiles(models=MODELS):
    fig, ax = plt.subplots(1,4, figsize=(12,6), sharey=True)
    # add era5 ml reanalysis - hourly data
    # era_t = xr.open_dataset(ap.TWP+"ERA5_T_0.25deg_ml_12-20km_Feb2020_TWP.nc").isel(time=slice(-(5*24),-1))['t']
    for i,m in enumerate(models):
        print(m, i+1, "of", len(models), end="...")
        if m=="UM" or m=="SAM":
            axes=(0,2,3)
        else:
            axes=(0,2)
        print("getting temp", end="...")
        t = xr.open_dataset(ap.get_file(m, region+"_3D", "ta"), 
                        chunks=chunks).isel(time=slice(-8*ndays,-1)).ta[:,1:]
        # tinit = xr.open_dataset(ap.get_file(m, region+"_3D", "ta"), 
        #                 chunks=chunks).isel(time=slice(0,8*ndays)).ta[:,1:]
        tinit = xr.open_dataset(ap.get_file(m, region+"_3D", "ta"), 
                        chunks=chunks).isel(time=slice(80,80+(8*ndays))).ta[:,1:]
        if m=="SCREAM":
            p = t.lev*100 # convert to Pa
        elif m=="UM" or m=="SHiELD" or m=="ICON" or m=="ARP" or m=="SAM":
            p = xr.open_dataset(ap.get_file(m, region+"_3D", "pa"), 
                        chunks=chunks).isel(time=slice(-8*ndays,-1)).pa[:,1:]
        elif m=="GEOS":
            p = xr.open_dataset(ap.get_file(m, region+"_3D", "pfull"), 
                        chunks=chunks).isel(time=slice(-8*ndays,-1)).pthick[1:]
        else:
            raise Exception("model pres not defined yet")
        qv = xr.open_dataset(ap.get_file(m, region+"_3D", "hus"), 
                            chunks=chunks).isel(time=slice(-8*ndays,-1)).hus[:,1:]
        print("calculating rhi", end="...")
        rhi = util.q2rhi(t, p, qv)
        rhi = rhi.mean(axis=axes)
        del p, qv
        print("getting z", end="...")
        if m=="SAM":
            z = rhi.z/1000
            print(z.values)
        else:
            z = xr.open_dataset(ap.get_file(m, region+"_3D", "zg"), 
                            chunks=chunks).isel(time=slice(-8*ndays,-1)).zg
            z = z.mean(axis=axes)/1000
        if m=="SHiELD" or m=="GEOS":
            z = z[1:]
        print("shape of t, rhi, and z", t.shape, rhi.shape, z.shape, end="...")
        tmean = t.mean(axis=axes).values
        tinitmean = tinit.mean(axis=axes).values
        print("... plotting tmean", end=", ")
        ax[0].plot(tmean, z, label=m, color=colors[m])
        del t
        print("tdrift", end=", ")
        ax[1].plot(tmean-tinitmean, z, label=m, color=colors[m])
        del tmean, tinitmean
        print("rhi", end=", ")
        ax[2].plot(rhi, z, label=m, color=colors[m])
        del rhi
        if m!="SAM" and m!="SHiELD":
            print("calculating cth hist", end="...")
            cth = xr.open_dataset("/work/bb1153/b380883/TWP/TWP_{}_cldtop_height_iwc_20200130-20200228.nc".format(m), 
                                  chunks=chunks).isel(time=slice(-8*ndays,-1))
            cth_sm = cth['cldtop_height1e-07']/1000
            cth_lg = cth['cldtop_height1e-06']/1000
            hist, _ = np.histogram(cth_sm.values.flatten(), bins=zbins)
            hist = hist/np.prod(np.shape(cth_sm))
            cf = (np.sum(np.where(cth_sm>12,1,0)) / np.prod(np.shape(cth_sm)))*100
            print("count of cth > 12:", np.sum(np.where(cth_sm>12,1,0)), end="...")
            # hist_lg, _ = np.histogram(cth_lg.values.flatten(), bins=zbins)
            # hist_lg = hist_lg/np.prod(np.shape(cth_lg))
            # cf_lg = (np.sum(np.where(cth_lg>12,1,0)) /
            #       np.prod(np.shape(cth_lg)))*100
            # ax[3].plot(hist_lg[2:], zbins[2:-1],
            #            lw=1, color=colors[m], linestyle='dashed')
            print("plotting cth")
            ax[3].plot(hist[2:], zbins[2:-1], lw=2, 
                       color=colors[m],
                       label=m+f" ({cf:0.1f}%)", )  # {cf_lg:0.1f}%/

        else:
            ax[3].plot([0,0],[0,0], color=colors[m], label=m+" (N/A)")
    # xlims = [(180,305),(-4.5,4.5),(0,110)]
    xlims = [(180,230),(-4,8),(50,110), (0,0.45)]
    xlabels= ["Temperature (K)", "Temperature drift (K)\n(last - first 5 days)", 
              "Relative Humidity wrt ice (%)", "CTH distribution"]   
    for i in range(4):
        ax[i].fill_between(xlims[i],14,18, color='gray', alpha=0.2)
        ax[i].set_xlabel(xlabels[i])
        ax[i].set_xlim(xlims[i])
        ax[i].set_ylim([12,20])
        ax[i].grid(True)
    ax[0].set_ylabel("Height (km)")
    ax[1].axvline(0,10,20, c='k', lw=2)
    ax[1].set_xticks(np.arange(-4,8.1,2))
    ax[-1].legend(bbox_to_anchor=(1, 0.5), loc='center left', ncol=1)
    # fig.suptitle("Last "+str(ndays)+" days of simulation period")
    print("-----\nsaving as ../plots/figure10_last{}days_UTLS.pdf".format(ndays))
    plt.savefig("../plots/figure10_last{}days_UTLS.pdf".format(ndays), bbox_inches='tight')
    plt.show()


if __name__=="__main__":
    plot_utlsprofiles()