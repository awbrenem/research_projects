__author__ = 'aaronbreneman'


class Coh_plot:


    def __init__(self, params):
        self.__dict__.update(params)



    def get_paths(self):
        root = '/Users/aaronbreneman/Desktop/'
        path = ['code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide/',
                'code/Aaron/RBSP/efw_barrel_coherence_analysis/Coherence_files/',
                'Research/RBSP_hiss_precip/OMNI/']
#        root = '/Users/sadietetrick/Desktop/'
#        path = ['New_Barrel/',
#                'OMNI/']
        paths = path
        for j in range(len(path)):
            paths[j] = root + path[j]
        return paths




# Get times, lshell and MLT values for a single payload
    def get_payload_vals(self, payload):
        import numpy as np

        # Get file that contains l, mlt, and time values for first payload
        f = open(self.get_paths()[0] + 'barrel_' + payload +
            '_fspc_fullmission.txt','r')

        l = []
        mlt = []
        time = []
        for line in f:
            l.append(line[37:40])
            mlt.append(line[43:47])
            time.append(line[1:15])

        ls = np.asarray(l[2:len(l) - 1])
        ls[ls == '***'] = 'NaN'
        mlts = np.asarray(mlt[2:len(mlt) - 1])
        times = np.asarray(time[2:len(time) - 1])

        m = []
        l = []
        t = []
        for x in range(0, len(mlts) - 1):
            m.append(float(mlts[x]))
        for x in range(0, len(times) - 1):
            t.append(float(times[x]))
        for x in range(0, len(ls) - 1):
            l.append(float(ls[x]))

        vals = {
            'lshell': l,
            'mlt': m,
            'time': t
        }

        f.close
        return vals



    def get_combo_vals(self, combo):
        import numpy as np

        # First get file with the coherence values, frequencies, 
        # and times for that combo
        f = open(self.get_paths()[0] + 'barrel_' + combo +
            '_coherence_fullmission.txt', 'r')


        new_times = []
        new_coh = []
        co = []

        for i in range(3): f.readline()

        # read in the frequencies
        goo = f.readline()
        new_freq = np.fromstring(goo, dtype=float, sep=' ')


        f.readline()

        # read in the coherence values. The first element represents the time
        for line in f:
            co.append(line)


        for a in range(len(co)):
            tmp = np.fromstring(co[a], dtype=float, sep=' ')
            new_times[a] = tmp[0]
            new_coh[a] = tmp[1:len(tmp)]

        f.close

        vals = {
            'freq': new_freq,
            'coh': new_coh,
            'times': new_times
        }

        return vals






# For a given payload filter times to those only inside or outside of plasmasphere
    def filter_plasmasphere(self, vals, times, payload, in_out):

        starttime = []
        endtime = []

        type(in_out)

        if in_out == 'in':
            f = open(self.get_paths()[1] + 'All_inside_ps/out' + payload + '.txt', 'r')
        if in_out == 'out':
            f = open(self.get_paths()[1] + 'All_outside_ps/in' + payload + '.txt', 'r')

        for line in f:
            starttime.append(line[0:10])
            endtime.append(line[13:23])
        f.close

        for y in range(0, len(vals)-1):
            for x in range(0, len(starttime) - 1):
                if starttime[x] < times[y] < endtime[x]:
                    vals[y] = 'NaN'

        return vals


    def filter_largeevents(self, vals, times, payload):

        # Now take out values that are not "large events"
        f = open(self.get_paths()[1] + 'big_events/' + payload + '.txt', 'r')
        start = []
        end = []
        for line in f:
            start.append(line[0:10])
            end.append(line[13:23])
        f.close
        for y in range(0, len(times)-1):
            for x in range(0, len(start)-1):
                if start[x] <= times[y] <= end[x]:
                    vals[y] = vals[y]
                else:
                    vals[y] = 'NaN'



        return vals


    def get_omni(self, times_interp):

        import numpy as np

        # for clock angle
        f = open(self.get_paths()[2] + 'omni_mission2.txt', 'r')
        clock = []
        time = []
        cone = []
        bz = []
        press = []

        for line in f:
            cone.append(line[40:49])
            clock.append(line[28:38])
            time.append(line[2:12])
            bz.append(line[90:96])
            press.append(line[53:61])

        clocks = clock[1:len(clock)]
        times = time[1:len(time)]
        cones = cone[1:len(cone)]
        bzs = bz[1:len(bz)]
        press = press[1:len(press)]


        bz_gsm = np.interp(times_interp, times, bzs)
        clock_angle = np.interp(times_interp, times, clocks)
        cone_angle = np.interp(times_interp, times, cones)
        flow_pressure = np.interp(times_interp, times, press)


        omni_data = {'times': times,
                     'clock_angle': clock_angle,
                     'cone_angle': cone_angle,
                     'flow_pressure': flow_pressure,
                     'bz_gsm': bz_gsm
                     }

        return omni_data



    def plot_histogram(self, vals, mlt, lshell, payload):

        import matplotlib.pyplot as plt
        mlt_val = {}
        lshell_val = {}

        for x in range(0, len(vals)):
            if vals[x] == 'NaN':
                mlt[x] = 'NaN'
            else:
                mlt[x] = mlt[x]
        
        mlt_val[payload] = [x for x in mlt if str(x) != 'NaN']

        for x in range(0, len(vals)):
            if vals[x] == 'NaN':
                lshell[x] = 'NaN'
            else:
                lshell[x] = lshell[x]

        lshell_val[payload] = [x for x in lshell if str(x) != 'NaN']
        # This will keep a count of each payload for the histogram

        plt.show()




    def plot_scatter(self, xvals, yvals, xt, yt, xlim, ylim):

        import matplotlib.pyplot as plt

        # plotting the scatter plots for BARREL data
#        split_coh = [i[0] if type(i) == list else i for i in split_coh]

#        plt.subplot(2, 1, 1)
        plt.xlim(xlim)
        plt.ylim(ylim)
        plt.scatter(xvals[0:len(yvals)], yvals[0:len(yvals)], color='blue' )
        plt.ylabel(yt)
        plt.xlabel(xt)
        plt.title(yt + ' vs ' + xt)

        plt.show()


# Extract the maximum coherence value per time chunk, so that it is the same length as the mlt and lshell values
    def get_max_coherence(self, vals):

        # Sadie question....are these numbers correct?????
        startt = 1   # should be 1, I think
        endd = 903   # should be 903, I think



        split_coh = []

        while endd < len(vals):
            split_coh.append(max(vals[startt:endd]))
            startt += 903
            endd += 903

        for x in range(0, len(split_coh) - 1):
            if split_coh[x] == 0:
                split_coh[x] = 'NaN'

        for x in range(0, len(split_coh) - 1):
            if split_coh[x] < 0.7:
                split_coh[x] = 'NaN'

        return split_coh



# Used to interpolate MLT or Lshell values for the two payloads, tagged with the times "times1" and "times2"
# to the common times of the payload combination "times_interp"
    def interpolate_vals(self, times_interp, coh_p1p2, times1, times2, vals1, vals2):

        import numpy as np

        times_interp = times_interp[0:len(times_interp)]
        vals1 = np.interp(times_interp, times1, vals1)

        vals2 = np.interp(times_interp, times2, vals2)


        avg_vals = []
        # Average the two payload mlt and lshell values
        for x in range(0, len(vals1)):
            avg_vals.append((vals1[x][0] + vals2[x][0])/2)
         #if the coherence is a NaN, then want to change the time for that to a NaN so it doesn't plot
       
        for x in range(0, len(coh_p1p2)):
            if coh_p1p2[x] == 'NaN':
                times_interp[x] = 'NaN'
        #tuple (times_interp)
        #tuple (vals1)
        #tuple (vals2)
        #tuple (avg_vals)
        valsr = {'times_interp': times_interp,
                 'vals1': vals1,
                 'vals2': vals2,
                 'avg_vals': avg_vals
                 }
                 
        target = {}
        for key in valsr:
            target[key] = []
            target[key].extend(valsr[key])

      
        return target

