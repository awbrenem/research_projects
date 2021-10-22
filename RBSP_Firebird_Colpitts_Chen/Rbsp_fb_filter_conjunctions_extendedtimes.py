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
import os
from scipy.stats import kde

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

        #skip first few lines of the header file 
        for _ in range(6):
            next(f)

        for row in f:
            header.append(row.split()[0].replace(':', ''))

    return header



# Reads in the conjunction files and returns a list of Pandas dataframes, one entry for each extended conjunction.
# Also adds the following variables to the Pandas Dataframe 
# "Tconj" - time of the conjunction
# "FBKmaxE", "FBKmaxB" - max of all used FBK channels of E, B

def read_conjunction_file_extended(path,fn):


    df_ext = []
    
    header = parse_header(path[:-37] + "RBSP_FU_conjunction_header_extendedtimes.fmt")


    for f in fn: 


        #file_name = path + "RBSPa_FU3_conjunction_values_hr.txt"
        file_name = path + f
        df = pd.read_csv(file_name, header=None, delim_whitespace=True, names=header, 
                        na_values=["NaN", "-NaN", "Inf", "-Inf"])



        # Create new variables that are the max FB flux and the max RB amplitude observed on the filter bank
        rbmaxE = []
        rbmaxB = []
        for i in range(len(df["Tstart"])):
            rbmaxE.append(max([df["7E4"][i],df["7E5"][i],df["7E6"][i],df["7E7"][i],df["13E7"][i],df["13E8"][i],df["13E9"][i],df["13E10"][i],df["13E11"][i],df["13E12"][i],df["13E13"][i]]))  # FB max flux
            rbmaxB.append(max([df["7B4"][i],df["7B5"][i],df["7B6"][i],df["7B7"][i],df["13B7"][i],df["13B8"][i],df["13B9"][i],df["13B10"][i],df["13B11"][i],df["13B12"][i],df["13B13"][i]]))  # FB max flux

        df1 = pd.DataFrame({"FBKmaxE":rbmaxE})
        df2 = pd.DataFrame({"FBKmaxB":rbmaxB})


        #add these to the original pandas dataframe
        df1.reset_index(drop=True, inplace=True)
        df2.reset_index(drop=True, inplace=True)


        # Add new variable that gives the time of the conjunction 
        tconj = f[29:33] + '-' + f[33:35] + '-' + f[35:37] + '/' + f[38:40] + ':' + f[40:42]
        tconj = [tconj]*len(df)

        df3 = pd.DataFrame({"Tconj":tconj})



        #axis=1 is column
        dftmp = pd.concat([df,df1,df2,df3], axis=1)


        df_ext.append(dftmp)

    return df_ext



# Reads in the (non-extended) conjunction files and returns a dictionary with all the values
def read_conjunction_file(path,fn):

    header = parse_header(path + "RBSP_FU_conjunction_header.fmt")


    #file_name = path + "RBSPa_FU3_conjunction_values_hr.txt"
    file_name = path + fn
    df = pd.read_csv(file_name, header=None, skiprows=2, delim_whitespace=True, names=header, 
                    na_values=[99999.9, 9999.99, 999.99])


    return df





# Filter the dataframe by requiring the input quantity to be within minv and maxv
def filter_based_on_range(df, quantity, minv, maxv, *use_abs):


    if not use_abs:
        df_filtered = df[(df[quantity] <= maxv) & (df[quantity] >= minv)]
    else: 
        df_filtered = df[(abs(df[quantity]) <= maxv) & (abs(df[quantity]) >= minv)]


        df_filtered.reset_index(drop=True, inplace=True)


    return df_filtered






if __name__ == "__main__":

    from matplotlib import pyplot as plt

    path = "/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/"
    data_b4 = read_conjunction_file(path, "RBSPb_FU4_conjunction_values.txt")

    folder_ext = 'RBSPb_FU4_extended_conjunction_files'
    path_ext = "/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/"+folder_ext+"/"

    #Grab names of all files in extended folder 
    #fn_ext = os.listdir(path_ext)
    fn_ext = [f for f in os.listdir(path_ext) if f[0:4] == "RBSP"]



    #Load in each extended file as a list of Pandas dataframes
    list_ext = read_conjunction_file_extended(path_ext, fn_ext)


    #At this point we have a list of dataframes. Each dataframe contains the extended data for each conjunction.








    #Going forward, we'll take each dataframe and:
        #1) grab the colS and hires flux for each conjunction from the usual conjunction_values.txt files. This is a single value for each dataframe.
        #2) isolate out various data slices (e.g. 2<dL<3 and -1<dMLT<1 data) and add these to a plot vs the colS flux.


    #Add in FIREBIRD data (from original conjunction file) to extended dataframe


    ##list of dataframes that survive the filtering and have colS from the conjunction added in 
    df_surviving_list = []



    #For each dataframe in our list:
    for j in range(len(list_ext)):

        df = list_ext[j]

        #Grab only 0th element for this dataframe. The others are identical
        conjtime = df["Tconj"][0]   
        conjtmp = [] 
        for b in data_b4["Tmin"]:
            conjtmp.append(b[0:16])

        conjindex = np.where(np.array(conjtmp) == conjtime)
        colS = float(data_b4["colS"][conjindex[0]])
        colHR = float(data_b4["colHR"][conjindex[0]])


        #isolate out slices of data 
        lmn = 3.5
        lmx = 8
        mltmn = 0
        mltmx = 12

        tmp = df
        tmp = filter_based_on_range(tmp, "Lref", lmn, lmx)
        tmp = filter_based_on_range(tmp, "MLTref", mltmn, mltmx)

        dlmn = 0.75
        dlmx = 20
        dmltmn = 0
        dmltmx = 1

        tmp = filter_based_on_range(tmp, "dLavg", dlmn, dlmx, 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltmn, dmltmx, 1) #1=|abs|



        #Now add in the column flux to the surviving data in the dataframe 
        colS_arr = [colS] * len(tmp)
        colHR_arr = [colHR] * len(tmp)
        df1 = pd.DataFrame({"colS":colS_arr})
        df2 = pd.DataFrame({"colHR":colHR_arr})
        df1.reset_index(drop=True, inplace=True)
        df2.reset_index(drop=True, inplace=True)
        df = pd.concat([tmp, df1, df2], axis=1)

        df_surviving_list.append(df)




    #Now concatenate list of dataframes into single dataframe that contains all the surviving data for a particular dL and dMLT range
    df_fin = pd.concat(df_surviving_list)



    #xkey = "SpecBAvg_lb"
    xkey = "FBKmaxB"
    ykey = "colHR"
    #ykey = "colS"

    """
    xvar = df_fin[xkey]
    yvar = df_fin[ykey]
    plt.scatter(df_fin[xkey], df_fin[ykey], color='black')
    plt.xlabel(xkey)
    plt.ylabel(ykey)
    plt.yscale("log")
    plt.xscale("log")
    plt.ylim([1e0,4e1])
    plt.xlim([1e-9,5e-5])
    plt.show()
    """



    #Plot density of points


    #Take log of data so it's properly weighted on a linear scale
    datx = np.log10(np.asarray(df_fin[xkey]))
    daty = np.log10(np.asarray(df_fin[ykey]))

    #Keep only non-NaN values
    tstx = np.isfinite(datx)
    tsty = np.isfinite(daty)
    good = np.logical_and(tstx, tsty)


    #Numpy version 
    datx2np = datx[good]
    daty2np = daty[good]
    datnp = np.vstack([datx2np, daty2np])
    k = kde.gaussian_kde(datnp)


    nbins = 12.
    xi, yi = np.mgrid[datx2np.min():datx2np.max():nbins*1j, daty2np.min():daty2np.max():nbins*1j]
    #zi = np.log10(k(np.vstack([xi.flatten(), yi.flatten()])))
    zi = k(np.vstack([xi.flatten(), yi.flatten()]))

    #Turn grid points back into linear scale
    xi2 = [10**x for x in xi]
    yi2 = [10**x for x in yi]

    #Set axes ranges
    #xmin = np.min(df_fin[xkey])
    xmin = 5e0
    #xmax = np.max(df_fin[xkey])
    xmax = 2000

    #ymin = np.min(df_fin[ykey])
    ymin = 1e0
    #ymax = np.max(df_fin[ykey])
    ymax = 4e1


    fig, ax = plt.subplots(2)
    ax[0].set_title("L="+str(lmn)+"-"+str(lmx)+"  MLT="+str(mltmn)+"-"+str(mltmx)+"  dL="+str(dlmn)+"-"+str(dlmx)+"  dMLT="+str(dmltmn)+"-"+str(dmltmx))
    ax[0].scatter(df_fin[xkey], df_fin[ykey], color='lightgray')
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
 
    #title_str = ykey+"-vs-"+xkey+"_L="+str(lmn)+"-"+str(lmx)+"_MLT="+str(mltmn)+"-"+str(mltmx)+"_dL="+str(dlmn)+"-"+str(dlmx)+"_dMLT="+str(dmltmn)+"-"+str(dmltmx)
    title_str = ykey+"-vs-"+xkey+"[L="+str(lmn)+"-"+str(lmx)+"][MLT="+str(mltmn)+"-"+str(mltmx)+"][dL="+str(dlmn)+"-"+str(dlmx)+"][dMLT="+str(dmltmn)+"-"+str(dmltmx)+"]"
    plt.savefig('/Users/abrenema/Desktop/'+ title_str + ".png")
    plt.show()



    print("Here")
