;Determine the extent of the modulated hiss on Jan 3rd. The two sc are at their
;closest b/t 19-20 UT


;Plot 2I's position in GSM


tplot_options,'title','from jan3_hiss_geophysical_extent.pro'

conjunction = '20140103'
date = '2014-01-03'
payloads = ['2I','2W']


spinperiod = 11.8
;2I is at an Lshell b/t 5-6

;the nice correlation b/t RBSP-A and 2I lasts from L=5 down to L=3.5 (dipole model)
;and a timespan from 18:40 - 22:20

t0 = date + '/' + '00:00'
t1 = date + '/' + '24:00'

timespan, date

rbsp_load_barrel_lc,payloads,date,type='rcnt'
;rbsp_load_barrel_lc,payloads,date,type='ephm'
rbsp_load_barrel_lc,payloads,date

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
tplot_options,'thick',1




;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250

get_data,'PeakDet_2W',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2W',data={x:xv,y:yv}
options,'PeakDet_2W','colors',250


rbsp_efw_position_velocity_crib,/noplot


rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	

rbsp_load_emfisis,probe='a b',/quicklook


rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
rbsp_load_efw_fbk,probe='b',type='calibrated',/pt
rbsp_split_fbk,'a'
rbsp_split_fbk,'b'

rbsp_load_efw_spec,probe='a',type='calibrated'
rbsp_load_efw_spec,probe='b',type='calibrated'



rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
rbsp_downsample,'rbspa' +'_efw_vsvy',1/spinperiod,/nochange	
rbsp_downsample,'rbspb' +'_efw_vsvy',1/spinperiod,/nochange	
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']

get_data,'rbspa_efw_vsvy_V1',data=v1a
get_data,'rbspa_efw_vsvy_V2',data=v2a
get_data,'rbspb_efw_vsvy_V1',data=v1b
get_data,'rbspb_efw_vsvy_V2',data=v2b

sum12a = (v1a.y + v2a.y)/2.
sum12b = (v1b.y + v2b.y)/2.


densitya = 7354.3897*exp(sum12a*2.8454878)+96.123628*exp(sum12a*0.43020781)
densityb = 7354.3897*exp(sum12b*2.8454878)+96.123628*exp(sum12b*0.43020781)


store_data,'densitya',data={x:v1a.x,y:densitya}
store_data,'densityb',data={x:v1b.x,y:densityb}
ylim,'density?',100,1000,1
options,'densitya','ytitle','densityA!Ccm^-3'
options,'densityb','ytitle','densityB!Ccm^-3'


options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_both'],'panel_size',0.25
options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_both'],'thick',2



;tplot Lshell variable for payload 2I
xv = time_double('2014-01-03/' + ['16:00','23:05'])
yv = [4.89,5.62]
store_data,'lshell_2I',data={x:xv,y:yv}
ylim,'lshell_2I',5,6
options,'lshell_2I','thick',2

xv = time_double('2014-01-03/' + ['16:00','23:05'])
yv = [9.62,15.94]
store_data,'mlt_2I',data={x:xv,y:yv}
ylim,'mlt_2I',5,6
options,'mlt_2I','thick',2


xv = time_double('2014-01-03/' + ['14:50','23:10'])
yv = [9.7,17.35]
store_data,'mlt_2W',data={x:xv,y:yv}
ylim,'mlt_2W',5,6
options,'mlt_2W','thick',2

xv = time_double('2014-01-03/' + ['14:50','23:10'])
yv = [3.63,3.83]
store_data,'lshell_2W',data={x:xv,y:yv}
ylim,'lshell_2W',5,6
options,'lshell_2W','thick',2



store_data,'rbsp_state_lshell_all',data=['rbspa_state_lshell','rbspb_state_lshell','Lshell_2I']
options,'rbsp_state_lshell_all','colors',[50,250,130]
ylim,'rbsp_state_lshell_all',4,7
options,'rbsp_state_lshell_all','labels','Blue=A!CRed=B!CGreen=2I'

store_data,'lshell_combw',data=['rbspa_state_lshell','lshell_2W']
options,'lshell_combw','colors',[50,130]
ylim,'lshell_combw',4,7
options,'lshell_combw','labels','Blue=A!CGreen=2W'

store_data,'mlt_combw',data=['rbspa_state_mlt','mlt_2W']
options,'mlt_combw','colors',[50,130]
ylim,'mlt_combw',4,7
options,'mlt_combw','labels','Blue=A!CGreen=2W'

store_data,'lshell_combi',data=['rbspa_state_lshell','lshell_2I']
options,'lshell_combi','colors',[50,130]
ylim,'lshell_combi',4,7
options,'lshell_combi','labels','Blue=A!CGreen=2I'

store_data,'mlt_combi',data=['rbspa_state_mlt','mlt_2I']
options,'mlt_combi','colors',[50,130]
ylim,'mlt_combi',4,7
options,'mlt_combi','labels','Blue=A!CGreen=2W'


store_data,'lshell_combw2',data=['rbspb_state_lshell','lshell_2W']
options,'lshell_combw2','colors',[50,130]
ylim,'lshell_combw2',4,7
options,'lshell_combw2','labels','Blue=B!CGreen=2W'

store_data,'mlt_combw2',data=['rbspb_state_mlt','mlt_2W']
options,'mlt_combw2','colors',[50,130]
ylim,'mlt_combw2',4,7
options,'mlt_combw2','labels','Blue=B!CGreen=2W'

store_data,'lshell_combi2',data=['rbspb_state_lshell','lshell_2I']
options,'lshell_combi2','colors',[50,130]
ylim,'lshell_combi2',4,7
options,'lshell_combi2','labels','Blue=B!CGreen=2I'

store_data,'mlt_combi2',data=['rbspb_state_mlt','mlt_2I']
options,'mlt_combi2','colors',[50,130]
ylim,'mlt_combi2',4,7
options,'mlt_combi2','labels','Blue=B!CGreen=2W'




;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


get_data,'rbspa_efw_64_spec2',data=bu2
get_data,'rbspa_efw_64_spec3',data=bv2
get_data,'rbspa_efw_64_spec4',data=bw2
bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissint_a',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint_a'


get_data,'rbspb_efw_64_spec2',data=bu2
get_data,'rbspb_efw_64_spec3',data=bv2
get_data,'rbspb_efw_64_spec4',data=bw2
bu2.y[*,0:2] = 0.
bv2.y[*,0:2] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfield_hissint_b',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint_b'



rbsp_detrend,'PeakDet_2I',60.*15.
copy_data,'PeakDet_2I_detrend','PeakDet_2I_detrend2'

rbsp_detrend,['Bfield_hissint_a','Bfield_hissint_b'],60.*0.5
rbsp_detrend,'PeakDet_2I',60.*1.
rbsp_detrend,'PeakDet_2W',60.*3.
store_data,'Peak2W_comb',data=['PeakDet_2W','PeakDet_2W_smoothed']
options,'Peak2W_comb','colors',[250,0]
store_data,'Peak2I_comb',data=['PeakDet_2I','PeakDet_2I_smoothed']
options,'Peak2I_comb','colors',[250,0]


timespan,'2014-01-03/15:00',9,/hours
tplot,['PeakDet_2I','PeakDet_2I_detrend','Peak2W_comb','Bfield_hissint_a','Bfield_hissint_b']


store_data,'spec_comb',data=['Bfield_hissint_a_smoothed','Bfield_hissint_b_smoothed']
options,'spec_comb','colors',[50,250]

store_data,'density_comb',data=['densitya','densityb']
options,'density_comb','colors',[50,250]
;Times when both sc are on same field line
tlimit,'2014-01-03/18:00','2014-01-03/20:30'
ylim,'rbsp_state_mlt_diff',0,2
tplot,['spec_comb','density_comb','rbsp_state_mlt_diff','rbsp_state_lshell_diff']


tplot,['Bfield_hissint_a_smoothed','Bfield_hissint_b_smoothed']



rbsp_detrend,['rbspa_fbk2_7pk_3','rbspb_fbk2_7pk_3'],60.*0.2
store_data,'fbk_comb1',data=['rbspa_fbk2_7pk_3_smoothed','rbspb_fbk2_7pk_3_smoothed']
options,'fbk_comb1','colors',[50,250]



ylim,['rbspa_fbk2_7pk_3','rbspa_fbk2_7pk_4','rbspb_fbk2_7pk_3','rbspb_fbk2_7pk_4'],0,100
tplot,['rbspa_fbk2_7pk_3','rbspb_fbk2_7pk_3_smoothed','rbspa_fbk2_7pk_4','rbspb_fbk2_7pk_4']



tplot,['PeakDet_2I','PeakDet_2W','spec_comb','density_comb','rbsp_state_mlt_both','rbsp_state_lshell_both']


;tplot,['rbspa_efw_64_spec3','rbspb_efw_64_spec3','Peak2W_comb','spec_comb','density_comb','rbsp_state_mlt_both','rbsp_state_lshell_both']
tplot,['rbspa_efw_64_spec3','Bfield_hissint_a_smoothed','Peak2W_comb','densitya','lshell_combw','mlt_combw']




rbsp_detrend,'PeakDet_2I_detrend2',60.*1.
timespan,'2014-01-03/18:00',4.5,/hours
tplot,['Peak2I_comb','PeakDet_2I_detrend2_smoothed','Bfield_hissint_a_smoothed','densitya','lshell_combi','mlt_combi']
timebar,'2014-01-03/' + ['18:50','22:05']



rbsp_detrend,'PeakDet_2I_detrend2',60.*1.
timespan,'2014-01-03/23:00',1,/hours
tplot,['Peak2I_comb','LC_2I','PeakDet_2I_detrend2_smoothed','Bfield_hissint_b_smoothed','densityb','lshell_combi2','mlt_combi2']
;timebar,'2014-01-03/' + ['18:50','22:05']

















rbsp_detrend,'rbspa_emfisis_quicklook_Magnitude',60.*20.
rbsp_detrend,'rbspb_emfisis_quicklook_Magnitude',60.*20.

rbsp_detrend,'densitya',60.*10.
rbsp_detrend,'densityb',60.*10.



;calculate density fluctuation %
get_data,'densitya_smoothed',data=da
get_data,'densitya_detrend',data=dad
den_fluc = 100*dad.y/da.y
store_data,'densitya_flucper',data={x:da.x,y:den_fluc}
options,'densitya_flucper','ytitle','dn/n!C(density fluc)!C%'

get_data,'densityb_smoothed',data=da
get_data,'densityb_detrend',data=dad
den_fluc = 100*dad.y/da.y
store_data,'densityb_flucper',data={x:da.x,y:den_fluc}
options,'densityb_flucper','ytitle','dn/n!C(density fluc)!C%'


rbsp_detrend,'PeakDet_2I',60.*10.
get_data,'PeakDet_2I_detrend',data=pk
get_data,'PeakDet_2I_smoothed',data=pk2
pk_fluc = 100*pk.y/pk2.y
store_data,'PeakDet_2I_flucper',data={x:pk.x,y:pk_fluc}
options,'PeakDet_2I_flucper','colors',250


options,'*rbspa*','colors',1
options,'*rbspb*','colors',2


rbsp_detrend,'densitya_flucper',60*1.
rbsp_detrend,'densityb_flucper',60*1.

;5 min is a good timescale for the smoothed version
rbsp_detrend,['rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_3'],60.*10
rbsp_detrend,['rbspb_fbk2_7pk_4','rbspb_fbk2_7pk_3'],60.*10

get_data,'rbspa_fbk2_7pk_4_detrend',data=dd
get_data,'rbspa_fbk2_7pk_4_smoothed',data=dd2
store_data,'rbspa_fbk2_7pk_4_flucper',data={x:dd.x,y:100.*(dd.y/dd2.y)}

get_data,'rbspb_fbk2_7pk_4_detrend',data=dd
get_data,'rbspb_fbk2_7pk_4_smoothed',data=dd2
store_data,'rbspb_fbk2_7pk_4_flucper',data={x:dd.x,y:100.*(dd.y/dd2.y)}

get_data,'rbspa_fbk2_7pk_3_detrend',data=dd
get_data,'rbspa_fbk2_7pk_3_smoothed',data=dd2
store_data,'rbspa_fbk2_7pk_3_flucper',data={x:dd.x,y:100.*(dd.y/dd2.y)}

get_data,'rbspb_fbk2_7pk_3_detrend',data=dd
get_data,'rbspb_fbk2_7pk_3_smoothed',data=dd2
store_data,'rbspb_fbk2_7pk_3_flucper',data={x:dd.x,y:100.*(dd.y/dd2.y)}


rbsp_detrend,'rbspa_fbk2_7pk_4_flucper',60.*0.5
rbsp_detrend,'rbspb_fbk2_7pk_4_flucper',60.*0.5
rbsp_detrend,'rbspa_fbk2_7pk_3_flucper',60.*0.5
rbsp_detrend,'rbspb_fbk2_7pk_3_flucper',60.*0.5


options,'*rbspa*','thick',2
options,'*rbspb*','thick',2
options,'*Peak*','thick',2



store_data,'rbspa_fbk4_dens_flucper_comb',data=['rbspa_fbk2_7pk_4_flucper_smoothed','densitya_flucper_smoothed']
store_data,'rbspb_fbk4_dens_flucper_comb',data=['rbspb_fbk2_7pk_4_flucper_smoothed','densityb_flucper_smoothed']
store_data,'rbspa_fbk3_dens_flucper_comb',data=['rbspa_fbk2_7pk_3_flucper_smoothed','densitya_flucper_smoothed']
store_data,'rbspb_fbk3_dens_flucper_comb',data=['rbspb_fbk2_7pk_3_flucper_smoothed','densityb_flucper_smoothed']

store_data,'rbspa_fbk4_peak_flucper_comb',data=['rbspa_fbk2_7pk_4_flucper_smoothed','PeakDet_2I_flucper']
store_data,'rbspb_fbk4_peak_flucper_comb',data=['rbspb_fbk2_7pk_4_flucper_smoothed','PeakDet_2I_flucper']
store_data,'rbspa_fbk3_peak_flucper_comb',data=['rbspa_fbk2_7pk_3_flucper_smoothed','PeakDet_2I_flucper']
store_data,'rbspb_fbk3_peak_flucper_comb',data=['rbspb_fbk2_7pk_3_flucper_smoothed','PeakDet_2I_flucper']

store_data,'dens_flucper_both',data=['densitya_flucper_smoothed','densityb_flucper_smoothed']
store_data,'dens_smoothed_both',data=['densitya_smoothed','densityb_smoothed']
store_data,'dens_detrend_both',data=['densitya_detrend','densityb_detrend']

options,'dens_flucper_both','thick',2

;15 min is a good timescale for the detrended version
rbsp_detrend,['rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_3'],60.*10
rbsp_detrend,['rbspb_fbk2_7pk_4','rbspb_fbk2_7pk_3'],60.*10

options,'PeakDet_2I_smoothed','colors',250

;options,'*7pk*','colors',0
;options,['densitya*'],'colors',1
;options,['densityb*'],'colors',2
options,'rbspa_fbk4_dens_flucper_comb','colors',[0,1]
options,'rbspb_fbk4_dens_flucper_comb','colors',[0,2]
options,'rbspa_fbk3_dens_flucper_comb','colors',[0,1]
options,'rbspb_fbk3_dens_flucper_comb','colors',[0,2]
options,'rbspa_fbk4_peak_flucper_comb','colors',[0,250]
options,'rbspb_fbk4_peak_flucper_comb','colors',[0,250]

options,'rbspa_fbk4_dens_flucper_comb','ytitle','RBSP-A!CFBK %change!C(pT 200-400Hz)!Cdens %change!C(purple)'
options,'rbspb_fbk4_dens_flucper_comb','ytitle','RBSP-B!CFBK %change!C(pT 200-400Hz)!Cdens %change!C(purple)'
options,'rbspa_fbk4_dens_flucper_comb','ytitle','RBSP-A!CFBK %change!C(pT 50-100Hz)!Cdens %change!C(purple)'
options,'rbspb_fbk4_dens_flucper_comb','ytitle','RBSP-B!CFBK %change!C(pT 50-100Hz)!Cdens %change!C(purple)'

options,'rbspa_fbk4_peak_flucper_comb','ytitle','RBSP-A!CFBK %change!C(pT 200-400Hz)!CLC1 2I %change!C(red)'
options,'rbspb_fbk4_peak_flucper_comb','ytitle','RBSP-B!CFBK %change!C(pT 200-400Hz)!CLC1 2I %change!C(red)'
options,'rbspa_fbk3_peak_flucper_comb','ytitle','RBSP-A!CFBK %change!C(pT 50-100Hz)!CLC1 2I %change!C(red)'
options,'rbspb_fbk3_peak_flucper_comb','ytitle','RBSP-B!CFBK %change!C(pT 50-100Hz)!CLC1 2I %change!C(red)'






ylim,'PeakDet_2I_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2I_flucper',-50,50
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50
ylim,'rbsp?_emfisis_quicklook_Magnitude_detrend',-6,6

t0 = time_double('2014-01-03/20:00')
t1 = time_double('2014-01-03/22:00')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb',$
	'rbspb_fbk4_dens_flucper_comb','rbspb_fbk4_peak_flucper_comb',$
	'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']

;-------------------------------------------------------------------




ylim,'PeakDet_2I_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2I_flucper',-20,20
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50

t0 = time_double('2014-01-03/19:50')
t1 = time_double('2014-01-03/20:40')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb','rbspb_fbk4_dens_flucper_comb',$
	'rbspb_fbk4_peak_flucper_comb','rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']


;-------------------------------------------------------------------



ylim,'PeakDet_2I_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2I_flucper',-20,20
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50

t0 = time_double('2014-01-03/20:20')
t1 = time_double('2014-01-03/21:40')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb','rbspb_fbk4_dens_flucper_comb',$
	'rbspb_fbk4_peak_flucper_comb','rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']


;-------------------------------------------------------------------




ylim,'PeakDet_2I_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2I_flucper',-20,20
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50

t0 = time_double('2014-01-03/21:00')
t1 = time_double('2014-01-03/22:10')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb','rbspb_fbk4_dens_flucper_comb',$
	'rbspb_fbk4_peak_flucper_comb','rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']

;-------------------------------------------------------------------




;rbsp_detrend,['PeakDet_2I'],60.*1


;Both sc at L=6 from ~18:20-19:00
t0 = time_double('2014-01-03/18:00')
t1 = time_double('2014-01-03/20:00')
tlimit,t0,t1


ylim,'PeakDet_2I_smoothed',10000,40000.,1
ylim,'PeakDet_2I_detrend',10,2000,0
ylim,'PeakDet_2I_flucper',-20,20
options,'PeakDet_2I_detrend','colors',50
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,['rbspa_fbk2_7pk_4_smoothed5'],0.3,30,1
ylim,['rbspb_fbk2_7pk_4_smoothed5'],1,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',0.1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',0.1,30,1
;ylim,['rbspb_fbk2_7pk_4_smoothed'],4,20,1
;ylim,'PeakDet_2I_smoothed',4000,12000.
ylim,'rbspa_fbk4_dens_flucper_comb',-80,80
ylim,'rbspb_fbk4_dens_flucper_comb',-80,80
ylim,'rbspa_fbk4_peak_flucper_comb',-100,100
ylim,'rbspb_fbk4_peak_flucper_comb',-100,100

tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb','rbspb_fbk4_dens_flucper_comb',$
	'rbspb_fbk4_peak_flucper_comb',$
	'rbsp_state_sc_sep','rbsp_state_mlt_diff',$
	'rbsp_state_lshell_all']




;---------------------------------------------------------------------------------

;rbsp_detrend,['PeakDet_2I'],60.*1


;Larger picture
t0 = time_double('2014-01-03/16:00')
t1 = time_double('2014-01-03/22:00')
tlimit,t0,t1



ylim,'PeakDet_2I_smoothed',1000,40000.,1
ylim,'PeakDet_2I_detrend',10,2000,0
ylim,'PeakDet_2I_flucper',-40,40
options,'PeakDet_2I_detrend','colors',50
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,['rbspa_fbk2_7pk_4_smoothed5'],0.3,30,1
ylim,['rbspb_fbk2_7pk_4_smoothed5'],1,50,1
ylim,'rbspa_fbk2_7pk_4_detrend',0.1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',0.1,30,1
;ylim,['rbspb_fbk2_7pk_4_smoothed'],4,20,1
;ylim,'PeakDet_2I_smoothed',4000,12000.
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'PeakDet_2I_flucper','rbspb_fbk4_dens_flucper_comb',$
	'rbsp_state_sc_sep','rbsp_state_mlt_diff',$
	'rbsp_state_lshell_all']





;-------------------------------------------------------------------




ylim,'PeakDet_2I_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2I_flucper',-20,20
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50

t0 = time_double('2014-01-03/19:00')
t1 = time_double('2014-01-03/20:00')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb','rbspb_fbk4_dens_flucper_comb',$
	'rbspb_fbk4_peak_flucper_comb','rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']

;-------------------------------------------------------------------

















