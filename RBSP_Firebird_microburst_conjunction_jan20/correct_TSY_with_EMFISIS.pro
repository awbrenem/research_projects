;Use the TS04 model to find out the most accurate conjunction b/t RBSPA and FB4
;for the Jan20th chorus/microburst correlations at 19:44 UT
;Once this is done, adjust the TSY L value by comparing its field magnitude
;with EMFISIS values.





rbsp_efw_init

;------
  sc = 'a'
  fb = '4'
  date = '2016-01-20'
  timespan,date


  t0 = time_double('2016-01-20/19:00:00')
  t1 = time_double('2016-01-20/21:00:00')

;---------------------------------------------------------------
  rbsp_efw_position_velocity_crib

  path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
  cdf2tplot,path+'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'

  path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/datafiles/'
  tplot_restore,filenames=path+'rbspa_jan20_ts04_mag.tplot'


;------
;Restore Scott's TS04 mapping of FB4 and RBSPa
path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_restore,filenames=path+'FB4_T04s_L_and_MLTs_20160120.tplot'
; 1 fb4!CL-shell-t04s
; 2 fb4!Cequatorial-foot-MLT!Ct04s
; 3 fb4!Cnorth-foot-MLT!Ct04
; 4 fb4!Csouth-foot-MLT!Ct04

tplot_restore,filenames=path+'RBSPa_T04s_L_and_MLTs_20160120.tplot'
; 5 RBSPa!CL-shell-t04s
; 6 RBSPa!Cequatorial-foot-MLT!Ct04s
; 7 RBSPa!Cnorth-foot-MLT!Ct04
; 8 RBSPa!Csouth-foot-MLT!Ct04


;tplot_restore,filenames=path+'RBSPb_T04s_L_and_MLTs_20160120.tplot'


;Interpolate these to a much higher cadence than once/min
times = dindgen(86400) + time_double('2016-01-20')

tinterpol_mxn,'fb4!CL-shell-t04s',times,newname='fb4!CL-shell-t04s'
tinterpol_mxn,'fb4!Cequatorial-foot-MLT!Ct04s',times,newname='fb4!Cequatorial-foot-MLT!Ct04s'
tinterpol_mxn,'RBSPa!CL-shell-t04s',times,newname='RBSPa!CL-shell-t04s'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct04s',times,newname='RBSPa!Cequatorial-foot-MLT!Ct04s'


;;get_data,'rbspa_state_lshell',fb_times,dtmp
;zerolinefb = replicate(0.,n_elements(times))
;store_data,'zerolinefb',fb_times,zerolinefb



tplot,['fb4!Cequatorial-foot-MLT!Ct04s','RBSPa!Cequatorial-foot-MLT!Ct04s']
tplot,['fb4!CL-shell-t04s','RBSPa!CL-shell-t04s']



;"Fix" the TSY values to match the EMFISIS values
tinterpol_mxn,'B_t04s_gse','RBSPa!CL-shell-t04s',newname='B_t04s_gse'
tinterpol_mxn,'Magnitude','RBSPa!CL-shell-t04s',newname='Magnitude'


get_data,'B_t04s_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'bmag_mod',t,bmag_mod
dif_data,'Magnitude','bmag_mod',newname='bdiff'

;smooth bdiff
rbsp_detrend,'bdiff',60.*20.



;Compare magnetic field vectors (model and data)
tplot,['Mag','B_t04s_gse']
tinterpol_mxn,'Mag','B_t04s_gse',newname='Mag'
tinterpol_mxn,'Magnitude','B_t04s_gse',newname='Magnitude'
get_data,'Mag',te,be
get_data,'B_t04s_gse',tm,bm
get_data,'Magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)

dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]

ang = acos(dotp/bmage/bmagm)/!dtor

store_data,'angle',tm,ang
options,'angle','ytitle','Angle b/t Bw model!Cand Bw EMFISIS'

tplot,['Mag','B_t04s_gse','angle']






;-----------------------------------------------------
;Assume that B varies as R^-3
;B1/B2 = (R2/R1)^3
;R2 = R1*(B1/B2)^0.33
;define:  dR = R2 - R1
;dR = R1*(B1/B2)^0.33 - R1
;dR = R1*((B1/B2)^0.33 - 1)

get_data,'RBSPa!CL-shell-t04s',t,L1
get_data,'bdiff',t,db
get_data,'bmag_mod',t,B1


;L1 = 5.77
;B1 = 146.
;dB = 10.
B2 = B1 + dB

dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL

store_data,'RBSPa!CL-shell-t04s_adj',t,L2

store_data,'Bcomb',data=['bdiff','bdiff_smoothed']
store_data,'Lcomb',data=['RBSPa!CL-shell-t04s','RBSPa!CL-shell-t04s_adj']
store_data,'Bdata_comb',data=['Magnitude','bmag_mod']
options,['Bdata_comb','Bcomb','Lcomb'],'colors',[0,250]
ylim,'Lcomb',5,6

ylim,['RBSPa!CL-shell-t04s','RBSPa!CL-shell-t04s_adj'],4,7
tplot,['Lcomb','Bdata_comb','Bcomb']

tlimit,'2016-01-20/19:00','2016-01-20/20:10'


;------
;Find conjunctions with dipole and TS04
;compare FB4 with RBSPa location
dif_data,'fb4!Cequatorial-foot-MLT!Ct04s','RBSPa!Cequatorial-foot-MLT!Ct04s',newname='mltdiff_tsy04'
dif_data,'fb4!CL-shell-t04s','RBSPa!CL-shell-t04s',newname='ldiff_tsy04'


options,['mltdiff_tsy04','ldiff_tsy04',$
'mltdiff_dipole','ldiff_dipole'],constant=0

options,'ldiff_tsy04','ytitle','delta-lshell!CFB4-RBSPa!CTSY04'
options,'mltdiff_tsy04','ytitle','delta-MLT!CFB4-RBSPa!CTSY04'


;Final plot showing Lshell and MLT separation
options,['mltdiff_tsy04','ldiff_tsy04'],'psym',-4
tplot,['mltdiff_tsy04','ldiff_tsy04']


path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EFW/'
fn = 'rbspa_efw-l2_spec_20160120_v01.cdf'
cdf2tplot,path+fn

options,'spec64_e12ac','spec',1
options,'spec64_scmw','spec',1
zlim,'spec64_e12ac',0.01,100,1
ylim,'spec64_e12ac',10,5000,1
ylim,'spec64_scmw',10,5000,1
zlim,'spec64_scmw',1d-6,1d-4,1

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
;fn = 'rbsp-a_wna-survey_emfisis-L4_20140120_v1.5.1.cdf'
fn = 'rbsp-a_wna-survey_emfisis-L4_20160120_v1.5.1.cdf'
cdf2tplot,path+fn

get_data,'bsum',t,d,v
store_data,'bsum',t,d,reform(v)
ylim,'bsum',10,10000,1
options,'bsum','spec',1
zlim,'bsum',1d-10,1d-5,1

get_data,'esum',t,d,v
store_data,'esum',t,d,reform(v)
ylim,'esum',10,10000,1
options,'esum','spec',1
zlim,'esum',1d-8,1d4,1

get_data,'thsvd',t,d,v
store_data,'thsvd',t,d,reform(v)
ylim,'thsvd',10,10000,1
options,'thsvd','spec',1
zlim,'thsvd',0,90,0


;----------------------------
get_data,'bsum',tt,dd,vv
tinterpol_mxn,'Magnitude',tt,newname='Magnitude'
get_data,'Magnitude',t,b
store_data,'fce',t,28.*b
store_data,'fce_2',t,28.*b/2.
store_data,'fce_01',t,28.*b*0.1

options,['fce','fce_2','fce_01'],'spec',0
options,['fce','fce_2','fce_01'],'thick',3

yspec = [200,3000]
ylim,['fce','fce_2','fce_01'],200,3000,1
ylim,'bsum',yspec,1
ylim,'esum',yspec,1
ylim,'thsvd2',yspec,1
ylim,'phsvd2',yspec,1
ylim,'mltdiff_tsy04',-5,5
ylim,'ldiff_tsy04',-2,2

store_data,'bcomb',data=['bsum','fce'];,'fce_2','fce_01','bsum']
ylim,'bcomb',yspec,1


ylim,'mltdiff_tsy04',-5,5
ylim,'ldiff_tsy04',-2,2

tplot,['RBSPa!CL-shell-t04s','RBSPa!Cequatorial-foot-MLT!Ct04s','bsum','esum','thsvd','angle','bcomb']

stop


;Compare model magnetic field to actual magnetic field to see how accurate it is
cdf2tplot,'~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'



sc = 'a'
ts = time_double(['2016-01-19/22:00','2016-01-20/23:59:59'])
timespan,ts[0],ts[1]-ts[0],/seconds
;model = 't04s'
model = 't04s'
;model = 't96'


;load RBSP gse positions
rbsp_load_spice_state,probe=sc,coord='gse';,/no_spice_load
cotrans,'rbsp'+sc+'_state_pos_gse','rbsp'+sc+'_state_pos_gsm',/GSE2GSM
pos_gsm = 'rbsp'+sc+'_state_pos_gsm'


get_field_model, pos_gsm, model, ts, source='wind'








;Compare the vector Bo
tplot,['B_t04s_gse','Mag']
;Compare the magnitude_minus_modelmagnitude
get_data,'B_t04s_gse',data=bo
bmag = sqrt(bo.y[*,0]^2 + bo.y[*,1]^2 + bo.y[*,2]^2)
store_data,'B_t04s_mag',bo.x,bmag

store_data,'Bmag_comb',data=['B_t04s_mag','Magnitude']
options,'Bmag_comb','colors',[0,250]
tplot,'Bmag_comb'




end
