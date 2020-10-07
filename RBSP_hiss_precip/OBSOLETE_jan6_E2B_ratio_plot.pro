;Calculate E/B ratio for the hiss/precipitation events



	;Calculate E/B ratio (E=VxB, where E(mV/m) = V(km/s) x B(nT)/1000)
	; V = 1000* (E/B)    km/s
	; n = B*c/E = c/vp




tplot_options,'title','from jan6_E2B_ratio_plot.pro'
tplot_options,'thick',2

conjunction = '20140106'
date = '2014-01-06'
payloads = ['2K','2L']


spinperiod = 11.8
;2K is at an Lshell b/t 5-6

;the nice correlation b/t RBSP-A and 2K lasts from L=5 down to L=3.5 (dipole model)
;and a timespan from 18:40 - 22:20

t0 = date + '/' + '00:00'
t1 = date + '/' + '24:00'

timespan, date

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


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2L',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2L',data={x:xv,y:yv}
options,'PeakDet_2L','colors',250


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


rbsp_load_efw_spec,probe='a',type='calibrated'
rbsp_load_efw_spec,probe='b',type='calibrated'


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

densitya = 7583.26*exp(sum12a/0.38)+94.62*exp(sum12a/2.3)
densityb = 7583.26*exp(sum12b/0.38)+94.62*exp(sum12b/2.3)

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
xv = time_double('2014-01-06/' + ['19:00','24:00'])
yv = [5.0,5.3]

store_data,'Lshell_2K',data={x:xv,y:yv}
ylim,'Lshell_2K',5,6
options,'Lshell_2K','thick',2

xv = time_double('2014-01-06/' + ['19:00','24:00'])
yv = [5.3,5.3]

store_data,'Lshell_2L',data={x:xv,y:yv}
ylim,'Lshell_2L',5,6
options,'Lshell_2L','thick',2


store_data,'rbsp_state_lshell_all',data=['rbspa_state_lshell','rbspb_state_lshell','Lshell_2K','Lshell_2L']
options,'rbsp_state_lshell_all','colors',[50,250,130]
ylim,'rbsp_state_lshell_all',4,7
options,'rbsp_state_lshell_all','labels','Blue=A!CRed=B!CGreen=2K'
		
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------

	
get_data,'rbspa_efw_64_spec0',data=Evals,dlimits=dlim,limits=lim
get_data,'rbspa_efw_64_spec4',data=Bvals,dlimits=dlimB


;make sure units are in nT
if strmid(dlimB.data_att.units,0,2) eq 'pT' then Bvals.y = Bvals.y/1000.


E2B = 1000*.Evals.y/Bvals.y    ;Velocity=1000*E/B (km/s)
boo = where(finite(E2B) eq 0)
if boo[0] ne -1 then E2B[boo] = 0.



store_data,'E2B',data={x:Evals.x,y:E2B,v:Evals.v},dlimits=dlim,limits=lim
store_data,'E2B_C',data=['E2B','fce','fce_2','fci','flh']


rbsp_detrend,'densitya',60.*5.

ylim,'E2B',20,300
zlim,'E2B',1,50,1
ylim,'densitya',200,400

options,'E2B','ytitle','E/B!CHz'
options,'E2B','ztitle','km/s'

tlimit,'2014-01-06/20:40','2014-01-06/20:50'	
tlimit,'2014-01-06/20:00','2014-01-06/21:10'	


tplot,['densitya','densitya_detrend','E2B']






		ylim,'E2B_C',3,10000,1
		zlim,'E2B_C',0.001,1d2,1
		options,'E2B_C','ztitle','(mV/m / nT)!C!CE/B'
		options,'E2B_C','ytitle','E12/Bw!C[Hz]'
		options,'E2B_C','ysubtitle',''

	
