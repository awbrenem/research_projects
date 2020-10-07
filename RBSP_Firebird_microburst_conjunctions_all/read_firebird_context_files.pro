;Read FIREBIRD CubeSat context data from http://solar.physics.montana.edu/FIREBIRD_II/Data/FU_4/context/
;and store as tplot variables


pro read_firebird_context_files

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/data/'
file = 'FU4_Context_camp23_2019-07-03_2019-07-30_L2.txt'

;---------------------------------------------------------
;Relevant values from FIREBIRD context files
;---------------------------------------------------------

;#    "Time": {
;#        "DESCRIPTION": "ISO formatted time in UTC",
;#    "D0": {
;#        "DESCRIPTION": "Counts from the highenergy collimated channel in 6 second bins",
;#        "ELEMENT_LABELS": "Collimated >985 keV",
;#        "UNITS": "Electron counts per 6 seconds"
;#    "D1": {
;#        "DESCRIPTION": "Counts from a low energy collimated channelin 6 second bins",
;#        "ELEMENT_LABELS": "Collimated 283.4 keV - 383.6 keV",
;#        "ELEMENT_NAMES": "Low Energy Collimated",
;#        "UNITS": "Electron counts per 6 seconds"
;#    "Count_Time_Correction": {
;#        "DESCRIPTION": "Time correction for count data expressed as (Ground Time - Spacecraft Time). Should be added to reported time stamp. Applies only to count and flux data, ephemeris does not need to be corrected.",
;#        "ELEMENT_LABELS": "Time_Correction",
;#        "ELEMENT_NAMES": "Count_Time_Correction",
;#        "UNITS": "seconds"
;#    "McIlwainL": {
;#        "DESCRIPTION": "Mcllwain L shell parameter for particles mirroring at the spacecraft using the T89 external model and IGRF inernal model",
;#        "ERROR_VALUE": 1e+31,
;#        "Min Valid Value": 0,
;#    "Lat": {
;#        "DESCRIPTION": "Latitude of spacecraft as calculated by STK",
;#        "ELEMENT_LABELS": "Lat",
;#    "Lon": {
;#        "DESCRIPTION": "Longitude of spacecraft as calculated by STK",
;#        "ELEMENT_LABELS": "Lon",
;#    "Alt": {
;#        "DESCRIPTION": "Altitude of spacecraft as calculated by STK",
;#        "ELEMENT_LABELS": "Alt",
;#        "UNITS": "km"
;#    "MLT": {
;#        "DESCRIPTION": "Magnetic Local Time of S/C.",
;#        "UNITS": "hours (decimal)"
;#    "kp": {
;#        "DESCRIPTION": "Planetary k index.",
;#        "Min Valid Value": 0,
;#        "TITLE": "kp",
;#        "UNITS": "10*kp"
;#    "Flag": {
;#        "DESCRIPTION": "Data flags from the CRC;1 is good data, 0 is potentially bad data.False negatives (0's) are possible,false positives (1's) are not.",
;#        "ELEMENT_LABELS": "CRC flag",
;#    "Loss_cone_type": {
;#        "DESCRIPTION": "Loss cone type: 0 = open field lines, 1 = trapped or quazi-trapped, 2 = bounce loss cone",
;#        "TITLE": "Loss Cone Type"



;-----------------------
;Read in file


fn = ['Time','D0','D1','Count_Time_Correction','McIlwainL','Lat','Lon','Alt','MLT','kp','Flag','Loss_cone_type']
ft = [7,4,4,4,4,4,4,4,4,4,4,3]
fl = [0,27,33,37,41,60,78,98,117,134,139,143]
fg = indgen(12)
str = {version:1.,datastart:99L,delimiter:32B,missingvalue:!values.f_nan,commentsymbol:'',fieldcount:12,$
  fieldtypes:ft,fieldnames:fn,FIELDLOCATIONS:fl,FIELDGROUPS:fg}
vals = read_ascii(path+file,template=str)

;FU3 or FU4?
fb = strmid(file,0,3)


;------------------------
;Save values as tplot variables (with time correction applied to count and flux data)

tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1

times = time_double(vals.time)
store_data,fb+'_flux_context_collimated_>985keV',times+vals.Count_Time_Correction,vals.D0
store_data,fb+'_flux_context_collimated_283.4-383.6keV',times+vals.Count_Time_Correction,vals.D1
store_data,fb+'_time_correction_for',times,vals.Count_Time_Correction
store_data,fb+'_McIlwainL',times,vals.McIlwainL & ylim,fb+'_McIlwainL',0,20
store_data,fb+'_lat',times,vals.Lat
store_data,fb+'_lon',times,vals.Lon
store_data,fb+'_alt',times,vals.alt
store_data,fb+'_MLT',times,vals.MLT
store_data,fb+'_kp',times,vals.kp
store_data,fb+'_flags',times,vals.Flag & ylim,fb+'_flags',0,1.5
store_data,fb+'_loss_cone_type',times,vals.Loss_cone_type & ylim,fb+'_loss_cone_type',-0.2,2.1
options,fb+'_loss_cone_type','ytitle','Loss cone type: 0=openFL!C1=trapped/quasi-trapped!C2=BLC'




end
