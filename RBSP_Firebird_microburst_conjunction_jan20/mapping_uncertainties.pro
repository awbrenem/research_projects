;Use the TS04 model to find out the most accurate conjunction b/t RBSPA and FB4
;for the Jan20th chorus/microburst correlations at 19:44 UT

;Find range of possible conjunctions of RBSPa and FB2 FU4 considering
;field mapping and FB timing uncertainties


pro mapping_uncertainties

rbsp_efw_init


path = '~/Desktop/'
fn = ['fb4_t04s_tshift=2.5sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=4.1sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=2.7sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=2.5sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=2.2sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=2.0sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=1.8sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=1.6sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=1.4sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=1.2sec_lshell_MLT_hires.tplot',$
'fb4_t04s_tshift=1.0sec_lshell_MLT_hires.tplot']




lvals = 0.

for i=0,n_elements(fn)-1 do begin
  tplot_restore,filenames=path + fn[i]

  get_data,'FB4!CL-shell-t04s',tms,l
  get_data,'FB4!Cnorth-foot-MLT!Ct04s',tms,mn
  get_data,'FB4!Csouth-foot-MLT!Ct04s',tms,ms
  get_data,'FB4!Cequatorial-foot-MLT!Ct04s',tms,me

  if i eq 0 then lvals = l
  if i gt 0 then lvals = [[l],[lvals]]
  if i eq 0 then mltN = mn
  if i gt 0 then mltN = [[mn],[mltN]]
  if i eq 0 then mltS = ms
  if i gt 0 then mltS = [[ms],[mltS]]
  if i eq 0 then mltE = me
  if i gt 0 then mltE = [[me],[mltE]]

endfor


ld = lvals[*,10]-lvals[*,1]

store_data,'ldiff',tms,ld
store_data,'lvals',tms,lvals
tplot,['lvals','ldiff']

stop






;fileroot = '~/Desktop/Research/RBSP_FIREBIRD_microburst_conjunction_jan20/IDL/'
;tplot_restore,filenames=fileroot+'aaron_fb4_rbspa.tplot'

date = '2016-01-20'
timespan,date

;------
  sc = 'a'
  fb = '4'

  t0 = time_double('2016-01-20/19:00:00')
  t1 = time_double('2016-01-20/21:00:00')






;---------------------------------------------------------------
  ;rbsp_efw_position_velocity_crib




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


;Interpolate these to a much higher cadence than once/min
times = dindgen(86400) + time_double('2016-01-20')

tinterpol_mxn,'fb4!CL-shell-t04s',times,newname='fb4!CL-shell-t04s'
tinterpol_mxn,'fb4!Cequatorial-foot-MLT!Ct04s',times,newname='fb4!Cequatorial-foot-MLT!Ct04s'
tinterpol_mxn,'RBSPa!CL-shell-t04s',times,newname='RBSPa!CL-shell-t04s'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct04s',times,newname='RBSPa!Cequatorial-foot-MLT!Ct04s'


;get_data,'rbspa_state_lshell',fb_times,dtmp
zerolinefb = replicate(0.,n_elements(times))
store_data,'zerolinefb',fb_times,zerolinefb



tplot,['fb4!Cequatorial-foot-MLT!Ct04s','RBSPa!Cequatorial-foot-MLT!Ct04s']
tplot,['fb4!CL-shell-t04s','RBSPa!CL-shell-t04s']



;------
;First compare RBSP dipole with TS04 vals
dif_data,'rbspa_state_lshell','RBSPa!CL-shell-t04s',newname='rbspa_ldiff'
dif_data,'rbspa_state_mlt','RBSPa!Cequatorial-foot-MLT!Ct04s',newname='rbspa_mltdiff'
options,['rbspa_mltdiff','rbspa_ldiff'],constant=0
tplot,['rbspa_state_lshell','RBSPa!CL-shell-t04s','rbspa_ldiff']
tplot,['rbspa_state_mlt','RBSPa!Cequatorial-foot-MLT!Ct04s','rbspa_mltdiff']

tplot,['rbspa_ldiff','rbspa_mltdiff']


;------
;see how the FB4 MLT changes from the foot point to the equator
dif_data,'fb4!Cnorth-foot-MLT!Ct04','fb4!Cequatorial-foot-MLT!Ct04s',newname='fb4_mltdiff_foot2eq'
options,'fb4_mltdiff_foot2eq',constant=0
tplot,'fb4_mltdiff_foot2eq'

;------
;now compare FB4 values from Alex to our TS04 FB4 mapped values
dif_data,'fb4!CL-shell-t04s','alex_fb4_lshell',newname='fb4_ldiff'
dif_data,'fb4!Cnorth-foot-MLT!Ct04','alex_fb4_mlt',newname='fb4_mltdiff'
dif_data,'RBSPa!Cequatorial-foot-MLT!Ct04s','alex_fb4_mlt',newname='fb4_mltdiff_mapped'


ylim,'fb4_ldiff',-5,5
options,['fb4_ldiff','fb4_mltdiff','fb4_mltdiff_mapped'],constant=0
tplot,['fb4!CL-shell-t04s','alex_fb4_lshell','fb4_ldiff']
ylim,['fb4_mltdiff','fb4_mltdiff_mapped'],-5,5
tplot,['fb4!Cnorth-foot-MLT!Ct04','alex_fb4_mlt','fb4_mltdiff','fb4_mltdiff_mapped']




;------
;Find conjunctions with dipole and TS04
;compare FB4 with RBSPa location
dif_data,'fb4!Cequatorial-foot-MLT!Ct04s','RBSPa!Cequatorial-foot-MLT!Ct04s',newname='mltdiff_tsy04'
dif_data,'fb4!CL-shell-t04s','RBSPa!CL-shell-t04s',newname='ldiff_tsy04'

dif_data,'alex_fb4_mlt','rbspa_state_mlt',newname='mltdiff_dipole'
dif_data,'alex_fb4_lshell','rbspa_state_lshell',newname='ldiff_dipole'

options,['mltdiff_tsy04','ldiff_tsy04',$
'mltdiff_dipole','ldiff_dipole'],constant=0

options,'ldiff_tsy04','ytitle','delta-lshell!CFB4-RBSPa!CTSY04'
options,'mltdiff_tsy04','ytitle','delta-MLT!CFB4-RBSPa!CTSY04'

options,'ldiff_dipole','ytitle','delta-lshell!CFB4-RBSPa!Cdipole'
options,'mltdiff_dipole','ytitle','delta-MLT!CFB4-RBSPa!Cdipole'

store_data,'lcomb',data=['ldiff_tsy04','ldiff_dipole']
store_data,'mltcomb',data=['mltdiff_tsy04','mltdiff_dipole']

options,'lcomb','colors',[0,250]
options,'mltcomb','colors',[0,250]

ylim,'*lcomb*',-6,6
ylim,'*mltcomb*',-5,5

options,'lcomb','ytitle','delta-lshell!CFB4-RBSPa!CTSY04(black)!Cdipole(red)'
options,'mltcomb','ytitle','delta-MLT!CFB4-RBSPa!CTSY04(black)!Cdipole(red)'


;Final plot showing Lshell and MLT separation
options,['mltdiff_tsy04','ldiff_tsy04'],'psym',-4
tplot,['lcomb','mltcomb']



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







end
