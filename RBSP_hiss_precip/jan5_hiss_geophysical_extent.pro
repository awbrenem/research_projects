;Determine the extent of the modulated hiss on Jan 3rd. The two sc are at their
;closest b/t 19-20 UT


;Plot 2K's position in GSM


tplot_options,'title','from jan5_hiss_geophysical_extent.pro'

conjunction = '20140105'
date = '2014-01-05'
payloads = ['2K']


spinperiod = 11.8
;2K is at an Lshell b/t 5-6

;the nice correlation b/t RBSP-A and 2K lasts from L=5 down to L=3.5 (dipole model)
;and a timespan from 18:40 - 22:20

t0 = date + '/' + '00:00'
t1 = date + '/' + '24:00'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,payloads,date,type='rcnt'
rbsp_load_barrel_lc,payloads,date


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K',data={x:xv,y:yv}
options,'PeakDet_2K','colors',250

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



;tplot Lshell variable for payload 2K
xv = time_double('2014-01-05/' + ['14:20','23:30'])
yv = [4.6,4.6]

store_data,'Lshell_2K',data={x:xv,y:yv}
ylim,'Lshell_2K',5,6
options,'Lshell_2K','thick',2

store_data,'rbsp_state_lshell_all',data=['rbspa_state_lshell','rbspb_state_lshell','Lshell_2K']
options,'rbsp_state_lshell_all','colors',[50,250,130]
ylim,'rbsp_state_lshell_all',4,7
options,'rbsp_state_lshell_all','labels','Blue=A!CRed=B!CGreen=2K'

;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------


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


rbsp_detrend,'PeakDet_2K',60.*10.
get_data,'PeakDet_2K_detrend',data=pk
get_data,'PeakDet_2K_smoothed',data=pk2
pk_fluc = 100*pk.y/pk2.y
store_data,'PeakDet_2K_flucper',data={x:pk.x,y:pk_fluc}
options,'PeakDet_2K_flucper','colors',250


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

store_data,'rbspa_fbk4_peak_flucper_comb',data=['rbspa_fbk2_7pk_4_flucper_smoothed','PeakDet_2K_flucper']
store_data,'rbspb_fbk4_peak_flucper_comb',data=['rbspb_fbk2_7pk_4_flucper_smoothed','PeakDet_2K_flucper']
store_data,'rbspa_fbk3_peak_flucper_comb',data=['rbspa_fbk2_7pk_3_flucper_smoothed','PeakDet_2K_flucper']
store_data,'rbspb_fbk3_peak_flucper_comb',data=['rbspb_fbk2_7pk_3_flucper_smoothed','PeakDet_2K_flucper']

store_data,'dens_flucper_both',data=['densitya_flucper_smoothed','densityb_flucper_smoothed']
store_data,'dens_smoothed_both',data=['densitya_smoothed','densityb_smoothed']
store_data,'dens_detrend_both',data=['densitya_detrend','densityb_detrend']

options,'dens_flucper_both','thick',2

;15 min is a good timescale for the detrended version
rbsp_detrend,['rbspa_fbk2_7pk_4','rbspa_fbk2_7pk_3'],60.*10
rbsp_detrend,['rbspb_fbk2_7pk_4','rbspb_fbk2_7pk_3'],60.*10

options,'PeakDet_2K_smoothed','colors',250

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

options,'rbspa_fbk4_peak_flucper_comb','ytitle','RBSP-A!CFBK %change!C(pT 200-400Hz)!CLC1 2K %change!C(red)'
options,'rbspb_fbk4_peak_flucper_comb','ytitle','RBSP-B!CFBK %change!C(pT 200-400Hz)!CLC1 2K %change!C(red)'
options,'rbspa_fbk3_peak_flucper_comb','ytitle','RBSP-A!CFBK %change!C(pT 50-100Hz)!CLC1 2K %change!C(red)'
options,'rbspb_fbk3_peak_flucper_comb','ytitle','RBSP-B!CFBK %change!C(pT 50-100Hz)!CLC1 2K %change!C(red)'






ylim,'PeakDet_2K_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2K_flucper',-50,50
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50
ylim,'rbsp?_emfisis_quicklook_Magnitude_detrend',-6,6

t0 = time_double('2014-01-05/14:00')
t1 = time_double('2014-01-05/23:00')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb',$
	'rbspb_fbk4_dens_flucper_comb','rbspb_fbk4_peak_flucper_comb',$
	'rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']

;-------------------------------------------------------------------




ylim,'PeakDet_2K_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2K_flucper',-20,20
ylim,'rbspa_fbk4_dens_flucper_comb',-60,60
ylim,'rbspb_fbk4_dens_flucper_comb',-60,60
ylim,'rbsp?_fbk4_peak_flucper_comb',-50,50

t0 = time_double('2014-01-05/19:00')
t1 = time_double('2014-01-05/20:00')
tlimit,t0,t1
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'rbspa_fbk4_peak_flucper_comb','rbspb_fbk4_dens_flucper_comb',$
	'rbspb_fbk4_peak_flucper_comb','rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_all']


;-------------------------------------------------------------------



ylim,'PeakDet_2K_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2K_flucper',-20,20
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




ylim,'PeakDet_2K_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2K_flucper',-20,20
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




;rbsp_detrend,['PeakDet_2K'],60.*1


;Both sc at L=6 from ~18:20-19:00
t0 = time_double('2014-01-03/18:00')
t1 = time_double('2014-01-03/20:00')
tlimit,t0,t1


ylim,'PeakDet_2K_smoothed',10000,40000.,1
ylim,'PeakDet_2K_detrend',10,2000,0
ylim,'PeakDet_2K_flucper',-20,20
options,'PeakDet_2K_detrend','colors',50
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,['rbspa_fbk2_7pk_4_smoothed5'],0.3,30,1
ylim,['rbspb_fbk2_7pk_4_smoothed5'],1,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',0.1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',0.1,30,1
;ylim,['rbspb_fbk2_7pk_4_smoothed'],4,20,1
;ylim,'PeakDet_2K_smoothed',4000,12000.
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

;rbsp_detrend,['PeakDet_2K'],60.*1


;Larger picture
t0 = time_double('2014-01-03/16:00')
t1 = time_double('2014-01-03/22:00')
tlimit,t0,t1



ylim,'PeakDet_2K_smoothed',1000,40000.,1
ylim,'PeakDet_2K_detrend',10,2000,0
ylim,'PeakDet_2K_flucper',-40,40
options,'PeakDet_2K_detrend','colors',50
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,['rbspa_fbk2_7pk_4_smoothed5'],0.3,30,1
ylim,['rbspb_fbk2_7pk_4_smoothed5'],1,50,1
ylim,'rbspa_fbk2_7pk_4_detrend',0.1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',0.1,30,1
;ylim,['rbspb_fbk2_7pk_4_smoothed'],4,20,1
;ylim,'PeakDet_2K_smoothed',4000,12000.
tplot,['dens_flucper_both','dens_detrend_both','rbspa_fbk4_dens_flucper_comb',$
	'PeakDet_2K_flucper','rbspb_fbk4_dens_flucper_comb',$
	'rbsp_state_sc_sep','rbsp_state_mlt_diff',$
	'rbsp_state_lshell_all']





;-------------------------------------------------------------------




ylim,'PeakDet_2K_smoothed',6000,12000.,1
;ylim,['rbspa_fbk2_7pk_4_smoothed','rbspb_fbk2_7pk_4_smoothed'],0,40
ylim,'rbspa_fbk2_7pk_4_smoothed5',0.7,30,1
ylim,'rbspb_fbk2_7pk_4_smoothed5',4,30,1
ylim,'rbspa_fbk2_7pk_4_detrend',1,20,1
ylim,'rbspb_fbk2_7pk_4_detrend',1,30,1
ylim,'PeakDet_2K_flucper',-20,20
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



tplot,['densitya_smoothed','densitya_detrend','PeakDet_2K_smoothed','PeakDet_2K_detrend']













