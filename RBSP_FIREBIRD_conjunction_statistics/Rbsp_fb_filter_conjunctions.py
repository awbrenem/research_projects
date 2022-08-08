"""
Read in the final RBSP/FIREBIRD conjunction .txt files and filter based
on criteria. The files used are based on my "master_conjunction_list_part3.pro"
program, which reads in the conjunction files created by Mykhaylo Shumko
(e.g. FU4_RBSPB_conjunctions_dL10_dMLT10_hr.txt) and add in useful info such as the
L, MLT position of RBSP during the conjunction, and the max filter bank amplitudes within +/-60 min
of closest conjunction. See the header of these files for their output.

NOTE: This code also adds in the max FB and RB values and the total burst minutes


My text files that this program uses have the start and end times for each conjunction, as well as the
time of closest approach. For each conjunction the RBSP L and MLT of closest approach are recorded, the
distance of closest approach, as well as burst and filter bank data.

"""

"""
class Rbsp_fb_filter_conjunctions:
    def __init__(self, params):
        self.__dict__.update(params)

    def print_test(self):
        print(self.rb, self.fb, self.hires)
"""


import numpy as np
import pandas as pd


#Read in header file with quantity labels
def parse_header(file_name):
    """
    Parses the header file (nominally RBSP_FU_conjunction_header.txt)

    Parameters
    ----------
    file_name: str or pathlib.Path
        The path to the header file

    Returns
    -------
    header: list
        A list containing the column names for the conjunction data.
    """

    header = []

    with open(file_name + '.txt') as f:

        #skip first 6 lines of the header file 
        for _ in range(6):
            next(f)

        for row in f:

            header.append(row.split()[0].replace(':', ''))

    return header



# Reads in the conjunction files and returns a dictionary with all the values
def read_conjunction_file(path,fn):

    header = parse_header(path + "RBSP_FU_conjunction_header.fmt")


    #file_name = path + "RBSPa_FU3_conjunction_values_hr.txt"
    file_name = path + fn
    df = pd.read_csv(file_name, header=None, skiprows=2, delim_whitespace=True, names=header, 
                    na_values=["NaN", "-NaN", "Inf", "-Inf"])




    # Create new variables that are the max FB flux and the max RB amplitude observed on the filter bank
    rbmaxE = []
    rbmaxB = []
    for i in range(len(df["Tstart"])):
        rbmaxE.append(max([df["7E4"][i],df["7E5"][i],df["7E6"][i],df["7E7"][i],df["13E7"][i],df["13E8"][i],df["13E9"][i],df["13E10"][i],df["13E11"][i],df["13E12"][i],df["13E13"][i]]))  # FB max flux
        rbmaxB.append(max([df["7B4"][i],df["7B5"][i],df["7B6"][i],df["7B7"][i],df["13B7"][i],df["13B8"][i],df["13B9"][i],df["13B10"][i],df["13B11"][i],df["13B12"][i],df["13B13"][i]]))  # FB max flux



    df1 = pd.DataFrame({"FBKmaxE":rbmaxE})
    df2 = pd.DataFrame({"FBKmaxB":rbmaxB})
    # Create new variable that is the total number of burst seconds within +/-60 minutes of closest conjunction
    bursttot_min = (df["EMFb"] + df["B1b"] + df["B2b"])/60.
    df3 = pd.DataFrame({"BurstTotMin":bursttot_min})


    #add these to the original pandas dataframe
    df1.reset_index(drop=True, inplace=True)
    df2.reset_index(drop=True, inplace=True)
    df3.reset_index(drop=True, inplace=True)

    #axis=1 is column
    dftmp = pd.concat([df,df1,df2,df3], axis=1)



    return dftmp




# Filter the dataframe by requiring the input quantity to be within minv and maxv
def filter_based_on_range(df, quantity, minv, maxv):


    df_filtered = df[(df[quantity] <= maxv) & (df[quantity] >= minv)]
    df_filtered.reset_index(drop=True, inplace=True)

    return df_filtered










    print("Conjunctions for RBSPa and FU4")
    print(
        "{:22}".format(keyv[2]),
        "{:4}".format(keyv[3]),
        "{:5}".format(keyv[4]),
        "{:6}".format(keyv[-4]),
        "{:6}".format(keyv[-3]),
        "{:6}".format(keyv[-2]),
        "{:6}".format(keyv[-1]),
    )

    for i in range(len(finv4a["datetime_min"])):
        if finv4a["Lrb"][i] != 0:
            print(
                "{:19}".format(finv4a["datetime_min"][i]),
                "{:6.1f}".format(finv4a["Lrb"][i]),
                "{:6.1f}".format(finv4a["MLTrb"][i]),
                "{:6.1f}".format(finv4a["Lfb"][i]),
                "{:6.1f}".format(finv4a["MLTfb"][i]),
                "{:8.1f}".format(finv4a["fbmaxflux"][i]),
                "{:8.1f}".format(finv4a["rbmaxampE"][i]),
                "{:8.1f}".format(finv4a["rbmaxampB"][i]),
                "{:8.1f}".format(finv4a["bursttotalmin"][i]),
            )

    """
    print("Conjunctions for RBSPb and FU3")
    print('{:22}'.format(keyv[2]),
            '{:4}'.format(keyv[3]),'{:5}'.format(keyv[4]),
            '{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),
            '{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
    for i in range(len(finv3b["datetime_min"])):
        if finv3b["Lmin"][i] != 0: print('{:19}'.format(finv3b["datetime_min"][i]),'{:6.1f}'.format(finv3b["Lmin"][i]),'{:6.1f}'.format(finv3b["MLTmin"][i]),
                                    '{:8.1f}'.format(finv3b["fbmaxflux"][i]),'{:8.1f}'.format(finv3b["rbmaxampE"][i]),
                                    '{:8.1f}'.format(finv3b["rbmaxampB"][i]),'{:8.1f}'.format(finv3b["bursttotalmin"][i]))


    print("Conjunctions for RBSPb and FU4")
    print('{:22}'.format(keyv[2]),'{:4}'.format(keyv[3]),'{:5}'.format(keyv[4]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
    for i in range(len(finv4b["datetime_min"])):
        if finv4b["Lmin"][i] != 0: print('{:19}'.format(finv4b["datetime_min"][i]),'{:6.1f}'.format(finv4b["Lmin"][i]),'{:6.1f}'.format(finv4b["MLTmin"][i]),
                                    '{:8.1f}'.format(finv4b["fbmaxflux"][i]),'{:8.1f}'.format(finv4b["rbmaxampE"][i]),
                                    '{:8.1f}'.format(finv4b["rbmaxampB"][i]),'{:8.1f}'.format(finv4b["bursttotalmin"][i]))

    """


# Filter out all conjunctions that don't have hires FIREBIRD data 
def filter_to_hires_only(df):

    df_filtered = df[np.isfinite(df["colHR"])]
    return df_filtered








if __name__ == "__main__":

    from matplotlib import pyplot as plt
    from scipy.stats import kde
    from datetime import datetime


    path = "/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/"
    #data_b4 = read_conjunction_file(path, "RBSPb_FU4_conjunction_values_hr.txt")
    data_b4 = read_conjunction_file(path, "RBSPb_FU4_conjunction_values.txt")


    data_b4_hires = filter_to_hires_only(data_b4)

    lmin = 0
    lmax = 12
    mltmin = 0
    mltmax = 24

    data_b4_filt = data_b4
    data_b4_filt = filter_based_on_range(data_b4_filt, "Lrb", lmin, lmax)
    data_b4_filt = filter_based_on_range(data_b4_filt, "MLTrb", mltmin, mltmax)
    #data_b4_filt = filter_based_on_range(data_b4_filt, "BurstTotMin", 0.01, 10000)

    lmin = 4
    lmax = 6
    mltmin = 0
    mltmax = 12
    data_b4_filt2 = data_b4
    data_b4_filt2 = filter_based_on_range(data_b4_filt2, "Lrb", lmin, lmax)
    data_b4_filt2 = filter_based_on_range(data_b4_filt2, "MLTrb", mltmin, mltmax)



    #print(data_b4_filt["Lba"], data_b4_filt["SpecBMax_lb"])


    for i in range(len(data_b4_filt["Lrb"])):
        print(
            "{:19}".format(data_b4_filt["Tmin"][i]),
            "{:6.1f}".format(data_b4_filt["Lrb"][i]),
            "{:6.1f}".format(data_b4_filt["MLTrb"][i]),
            "{:6.1f}".format(data_b4_filt["Lfb"][i]),
            "{:6.1f}".format(data_b4_filt["MLTfb"][i]),
            "{:8.1f}".format(data_b4_filt["colS"][i]),
            "{:8.1f}".format(data_b4_filt["colHR"][i]),
            "{:8.1f}".format(data_b4_filt["FBKmaxE"][i]),
            "{:8.1f}".format(data_b4_filt["FBKmaxB"][i]),
            "{:8.1f}".format(data_b4_filt["BurstTotMin"][i]),
            )


    for i in range(len(data_b4_filt2["Lrb"])):
        print(
            "{:19}".format(data_b4_filt2["Tmin"][i]),
            "{:6.1f}".format(data_b4_filt2["Lrb"][i]),
            "{:6.1f}".format(data_b4_filt2["MLTrb"][i]),
            "{:6.1f}".format(data_b4_filt2["Lfb"][i]),
            "{:6.1f}".format(data_b4_filt2["MLTfb"][i]),
            "{:8.1f}".format(data_b4_filt2["colS"][i]),
            "{:8.1f}".format(data_b4_filt2["colHR"][i]),
            "{:8.1f}".format(data_b4_filt2["FBKmaxE"][i]),
            "{:8.1f}".format(data_b4_filt2["FBKmaxB"][i]),
            "{:8.1f}".format(data_b4_filt2["BurstTotMin"][i]),
            )
 
    """
    fig, ax = plt.subplots(2, 2)

    xkey = "FBKmaxB"
    ykey = "colS"
    ax[0, 0].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[0, 0].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[0, 0].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[0, 0].set_xlabel(xkey)
    ax[0, 0].set_ylabel(ykey)
    ax[0, 0].set_yscale("log")
    ax[0, 0].set_xscale("log")

    xkey = "SpecBAvg_lb"
    ykey = "colS"
    ax[0, 1].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[0, 1].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[0, 1].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[0, 1].set_xlabel(xkey)
    ax[0, 1].set_ylabel(ykey)
    ax[0, 1].set_yscale("log")
    ax[0, 1].set_xscale("log")

    xkey = "FBKmaxB"
    ykey = "colHR"
    ax[1, 0].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[1, 0].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[1, 0].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[1, 0].set_xlabel(xkey)
    ax[1, 0].set_ylabel(ykey)
    ax[1, 0].set_yscale("log")
    ax[1, 0].set_xscale("log")

    xkey = "SpecBAvg_lb"
    ykey = "colHR"
    ax[1, 1].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[1, 1].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[1, 1].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[1, 1].set_xlabel(xkey)
    ax[1, 1].set_ylabel(ykey)
    ax[1, 1].set_yscale("log")
    ax[1, 1].set_xscale("log")

    #plt.show()

    """
    
    

    #xkey = "FBKmaxE"
    xkey = "SpecBMed_ub"
    #xkey = "SpecBAvg_lf"
    ykey = "colS"
    #xkey = "FBKmaxB"
    #ykey = "colHR"
    datplot = data_b4
    #datplot = data_b4_filt2

    #Take log of data so it's properly weighted on a linear scale
    datx = np.log10(np.asarray(datplot[xkey]))
    daty = np.log10(np.asarray(datplot[ykey]))

    #Keep only non-NaN values
    tstx = np.isfinite(datx)
    tsty = np.isfinite(daty)
    good = np.logical_and(tstx, tsty)


    #Numpy version 
    datx2np = datx[good]
    daty2np = daty[good]
    datnp = np.vstack([datx2np, daty2np])
    k = kde.gaussian_kde(datnp)


    nbins = 30.
    xi, yi = np.mgrid[datx2np.min():datx2np.max():nbins*1j, daty2np.min():daty2np.max():nbins*1j]
    #zi = np.log10(k(np.vstack([xi.flatten(), yi.flatten()])))
    zi = k(np.vstack([xi.flatten(), yi.flatten()]))

    #Turn grid points back into linear scale
    xi2 = [10**x for x in xi]
    yi2 = [10**x for x in yi]

    #Set axes ranges
    xmin = np.min(datplot[xkey])
    xmax = np.max(datplot[xkey])
    ymin = np.min(datplot[ykey])
    ymax = np.max(datplot[ykey])


    fig, ax = plt.subplots(2)
    ax[0].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[0].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[0].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[0].set_xlabel(xkey)
    ax[0].set_ylabel(ykey)
    ax[0].set_yscale("log")
    ax[0].set_xscale("log")
    ax[0].set_xlim([xmin, xmax])
    ax[0].set_ylim([ymin, ymax])
 
    # Make the plot
    ax[1].pcolormesh(xi2, yi2, zi.reshape(xi.shape), shading='auto')
    ax[1].set_yscale("log")
    ax[1].set_xscale("log")
    ax[1].set_xlabel(xkey)
    ax[1].set_ylabel(ykey)
    ax[1].set_xlim([xmin, xmax])
    ax[1].set_ylim([ymin, ymax])
 
    plt.show()
    



    #Plot histograms of all the conjunctions 
    print('here')
    #data_b4.dtypes


    #-------------------------------------------------------------
    #Plot various histograms
    #-------------------------------------------------------------


    """
    #Histogram bin location STARTS with the value in vals[1]
    vals = np.histogram(data_b4["Lfb"], bins=range(12))
    vals = np.histogram(data_b4["Lrb"], bins=range(12))
    vals = np.histogram(data_b4["MLTfb"], bins=range(24))
    vals = np.histogram(data_b4["dLmin"], bins=10, range=(0, 1))
    vals = np.histogram(data_b4["dMLTmin"], bins=10, range=(0, 2))

    vals = np.histogram(data_b4["BurstTotMin"], bins=10, range=(0, 10))
    vals = np.histogram(data_b4["EMFb"]/60., bins=10, range=(0, 10))
    vals = np.histogram(data_b4["B1b"]/60., bins=10, range=(0, 10))
    vals = np.histogram(data_b4["B2b"]/60., bins=10, range=(0, 10))

    vals = np.histogram(data_b4["FBKmaxB"], bins=20, range=(0, 500))
    vals = np.histogram(data_b4["FBKmaxE"], bins=10, range=(0, 50))
    vals = np.histogram(data_b4["SpecBMax_lb"], bins=10, range=(1e-10, 1e-6))
    specbmax_lb_log = np.log10(data_b4["SpecBMax_lb"])
    vals = np.histogram(specbmax_lb_log, bins=10, range=(-10,-2))
    specemax_lb_log = np.log10(data_b4["SpecEMax_lb"])

    vals = np.histogram(data_b4["colS"], bins=10, range=(0, 150))
    vals = np.histogram(data_b4["colHR"], bins=10, range=(0, 25))



    """

    #Log power for spectra
    specbmax_lb_log = np.log10(data_b4["SpecBMax_lb"])
    specemax_lb_log = np.log10(data_b4["SpecEMax_lb"])
    specbmax_lb_hires_log = np.log10(data_b4_hires["SpecBMax_lb"])
    specemax_lb_hires_log = np.log10(data_b4_hires["SpecEMax_lb"])


    #Calculate conjunction durations 
    duration = []
    for i in range(len(data_b4["Tstart"])):
        ds = datetime.strptime(data_b4["Tstart"][i], "%Y-%m-%d/%H:%M:%S")    
        de = datetime.strptime(data_b4["Tend"][i], "%Y-%m-%d/%H:%M:%S")    
        duration.append((de - ds).seconds)

    #vals = np.histogram(duration, bins=20, range=(0, 250))


    """
    fig, ax = plt.subplots(2, 2, tight_layout=True)
    ax[0, 0].hist(data_b4["FBKmaxB"], bins=20, range=(0, 200))
    ax[0, 0].hist(data_b4_hires["FBKmaxB"], bins=20, range=(0, 300))
    ax[0, 1].hist(data_b4["FBKmaxE"], bins=20, range=(0, 10))
    ax[0, 1].hist(data_b4_hires["FBKmaxE"], bins=20, range=(0, 15))
    ax[1, 0].hist(specbmax_lb_log, bins=20, range=(-12, 2))
    ax[1, 0].hist(specbmax_lb_hires_log, bins=20, range=(-12, 2))
    ax[1, 1].hist(specemax_lb_log, bins=20, range=(-6, 3))
    ax[1, 1].hist(specemax_lb_hires_log, bins=20, range=(-6, 3))
    ax[0, 0].set_xlabel('FBKmaxB (pT)')
    ax[0, 1].set_xlabel('FBKmaxE (mV/m)')
    ax[1, 0].set_xlabel('SpecBMax_lb (log10)\nnT^2/Hz')
    ax[1, 1].set_xlabel('SpecEMax_lb (log10)\n(mV/m)^2/Hz')
    ax[0, 0].set_yscale("log")
    ax[0, 1].set_yscale("log")
    ax[1, 0].set_yscale("log")
    ax[1, 1].set_yscale("log")
    ax[1, 0].set_xlim(-12, 0)
    ax[1, 1].set_xlim(-6, 2)


    plt.show()
    """
    
    #"""
    fig, ax = plt.subplots(2, 2, tight_layout=True)
    ax[0, 0].hist(data_b4["Lfb"], bins=10, range=(2, 8))
    ax[0, 0].hist(data_b4_hires["Lfb"], bins=10, range=(2, 8))
    ax[0, 1].hist(data_b4["MLTfb"], bins=10, range=(0, 24))
    ax[0, 1].hist(data_b4_hires["MLTfb"], bins=10, range=(0, 24))
    ax[1, 0].hist(data_b4["dLmin"], bins=10, range=(0, 1))
    ax[1, 0].hist(data_b4_hires["dLmin"], bins=10, range=(0, 1))
    ax[1, 1].hist(data_b4["dMLTmin"], bins=10, range=(0, 2))
    ax[1, 1].hist(data_b4_hires["dMLTmin"], bins=10, range=(0, 2))
    ax[0, 0].set_xlabel('Lshell (closest app)')
    ax[0, 1].set_xlabel('MLT (closest app) ')
    ax[1, 0].set_xlabel('dLmin')
    ax[1, 1].set_xlabel('dMLTmin')
    ax[0, 0].set_yscale("log")
    ax[0, 1].set_yscale("log")
    ax[1, 0].set_yscale("log")
    ax[1, 1].set_yscale("log")

    plt.show()
    #"""

    print("Here")

















    """
    #Comparison of different wave bands 
    fig, ax = plt.subplots(2, 2)

    xkey = "SpecBMed_lf"
    ykey = "colS"
    ax[0, 0].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[0, 0].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[0, 0].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[0, 0].set_xlabel(xkey)
    ax[0, 0].set_ylabel(ykey)
    ax[0, 0].set_yscale("log")
    ax[0, 0].set_xscale("log")

    xkey = "SpecBMed_lb"
    ykey = "colS"
    ax[0, 1].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[0, 1].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[0, 1].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[0, 1].set_xlabel(xkey)
    ax[0, 1].set_ylabel(ykey)
    ax[0, 1].set_yscale("log")
    ax[0, 1].set_xscale("log")


    xkey = "SpecBMed_ub"
    ykey = "colS"
    ax[1, 0].scatter(data_b4[xkey], data_b4[ykey], color='lightgray')
    ax[1, 0].scatter(data_b4_filt[xkey], data_b4_filt[ykey], color='black')
    ax[1, 0].scatter(data_b4_filt2[xkey], data_b4_filt2[ykey], color='lightgreen')
    ax[1, 0].set_xlabel(xkey)
    ax[1, 0].set_ylabel(ykey)
    ax[1, 0].set_yscale("log")
    ax[1, 0].set_xscale("log")



    """


    



    print('Here')





