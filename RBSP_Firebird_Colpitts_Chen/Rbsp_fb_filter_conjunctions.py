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


class Rbsp_fb_filter_conjunctions:


    def __init__(self, params):
        self.__dict__.update(params)


    def print_test(self):
        print(self.rb, self.fb, self.hires)


    #Reads in the conjunction files and returns a dictionary with all the values
    def read_conjunction_file(self):
        import numpy as np

        path = "/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/"


        if self.hires == "1":
            suffix = "_conjunction_values_hr.txt"
        else:
            suffix = "_conjunction_values.txt"

        fn = "RBSP"+self.rb.lower()+"_FU"+self.fb.lower()+suffix

        f = open(path+fn,'r')

        vals = f.read()

        vals = vals.split("\n")
        header = vals[48]
        vals = vals[49:len(vals)]
        f.close()

        #Header quantities
        headerv = header.split()
        headerv = headerv[3:]  #Don't include the date. This will make headerv the same size as data array
        headervnp = np.array(headerv) #numpy array of header values

        data = []   #array of values for each conjunction time
        timesS = []  #String START times for each conjunction
        timesE = []   #String END times
        timesM = []   #String time of closest approach

        for i in range(len(vals[1:])):
            tmpp = vals[i].split()
            timesS.append(tmpp[0])
            timesE.append(tmpp[1])
            timesM.append(tmpp[2])
            tmpp2 = [float(j) for j in tmpp[3:]]
            data.append(tmpp2)


        #Create new variables that are the max FB flux and the max RB amplitude observed on the filter bank
        fbtot = []
        rbtotE = []
        rbtotB = []
        #locations of certain data quantities
        whfbk7e = int(np.where(headervnp == '7E3')[0])
        whfbk7b = int(np.where(headervnp == '7B3')[0])
        whfbk13e = int(np.where(headervnp == '13E6')[0])
        whfbk13b = int(np.where(headervnp == '13B6')[0])
        whcolS = int(np.where(headervnp == 'colS')[0])

        for i in range(len(data)):
            fbtot.append(max(data[i][whcolS:whcolS+3]))  #FB max flux

            tmp1 = max(data[i][whfbk7e:whfbk7e+4])
            tmp2 = max(data[i][whfbk13e:whfbk13e+7])
            tmpE = max(tmp1,tmp2)

            tmp1 = max(data[i][whfbk7b:whfbk7b+4])
            tmp2 = max(data[i][whfbk13b:whfbk13b+7])
            tmpB = max(tmp1,tmp2)

            rbtotE.append(tmpE)
            rbtotB.append(tmpB)


        #Create new variable that is the total number of burst seconds within +/-60 minutes of closest conjunction
        whemfb = int(np.where(headervnp == 'EMFb')[0])
        whb1b = int(np.where(headervnp == 'B1b')[0])
        whb2b = int(np.where(headervnp == 'B2b')[0])
        bursttot = []
        for i in range(len(data)):
            bursttot.append(data[i][whemfb]+data[i][whb1b]+data[i][whb2b])


        #Put the values associated with each header into a dictionary
        thisdict = {}
        thisdict["datetime_start"] = timesS
        thisdict["datetime_end"] = timesE
        thisdict["datetime_min"] = timesM
        for j in range(len(headerv)-1):
            thisdict[headerv[j]] = [data[i][j] for i in range(len(data))]

        #add in the max FB and RB values and total burst minutes variables
        thisdict["fbmaxflux"] = fbtot
        thisdict["rbmaxampE"] = rbtotE
        thisdict["rbmaxampB"] = rbtotB
        bursttotmin = []
        for q in bursttot: bursttotmin.append(q/60)
        thisdict["bursttotalmin"] = bursttotmin
        return thisdict




    #Filter the dictionary by requiring the input quantity to be within minv and maxv
    def filter_based_on_range(self, dictt, quantity, minv, maxv):
        import numpy as np

        out_arr = np.asarray(dictt[quantity])

    #    print(np.where(out_arr > minv and out_arr < maxv,1,0))
        cond1 = np.where(out_arr < maxv,1,0)
        cond2 = np.where(out_arr > minv,1,0)
        tstt = cond1 * cond2
        condfin = np.where(tstt == 1,1,0)
        condfin2 = condfin.tolist()


        #Now reduce the dictionary to only the values that pass the test.
        newdict = dictt
        for key in newdict.keys():
            if key != "date":
                goo = newdict[key]
                goofin = [goo[j]*condfin2[j] for j in range(len(condfin2))]
                newdict[key] = goofin


        return newdict





    def main():

        import sys
        import matplotlib.pyplot as plt
        import numpy as np
        sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_Colpitts_Chen/')
        from Rbsp_fb_filter_conjunctions import Rbsp_fb_filter_conjunctions

        hires = "1"   #use only conjunctions with FIREBIRD hires data?


        rbaf3_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"3", "hires":hires})

#        rbaf4_obj = Rbsp_fb_filter_conjunctions({"rb":"a", "fb":"4", "hires":hires})

        #        rbbf3_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"3", "hires":hires})
        #        rbbf4_obj = Rbsp_fb_filter_conjunctions({"rb":"b", "fb":"4", "hires":hires})

        lmin = 0
        lmax = 12
        mltmin = 0
        mltmax = 24

        rbaf3 = rbaf3_obj.read_conjunction_file()
        keyv = list(rbaf3.keys())
        rbaf3_1 = rbaf3_obj.filter_based_on_range(rbaf3, "Lrb", lmin, lmax)
        rbaf3_2 = rbaf3_obj.filter_based_on_range(rbaf3_1, "MLTrb", mltmin, mltmax)
        rbaf3_3 = rbaf3_obj.filter_based_on_range(rbaf3_2, "bursttotalmin", 0.01, 10000)
        finv3a = rbaf3_3

        """

        rbaf4 = rbaf4_obj.read_conjunction_file()
        rbaf4_1 = rbaf4_obj.filter_based_on_range(rbaf4, "Lrb", lmin, lmax)
        rbaf4_2 = rbaf4_obj.filter_based_on_range(rbaf4_1, "MLTrb", mltmin, mltmax)
        rbaf4_3 = rbaf4_obj.filter_based_on_range(rbaf4_2, "bursttotalmin", 0.01, 10000)
        finv4a = rbaf4_3


        rbbf3 = rbbf3_obj.read_conjunction_file()
        rbbf3_1 = rbbf3_obj.filter_based_on_range(rbbf3, "Lrb", lmin, lmax)
        rbbf3_2 = rbbf3_obj.filter_based_on_range(rbbf3_1, "MLTrb", mltmin, mltmax)
        rbbf3_3 = rbbf3_obj.filter_based_on_range(rbbf3_2, "bursttotalmin", 0.01, 10000)
        finv3b = rbbf3_3

    

        rbbf4 = rbbf4_obj.read_conjunction_file()
        rbbf4_1 = rbbf4_obj.filter_based_on_range(rbbf4, "Lrb", lmin, lmax)
        rbbf4_2 = rbbf4_obj.filter_based_on_range(rbbf4_1, "MLTrb", mltmin, mltmax)
        rbbf4_3 = rbbf4_obj.filter_based_on_range(rbbf4_2, "bursttotalmin", 0.01, 10000)
        finv4b = rbbf4_3

        """





        #Print final results after filtering
        print("fbmaxflux --> max collumated or surface detector fluxes during the conjunction")
        print("rbmaxampE --> max RBSP electric field amplitude (mV/m, filter bank) within +/-60 of conjunction")
        print("rbmaxampB --> max RBSP magnetic field amplitude (pT, filter bank) within +/-60 of conjunction")
        print("bursttotalmin --> total number of burst minutes within +/-60 minutes of conjunction")
        print("This includes B1, B2, and EMFISIS burst")
        print("Lrb, Lfb, and MLTrb, MLTfb are the L and MLT values of RBSP and FB during the exact time of closest conjunction")

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
        print('{:22}'.format(keyv[2]),'{:4}'.format(keyv[3]),'{:5}'.format(keyv[4]),'{:6}'.format(keyv[-4]),'{:6}'.format(keyv[-3]),'{:6}'.format(keyv[-2]),'{:6}'.format(keyv[-1]))
        for i in range(len(finv4a["datetime_min"])):
            if finv4a["Lmin"][i] != 0: print('{:19}'.format(finv4a["datetime_min"][i]),'{:6.1f}'.format(finv4a["Lmin"][i]),'{:6.1f}'.format(finv4a["MLTmin"][i]),
                                        '{:8.1f}'.format(finv4a["fbmaxflux"][i]),'{:8.1f}'.format(finv4a["rbmaxampE"][i]),
                                        '{:8.1f}'.format(finv4a["rbmaxampB"][i]),'{:8.1f}'.format(finv4a["bursttotalmin"][i]))




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


    if __name__ == "__main__": main()

