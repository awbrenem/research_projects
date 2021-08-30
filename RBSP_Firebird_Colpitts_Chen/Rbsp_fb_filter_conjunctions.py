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
                    na_values=[99999.9, 9999.99, 999.99])


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
















    # Print final results after filtering
    print(
        "fbmaxflux --> max collumated or surface detector fluxes during the conjunction"
    )
    print(
        "rbmaxampE --> max RBSP electric field amplitude (mV/m, filter bank) within +/-60 of conjunction"
    )
    print(
        "rbmaxampB --> max RBSP magnetic field amplitude (pT, filter bank) within +/-60 of conjunction"
    )
    print(
        "bursttotalmin --> total number of burst minutes within +/-60 minutes of conjunction"
    )
    print("This includes B1, B2, and EMFISIS burst")
    print(
        "Lrb, Lfb, and MLTrb, MLTfb are the L and MLT values of RBSP and FB during the exact time of closest conjunction"
    )

    """

    print("Conjunctions for RBSPa and FU3")
    print('{:22}'.format(keyv[2]),
            '{:4}'.format(keyv[3]),'{:5}'.format(keyv[5]),
            '{:4}'.format(keyv[4]),'{:5}'.format(keyv[6]),
            '{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),
            '{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))


    for i in range(len(finv3a["datetime_min"])):
        if finv3a["Lrb"][i] != 0:
            print('{:19}'.format(finv3a["datetime_min"][i]),
                    '{:6.1f}'.format(finv3a["Lrb"][i]),'{:6.1f}'.format(finv3a["MLTrb"][i]),
                    '{:6.1f}'.format(finv3a["Lfb"][i]),'{:6.1f}'.format(finv3a["MLTfb"][i]),
                    '{:8.1f}'.format(finv3a["fbmaxflux"][i]),
                    '{:8.1f}'.format(finv3a["rbmaxampE"][i]),'{:8.1f}'.format(finv3a["rbmaxampB"][i]),
                    '{:8.1f}'.format(finv3a["bursttotalmin"][i]))

    """

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

"""    

#Total up values for all four combinations of RBSP and FIREBIRD


    v1 = np.asarray(finv3a["rbmaxampB"]+finv3b["rbmaxampB"]+finv4a["rbmaxampB"]+finv4b["rbmaxampB"])
    v2 = np.asarray(finv3a["fbmaxflux"]+finv3b["fbmaxflux"]+finv4a["fbmaxflux"]+finv4b["fbmaxflux"])
    cond = np.where(v1 != 0)

    v12 = v1[cond].tolist()
    v22 = v2[cond].tolist()
    plt.scatter([v12],[v22])
    plt.plot([0.1,10000],[0.1,10000])
    plt.title("All conjunctions\n(from rbsp_fb_filter_conjunctions.py)")
    plt.ylabel("FIREBIRD max flux")
    plt.xlabel("RBSP max wave amp (pT) within +/-1 hr\nof conjunction")
    plt.xscale('log')
    plt.yscale('log')
    plt.axis([1,10000,1,10000])
    plt.show()

"""

if __name__ == "__main__":

    from matplotlib import pyplot as plt

    path = "/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/"
    data_a4 = read_conjunction_file(path, "RBSPa_FU4_conjunction_values_hr.txt")


    lmin = 4
    lmax = 7
    mltmin = 2
    mltmax = 11

    data_a4_filt = data_a4
    data_a4_filt = filter_based_on_range(data_a4_filt, "Lrb", lmin, lmax)
    data_a4_filt = filter_based_on_range(data_a4_filt, "MLTrb", mltmin, mltmax)
    #data_a4_filt = filter_based_on_range(data_a4_filt, "BurstTotMin", 0.01, 10000)

    mltmin = 14
    mltmax = 20
    data_a4_filt2 = data_a4
    data_a4_filt2 = filter_based_on_range(data_a4_filt2, "Lrb", lmin, lmax)
    data_a4_filt2 = filter_based_on_range(data_a4_filt2, "MLTrb", mltmin, mltmax)



    #print(data_a4_filt["Lba"], data_a4_filt["SpecBMax_lb"])


    for i in range(len(data_a4_filt["Lrb"])):
        print(
            "{:19}".format(data_a4_filt["Tmin"][i]),
            "{:6.1f}".format(data_a4_filt["Lrb"][i]),
            "{:6.1f}".format(data_a4_filt["MLTrb"][i]),
            "{:6.1f}".format(data_a4_filt["Lfb"][i]),
            "{:6.1f}".format(data_a4_filt["MLTfb"][i]),
            "{:8.1f}".format(data_a4_filt["colS"][i]),
            "{:8.1f}".format(data_a4_filt["colHR"][i]),
            "{:8.1f}".format(data_a4_filt["FBKmaxE"][i]),
            "{:8.1f}".format(data_a4_filt["FBKmaxB"][i]),
            "{:8.1f}".format(data_a4_filt["BurstTotMin"][i]),
            )


    for i in range(len(data_a4_filt2["Lrb"])):
        print(
            "{:19}".format(data_a4_filt2["Tmin"][i]),
            "{:6.1f}".format(data_a4_filt2["Lrb"][i]),
            "{:6.1f}".format(data_a4_filt2["MLTrb"][i]),
            "{:6.1f}".format(data_a4_filt2["Lfb"][i]),
            "{:6.1f}".format(data_a4_filt2["MLTfb"][i]),
            "{:8.1f}".format(data_a4_filt2["colS"][i]),
            "{:8.1f}".format(data_a4_filt2["colHR"][i]),
            "{:8.1f}".format(data_a4_filt2["FBKmaxE"][i]),
            "{:8.1f}".format(data_a4_filt2["FBKmaxB"][i]),
            "{:8.1f}".format(data_a4_filt2["BurstTotMin"][i]),
            )



    xkey = "SpecBMed_lf"
    #xkey = "FBKmaxE"
    ykey = "colHR"
    xvar = data_a4_filt[xkey]
    yvar = data_a4_filt[ykey]
    plt.scatter(data_a4[xkey], data_a4[ykey], color='black')
    plt.scatter(data_a4_filt[xkey], data_a4_filt[ykey], color='red')
    plt.scatter(data_a4_filt2[xkey], data_a4_filt2[ykey], color='green')
    plt.xlabel(xkey)
    plt.ylabel(ykey)
    plt.yscale("log")
    plt.xscale("log")
    plt.show()

    print('Here')



