"""
Downloads FIREBIRD data from http://solar.physics.montana.edu/FIREBIRD_II/Data/
for specified date. Extracts all data fields into a dictionary
"""

class Load_firebird_data:

    def __init__(self, params):
        self.__dict__.update(params)



    def download_file(self):
        import requests
        from os import path
        from bs4 import BeautifulSoup
        import urllib.request
        import re
        import datetime

        #extract date string
        datestr = self.date.strftime("%Y-%m-%d")

        #construct filename
        cs2 = self.cubesat[0:2] + '_' + self.cubesat[2:3]
        url = 'http://solar.physics.montana.edu/FIREBIRD_II/Data/' + cs2 + '/' + self.type + '/'
        type2 = self.type[0].upper() + self.type[1:]
        fn = self.cubesat + '_' + type2 + '_' + datestr + '_L2.txt'
        savepath = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/firebird/'+fn




        #Check for file existence
        content = urllib.request.urlopen(url).read()
        soup = BeautifulSoup(content, features="html.parser")
        files = soup.get_text()
        f2 = files.split('\n')



        #Grab names of all the files online and extract useful info from them
        for f in f2:
            # Check to see if current line contains a filename.
            m = re.search(fn, f)
            if m:
                break


        if not m:
            return "No FIREBIRD file online or local for this date"





        #If the local file doesn't exist, then download it
        if not path.exists(savepath):
            myfile = requests.get(url+fn)
            open(savepath, 'wb').write(myfile.content)



        #Read in file now that it exists locally
        import numpy as np
        f = open(savepath,'r')

        vals = f.read()
        vals = vals.split("\n")
        vals = vals[1:len(vals)]
        f.close()

        #Start of data
        vals = vals[123:]
        data = []   #array of values for each conjunction time
        times = []  #String times for each conjunction
        for i in range(len(vals[1:])):
            tmpp = vals[i].split()
            timetmp = tmpp[0]

            try:
                tdt = datetime.datetime.strptime(timetmp,'%Y-%m-%dT%H:%M:%S.%f')
            except ValueError as ve:
                print('ValueError Raised:', ve)
                tdt = datetime.datetime.strptime(timetmp,'%Y-%m-%dT%H:%M:%S')

            """
            Note: in an email from Mykhaylo on May 26, 2020 he mentions this method which
            doesn't throw an error when the time format changes'
            import dateutil.parser
            import numpy as np
            
            # Convert a single time stamp
            tdt = dateutil.parser.parse(timetmp)
            
            # Parse the entire FIREBIRD time array at once. FIREBIRD data is loaded into the hr object
            hr['Time'] = np.array([ dateutil.parser.parse(t_i) for t_i in hr['Time'] ])
            """


            times.append(tdt)
            tmpp2 = [float(j) for j in tmpp[1:]]
            data.append(tmpp2)


        data2 = np.array(data)



        finaldat = {'time':times,
                    'col_flux1':data2[:,0],'col_flux2':data2[:,1],'col_flux3':data2[:,2],
                    'col_flux4':data2[:,3],'col_flux5':data2[:,4],'col_flux6':data2[:,5],
                    'sur_flux1':data2[:,6],'sur_flux2':data2[:,7],'sur_flux3':data2[:,8],
                    'sur_flux4':data2[:,9],'sur_flux5':data2[:,10],'sur_flux6':data2[:,11],
                    'col_counts1':data2[:,12],'col_counts2':data2[:,13],'col_counts3':data2[:,14],
                    'col_counts4':data2[:,15],'col_counts5':data2[:,16],'col_counts6':data2[:,17],
                    'sur_counts1':data2[:,18],'sur_counts2':data2[:,19],'sur_counts3':data2[:,20],
                    'sur_counts4':data2[:,21],'sur_counts5':data2[:,22],'sur_counts6':data2[:,23],
                    'count_time_correction':data2[:,24],'mcilwainl':data2[:,25],
                    'lat':data2[:,26],'lon':data2[:,27],'alt':data2[:,28],'mlt':data2[:,29],
                    'kp':data2[:,30],'flag':data2[:,31],'loss_cone_type':data2[:,32]}


        return finaldat



    def main():
        import sys
        sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/')
        from Load_firebird_data import Load_firebird_data
        import datetime

        date = datetime.datetime(2015,6,11)

        params = {'type':'hires','cubesat':'FU3','date':date}
        fb = Load_firebird_data(params)
        result = fb.download_file()

        print(result)




    if __name__ == "__main__": main()
