import xarray as xr
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
from utility import analysis_parameters as ap
from utility import util
import numpy as np
import dask

chunk_dict = {"time":80,"lat":71, "lon":71, "Xdim":1000, "ncol":1000, "rgrid":1000}
colors=ap.COLORS
plt.rcParams['font.size']=18

def plot_cldtophist():
    models = ["ARP","GEOS","ICON","SCREAM"]
    region="TWP"
    mod_lab=""
    zbins = np.arange(5,20.1)
    fs=20

    fig = plt.figure(figsize=(5*len(models)+6,15), layout="constrained")
    gs = GridSpec(3, 6, figure=fig)
    # add a subplot like this: ax1 = fig.add_subplot(gs[0, :])
    # subplots for cth histograms
    ax_cth0 = fig.add_subplot(gs[0,-1])
    ax_cth1 = fig.add_subplot(gs[1,-1])
    ax_cth2 = fig.add_subplot(gs[2,-1])
    for i,m in enumerate(models):
        print(i, m, end="...")
        file = "/work/bb1153/b380883/TWP/TWP_{}_cldtop_height_iwc_20200130-20200228.nc".format(m)
        ds = xr.open_dataset(file, chunks=chunk_dict)
    
        olr = ap.load_olr(m,"TWP", r=0).sel(time=ds.time)
        if m=="ARP":
            olr = olr/-900
        if (ds['cldtop_height1e-05'].shape==olr.shape):
            print("shapes of ds and olr match:", olr.shape, end="...")
        else:
            raise Exception("make sure the cth and olr are the same size/shape",
                            olr.shape, ds['cldtop_height1e-05'].shape)
        # generate gridspec subplots for each model (one in each column)
        ax0 = fig.add_subplot(gs[0,i+1])
        ax1 = fig.add_subplot(gs[1,i+1])
        ax2 = fig.add_subplot(gs[2,i+1])

        print("plotting the 2d histograms", end="...")
        # plot 2d histogram for each threshold of cloud
        util.dennisplot("density",olr.values.flatten(), 
                        ds['cldtop_height1e-05'].values.flatten()/1000, 
                        ax=ax0, model=m, region=region,
                        cmap="gist_earth_r", levels=np.arange(-3.4,-1.2,0.2), 
                        ybins=zbins, colorbar_on=False, draw_line=False)
        ax0.set_ylim([5,20])
        ax0.set_xlim([80,310])
        ax0.set_title("{} TWP\ncld thres = {} kg/m$^3$".format(m, 1e-5), fontsize=fs)
        util.dennisplot("density",olr.values.flatten(), 
                        ds['cldtop_height1e-06'].values.flatten()/1000, 
                        ax=ax1, model=m, region=region,
                        cmap="gist_earth_r", levels=np.arange(-3.4,-1.2,0.2), 
                        ybins=zbins, colorbar_on=False, draw_line=False)
        ax1.set_ylim([5,20])
        ax1.set_xlim([80,310])
        ax1.set_title("{} TWP\ncld thres = {} kg/m$^3$".format(m, 1e-6), fontsize=fs)
    
        _, im = util.dennisplot("density",olr.values.flatten(), 
                                ds['cldtop_height1e-07'].values.flatten()/1000, 
                        ax=ax2, model=m, region=region,
                        cmap="gist_earth_r", levels=np.arange(-3.4,-1.2,0.2), 
                        ybins=zbins, colorbar_on=False, draw_line=False)
        ax2.set_ylim([5,20])
        ax2.set_xlim([80,310])
        ax2.set_title("{} TWP\ncld thres = {} kg/m$^3$".format(m, 1e-7), fontsize=fs)

        if i == 0:
            ax0.set(ylabel="cloud top height (km)", xlabel="")
            ax1.set(ylabel="cloud top height (km)", xlabel="")
            ax2.set(ylabel="", xlabel="OLR (W/m$^2$)")
        else:
            ax0.set(ylabel="", xlabel="")
            ax1.set(ylabel="", xlabel="")
            ax2.set(ylabel="", xlabel="OLR (W/m$^2$)")

        print("plotting the cth distributions...")
        # cth pdf on far right plot (ie., 1d histogram of cth)
        hist0, _ = np.histogram(ds['cldtop_height1e-05'].values.flatten()/1000, bins=zbins)
        hist0 = hist0/np.prod(np.shape(ds['cldtop_height1e-05']))
        cf = (np.sum(np.where(ds['cldtop_height1e-05']>5000,1,0)) /
              np.prod(np.shape(ds['cldtop_height1e-05'])))*100
        ax_cth0.step(hist0[2:], zbins[2:-1], label=m+f" ({cf:0.0f}%)", lw=3, 
                     where='pre', color=colors[m])
        hist1, _ = np.histogram(ds['cldtop_height1e-06'].values.flatten()/1000, bins=zbins)
        hist1 = hist1/np.prod(np.shape(ds['cldtop_height1e-06']))
        cf = (np.sum(np.where(ds['cldtop_height1e-06']>5000,1,0)) /
              np.prod(np.shape(ds['cldtop_height1e-06'])))*100
        ax_cth1.step(hist1[2:], zbins[2:-1], label=m+f" ({cf:0.0f}%)", lw=3, 
                     where='pre', color=colors[m])
        hist2, _ = np.histogram(ds['cldtop_height1e-07'].values.flatten()/1000, bins=zbins)
        hist2 = hist2/np.prod(np.shape(ds['cldtop_height1e-07']))
        cf = (np.sum(np.where(ds['cldtop_height1e-07']>5000,1,0)) /
              np.prod(np.shape(ds['cldtop_height1e-07'])))*100
        print("cf count:", np.sum(np.where(ds['cldtop_height1e-07']>5000,1,0)), np.prod(np.shape(ds['cldtop_height1e-07']))*100)
        ax_cth2.step(hist2[2:], zbins[2:-1], label=m+f" ({cf:0.0f}%)", lw=3, 
                     where='pre', color=colors[m])
    
        mod_lab+=m[:2]
    # add CCCM 
    model="CCCM"
    region="TWP"
    olr = xr.open_dataset(ap.CCCM_JFM).CERES_LW_TOA_flux___upwards
    cth = xr.open_dataset(ap.CCCM_JFM).Mean_CALIPSO_5_km_cloud_layer_top_height.mean(axis=1)
    cth = np.where(np.isnan(cth), 0, cth)

    # plot olr-cth hist
    ax_obs = fig.add_subplot(gs[-1,0])
    util.dennisplot("density",olr.values.flatten(), cth.flatten(), 
                ax=ax_obs, model=model, region=region,
                cmap="gist_earth_r", levels=np.arange(-3.4,-1.2,0.2), 
                ybins=np.arange(0,20.1), colorbar_on=False, draw_line=False)
    ax_obs.set(ylim=[5,20], ylabel="cloud top height (m)")
    ax_obs.set_title("CCCM (JFM 2008-2011)\nCALIPSO mean cloud top height", fontsize=fs)

    # plot hist of cth from cccm
    hist, _ = np.histogram(cth, bins=zbins)
    hist = hist/np.prod(np.shape(cth))
    cf = (np.sum(np.where(cth>6,1,0)) /
              np.prod(np.shape(cth)))*100
    ax_cth2.step(hist[2:], zbins[2:-1], where='pre', lw=3.5, color="k", label="CCCM")
    
    mod_lab+="_CCCM"
    
    ax_cth0.legend(bbox_to_anchor=(0.7, 1.), loc='upper left', ncol=1, fontsize=18)
    ax_cth1.legend(bbox_to_anchor=(0.7, -0.01), loc='lower left', ncol=1, fontsize=18)
    ax_cth2.legend(bbox_to_anchor=(0.7, -0.01), loc='lower left', ncol=1, fontsize=18)
    ax_cth0.set(ylabel="", xlabel="", title="CTH (iwc$>1$e$-5$ kg/m$^3$)")
    ax_cth1.set(ylabel="", xlabel="", title="CTH (iwc$>1$e$-6$ kg/m$^3$)")
    ax_cth2.set(ylabel="", xlabel="CTH distribution", title="CTH (iwc$>1$e$-7$ kg/m$^3$)")
    # ax[j,3].spines[['right', 'top']].set_visible(False)

    cbar_ax = fig.add_subplot(gs[:2,0])
    cbar_ax.axis('off')
    cb = fig.colorbar(im, ax=cbar_ax, shrink=0.7,
                      label="log10(pdf)", location="left")
    
    print("saved as ../plots/figure11_ccldtopiwc_vs_olr_{}.png".format(mod_lab))
    plt.savefig("../plots/figure11_ccldtopiwc_vs_olr_{}.png".format(mod_lab),dpi=120,
                bbox_inches="tight", pad_inches=1)
    plt.show()

