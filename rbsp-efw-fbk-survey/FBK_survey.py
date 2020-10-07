class FBK_survey:


    def __init__(self,params):
        self.__dict__.update(params)

        #Variables are....
        # probe
        # d0t
        # d1t
        # dt
        # ndays
        # fbk_mode
        # fbk_type
        # minfreq
        # maxfreq
        # minamp_pk
        # maxamp_pk
        # minamp_av
        # maxamp_av
        # root
        # path
        # fn_info
        # path_ephem
        # delta

    def create_info_struct(self):
        import subprocess
        import os


        #Test for existence of "folder", create if not existing
        if not os.path.isdir(self.root+self.folder): os.mkdir(self.root+self.folder)

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                                     'rbsp_survey_create_info_struct','-args',
                                     '%s'%self.probe,'%s'%self.d0t,'%s'%self.d1t,
                                     '%f'%self.dt,'%s'%self.ndays,
                                     '%s'%self.fbk_mode,'%s'%self.fbk_type,
                                     '%s'%self.f_fceB,'%s'%self.f_fceT,
                                     '%f'%self.minamp_pk,'%f'%self.maxamp_pk,
                                     '%s'%self.minamp_av,'%s'%self.maxamp_av,
                                     '%s'%self.path,'%s'%self.fn_info,
                                     '%s'%self.path_ephem,'%s'%self.scale_fac_lim])


    def create_ephem_ascii(self,currdate):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                                     'rbsp_survey_create_ephem_ascii','-args',
                                     '%s'%self.fn_info,'%s'%currdate])


    def survey_combine_ascii(self,type,optstr):
        import os
        import glob

        #Options for type:
        #....'ephem'
        #....'ephem2'  (spin axis direction file)
        #....'fbk'
        #....'ampdist' (pk, avg, avg4sec)
        #....'freq'    (OBSOLETE)
        #....'ratio'   (ratio or 4sec ratio)

        #Options for optstr:
        #....'pk'  -> for 'ampdist'
        #....'pk0102' -> for file showing 0.1*fce to 0.2*fce only, etc...
        #....'avg' -> for 'ampdist'
        #....'avg0102' -> for file showing 0.1*fce to 0.2*fce only, etc...
        #....'avg4sec' -> for 'ampdist'
        #....'avg4sec0102' -> for file showing 0.1*fce to 0.2*fce only, etc...
        #....'4sec'-> for 'ratio'


        #if not optstr in locals():optstr = ''


        if type == 'ephem':
            path = self.path_ephem
            istr = 'ephem_RBSP'+self.probe
        elif type == 'fbk_ephem2':
            path = self.path
            # istr = 'ephem_RBSP'+self.probe
            istr = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_fbk_ephem2_'+self.fbk_type
        elif type == 'fbk':
            path = self.path
            istr = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_fbk'+optstr+'_'+self.fbk_type
        elif type == 'ampdist':
            path = self.path
            istr = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_ampdist_'+optstr+'_'+self.fbk_type
        elif type == 'freq':
            path = self.path
            istr = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_freq_'+self.fbk_type
        elif type == 'ratio':
            path = self.path
            if optstr == '':
                istr = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_ratio'+'_'+self.fbk_type
            else:
                istr = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_ratio'+optstr+'_'+self.fbk_type


        ostr = istr + '_combined.txt'


        print "istr = " + istr
        print "ostr = " + ostr


        #files = os.listdir(self.path_ephem)

        #find all files with correct sc
        goodfiles = []
        for x in glob.glob(path + istr + '*'):
            goodfiles.append(x)



        #Find files that fall within desired date range
        finalfiles = []
        for x in range(0,len(goodfiles)):
            goo = goodfiles[x]
            #extract date from filename
            dtmp =  goo[-12:-4]

            if dtmp >= self.d0t.strftime("%Y%m%d") and dtmp <= self.d1t.strftime("%Y%m%d"):
                finalfiles.append(goodfiles[x])

        print "finalfiles:"
        print finalfiles


        #Now combine the output from all "finalfiles"
        vals = []
        for x in range(0,len(finalfiles)):
            f = open(finalfiles[x], 'r')
            print f
            tmp = f.read()
            tmp = tmp.split("\n")
            tmp = tmp[0:len(tmp)-1]
            vals.extend(tmp)
            f.close()



        f = open(self.path+ostr,'w')
        for x in range(0,len(vals)):
            f.write(vals[x]+'\n')

        f.close()





    def ephem_combine_tplot(self):
        import subprocess

        #Combine all the appropriate ephem files into tplot variables
        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                                     'rbsp_survey_ephem_combine_tplot','-args',
                                     '%s'%self.path,'%s'%self.probe])




    def create_fbk_ascii(self,currdate):
        import subprocess

        #Extract mlats and spin axis data
        f = open(self.path_ephem+'ephem_RBSP'+self.probe+'_'+
                 currdate.strftime("%Y%m%d")+'.txt','r')
        vals = f.read()
        f.close()
        vals = vals.split("\n")
        mlats = []
        sax, say, saz = [], [], []
        for y in range(0,len(vals)-1):
            tmp = vals[y]
            st = 49
            mlats.append(tmp[st:5+st])
            stx = 165
            sty = 173
            stz = 181
            sax.append(tmp[stx:stx+5])
            say.append(tmp[sty:sty+5])
            saz.append(tmp[stz:stz+5])



        #Changing these to floats will get rid of the "'" separating each value.
        #I still have to pass these to IDL as strings, but this makes turning them into
        #floats within IDL easier.
        mlats = [float(x) for x in mlats]
        sax = [float(x) for x in sax]
        say = [float(x) for x in say]
        saz = [float(x) for x in saz]

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                                     'rbsp_survey_create_fbk_ascii','-args',
                                     '%s'%self.fn_info,'%s'%currdate,'%s'%mlats,'%s'%sax,'%s'%say,'%s'%saz])



    def fbk_combine_tplot(self,optstr):
        #Takes the "combined" FBK value files and produces tplot output

        import subprocess
        #fbk13_RBSPa_fbk0001_Ew_combined


#        filename = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_fbk_'+self.fbk_type+'_combined.txt'
        filename = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_'+optstr+'_'+self.fbk_type+'_combined.txt'

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                                     'rbsp_survey_fbk_combine_tplot','-args',
                                     '%s'%self.probe,'%s'%self.path,'%s'%filename,'%s'%self.dt,'%s'%optstr])



    def get_bins(self,type):

        #Options for type
        #....'pk'
        #....'avg'
        #....'ratio'
        #....'freq'

        f = open(self.path + type+'_bins.txt','r')
        vals = f.read()
        f.close
        vals = vals.split("\n")
        vals = vals[1:len(vals)-1]
        vals2 = [float(x) for x in vals]
        return vals2




    def fbk_combine_tplot_ampfreqdist(self,optstr):

        #Takes the "combined" ampdist files and produces tplot output

        #Options for optstr are
        #....'ampdist_pk'
        #....'ampdist_avg'
        #....'ampdist_avg4sec'
        #....'freq'
        #....'ratio'
        #....'ratio4sec'

        import subprocess

        optstr2 = ''

        if optstr[0:10] == 'ampdist_pk': optstr2 = 'pk'
        if optstr[0:11] == 'ampdist_avg': optstr2 = 'avg'
        if optstr[0:15] == 'ampdist_avg4sec': optstr2 = 'avg4sec'
        if optstr[0:13] == 'ampdist_ratio': optstr2 = 'ratio'
        if optstr[0:17] == 'ampdist_ratio4sec': optstr2 = 'ratio4sec'
        # if optstr[0:4] == 'freq': optstr2 = 'freq'
        # if optstr[0:5] == 'ratio': optstr2 = 'ratio'


        print optstr2

        if optstr2 == 'avg' or optstr2 == 'avg4sec': bins = self.get_bins('avg')
        if optstr2 == 'pk': bins = self.get_bins('pk')
        if optstr2 == 'ratio' or optstr2 == 'ratio4sec': bins = self.get_bins('ratio')

        #bins = self.get_bins(optstr2)
        print bins


        filename = 'fbk'+self.fbk_mode+'_RBSP'+self.probe+'_'+optstr+'_'+self.fbk_type + '_combined.txt'

        print filename



        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl','-e',
                                     'rbsp_survey_fbk_combine_tplot_ampfreqdist','-args',
                                     '%s'%self.fn_info,'%s'%self.probe,'%s'%self.path,'%s'%filename,'%s'%self.dt,
                                     '%s'%bins,'%s'%optstr,'%s'%self.fbk_type])
