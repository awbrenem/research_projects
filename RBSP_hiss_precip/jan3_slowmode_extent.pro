
tplot_options,'title','from jan3_zoomed_event.pro'

date = '2014-01-03'
probe = 'a'
rbspx = 'rbspa'
timespan,date

rbsp_efw_init

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL




t0 = time_double('2014-01-03/19:30')
t1 = time_double('2014-01-03/22:30')

;rbsp_load_efw_spec,probe=probe,type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
;rbsp_efw_vxb_subtract_crib,probe,/hires,/no_spice_load
;-----------------------------------------------
rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspa_efw_vsvy_V1',data=v1
get_data,'rbspa_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densitya',data={x:v1.x,y:density}

rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densityb',data={x:v1.x,y:density}


ylim,'density?',1,10000,1
options,'densitya','ytitle','densitya'+'!Ccm^-3'
options,'densityb','ytitle','densityb'+'!Ccm^-3'



;get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
;times = esvy.x

;rbsp_boom_directions_crib,times,'a',/no_spice_load
;tplot,['vecu_gse','vecv_gse','vecw_gse']


rbsp_load_emfisis,probe='a',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
rbsp_load_emfisis,probe='b',coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract

rbsp_detrend,['rbspa_emfisis_l3_1sec_gse_Mag','densitya'],60.*0.2
rbsp_detrend,['rbspa_emfisis_l3_1sec_gse_Mag_smoothed','densitya_smoothed'],60.*5.

split_vec,'rbspa_emfisis_l3_1sec_gse_Mag_smoothed_detrend'


;t0 = '2014-01-03/19:30'
;t1 = '2014-01-03/20:20'
t0 = '2014-01-03/19:00'
t1 = '2014-01-03/22:00'

ylim,'rbspa_emfisis_l3_1sec_gse_Mag_smoothed_detrend_z',-5,5
ylim,'densitya_smoothed_detrend',-80,80
tplot,['rbspa_emfisis_l3_1sec_gse_Mag_smoothed_detrend_z','densitya_smoothed_detrend']

get_data,'rbspa_emfisis_l3_1sec_gse_Mag_smoothed_detrend_z',data=bz
get_data,'densitya_smoothed_detrend',data=dens



store_data,'Bz_norm',data={x:bz.x,y:bz.y/3.}
store_data,'dens_norm',data={x:dens.x,y:dens.y/60.}

store_data,'slowmode',data=['Bz_norm','dens_norm']
options,'slowmode','colors',[0,250]
tplot,['slowmode','rbspa_emfisis_l3_1sec_gse_Mag_smoothed_detrend_z','densitya_smoothed_detrend']



x = tsample('dens_norm',time_double([t0,t1]),times=tms)
store_data,'dens_norm2',data={x:tms,y:x}

epsd = {xlog:1,xrange:[0.001,0.1],yrange:[-30,20]}
plot_wavestuff,'dens_norm2',/psd,extra_psd=epsd


0.002-0.02







rad=findgen(101)
rad=rad*2*!pi/100.0
lval=findgen(7)
lval=lval+3.0
lshell1x=1.0*cos(rad)
lshell1y=1.0*sin(rad)
lshell3x=lval(0)*cos(rad)
lshell3y=lval(0)*sin(rad)
lshell5x=lval(2)*cos(rad)
lshell5y=lval(2)*sin(rad)
lshell7x=lval(4)*cos(rad)
lshell7y=lval(4)*sin(rad)
lshell9x=lval(6)*cos(rad)
lshell9y=lval(6)*sin(rad)
!x.margin=[5,5]
!y.margin=[5,5]
;!y.tickname=[' 18:00',"  ", "  6:00"]
!y.ticks=2
;!x.tickname=[' ', '5', ' 0', ' 5', '  ']
!x.ticks=4
;window,1, xsize = 600, ysize = 600




T1 = '2014-01-03/19:00'
T2 = '2014-01-03/22:30'



split_vec,'rbspa_emfisis_l3_1sec_gse_Mag'
split_vec,'rbspb_emfisis_l3_1sec_gse_Mag'


window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4


rbsp_detrend,['rbspa_emfisis_l3_1sec_gse_Mag_z','rbspb_emfisis_l3_1sec_gse_Mag_z'],60.*10.

;Find the predominant frequencies 
t0x = '2014-01-03/15:00'
t1x = '2014-01-03/23:30'
yv = tsample('rbspa_emfisis_l3_1sec_gse_Mag_z_detrend',time_double([t0x,t1x]),times=tms)
store_data,'Bza_tmp',data={x:tms,y:yv}
yv = tsample('rbspb_emfisis_l3_1sec_gse_Mag_z_detrend',time_double([t0x,t1x]),times=tms)
store_data,'Bzb_tmp',data={x:tms,y:yv}

;tplot,['Bza_tmp','Bzb_tmp']
;tlimit,t0x,t1x

epsd = {xlog:1,xrange:[0.001,0.1],yrange:[-30,40]}
plot_wavestuff,'Bza_tmp',/psd,extra_psd=epsd
epsd = {xlog:1,xrange:[0.001,0.1],yrange:[-30,40]}
plot_wavestuff,'Bzb_tmp',/psd,extra_psd=epsd



v1 = 'Bza_tmp'
v2 = 'Bzb_tmp'
dynamic_cross_spec_tplot,v1,0,v2,0,t0x,t1x,window,lag,coherence_time,new_name='bza_bzb'


cormin = 0.2
get_data,'bza_bzb_coherence',data=coh
get_data,'bza_bzb_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'bza_bzb_coherence',data=coh
store_data,'bza_bzb_phase',data=ph
options,'bza_bzb_coherence','ytitle','Bza vs Bzb GSE!CCoherence!Cfreq[Hz]'
options,'bza_bzb_phase','ytitle','Bza vs Bzb GSE!CPhase!Cfreq[Hz]'
ylim,['bza_bzb_coherence','bza_bzb_phase'],-0.001,0.04
zlim,'bza_bzb_coherence',0.4,1


var = 'bza_bzb_coherence'
get_data,var,data=dat
num = 20.
hc3m = dat.y[*,num]

period = 1/dat.v[num]/60.
;periods = 1/dat.v/60.
;print,1/dat.v[7]/60.
;for i=0,100 do print,i,1/dat.v[i]/60.

;18:89

;Find the max coherence for periods b/t 0.333 and 1.667
;hc3m = fltarr(n_elements(dat.x))
;for i=0,n_elements(dat.x)-1 do hc3m[i] = max(dat.y[i,7:11],/nan)
;minv = 0.333
;maxv = 1.667



get_data,'rbspa_state_lshell',data=la

tinterpol_mxn,'rbspa_state_lshell','bza_bzb_coherence'
tinterpol_mxn,'rbspa_state_mlt','bza_bzb_coherence'
tinterpol_mxn,'rbspb_state_lshell','bza_bzb_coherence'
tinterpol_mxn,'rbspb_state_mlt','bza_bzb_coherence'
get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'rbspb_state_lshell_interp',data=lb
get_data,'rbspb_state_mlt_interp',data=mltb

;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
xvb = lb.y*cos(mltb.y*360.*!dtor/24.)
yvb = lb.y*sin(mltb.y*360.*!dtor/24.)

datavals = hc3m
datavals[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals[goo] = 75
goo = where((hc3m ge 0.0) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals[goo] = 1




get_data,'rbspa_state_mlt',data=mlt_a
get_data,'rbspa_state_lshell',data=lshell_a
get_data,'rbspb_state_mlt',data=mlt_b
get_data,'rbspb_state_lshell',data=lshell_b


t1 = (mlt_a.y - 12)*360./24.
t2 = (mlt_b.y - 12)*360./24.
x1 = lshell_a.y * sin(t1*!dtor)
y1 = lshell_a.y * cos(t1*!dtor)
x2 = lshell_b.y * sin(t2*!dtor)
y2 = lshell_b.y * cos(t2*!dtor)
daa = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dab',data={x:mlt_a.x,y:daa}
store_data,'mab',data={x:mlt_a.x,y:(mlt_a.y-mlt_b.y)}
store_data,'lab',data={x:mlt_a.x,y:(lshell_a.y-lshell_b.y)}

tinterpol_mxn,'dab','bza_bzb_coherence'
tinterpol_mxn,'mab','bza_bzb_coherence'
tinterpol_mxn,'lab','bza_bzb_coherence'

get_data,'dab_interp',data=dab
get_data,'mab_interp',data=mab
get_data,'lab_interp',data=lab


!p.multi = [0,0,3]
plot,dab.y,hc3m,xrange=[1,4],yrange=[0.2,1],title='from jan3_slowmode_extent.pro!C1.5min periods only',$
	xtitle='Straight-line separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
plot,mab.y,hc3m,xrange=[0,5],yrange=[0.2,1],$
	xtitle='MLT separation b/t payloads (hrs)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
plot,lab.y,hc3m,xrange=[-3,3],yrange=[0.2,1],$
	xtitle='Lshell separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa





popen,'~/Desktop/polarplot_' + strtrim(period,2) + 'min_period.ps'

plot, lshell3x, lshell3y, xrange=[-10,10], yrange=[-10,10],XSTYLE=4, YSTYLE=4, $
  title="Jan. 3, 2014 (L vs MLT Kp=1)!Cfrom jan3_correlations.pro"
AXIS,0,0,XAX=0,/DATA
AXIS,0,0,0,YAX=0,/DATA
oplot, lshell5x, lshell5y
oplot, lshell7x, lshell7y
oplot, lshell9x,lshell9y

q=7.5*sin(!pi/4)
q2 = 7.5*cos(!pi/8)
q3 = 7.5*sin(!pi/8)
q4 = 7.5*cos(3.0*!pi/8)
q5 = 7.5*sin(3.0*!pi/8)
usersym, [0,q4,q,q2,7.5,q2,q,q4,0,0],[7.5,q5,q,q3,0,-q3,-q,-q5,-7.5,7.5],/fill
oplot, lshell1x,lshell1y
oplot, [0,0],[0,0],psym=8

xyouts, -10.5, -0.60, '12:00', /data
xyouts, 9.75, -0.60, '0:00', /data
xyouts, -7, -0.6, '7', /data
xyouts, -3, -0.6, '3',/data
xyouts, 7, -0.6, '7', /data
xyouts, 3, -0.6,'3', /data
xyouts, 0.7,0.8,period + ' min period',/normal


;Plot straight line connections b/t each sc with the color of the line indicating the correlation
;Sort by color so that the best correlations plot over the weaker ones
st = sort(datavals)
datavals2 = (datavals[st])
xva2 = xva[st]
xvb2 = xvb[st]
yva2 = yva[st]
yvb2 = yvb[st]
for i=0,n_elements(hc3m)-1 do begin  $
	print,datavals[i] & $
	if finite(hc3m[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
;oplot,[xva2,xva2],[yva2,yva2],psym=4
;oplot,[xvb2,xvb2],[yvb2,yvb2],psym=4,color=220

pclose





