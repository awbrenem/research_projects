class Coh_analysis:

    def __init__(self, params):
        self.__dict__.update(params)
    #----------------------------------------

    def print_test(self):
        print self.payloads

    #----------------------------------------
    # return string of all the payload combinations (e.g. AB, KW, etc...)
    def get_combos(self):

        n = len(self.payloads)
        combos = []

        for x in range(n):
            for y in range(x + 1, n):
                if x != y: combos.append(self.payloads[x] + self.payloads[y])

        for x in range(0, len(combos)): combos[x] = combos[x].upper()
        return combos

    #----------------------------------------
    # return list of dates corresponding from start to end of mission
    def get_dates(self):
        import datetime

        x = self.date1 - self.date0
        ndays = x.days
        dates = []
        for x in range(0, ndays): dates.append(self.date0 + datetime.timedelta(days=x))

        return dates

    #----------------------------------------
    # create tplot files containing FSPC data, L, MLT (Kp=2) for each payload
    def create_barrel_singlepayload_tplot(self, payload, dates):
        import subprocess

        dtmp = []
        for i in range(len(dates)): dtmp.append(dates[i].isoformat())

        dateS = dtmp[0]
        dateE = dtmp[len(dtmp) - 1]

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_create_barrel_singlepayload_tplot', '-args',
                                     '%s' % payload, '%s' % dateS, '%s' % dateE, '%s' % self.pre,
                                     '%s' % self.fspc, '%s' % self.datapath, '%s' % self.folder_singlepayload,
                                     '%s' % self.tsmooth])


    #----------------------------------------
    # create tplot variables of coherence/phase for payload combinations
    def create_coh_tplot(self, combo):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_create_coh_tplot', '-args',
                                     '%s' % combo, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_singlepayload, '%s' % self.folder_coh, '%s' % self.window_minutes, '%s' % self.lag_factor,
                                     '%s' % self.coherence_multiplier])


    #----------------------------------------
    # create tplot variables of coherence/phase for a single BARREL payload plus another
    # mission variable (like OMNI_pressure_dyn)
    def create_coh_tplot_general(self, payload, folder2, file2, tplotvar):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_create_coh_tplot_general', '-args',
                                     '%s' % payload, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_singlepayload, '%s' % folder2, '%s' % self.folder_coh,
                                     '%s' % file2, '%s' % tplotvar,
                                     '%s' % self.window_minutes, '%s' % self.lag_factor,
                                     '%s' % self.coherence_multiplier])



    #----------------------------------------
    # create tplot variables of the coherence spectra filtered to remove salt/pepper noise
    def filter_coh_tplot(self, combo):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_filter_coh_tplot', '-args',
                                     '%s' % combo, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_coh, '%s' % self.meanfilterwidth, '%s' % self.meanfilterheight])


    #----------------------------------------
    # create tplot variables of the coherence spectra filtered to remove salt/pepper noise
    def filter_coh_tplot_general(self, combo):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_filter_coh_tplot_general', '-args',
                                     '%s' % combo, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_coh, '%s' % self.meanfilterwidth, '%s' % self.meanfilterheight])


    #----------------------------------------

    def filter_barrel_by_ulf_period(self, payload, pmin, pmax):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_filter_barrel_by_ulf_period', '-args',
                                     '%s' % payload, '%s' % self.pre, '%s' % self.fspc, '%s' % pmin, '%s' % pmax,
                                     '%s' % self.folder_singlepayload, '%s' % self.datapath])


    #----------------------------------------
    # create tplot files containing distance of BARREL balloon from plasmapause (Goldstein model)
    def create_barrel_plasmapause_distance(self, payload):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_create_barrel_plasmapause_distance', '-args',
                                     '%s' % payload, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_ephem, '%s' % self.folder_singlepayload])

    #----------------------------------------
    # create tplot files containing distance of BARREL balloon from plasmapause (Goldstein model)
    def plot_coh_tplot(self, combo, pmin, pmax):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_plot_coh_tplot', '-args',
                                     '%s' % combo, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_plots, '%s' % self.folder_coh,
                                     '%s' % self.folder_singlepayload,
                                     '%s' % pmin, '%s' % pmax])


    #----------------------------------------
    # create tplot files containing distance of BARREL balloon from plasmapause (Goldstein model)
    def plot_coh_tplot_general(self, combo, pmin, pmax):
        import subprocess

        exit_code = subprocess.call(['/Applications/exelis/idl84/bin/idl', '-e',
                                     'py_plot_coh_tplot_general', '-args',
                                     '%s' % combo, '%s' % self.pre, '%s' % self.fspc, '%s' % self.datapath,
                                     '%s' % self.folder_plots, '%s' % self.folder_coh,
                                     '%s' % self.folder_singlepayload,
                                     '%s' % pmin, '%s' % pmax])
