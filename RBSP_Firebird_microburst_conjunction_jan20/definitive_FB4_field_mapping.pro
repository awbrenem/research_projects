

;Uncertainty in field values
;FB4:
;1) timing error (2-3 sec, maybe)
;2) difference b/t different models
;--> Turns out #2 is a larger error


rbsp_efw_init

;------
date = '2016-01-20'
timespan,date


t0 = time_double('2016-01-20/19:00:00')
t1 = time_double('2016-01-20/21:00:00')


;---------------------------------------------------------------

;path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
;cdf2tplot,path+'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'

;path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/datafiles/'
;tplot_restore,filenames=path+'rbspa_jan20_ts04_mag.tplot'


;------
;Restore Scott's TS04 mapping of FB4 and RBSPa
path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'


tplot_restore,filenames=path+'fb4_ts04_mapping_20160120_tshift=0s.tplot'
tplot_restore,filenames=path+'fb4_ts01_mapping_20160120_tshift=0s.tplot'
tplot_restore,filenames=path+'fb4_ts89_mapping_20160120_tshift=0s.tplot'
tplot_restore,filenames=path+'fb4_ts96_mapping_20160120_tshift=0s.tplot'
tplot_restore,filenames=path+'fb4_igrf_mapping_20160120_tshift=0s.tplot'


store_data,'fb4_Lcomb_0s',data=['FB4!CL-shell-igrf','FB4!CL-shell-t89',$
  'FB4!CL-shell-t96','FB4!CL-shell-t01','FB4!CL-shell-t04']
options,'fb4_Lcomb_0s','colors',[0,20,50,120,250]


store_data,'fb4_MLTcomb_0s',data=['FB4!Cequatorial-foot-MLT!Cigrf',$
  'FB4!Cequatorial-foot-MLT!Ct89',$
  'FB4!Cequatorial-foot-MLT!Ct96','FB4!Cequatorial-foot-MLT!Ct01',$
  'FB4!Cequatorial-foot-MLT!Ct04s']
options,'fb4_MLTcomb_0s','colors',[0,50,120,250]



store_data,'fb4_MLTcomb',$
  data=['FB4!Cequatorial-foot-MLT!Cigrf',$
  'FB4!Cequatorial-foot-MLT!Ct89',$
  'FB4!Cequatorial-foot-MLT!Ct96',$
  'FB4!Cequatorial-foot-MLT!Ct01',$
  'FB4!Cequatorial-foot-MLT!Ct04s']
options,'fb4_MLTcomb','colors',[0,0,50,50,200,200,254,254]
tplot,'fb4_MLTcomb'



tlimit,'2016-01-20/19:00','2016-01-20/20:10'


ylim,['fb4_Lcomb_0s'],4,7
ylim,['fb4_MLTcomb_0s'],8,12
tplot,['fb4_Lcomb_0s','fb4_MLTcomb_0s']

tplot,['fb4_Lcomb_0s']



;---------------------------------------------------------------
;Get accurate FB GSM coord for magnetic field values
;---------------------------------------------------------------

path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/FIREBIRD/'
tplot_restore,filenames=path+'fb4_coord_jan20_accurate.tplot'

pos_gsm = 'fb4_gsm'
get_data,pos_gsm,t,d,dlim=dlim,lim=lim
coord_sys = {coord_sys:'gsm'}
dlim = {data_att:coord_sys}
store_data,pos_gsm,t,6370.*d,dlim=dlim

ts = time_double(['2016-01-19/22:00','2016-01-20/23:59:59'])
timespan,ts[0],ts[1]-ts[0],/seconds


fn = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'

;get_field_model, pos_gsm, 't96', ts, source='omni'
;tplot_save,'B_t96_gse',filename=fn+'fb4_tsy96_omni_bfield'
;get_field_model, pos_gsm, 't01', ts, source='omni'
;tplot_save,'B_t01_gse',filename=fn+'fb4_tsy01_omni_bfield'
;get_field_model, pos_gsm, 't04s', ts, source='omni'
;tplot_save,'B_t04s_gse',filename=fn+'fb4_tsy04_omni_bfield'
;get_field_model, pos_gsm, 't89', ts
;tplot_save,'B_t89_gse',filename=fn+'fb4_tsy89_bfield'
;get_field_model, pos_gsm, 'igrf', ts
;tplot_save,'B_igrf_gse',filename=fn+'fb4_igrf_bfield'

path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_restore,filenames=path+'fb4_igrf_bfield.tplot'
tplot_restore,filenames=path+'fb4_tsy89_bfield.tplot'
tplot_restore,filenames=path+'fb4_tsy96_omni_bfield.tplot'
tplot_restore,filenames=path+'fb4_tsy01_omni_bfield.tplot'
tplot_restore,filenames=path+'fb4_tsy04_omni_bfield.tplot'

copy_data,'B_igrf_gse','FB4_B_igrf_gse'
copy_data,'B_t89_gse','FB4_B_t89_gse'
copy_data,'B_t96_gse','FB4_B_t96_gse'
copy_data,'B_t01_gse','FB4_B_t01_gse'
copy_data,'B_t04s_gse','FB4_B_t04_gse'

path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_save,'*',filename=path+'definitive_FB4_field_mapping'    ;don't add .tplot





stop


end
