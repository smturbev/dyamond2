import scipy.stats as ss
import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
from utility import analysis_parameters as ap


colors = ap.COLORS
region="TWP"

olr1 = xr.open_dataset(ap.TWP_MEANOLR_DY1)
olr2 = xr.open_dataset(ap.TWP_MEANOLR_DY2)
swu1 = xr.open_dataset(ap.TWP_MEANSWU_DY1)
swu2 = xr.open_dataset(ap.TWP_MEANSWU_DY2)

plot2_models = ["OBS", None, "SHiELDr0.1deg", "ICONr0.1deg", "SAMr0.1deg", "IFS", "MPASr0.1deg",
               "ARPr0.1deg","UM","SCREAMr0.1deg", "GEOSr0.1deg"]
plot1_models = ["OBS", "NICAM", "FV3", "ICON", "SAM", "IFS", "MPAS", 
               "ARP","UM",None, None]
markers=['o','D','v','^','s','<','>','o','*','p','P']

def plot_olrvsswu():
    fig, ax = plt.subplots(1,1, figsize=(6,5))
    a1, a2 = 1, 1
    for i in range(len(plot2_models)):
        if plot2_models[i] is not None:
            if plot2_models[i]=="OBS":
                d2_swu = xr.open_dataset(ap.CERES_SYN1_ANN_MEAN_DY2)["adj_atmos_sw_up_all_toa_3h"]
                d1_swu = xr.open_dataset(ap.CERES_SYN1_ANN_MEAN_DY1)["adj_atmos_sw_up_all_toa_3h"]
                d2_olr = xr.open_dataset(ap.CERES_SYN1_ANN_MEAN_DY2)["adj_atmos_lw_up_all_toa_3h"]
                d1_olr = xr.open_dataset(ap.CERES_SYN1_ANN_MEAN_DY1)["adj_atmos_lw_up_all_toa_3h"]
                m1, b1, r1, p1, se1 = ss.linregress(d1_olr, d1_swu)
                m2, b2, r2, p2, se2 = ss.linregress(d2_olr, d2_swu)
                m3, b3, r3, p3, se3 = ss.linregress(np.append(d2_olr,d1_olr), np.append(d2_swu,d1_swu))
                x = np.arange(170,271,2)
                ax.plot(x, m3*x+b3, "k", alpha=a2, linestyle="dashed", label="Observational\n fit DY1+2")
                ax.scatter(d2_olr, d2_swu, ec="k", marker="o", alpha=a2, s=20, facecolors="none")
                ax.scatter(d1_olr, d1_swu, c="k", marker="o", alpha=a1, s=20)
                ax.plot([d1_olr.mean()],[d1_swu.mean()], c="k", 
                        markersize=10, marker=markers[i], alpha=a1, label="OBS DY1")
                ax.plot([d2_olr.mean()],[d2_swu.mean()], c="k", fillstyle="none",
                        markersize=10, marker=markers[i], alpha=a2, label="OBS DY2")
            else:
                if plot1_models[i] is not None:
                    ax.plot([olr1[plot1_models[i]],olr2[plot2_models[i]]], [swu1[plot1_models[i]],swu2[plot2_models[i]]], color=colors[plot1_models[i]], 
                            alpha=a1, marker=markers[i], markersize=10, linewidth=2, fillstyle="none")
                    ax.plot(olr1[plot1_models[i]], swu1[plot1_models[i]], c=colors[plot1_models[i].split("r")[0]], 
                            alpha=a1, marker=markers[i], markersize=10, label=plot1_models[i]) 
                else:
                    ax.plot(olr2[plot2_models[i]], swu2[plot2_models[i]], c=colors[plot2_models[i].split("r")[0]], 
                            alpha=a2, marker=markers[i], markersize=10, fillstyle="none", label=plot2_models[i].split("r")[0])        
        elif plot1_models[i] is not None:
                ax.plot(olr1[plot1_models[i]], swu1[plot1_models[i]], c=colors[plot1_models[i]], 
                            alpha=a1, marker=markers[i], markersize=10, label=plot1_models[i])

    plt.grid(True)
    plt.xlim([170,270])
    plt.xlabel("OLR (W m$^{-2}$)", fontsize=16)
    plt.ylabel("Reflected SW (W m$^{-2}$)", fontsize=16)
    plt.legend(bbox_to_anchor=(1.4,0.9))
    print("saving as ../plots/figure06_olrvsrsw.pdf")
    plt.savefig("../plots/figure06_olrvsrsw.pdf", bbox_inches="tight", pad_inches=0.25)
    plt.show()

if __name__=="__main__":
    plot_olrvsswu()

