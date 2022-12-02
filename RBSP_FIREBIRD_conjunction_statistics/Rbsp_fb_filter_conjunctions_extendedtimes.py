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
from natsort import natsorted
from datetime import datetime
import bisect 
from matplotlib import pyplot as plt
import gc 


def reduce_to_common_conjunctions(df1,df2,df3, conj, conj_ub, conj_ext):

    print(df1.shape)  #RBSP dataframe
    print(df2.shape)  #FB dataframe
    print(len(df3))   #Extended conjunction dataframe (number of conjunctions)


    df3times = []
    for i in range(len(df3)): 
        tmp = df3[i]
        df3times.append(tmp["Tstart"][0])

    for i in range(len(conj)): print(str(i), ")", conj[i], conj_ub[i], conj_ext[i])





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

def read_conjunction_file_extended(path, fn, dstart, dend):


    df_ext = []

    pathtmp = "/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_FIREBIRD_conjunction_statistics/conjunction_values/extended_conjunction_values/"
    header = parse_header(pathtmp + "RBSP_FU_conjunction_header_extendedtimes.fmt")

    #Sort extended file list numerically 
    fn = natsorted(fn)

    for f in fn: 


        file_name = path + f
        df = pd.read_csv(file_name, header=None, delim_whitespace=True, names=header, 
                        na_values=["NaN", "-NaN", "Inf", "-Inf"])

        # Create new variables that are the max FB flux and the max RB amplitude observed on the filter bank
        rbmaxE = []
        rbmaxB = []
        for i in range(len(df["Tstart"])):
            rbmaxE.append(max([df["7E3"][i],df["7E4"][i],df["7E5"][i],df["7E6"][i],df["13E6"][i],df["13E7"][i],df["13E8"][i],df["13E9"][i],df["13E10"][i],df["13E11"][i],df["13E12"][i]]))  # FB max flux
            rbmaxB.append(max([df["7B3"][i],df["7B4"][i],df["7B5"][i],df["7B6"][i],df["13B6"][i],df["13B7"][i],df["13B8"][i],df["13B9"][i],df["13B10"][i],df["13B11"][i],df["13B12"][i]]))  # FB max flux

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


    #Create list of datetime objects with the conjunction times. 
    conjtimes = []
    for i in range(len(fn)): 
        goo = fn[i]
        tst = goo[29:-4]
        conjtimes.append(datetime.strptime(tst, "%Y%m%d_%H%M%S"))


    df["Tstart"] = pd.to_datetime(df["Tstart"])


    dstart = datetime.strptime(dstart, "%Y-%m-%d")
    dend = datetime.strptime(dend, "%Y-%m-%d")


    #Reduce to desired date range
    lower = bisect.bisect_right(conjtimes, dstart)
    upper = bisect.bisect_left(conjtimes,  dend)
    conjtimes = conjtimes[lower:upper]
    df_ext = df_ext[lower:upper]


    return df_ext, conjtimes



# Reads in the (non-extended) conjunction files and returns a Pandas data frame with all the values
# These files have the FIREBIRD flux values that are not in the extended files
def read_conjunction_file(path, fn, dstart, dend):

    header = parse_header(path + "RBSP_FU_conjunction_header.fmt")


    #file_name = path + "RBSPa_FU3_conjunction_values_hr.txt"
    file_name = path + fn
    df = pd.read_csv(file_name, header=None, skiprows=1, delim_whitespace=True, names=header, 
                    na_values=[99999.9, 9999.99, 999.99])


    # Create new variables that are the max FB flux and the max RB amplitude observed on the filter bank
    rbmaxE = []
    rbmaxB = []
    for i in range(len(df["Tstart"])):
        rbmaxE.append(max([df["7E3"][i],df["7E4"][i],df["7E5"][i],df["7E6"][i],df["13E6"][i],df["13E7"][i],df["13E8"][i],df["13E9"][i],df["13E10"][i],df["13E11"][i],df["13E12"][i]]))  # FB max flux
        rbmaxB.append(max([df["7B3"][i],df["7B4"][i],df["7B5"][i],df["7B6"][i],df["13B6"][i],df["13B7"][i],df["13B8"][i],df["13B9"][i],df["13B10"][i],df["13B11"][i],df["13B12"][i]]))  # FB max flux

    df1 = pd.DataFrame({"FBKmaxE":rbmaxE})
    df2 = pd.DataFrame({"FBKmaxB":rbmaxB})


    #add these to the original pandas dataframe
    df1.reset_index(drop=True, inplace=True)
    df2.reset_index(drop=True, inplace=True)

    ## Add new variable that gives the time of the conjunction 
    #tconj = f[29:33] + '-' + f[33:35] + '-' + f[35:37] + '/' + f[38:40] + ':' + f[40:42]
    #tconj = [tconj]*len(df)
    #df3 = pd.DataFrame({"Tconj":tconj})

    #axis=1 is column
    df = pd.concat([df,df1,df2], axis=1)
    #df.append(dftmp)



    #Create list of datetime objects with the conjunction times. 
    conjtimes = []
    for i in df["Tstart"]: 
        conjtimes.append(datetime.strptime(i, "%Y-%m-%d/%H:%M:%S"))


    #Change times to datetime objects
    df["Tstart"] = pd.to_datetime(df["Tstart"])


    dstart = datetime.strptime(dstart, "%Y-%m-%d")
    dend = datetime.strptime(dend, "%Y-%m-%d")


    #Reduce to desired date range
    lower = bisect.bisect_right(conjtimes, dstart)
    upper = bisect.bisect_left(conjtimes,  dend)
    conjtimes = conjtimes[lower:upper]
    df = df[lower:upper]

    return df, conjtimes


# Reads the file that contains properties of the microbursts during each conjunction, where the microbursts
# have been identify from Shumko's id program. 
def read_conjunction_microbursts_file(path, fn, dstart, dend):


    header = ["Tstart", "Tend", "number_uB", "uB_maxflux", "uB_avgflux", "uB_medflux"]
    file_name = path + fn
    df = pd.read_csv(file_name, header=None, skiprows=3, delim_whitespace=True, names=header, 
                    na_values=[99999.9, 9999.99, 999.99])

    #Create list of datetime objects with the conjunction times. 
    conjtimes = []
    for i in df["Tstart"]: 
        conjtimes.append(datetime.strptime(i, "%Y-%m-%d/%H:%M:%S"))


    df["Tstart"] = pd.to_datetime(df["Tstart"])



    dstart = datetime.strptime(dstart, "%Y-%m-%d")
    dend = datetime.strptime(dend, "%Y-%m-%d")

    #Reduce to desired date range
    lower = bisect.bisect_right(conjtimes, dstart)
    upper = bisect.bisect_left(conjtimes,  dend)
    conjtimes = conjtimes[lower:upper]
    df = df[lower:upper]

    return df, conjtimes 



# Filter the dataframe by requiring the input quantity to be within minv and maxv
def filter_based_on_range(df, quantity, minv, maxv, *use_abs):


    if not use_abs:
        df_filtered = df[(df[quantity] <= maxv) & (df[quantity] >= minv)]
    else: 
        df_filtered = df[(abs(df[quantity]) <= maxv) & (abs(df[quantity]) >= minv)]


        df_filtered.reset_index(drop=True, inplace=True)


    return df_filtered


# Add in the FIREBIRD flux to every entry in the list of extended Pandas dataframes
def add_fb_flux_to_extended_df_list(list_of_df_ext, df, dfuB):



    #For each dataframe in our list (which has extended values for a particular conjunction)
    for j in range(len(list_of_df_ext)):


        #Turn the uB values for each conjunction into an array of the size of the extended array. 
        dfuB2 = pd.DataFrame({"number_uB":[dfuB["number_uB"][j]]*60,
                              "uB_maxflux":[dfuB["uB_maxflux"][j]]*60, 
                              "uB_avgflux":[dfuB["uB_avgflux"][j]]*60, 
                              "uB_medflux":[dfuB["uB_medflux"][j]]*60})

        df_ext = list_of_df_ext[j]
        list_of_df_ext[j] = pd.concat([df_ext, dfuB2], axis=1)


        """
        #Grab only 0th element for this dataframe. The others have identical Tconj and Tmin values
        conjtime = df_ext["Tconj"][0]   
        conjtmp = [] 
        for b in df["Tmin"]:
            conjtmp.append(b[0:16])

        #Find which elements in extended dataframe correspond to jth conjunction 
        conjindex = np.where(np.array(conjtmp) == conjtime)
        if np.size(conjindex) == 0: 
            return -1 

        #colHR = float(df["colHR"][conjindex[0]])
        colHR = float(dfuB["uB_maxflux"][conjindex[0]])
        """


        """
        #Now add in the column flux to the surviving data in the dataframe 
        colHR_arr = [colHR] * len(df_ext)
        df2 = pd.DataFrame({"colHR":colHR_arr})
        df2.reset_index(drop=True, inplace=True)
        #df_ext = pd.concat([df_ext, df1, df2], axis=1)

        list_of_df_ext[j] = pd.concat([df_ext, df2], axis=1)
        #df_surviving_list_b4.append(df_ext)
        """


    return list_of_df_ext





def get_kde_values(df_fin, xkey, ykey, nbins): 


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


    xi, yi = np.mgrid[datx2np.min():datx2np.max():nbins*1j, daty2np.min():daty2np.max():nbins*1j]
    #zi = np.log10(k(np.vstack([xi.flatten(), yi.flatten()])))
    zi = k(np.vstack([xi.flatten(), yi.flatten()]))

    #Turn grid points back into linear scale
    xi2 = [10**x for x in xi]
    yi2 = [10**x for x in yi]


    return xi, yi, xi2, yi2, zi




def add_subplot(df_surviving_list, lrange, mltrange, dlrange, dmltrange, xkey, ykey, ax_number):

    #Now concatenate list of dataframes into single dataframe that contains all the surviving data for a particular dL and dMLT range
    df_fin = pd.concat(df_surviving_list)

    #Set axes ranges
    xmin = np.min(df_fin[xkey])
    #xmin = 0
    xmax = np.max(df_fin[xkey])/10
    #xmax = 200
    #ymin = np.min(df_fin[ykey])
    ymin = 0
    #ymax = np.max(df_fin[ykey])/10
    ymax = 110


    #for i in range(3000): print(df_fin[xkey][i])

    #Calculate the number of bins for the KDE gridding based on the range of datapoints available. 
    #This is a better way than having a set gridsize which can lead to vastly different bin "fatness"
    binsmax = np.nanmax(df_fin[xkey]) if np.nanmax(df_fin[xkey]) < xmax else xmax
    binsmin = np.nanmin(df_fin[xkey]) if np.nanmin(df_fin[xkey]) > xmin else xmin
    #nbins = abs(np.floor((np.log10(binsmax) - np.log10(binsmin)) * 10))
    nbins = 60

    xi,yi,xi2,yi2,zi = get_kde_values(df_fin, xkey, ykey, nbins)
    ax[ax_number[0],ax_number[1]].set_title(str(len(df_surviving_list))+" events; "+str(len(df_fin[xkey]))+" data points;  L="+str(lrange[0])+"-"+str(lrange[1])+"  MLT="+str(mltrange[0])+"-"+str(mltrange[1])+"  dL="+str(dlrange[0])+"-"+str(dlrange[1])+"  dMLT="+str(dmltrange[0])+"-"+str(dmltrange[1]), fontsize=6)
    ax[ax_number[0],ax_number[1]].pcolormesh(xi2, yi2, zi.reshape(xi.shape), shading='auto')
    ax[ax_number[0],ax_number[1]].set_yscale("linear")
    ax[ax_number[0],ax_number[1]].set_xscale("linear")
    ax[ax_number[0],ax_number[1]].set_xlabel(xkey, fontsize=6)
    ax[ax_number[0],ax_number[1]].set_ylabel(ykey, fontsize=6)
    ax[ax_number[0],ax_number[1]].set_xlim([xmin, xmax])
    ax[ax_number[0],ax_number[1]].set_ylim([ymin, ymax])

    print('-------')
    print(np.log10(binsmin), np.log10(binsmax))
    print(np.log10(binsmax) - np.log10(binsmin))

    print(nbins)
    print("add_subplot -- returning")




if __name__ == "__main__":


    #Start and end dates for data loading
    dstart = '2015-03-26'
    dend = '2018-01-01'


    path = "/Users/abrenema/Desktop/code/Aaron/github/research_projects/RBSP_FIREBIRD_conjunction_statistics/conjunction_values/"



    #------------------------------------
    #Read in all the data
    #------------------------------------

    #...normal conjunction file.  size = (nconj, nkeys=len(keysave))
    df_a3, conja3 = read_conjunction_file(path+"immediate_conjunction_values/", "RBSPa_FU3_conjunction_values_hr.txt", dstart, dend)
    df_b3, conjb3 = read_conjunction_file(path+"immediate_conjunction_values/", "RBSPb_FU3_conjunction_values_hr.txt", dstart, dend)
    df_a4, conja4 = read_conjunction_file(path+"immediate_conjunction_values/", "RBSPa_FU4_conjunction_values_hr.txt", dstart, dend)
    df_b4, conjb4 = read_conjunction_file(path+"immediate_conjunction_values/", "RBSPb_FU4_conjunction_values_hr.txt", dstart, dend)


    #Combine files for all RBSP, FIREBIRD combinations
    df = pd.concat([df_a3, df_b3, df_a4, df_b4], axis=0)
    df = df.sort_values(by="Tstart")
    df = df.reset_index(drop=True)
    conj = conja3 + conjb3 + conja4 + conjb4

    #...microburst amplitudes from Shumko's code. size = (nconj, nkeys_ub=6)
    uB_a3, conj_uba3 = read_conjunction_microbursts_file(path+"immediate_conjunction_microbursts/", "RBSPa_FU3_conjunction_microbursts.txt", dstart, dend)
    uB_b3, conj_ubb3 = read_conjunction_microbursts_file(path+"immediate_conjunction_microbursts/", "RBSPb_FU3_conjunction_microbursts.txt", dstart, dend)
    uB_a4, conj_uba4 = read_conjunction_microbursts_file(path+"immediate_conjunction_microbursts/", "RBSPa_FU4_conjunction_microbursts.txt", dstart, dend)
    uB_b4, conj_ubb4 = read_conjunction_microbursts_file(path+"immediate_conjunction_microbursts/", "RBSPb_FU4_conjunction_microbursts.txt", dstart, dend)

    #Combine files for all RBSP, FIREBIRD combinations
    uB = pd.concat([uB_a3, uB_b3, uB_a4, uB_b4], axis=0)
    uB = uB.sort_values(by="Tstart")
    uB = uB.reset_index(drop=True)
    conj_ub = conj_uba3 + conj_ubb3 + conj_uba4 + conj_ubb4



    #...extended conjunction file as a LIST of Pandas dataframes. 
    # List has size = (nconj)
    # Each element of list has size = (n_extendedtimes, nkeys)
    path_ext = path + "extended_conjunction_values/" + "RBSPa_FU3/"
    fn_ext = [f for f in os.listdir(path_ext) if f[0:4] == "RBSP"]  #names of files in extended folder
    df_a3_ext, conj_exta3 = read_conjunction_file_extended(path_ext, fn_ext, dstart, dend)

    path_ext = path + "extended_conjunction_values/" + "RBSPa_FU4/"
    fn_ext = [f for f in os.listdir(path_ext) if f[0:4] == "RBSP"]
    df_a4_ext, conj_exta4 = read_conjunction_file_extended(path_ext, fn_ext, dstart, dend)

    path_ext = path + "extended_conjunction_values/" + "RBSPb_FU3/"
    fn_ext = [f for f in os.listdir(path_ext) if f[0:4] == "RBSP"]
    df_b3_ext, conj_extb3 = read_conjunction_file_extended(path_ext, fn_ext, dstart, dend)

    path_ext = path + "extended_conjunction_values/" + "RBSPb_FU4/"
    fn_ext = [f for f in os.listdir(path_ext) if f[0:4] == "RBSP"]
    df_b4_ext, conj_extb4 = read_conjunction_file_extended(path_ext, fn_ext, dstart, dend)

    df_ext = df_a3_ext + df_b3_ext + df_a4_ext + df_b4_ext
    conj_ext = conj_exta3 + conj_extb3 + conj_exta4 + conj_extb4

    #Remove to save on memory
    del [[df_a3_ext,df_a4_ext,df_b3_ext,df_b4_ext]]
    gc.collect()


    #The extended dataframes don't have the FIREBIRD flux (they only have the RBSP data at various times away from the conjunction).
    #Here we'll add in the FIREBIRD flux (from the uB flux files) to the list of extended dataframes
    #Note: it's easier to do it this way than to filter the extended array based on selected conjunctions from uB and df dataframes. 
    #All the plotting at the end involves ONLY the extended array, and all the bad values are just NaN'd out. 
    df_ext_fb = add_fb_flux_to_extended_df_list(df_ext, df, uB)


    # Test to make sure all lists are same size
    print(len(df_ext_fb), len(df_ext), len(df), len(uB))
    #for i in range(61): print(conja3[i], conj_uba3[i], conj_exta3[i])
    print('here')




    ##Test to make sure that the dataframes for immediate conjunction values, 
    ##immediate conjunction microbursts, and extended conjunctions all have the same conjunction times
    #tstresult = reduce_to_common_conjunctions(df, uB, df_ext, conj, conj_ub, conj_ext)




    #----------------------------------------------------------------
    #Basic plot to test uB vs chorus amplitudes during conjunction. 
    #----------------------------------------------------------------


    #SpecBTot_lb
    #SpecBMax_lb
    #SpecBMed_lb
    #SpecBAvg_lb
    #xkey = "SpecBMax_lb"
    xkey = "FBKmaxB"
    ykey = "uB_maxflux"
    #ykey = "number_uB"


    #The above dataframes are HUGE. Reduce them to only the needed keys 
    keysave = ['Lfb','MLTfb',xkey]
    df = df[keysave]
    keysave = [ykey]
    uB = uB[keysave]


    tmp2 = []
    tmpfin = []
    keysave = ['Lref','MLTref','dLavg','dMLTavg',xkey,ykey]
    for i in range(len(df_ext_fb)):
        tmp = df_ext_fb[i] 
        tmp2 = tmp[keysave]
        tmpfin.append(tmp2)

    df_ext_fb = tmpfin 


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    #dlrange = [0, 2]
    #dmltrange = [0, 4]


    df2 = df[(df["Lfb"] > lrange[0]) & (df["Lfb"] < lrange[1]) & (df["MLTfb"] > mltrange[0]) & (df["MLTfb"] < mltrange[1])] 
    uB2 = uB[(df["Lfb"] > lrange[0]) & (df["Lfb"] < lrange[1]) & (df["MLTfb"] > mltrange[0]) & (df["MLTfb"] < mltrange[1])] 

    xv = df2[xkey]
    yv = uB2[ykey]

    """
    plt.scatter(xv,yv)
    plt.title("uB vs chorus - conjunction times only")
    plt.xlabel("Chorus max amp within +/-2 hrs")
    plt.ylabel("microburst max amp during conjunction")
    plt.ylim(0,125)
    plt.xlim(0,1000)
    plt.show()

    print("here")
    """ 





    #----------------------------------------------------------------
    #Basic plot to test FU4, RBSPb to compare with previous version
    #----------------------------------------------------------------


    #FILTER AND PLOT:  For each dataframe in out list, filter the data based on desired L, MLT, dL, dMLT

    """
    #KDE plots
    fig, ax = plt.subplots(2,2)


    #Ranges to filter all the data (each dataframe in list) to 
    lrange = [0, 200] 
    mltrange = [0, 12]
    dlrange = [0, 200]
    dmltrange = [0, 12]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [0,0])

    lrange = [0, 200] 
    mltrange = [12, 24]
    dlrange = [0, 200]
    dmltrange = [0, 12]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [1,0])


    title_str = ykey+"-vs-"+xkey+"[L="+str(lrange[0])+"-"+str(lrange[1])+"][MLT="+str(mltrange[0])+"-"+str(mltrange[1])+"][dL="+str(dlrange[0])+"-"+str(dlrange[1])+"][dMLT="+str(dmltrange[0])+"-"+str(dmltrange[1])+"]"
    plt.savefig('/Users/abrenema/Desktop/'+ title_str + "_overview.ps")
    plt.show()

    print("here")

    """




    fig, ax = plt.subplots(3,2)

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [0, 1]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [0,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [1, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [1,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [2, 10]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [2,0])




    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 1]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [0,1])

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [1, 2]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [1,1])

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [2, 3]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [2,1])





    print("here")


















    
    fig, ax = plt.subplots(6,2)



    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [0, 0.5]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [0,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [0.5, 1]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [1,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [1, 1.5]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [2,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [1.5, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [3,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [2, 2.5]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [4,0])


    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 2]
    dmltrange = [2.5, 3]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [5,0])






    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0, 0.33]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [0,1])

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0.33, 0.66]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [1,1])

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [0.66, 1]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [2,1])

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [1, 1.33]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [3,1])

    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [1.33, 100]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [4,1])



    """
    lrange = [3.5, 8] 
    mltrange = [0, 12]
    dlrange = [1.66, 2]
    dmltrange = [0, 2]
    df_surviving_list_tmp = []
    for j in range(len(df_ext_fb)):
        tmp = df_ext_fb[j]
        tmp = filter_based_on_range(tmp, "Lref", lrange[0], lrange[1])
        tmp = filter_based_on_range(tmp, "MLTref", mltrange[0], mltrange[1])
        tmp = filter_based_on_range(tmp, "dLavg", dlrange[0], dlrange[1], 1)
        tmp = filter_based_on_range(tmp, "dMLTavg", dmltrange[0], dmltrange[1], 1) #1=|abs|
        df_surviving_list_tmp.append(tmp)
    add_subplot(df_surviving_list_tmp, lrange, mltrange, dlrange, dmltrange, xkey, ykey, [5,1])
    """



    title_str = ykey+"-vs-"+xkey+"[L="+str(lrange[0])+"-"+str(lrange[1])+"][MLT="+str(mltrange[0])+"-"+str(mltrange[1])+"][dL="+str(dlrange[0])+"-"+str(dlrange[1])+"][dMLT="+str(dmltrange[0])+"-"+str(dmltrange[1])+"]"
    plt.savefig('/Users/abrenema/Desktop/'+ title_str + ".ps")
    plt.show()




    
    #title_str = ykey+"-vs-"+xkey+"_L="+str(lmn)+"-"+str(lmx)+"_MLT="+str(mltmn)+"-"+str(mltmx)+"_dL="+str(dlmn)+"-"+str(dlmx)+"_dMLT="+str(dmltmn)+"-"+str(dmltmx)
    title_str = ykey+"-vs-"+xkey+"[L="+str(lrange[0])+"-"+str(lrange[1])+"][MLT="+str(mltrange[0])+"-"+str(mltrange[1])+"][dL="+str(dlrange[0])+"-"+str(dlrange[1])+"][dMLT="+str(dmltrange[0])+"-"+str(dmltrange[1])+"]"
    plt.savefig('/Users/abrenema/Desktop/'+ title_str + ".ps")
    plt.show()





    print("Here")
