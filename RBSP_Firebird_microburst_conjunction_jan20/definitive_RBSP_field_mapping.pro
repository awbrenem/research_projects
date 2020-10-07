

;Uncertainty in field values RBSPa:
;
;1) correct values with EMFISIS data
;2) difference b/t different models
;3) Extended chorus region caused by similar chorus
  ;Chorus observed and has similar properties from
  ;RBSPa -> 19:00 - 20:10 UT
  ;RBSPb -> 19:10 - 19:50 UT

;4) The MLT values can't be corrected w/ EMFISIS b/c
;   of azimuthal (mostly) symmetry. But, I'll find an
;   acceptable range by comparing all the models


rbsp_efw_init

;------
;sc = 'a'
date = '2016-01-20'
timespan,date


t0 = time_double('2016-01-20/19:00:00')
t1 = time_double('2016-01-20/21:00:00')

;get dipole Lshell
rbsp_efw_position_velocity_crib




;---------------------------------------------------------------

path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
cdf2tplot,path+'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
copy_data,'Mag','rbspa_mag'
copy_data,'Magnitude','rbspa_magnitude'
cdf2tplot,path+'rbsp-b_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
copy_data,'Mag','rbspb_mag'
copy_data,'Magnitude','rbspb_magnitude'


;------
;Restore Aaron's TS04 mapping of FB4 and RBSPa
path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_restore,filenames=path+'rbspa_igrf_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspa_tsy04_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspa_tsy89_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspa_tsy96_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspa_tsy01_mapping_20160120.tplot'

tplot_restore,filenames=path+'rbspb_igrf_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspb_tsy04_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspb_tsy89_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspb_tsy96_mapping_20160120.tplot'
tplot_restore,filenames=path+'rbspb_tsy01_mapping_20160120.tplot'


store_data,'rbspa_Lcomb',data=['rbspa_state_lshell','RBSPa!CL-shell-t89','RBSPa!CL-shell-t96','RBSPa!CL-shell-t01','RBSPa!CL-shell-t04s']
store_data,'rbspb_Lcomb',data=['rbspb_state_lshell','RBSPb!CL-shell-t89','RBSPb!CL-shell-t96','RBSPb!CL-shell-t01','RBSPb!CL-shell-t04s']
options,'rbsp?_Lcomb','colors',[0,50,100,120,250]
;options,'rbspa_Lcomb','colors',[0,0,100,0,0]
ylim,'rbsp?_Lcomb',4,8
tplot,['rbspa_Lcomb','rbspb_Lcomb']


;---------------------------------------------------
;Now get the magnetic field values from the models
;---------------------------------------------------

ts = time_double(['2016-01-19/22:00','2016-01-20/23:59:59'])
timespan,ts[0],ts[1]-ts[0],/seconds

;load RBSP gse positions
rbsp_load_spice_state,probe='a',coord='gse';,/no_spice_load
cotrans,'rbspa_state_pos_gse','rbspa_state_pos_gsm',/GSE2GSM
pos_gsm = 'rbspa_state_pos_gsm'
;Interpolate to 4 sec to match EMFISIS data
tinterpol_mxn,'rbspa_state_pos_gsm','rbspa_magnitude',newname='rbspa_state_pos_gsm'

;load RBSP gse positions
rbsp_load_spice_state,probe='b',coord='gse';,/no_spice_load
cotrans,'rbspb_state_pos_gse','rbspb_state_pos_gsm',/GSE2GSM
pos_gsm = 'rbspb_state_pos_gsm'
;Interpolate to 4 sec to match EMFISIS data
tinterpol_mxn,'rbspb_state_pos_gsm','rbspb_magnitude',newname='rbspb_state_pos_gsm'


;-------------------------------------------------------------------
;Get the Tsyganenko magnetic field values for RBSPa
;These take a while to run at 4sec cadence, so I'll save them as
;tplot save files
;-------------------------------------------------------------------

fn = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'

;get_field_model, pos_gsm, 't96', ts, source='omni'
;tplot_save,'B_t96_gse',filename=fn+'rbspb_tsy96_omni_bfield'
;get_field_model, pos_gsm, 't01', ts, source='omni'
;tplot_save,'B_t01_gse',filename=fn+'rbspb_tsy01_omni_bfield'
;get_field_model, pos_gsm, 't04s', ts, source='omni'
;tplot_save,'B_t04s_gse',filename=fn+'rbspb_tsy04_omni_bfield'
;get_field_model, pos_gsm, 't89', ts
;tplot_save,'B_t89_gse',filename=fn+'rbspb_tsy89_bfield'
;get_field_model, pos_gsm, 'igrf', ts
;tplot_save,'B_igrf_gse',filename=fn+'rbspb_igrf_bfield'


tplot_restore,filenames=fn+'rbspa_igrf_bfield.tplot'
tplot_restore,filenames=fn+'rbspa_tsy89_bfield.tplot'
tplot_restore,filenames=fn+'rbspa_tsy96_omni_bfield.tplot'
tplot_restore,filenames=fn+'rbspa_tsy01_omni_bfield.tplot'
tplot_restore,filenames=fn+'rbspa_tsy04_omni_bfield.tplot'

copy_data,'B_igrf_gse','rbspa_B_igrf_gse'
copy_data,'B_t89_gse','rbspa_B_t89_gse'
copy_data,'B_t96_gse','rbspa_B_t96_gse'
copy_data,'B_t01_gse','rbspa_B_t01_gse'
copy_data,'B_t04s_gse','rbspa_B_t04_gse'

tplot_restore,filenames=fn+'rbspb_igrf_bfield.tplot'
tplot_restore,filenames=fn+'rbspb_tsy89_bfield.tplot'
tplot_restore,filenames=fn+'rbspb_tsy96_omni_bfield.tplot'
tplot_restore,filenames=fn+'rbspb_tsy01_omni_bfield.tplot'
tplot_restore,filenames=fn+'rbspb_tsy04_omni_bfield.tplot'

copy_data,'B_igrf_gse','rbspb_B_igrf_gse'
copy_data,'B_t89_gse','rbspb_B_t89_gse'
copy_data,'B_t96_gse','rbspb_B_t96_gse'
copy_data,'B_t01_gse','rbspb_B_t01_gse'
copy_data,'B_t04s_gse','rbspb_B_t04_gse'

ylim,['rbspa_mag','rbspa_B_igrf_gse','rbspa_B_t89_gse','rbspa_B_t96_gse','rbspa_B_t01_gse','rbspa_B_t04_gse'],-50,200
tplot,['rbspa_mag','rbspa_B_igrf_gse','rbspa_B_t89_gse','rbspa_B_t96_gse','rbspa_B_t01_gse','rbspa_B_t04_gse']

ylim,['rbspb_mag','rbspb_B_igrf_gse','rbspb_B_t89_gse','rbspb_B_t96_gse','rbspb_B_t01_gse','rbspb_B_t04_gse'],-50,200
tplot,['rbspb_mag','rbspb_B_igrf_gse','rbspb_B_t89_gse','rbspb_B_t96_gse','rbspb_B_t01_gse','rbspb_B_t04_gse']



;Compare magnetic field vectors (model and data)
get_data,'rbspa_mag',te,be
get_data,'rbspa_B_igrf_gse',tm,bm
get_data,'rbspa_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspa_angle_igrf',tm,ang

get_data,'rbspa_mag',te,be
get_data,'rbspa_B_t89_gse',tm,bm
get_data,'rbspa_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspa_angle_t89',tm,ang

get_data,'rbspa_B_t04_gse',tm,bm
get_data,'rbspa_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspa_angle_t04',tm,ang

get_data,'rbspa_B_t01_gse',tm,bm
get_data,'rbspa_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspa_angle_t01',tm,ang

get_data,'rbspa_B_t96_gse',tm,bm
get_data,'rbspa_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspa_angle_t96',tm,ang


get_data,'rbspb_mag',te,be
get_data,'rbspb_B_igrf_gse',tm,bm
get_data,'rbspb_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspb_angle_igrf',tm,ang

get_data,'rbspb_mag',te,be
get_data,'rbspb_B_t89_gse',tm,bm
get_data,'rbspb_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspb_angle_t89',tm,ang

get_data,'rbspb_B_t04_gse',tm,bm
get_data,'rbspb_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspb_angle_t04',tm,ang

get_data,'rbspb_B_t01_gse',tm,bm
get_data,'rbspb_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspb_angle_t01',tm,ang

get_data,'rbspb_B_t96_gse',tm,bm
get_data,'rbspb_magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)
dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]
ang = acos(dotp/bmage/bmagm)/!dtor
store_data,'rbspb_angle_t96',tm,ang


options,'rbspa_angle_t96','ytitle','Angle b/t Bw T96 model!Cand Bw EMFISIS'
options,'rbspa_angle_t01','ytitle','Angle b/t Bw T01 model!Cand Bw EMFISIS'
options,'rbspa_angle_t04','ytitle','Angle b/t Bw T04 model!Cand Bw EMFISIS'
options,'rbspa_angle_t89','ytitle','Angle b/t Bw T89 model!Cand Bw EMFISIS'
options,'rbspa_angle_igrf','ytitle','Angle b/t Bw IGRF model!Cand Bw EMFISIS'
ylim,'rbspa_'+['angle_igrf','angle_t89','angle_t96','angle_t01','angle_t04'],0,10
tplot,'rbspa_'+['angle_igrf','angle_t89','angle_t96','angle_t01','angle_t04']


options,'rbspb_angle_t96','ytitle','Angle b/t Bw T96 model!Cand Bw EMFISIS'
options,'rbspb_angle_t01','ytitle','Angle b/t Bw T01 model!Cand Bw EMFISIS'
options,'rbspb_angle_t04','ytitle','Angle b/t Bw T04 model!Cand Bw EMFISIS'
options,'rbspb_angle_t89','ytitle','Angle b/t Bw T89 model!Cand Bw EMFISIS'
options,'rbspb_angle_igrf','ytitle','Angle b/t Bw IGRF model!Cand Bw EMFISIS'
ylim,'rbspb_'+['angle_igrf','angle_t89','angle_t96','angle_t01','angle_t04'],0,10
tplot,'rbspb_'+['angle_igrf','angle_t89','angle_t96','angle_t01','angle_t04']






;The only L mapping that's any different from the dipole is T01.
;It reaches max of about 0.01 L difference at 20:10
;On a scale of L=4-8 there's no visible difference b/t the models.
;So, let's correct with EMFISIS data only T04s.



;"Fix" the TSY values to match the EMFISIS values
;-----------------------------------------------------
;Assume that B varies as R^-3
;B1/B2 = (R2/R1)^3
;R2 = R1*(B1/B2)^0.33
;define:  dR = R2 - R1
;dR = R1*(B1/B2)^0.33 - R1
;dR = R1*((B1/B2)^0.33 - 1)




tinterpol_mxn,'RBSPa!CL-shell-igrf','rbspa_B_igrf_gse',newname='RBSPa!CL-shell-igrf'
get_data,'rbspa_B_igrf_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspa_bmag_igrf',t,bmag_mod
dif_data,'rbspa_magnitude','rbspa_bmag_igrf',newname='rbspa_bdiff_igrf'

tinterpol_mxn,'RBSPa!CL-shell-t89','rbspa_B_t89_gse',newname='RBSPa!CL-shell-t89'
get_data,'rbspa_B_t89_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspa_bmag_t89',t,bmag_mod
dif_data,'rbspa_magnitude','rbspa_bmag_t89',newname='rbspa_bdiff_t89'

tinterpol_mxn,'RBSPa!CL-shell-t96','rbspa_B_t96_gse',newname='RBSPa!CL-shell-t96'
get_data,'rbspa_B_t96_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspa_bmag_t96',t,bmag_mod
dif_data,'rbspa_magnitude','rbspa_bmag_t96',newname='rbspa_bdiff_t96'

tinterpol_mxn,'RBSPa!CL-shell-t01','rbspa_B_t01_gse',newname='RBSPa!CL-shell-t01'
get_data,'rbspa_B_t01_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspa_bmag_t01',t,bmag_mod
dif_data,'rbspa_magnitude','rbspa_bmag_t01',newname='rbspa_bdiff_t01'

tinterpol_mxn,'RBSPa!CL-shell-t04s','rbspa_B_t04_gse',newname='RBSPa!CL-shell-t04s'
get_data,'rbspa_B_t04_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspa_bmag_t04',t,bmag_mod
dif_data,'rbspa_magnitude','rbspa_bmag_t04',newname='rbspa_bdiff_t04'









tinterpol_mxn,'RBSPb!CL-shell-igrf','rbspb_B_igrf_gse',newname='RBSPb!CL-shell-igrf'
get_data,'rbspb_B_igrf_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspb_bmag_igrf',t,bmag_mod
dif_data,'rbspb_magnitude','rbspb_bmag_igrf',newname='rbspb_bdiff_igrf'

tinterpol_mxn,'RBSPb!CL-shell-t89','rbspb_B_t89_gse',newname='RBSPb!CL-shell-t89'
get_data,'rbspb_B_t89_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspb_bmag_t89',t,bmag_mod
dif_data,'rbspb_magnitude','rbspb_bmag_t89',newname='rbspb_bdiff_t89'

tinterpol_mxn,'RBSPb!CL-shell-t96','rbspb_B_t96_gse',newname='RBSPb!CL-shell-t96'
get_data,'rbspb_B_t96_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspb_bmag_t96',t,bmag_mod
dif_data,'rbspb_magnitude','rbspb_bmag_t96',newname='rbspb_bdiff_t96'

tinterpol_mxn,'RBSPb!CL-shell-t01','rbspb_B_t01_gse',newname='RBSPb!CL-shell-t01'
get_data,'rbspb_B_t01_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspb_bmag_t01',t,bmag_mod
dif_data,'rbspb_magnitude','rbspb_bmag_t01',newname='rbspb_bdiff_t01'

tinterpol_mxn,'RBSPb!CL-shell-t04s','rbspb_B_t04_gse',newname='RBSPb!CL-shell-t04s'
get_data,'rbspb_B_t04_gse',t,b
bmag_mod = sqrt(b[*,0]^2+b[*,1]^2+b[*,2]^2)
store_data,'rbspb_bmag_t04',t,bmag_mod
dif_data,'rbspb_magnitude','rbspb_bmag_t04',newname='rbspb_bdiff_t04'



tplot,['rbspa_bdiff_???','rbspa_bdiff_igrf']


get_data,'RBSPa!CL-shell-t04s',t,L1
get_data,'rbspa_bdiff_t04',t,db
get_data,'rbspa_bmag_t04',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPa!CL-shell-t04s_adj',t,L2

get_data,'RBSPa!CL-shell-t01',t,L1
get_data,'rbspa_bdiff_t01',t,db
get_data,'rbspa_bmag_t01',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPa!CL-shell-t01_adj',t,L2

get_data,'RBSPa!CL-shell-t96',t,L1
get_data,'rbspa_bdiff_t96',t,db
get_data,'rbspa_bmag_t96',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPa!CL-shell-t96_adj',t,L2

get_data,'RBSPa!CL-shell-t89',t,L1
get_data,'rbspa_bdiff_t89',t,db
get_data,'rbspa_bmag_t89',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPa!CL-shell-t89_adj',t,L2

get_data,'RBSPa!CL-shell-igrf',t,L1
get_data,'rbspa_bdiff_igrf',t,db
get_data,'rbspa_bmag_igrf',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPa!CL-shell-igrf_adj',t,L2




get_data,'RBSPb!CL-shell-t04s',t,L1
get_data,'rbspb_bdiff_t04',t,db
get_data,'rbspb_bmag_t04',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPb!CL-shell-t04s_adj',t,L2

get_data,'RBSPb!CL-shell-t01',t,L1
get_data,'rbspb_bdiff_t01',t,db
get_data,'rbspb_bmag_t01',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPb!CL-shell-t01_adj',t,L2

get_data,'RBSPb!CL-shell-t96',t,L1
get_data,'rbspb_bdiff_t96',t,db
get_data,'rbspb_bmag_t96',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPb!CL-shell-t96_adj',t,L2

get_data,'RBSPb!CL-shell-t89',t,L1
get_data,'rbspb_bdiff_t89',t,db
get_data,'rbspb_bmag_t89',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPb!CL-shell-t89_adj',t,L2

get_data,'RBSPb!CL-shell-igrf',t,L1
get_data,'rbspb_bdiff_igrf',t,db
get_data,'rbspb_bmag_igrf',t,B1
B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL
store_data,'RBSPb!CL-shell-igrf_adj',t,L2







store_data,'rbspa_Lcomb_t04',data=['RBSPa!CL-shell-t04s','RBSPa!CL-shell-t04s_adj']
store_data,'rbspa_Lcomb_t01',data=['RBSPa!CL-shell-t01','RBSPa!CL-shell-t01_adj']
store_data,'rbspa_Lcomb_t96',data=['RBSPa!CL-shell-t96','RBSPa!CL-shell-t96_adj']
store_data,'rbspa_Lcomb_t89',data=['RBSPa!CL-shell-t89','RBSPa!CL-shell-t89_adj']
store_data,'rbspa_Lcomb_igrf',data=['RBSPa!CL-shell-igrf','RBSPa!CL-shell-igrf_adj']
store_data,'rbspa_Bdata_comb',data=['rbspa_magnitude','rbspa_bmag_t04']

store_data,'rbspb_Lcomb_t04',data=['RBSPb!CL-shell-t04s','RBSPb!CL-shell-t04s_adj']
store_data,'rbspb_Lcomb_t01',data=['RBSPb!CL-shell-t01','RBSPb!CL-shell-t01_adj']
store_data,'rbspb_Lcomb_t96',data=['RBSPb!CL-shell-t96','RBSPb!CL-shell-t96_adj']
store_data,'rbspb_Lcomb_t89',data=['RBSPb!CL-shell-t89','RBSPb!CL-shell-t89_adj']
store_data,'rbspb_Lcomb_igrf',data=['RBSPb!CL-shell-igrf','RBSPb!CL-shell-igrf_adj']

store_data,'rbspa_Bdata_comb',data=['rbspa_magnitude','rbspa_bmag_t04']

options,['rbspa_Bdata_comb','rbspa_Bcomb','rbspa_Lcomb'],'colors',[0,250]
ylim,'rbspa_Lcomb',5,6
ylim,['RBSPa!CL-shell-t04s','RBSPa!CL-shell-t04s_adj'],4,7
tplot,['rbspa_Lcomb','rbspa_Bdata_comb','rbspa_bdiff']

get_data,'RBSPb!CL-shell-t04s',t,L1
get_data,'rbspb_bdiff',t,db
get_data,'rbspb_bmag_t04',t,B1

B2 = B1 + dB
dL = L1*((B1/B2)^(1/3.) - 1.)
L2 = L1 + dL

store_data,'RBSPb!CL-shell-t04s_adj',t,L2
store_data,'rbspb_Lcomb',data=['RBSPb!CL-shell-t04s','RBSPb!CL-shell-t04s_adj']
store_data,'rbspb_Bdata_comb',data=['rbspb_magnitude','rbspb_bmag_t04']
options,['rbspb_Bdata_comb','rbspb_Bcomb','rbspb_Lcomb'],'colors',[0,250]
ylim,'rbspb_Lcomb',5,6
ylim,['RBSPb!CL-shell-t04s','RBSPb!CL-shell-t04s_adj'],4,7
tplot,['rbspb_Lcomb','rbspb_Bdata_comb','rbspb_bdiff']




tlimit,'2016-01-20/19:00','2016-01-20/20:10'

tplot_options,'title','from definitive_RBSP_field_mapping.pro'
ylim,['rbspa_Lcomb','rbspb_Lcomb'],4,7
tplot,['rbspa_Lcomb','rbspb_Lcomb']




store_data,'rbspa_MLTcomb',data=['rbspa_state_mlt',$
  'RBSPa!Cequatorial-foot-MLT!Ct89',$
  'RBSPa!Cequatorial-foot-MLT!Ct96',$
  'RBSPa!Cequatorial-foot-MLT!Ct01',$
  'RBSPa!Cequatorial-foot-MLT!Ct04s',$
  'RBSPa!Cequatorial-foot-MLT!Cigrf']

  options,'rbsp?_MLTcomb','colors',[200,120,20,50,100,254]
  ylim,'rbspa_MLTcomb',9.5,11
  tplot,'rbspa_MLTcomb'


store_data,'rbspb_MLTcomb',data=['rbspb_state_mlt',$
  'RBSPb!Cequatorial-foot-MLT!Cigrf',$
  'RBSPb!Cequatorial-foot-MLT!Ct89',$
  'RBSPb!Cequatorial-foot-MLT!Ct96',$
  'RBSPb!Cequatorial-foot-MLT!Ct01',$
  'RBSPb!Cequatorial-foot-MLT!Ct04s']

  options,'rbsp?_MLTcomb','colors',[0,0,0,50,200,254]
;  options,'rbsp?_MLTcomb','linestyle',0
  ylim,'rbspb_MLTcomb',10,11
  tplot,'rbspb_MLTcomb'


;Create a tplot variable with the min MLT limits of the
;larger chorus source region
;RBSPa chorus source observed from 19:00-20:10 UT
;.....NO DIPOLE MODEL. IT'S VALUE IS QUITE DIFFERENT
MLTrange_rbspa = [9.91,10.71]
MLTrange_rbspb = [10.33,10.77]

get_data,'RBSPb!Cequatorial-foot-MLT!Ct89',t,d
mlta0 = replicate(MLTrange_rbspa[0],n_elements(t))
mlta1 = replicate(MLTrange_rbspa[1],n_elements(t))
mltb0 = replicate(MLTrange_rbspb[0],n_elements(t))
mltb1 = replicate(MLTrange_rbspb[1],n_elements(t))

store_data,'MLTa0',t,mlta0
store_data,'MLTa1',t,mlta1
store_data,'MLTb0',t,mltb0
store_data,'MLTb1',t,mltb1
store_data,'MLTlims',data=['MLTa0','MLTa1','MLTb0','MLTb1']
options,'MLTlims','colors',[0,0,50,50]

tplot,['rbspa_MLTcomb','rbspb_MLTcomb','MLTlims']





path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
tplot_save,'*',filename=path+'definitive_RBSP_field_mapping'    ;don't add .tplot




stop


end
