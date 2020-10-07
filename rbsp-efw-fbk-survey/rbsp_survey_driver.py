#! /usr/bin/env  python


#THINGS TO DO


#...run from "RBSP" folder. This causes IDL to load much faster

import sys
#sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/')
sys.path.append('/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/rbsp-efw-fbk-survey/')
from FBK_survey import FBK_survey
import datetime




# ;Data limits:
# 	;09-25 - first day with FBK data
# 	;03-15 - last day of FBK13 data



# r1 = {
#     'folder': 'runtest_fbk13a',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2012,9,25),
#     'd1t': datetime.date(2013,3,15),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }

#    'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',

r1 = {
    'folder': 'runtest_evan',
    'root': '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/rbsp-efw-fbk-survey/',
    'probe': 'a',
    'd0t': datetime.date(2012,11,1),
    'd1t': datetime.date(2012,11,2),
    'dt': 60.,
    'fbk_mode': '13',
    'fbk_type': 'Ew',
    'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
    'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
    'minamp_pk': 2.0,
    'maxamp_pk': 1e5,
    'minamp_av': .25,
    'maxamp_av': 1e5,
    'scale_fac_lim': 0.99
}


#r1 = {
#    'folder': 'runtest_fbk7b',
#    'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#    'probe': 'b',
#    'd0t': datetime.date(2013,4,11),
#    'd1t': datetime.date(2015,7,31),
#    'dt': 60.,
#    'fbk_mode': '7',
#    'fbk_type': 'Ew',
#    'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#    'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#    'minamp_pk': 2.0,
#    'maxamp_pk': 1e5,
#    'minamp_av': .25,
#    'maxamp_av': 1e5,
#    'scale_fac_lim': 0.99
#}


# r1 = {
#     'folder': 'runtest_fbk13a',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2012,11,11),
#     'd1t': datetime.date(2013,3,15),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }



# r1 = {
#     'folder': 'runtest_tmp3',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2012,10,1),
#     'd1t': datetime.date(2012,12,1),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }

# r1 = {
#     'folder': 'runtest_tmp1',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2012,10,13),
#     'd1t': datetime.date(2012,10,13),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }

# r1 = {
#     'folder': 'runtest_l=5.5_mlt=0..12',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2013,1,3),
#     'd1t': datetime.date(2013,1,3),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }


# r1 = {
#     'folder': 'runtest_l=2-5_mlt=5',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2013,1,3),
#     'd1t': datetime.date(2013,1,3),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }




# #Quiet day test
# r1 = {
#     'folder': 'runtest_tmp0',
#     'root': '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/',
#     'probe': 'a',
#     'd0t': datetime.date(2012,10,4),
#     'd1t': datetime.date(2012,10,4),
#     'dt': 60.,
#     'fbk_mode': '13',
#     'fbk_type': 'Ew',
#     'f_fceB': [0.0 ,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0],
#     'f_fceT': [10.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,10.0],
#     'minamp_pk': 2.0,
#     'maxamp_pk': 1e5,
#     'minamp_av': .25,
#     'maxamp_av': 1e5,
#     'scale_fac_lim': 0.99
# }


r1['path'] = r1['root'] + r1['folder'] + '/'
r1['fn_info'] = r1['path'] + 'info.idl'
r1['path_ephem'] = r1['root'] + 'ephem/'
r1['delta'] = r1['d1t'] - r1['d0t']
r1['ndays'] = r1['delta'].days + 1


run = FBK_survey(r1)
run.probe


#--------------------------------------------------
#Deselect to create info structure
#--------------------------------------------------
run.create_info_struct()   #DONE




#--------------------------------------------------
#Deselect to create ephemeris files from d0t to d1t
#--------------------------------------------------
currdate = run.d0t
for x in range(0,run.ndays):
    print currdate
    run.create_ephem_ascii(currdate)
    currdate = currdate + datetime.timedelta(days=1)




#--------------------------------------------------
#Combine all the ephem files for a particular FBK survey run into a single large ascii file.
#This will be read by the IDL program rbsp_survey_ephem_combine_tplot.pro to create long-duration
#tplot variables for each ephemeris quantity
#--------------------------------------------------

run.survey_combine_ascii('ephem','')




#--------------------------------------------------
#Combine all the appropriate ephem files into tplot variables
#--------------------------------------------------

run.ephem_combine_tplot()





#--------------------------------------------------
#Create individual FBK files for each day correctly timetagged
#--------------------------------------------------


currdate = run.d0t
for x in range(0,run.ndays):
    print currdate
    run.create_fbk_ascii(currdate)
    currdate = currdate + datetime.timedelta(days=1)


#at this point everything should be 1/min cadence

#--------------------------------------------------
#Combine all the FBK files for a particular survey run into single large ASCII file.
#--------------------------------------------------

run.survey_combine_ascii('fbk_ephem2','')
run.survey_combine_ascii('fbk','00100')
run.survey_combine_ascii('fbk','0001')
run.survey_combine_ascii('fbk','0102')
run.survey_combine_ascii('fbk','0203')
run.survey_combine_ascii('fbk','0304')
run.survey_combine_ascii('fbk','0405')
run.survey_combine_ascii('fbk','0506')
run.survey_combine_ascii('fbk','0607')
run.survey_combine_ascii('fbk','0708')
run.survey_combine_ascii('fbk','0809')
run.survey_combine_ascii('fbk','0910')
run.survey_combine_ascii('fbk','10100')


run.survey_combine_ascii('ampdist','pk00100')
run.survey_combine_ascii('ampdist','pk0001')
run.survey_combine_ascii('ampdist','pk0102')
run.survey_combine_ascii('ampdist','pk0203')
run.survey_combine_ascii('ampdist','pk0304')
run.survey_combine_ascii('ampdist','pk0405')
run.survey_combine_ascii('ampdist','pk0506')
run.survey_combine_ascii('ampdist','pk0607')
run.survey_combine_ascii('ampdist','pk0708')
run.survey_combine_ascii('ampdist','pk0809')
run.survey_combine_ascii('ampdist','pk0910')
run.survey_combine_ascii('ampdist','pk10100')


run.survey_combine_ascii('ampdist','avg00100')
run.survey_combine_ascii('ampdist','avg0001')
run.survey_combine_ascii('ampdist','avg0102')
run.survey_combine_ascii('ampdist','avg0203')
run.survey_combine_ascii('ampdist','avg0304')
run.survey_combine_ascii('ampdist','avg0405')
run.survey_combine_ascii('ampdist','avg0506')
run.survey_combine_ascii('ampdist','avg0607')
run.survey_combine_ascii('ampdist','avg0708')
run.survey_combine_ascii('ampdist','avg0809')
run.survey_combine_ascii('ampdist','avg0910')
run.survey_combine_ascii('ampdist','avg10100')

run.survey_combine_ascii('ampdist','avg4sec00100')
run.survey_combine_ascii('ampdist','avg4sec0001')
run.survey_combine_ascii('ampdist','avg4sec0102')
run.survey_combine_ascii('ampdist','avg4sec0203')
run.survey_combine_ascii('ampdist','avg4sec0304')
run.survey_combine_ascii('ampdist','avg4sec0405')
run.survey_combine_ascii('ampdist','avg4sec0506')
run.survey_combine_ascii('ampdist','avg4sec0607')
run.survey_combine_ascii('ampdist','avg4sec0708')
run.survey_combine_ascii('ampdist','avg4sec0809')
run.survey_combine_ascii('ampdist','avg4sec0910')
run.survey_combine_ascii('ampdist','avg4sec10100')

run.survey_combine_ascii('ampdist','ratio00100')
run.survey_combine_ascii('ampdist','ratio0001')
run.survey_combine_ascii('ampdist','ratio0102')
run.survey_combine_ascii('ampdist','ratio0203')
run.survey_combine_ascii('ampdist','ratio0304')
run.survey_combine_ascii('ampdist','ratio0405')
run.survey_combine_ascii('ampdist','ratio0506')
run.survey_combine_ascii('ampdist','ratio0607')
run.survey_combine_ascii('ampdist','ratio0708')
run.survey_combine_ascii('ampdist','ratio0809')
run.survey_combine_ascii('ampdist','ratio0910')
run.survey_combine_ascii('ampdist','ratio10100')

run.survey_combine_ascii('ampdist','ratio4sec00100')
run.survey_combine_ascii('ampdist','ratio4sec0001')
run.survey_combine_ascii('ampdist','ratio4sec0102')
run.survey_combine_ascii('ampdist','ratio4sec0203')
run.survey_combine_ascii('ampdist','ratio4sec0304')
run.survey_combine_ascii('ampdist','ratio4sec0405')
run.survey_combine_ascii('ampdist','ratio4sec0506')
run.survey_combine_ascii('ampdist','ratio4sec0607')
run.survey_combine_ascii('ampdist','ratio4sec0708')
run.survey_combine_ascii('ampdist','ratio4sec0809')
run.survey_combine_ascii('ampdist','ratio4sec0910')
run.survey_combine_ascii('ampdist','ratio4sec10100')

# run.survey_combine_ascii('freq','')
# run.survey_combine_ascii('ratio','')
# run.survey_combine_ascii('ratio','4sec')



#--------------------------------------------------
#Combine all the FBK files for a particular survey run into single large tplot file.
#--------------------------------------------------

run.fbk_combine_tplot('fbk_ephem2')
run.fbk_combine_tplot('fbk00100')
run.fbk_combine_tplot('fbk0001')
run.fbk_combine_tplot('fbk0102')
run.fbk_combine_tplot('fbk0203')
run.fbk_combine_tplot('fbk0304')
run.fbk_combine_tplot('fbk0405')
run.fbk_combine_tplot('fbk0506')
run.fbk_combine_tplot('fbk0607')
run.fbk_combine_tplot('fbk0708')
run.fbk_combine_tplot('fbk0809')
run.fbk_combine_tplot('fbk0910')
run.fbk_combine_tplot('fbk10100')


#--------------------------------------------------
#Call the program that creates the amplitude distributions for each
#data type
#--------------------------------------------------

run.fbk_combine_tplot_ampfreqdist('ampdist_pk00100')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0001')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0102')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0203')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0304')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0405')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0506')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0607')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0708')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0809')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk0910')
run.fbk_combine_tplot_ampfreqdist('ampdist_pk10100')

run.fbk_combine_tplot_ampfreqdist('ampdist_avg00100')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0001')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0102')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0203')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0304')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0405')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0506')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0607')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0708')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0809')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg0910')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg10100')

run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec00100')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0001')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0102')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0203')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0304')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0405')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0506')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0607')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0708')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0809')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec0910')
run.fbk_combine_tplot_ampfreqdist('ampdist_avg4sec10100')

run.fbk_combine_tplot_ampfreqdist('ampdist_ratio00100')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0001')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0102')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0203')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0304')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0405')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0506')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0607')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0708')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0809')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio0910')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio10100')

run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec00100')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0001')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0102')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0203')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0304')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0405')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0506')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0607')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0708')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0809')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec0910')
run.fbk_combine_tplot_ampfreqdist('ampdist_ratio4sec10100')
