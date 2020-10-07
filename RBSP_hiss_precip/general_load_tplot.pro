;General crib sheet for loading all data applicable to the hiss/precip events


general_load_tplot,date,probe


det = 5.   ;detrend time
rbspx = 'rbsp' + probe

spinperiod = 11.8

t0 = date + '/' + '00:00'
t1 = date + '/' + '24:00'

timespan, date


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
	

rbsp_load_emfisis,probe=probe,/quicklook

rbsp_load_efw_spec,probe=probe,type='calibrated',/pt

rbsp_load_efw_fbk,probe=probe,type='calibrated',/pt
rbsp_split_fbk,probe


get_data,'rbsp'+probe+'_emfisis_quicklook_Magnitude',data=mag
get_data,'rbsp'+probe+'_efw_64_spec0',data=dat

fce = 28.*mag.y
fce = interpol(fce,mag.x,dat.x)

store_data,'fce'+probe,data={x:dat.x,y:fce}
store_data,'fce_2'+probe,data={x:dat.x,y:fce/2.}
store_data,'fci'+probe,data={x:dat.x,y:fce/1836.}
store_data,'flh'+probe,data={x:dat.x,y:sqrt(fce*fce/1836.)}

rbsp_downsample,['fce'+probe,'fce_2'+probe,'fci'+probe,'flh'+probe],1/spinperiod,/nochange





rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='vsvy'
rbsp_downsample,rbspx + '_efw_vsvy',1/spinperiod,/nochange	
split_vec,rbspx + '_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']

get_data,rbspx + '_efw_vsvy_V1',data=v1
get_data,rbspx + '_efw_vsvy_V2',data=v2

sum12 = (v1.y + v2.y)/2.

density = 7583.26*exp(sum12/0.38)+94.62*exp(sum12/2.3)

store_data,'density'+probe,data={x:v1.x,y:density}
ylim,'density?',100,1000,1
options,'density'+probe,'ytitle','density'+strupcase(probe)+'!Ccm^-3'


options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_both'],'panel_size',0.25
options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
	'rbsp_state_lshell_both'],'thick',2


;--------------------------------------------------------------------------
;--------------------------------------------------------------------------
;--------------------------------------------------------------------------


rbsp_detrend,'rbsp'+probe+'_emfisis_quicklook_Magnitude',60.*det
rbsp_detrend,'density'+probe,60.*det

options,'*rbspa*','colors',1
options,'*rbspb*','colors',2
options,'*rbspa*','thick',2
options,'*rbspb*','thick',2

rbsp_detrend,['rbsp'+probe+'_fbk2_7pk_4','rbsp'+probe+'_fbk2_7pk_3'],60.*det





;Create E/B plot

get_data,'rbsp'+probe+'_efw_64_spec0',data=Evals,dlimits=dlim,limits=lim
get_data,'rbsp'+probe+'_efw_64_spec4',data=Bvals,dlimits=dlimB,lim=limB

;make sure units are in nT
if strmid(dlimB.data_att.units,0,2) eq 'pT' then Bvals.y = Bvals.y/1000.

E2B = 1000*Evals.y/Bvals.y    ;Velocity=1000*E/B (km/s)
boo = where(finite(E2B) eq 0)
if boo[0] ne -1 then E2B[boo] = 0.


store_data,'E2B'+probe,data={x:Evals.x,y:E2B,v:Evals.v},dlimits=dlim,limits=lim
store_data,'E2B_C'+probe,data=['E2B'+probe,'fce'+probe,'fce_2'+probe,'fci'+probe,'flh'+probe]

options,'E2B'+probe,'ytitle','E/B!CHz'
options,'E2B'+probe,'ztitle','km/s'
options,'E2B_C'+probe,'ytitle','E/B!CHz'
options,'E2B_C'+probe,'ztitle','km/s'

ylim,'E2B_C'+probe,10,1000,1
zlim,'E2B'+probe,1,100,1


end
