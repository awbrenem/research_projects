;pro combine_barrel_data,payload,dates,ephem=ephem,fspc=fspc



;pro combine_barrel_data,payload,dates
;data = [0.]
;tms = [0d]
;n = n_elements(dates)

;;Load and store peak detector data
;for i=0,n-1 do begin
;	rbsp_load_barrel_lc,payload,dates[i],type='rcnt'
;	get_data,'PeakDet_' + payload,data=d

;	if is_struct(d) then data = [data,d.y]
;	if is_struct(d) then tms = [tms,d.x]

;	d=0
;endfor

;data = data[1:n_elements(data)-1]
;tms = tms[1:n_elements(tms)-1]
;store_data,'PeakDet_' + payload,data={x:tms,y:data}


;data = [0.]
;tms = [0d]

;;Load and store Lshell data
;for i=0,n-1 do begin
;	rbsp_load_barrel_lc,payload,dates[i],type='ephm'
;	get_data,'L_Kp2_' + payload,data=d

;	if is_struct(d) then data = [data,d.y]
;	if is_struct(d) then tms = [tms,d.x]

;	d=0
;endfor

;data = data[1:n_elements(data)-1]
;tms = tms[1:n_elements(tms)-1]
;store_data,'L_' + payload,data={x:tms,y:data}

;end



;-------------------------------------------------------------------------

pro jan_multi_day_correlations





tplot_options,'title','from jan_multi_day_correlations.pro'

date = '2014-01-01'
rbspx = 'rbspa'
;timespan,date,18,/days
timespan,date,20,/days







rbsp_efw_init

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

charsz_plot = 0.8  ;character size for plots
charsz_win = 1.2
!p.charsize = charsz_win
tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1


dates = '2014-01-' + ['01','02','03','04','05','06','07','08','09','10','11','12','13','14',$
	'15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30']



payloads = ['i','k','l','m','n','o','p','q','t','a','b','c','d','e','f','x','w','y']


for j=0,n_elements(payloads)-1 do begin
	combine_barrel_data,'2' + strupcase(payloads[j]),dates
endfor

for j=0,n_elements(payloads)-1 do begin
	tinterpol_mxn,'L_'+payloads[j]
endfor



for j=0,n_elements(payloads)-1 do tinterpol_mxn,'L_2'+strupcase(payloads[j]),'PeakDet_2' + strupcase(payloads[j])


!p.multi = [0,0,2]

plot,[0,0],xrange=[1,25],yrange=[0,20000],/nodata,xstyle=1,ystyle=1,$
	xtitle='Lshell of BARREL balloons',ytitle='PeakDet counts'


;for j=0,n_elements(payloads)-1 do begin $
;	get_data,'L_2' + strupcase(payloads[j]),data=l   & $
;	get_data,'PeakDet_2' + strupcase(payloads[j]),data=pk   & $
;	oplot,l.y,pk.y

for j=0,n_elements(payloads)-1 do begin
	get_data,'L_2' + strupcase(payloads[j]),data=l
	get_data,'PeakDet_2' + strupcase(payloads[j]),data=pk
	oplot,l.y,pk.y
endfor

for j=0,n_elements(payloads)-1 do begin
	get_data,'L_2' + strupcase(payloads[j]),data=l
	get_data,'PeakDet_2' + strupcase(payloads[j]),data=pk
	oplot,l.y,pk.y
endfor



stop



stop







stop
combine_barrel_data,'2L',dates
tplot,['PeakDet_2L','L_2L']
stop
combine_barrel_data,'2X',dates
tplot,['PeakDet_2X','L_2X']
stop


get_data,'PeakDet_2X',data=pk

tinterpol_mxn,'L_2X',pk.x,newname='L_2X'
get_data,'L_2X',data=l

plot,l.y,pk.y,xrange=[0,20],yrange=[0,20000]





;t0 = time_double('2014-01-01/00:00')
;t1 = time_double('2014-01-08/22:00')

rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,'a',/no_spice_load;,/hires
rbsp_efw_vxb_subtract_crib,'b',/no_spice_load;,/hires
rbsp_load_emfisis,probe='a',coord='gse',cadence='1sec',level='l3'
rbsp_load_emfisis,probe='b',coord='gse',cadence='1sec',level='l3'

dif_data,'rbspa_state_lshell','rbspb_state_lshell',newname='rbsp_state_lshell_diff'

;-----------------------------------------------
rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspa_efw_vsvy_V1',data=v1
get_data,'rbspa_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densitya',data={x:v1.x,y:density}
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densityb',data={x:v1.x,y:density}


ylim,'density?',1,10000,1
options,'densitya','ytitle','density'+strupcase('a')+'!Ccm^-3'
options,'densityb','ytitle','density'+strupcase('b')+'!Ccm^-3'
;-----------------------------------------------
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
store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'

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
store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,'Bfield_hissintb'

;-----------------------------------------------
;MAGEIS file
pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
fnt = 'rbspa_rel02_ect-mageis-L2_20140106_v3.0.0.cdf'
cdf2tplot,file=pn+fnt
get_data,'FESAa',data=dd
store_data,'FESAa',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
get_data,'FESAa',data=dd
store_data,'fesaa_2mev',data={x:dd.x,y:dd.y[*,21]}
ylim,'fesaa_2mev',0.02,100,1
ylim,'FESAa',30,4000,1
tplot,'FESAa'
zlim,'FESAa',0,1d5

pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
fnt = 'rbspb_rel02_ect-mageis-L2_20140106_v3.0.0.cdf'
cdf2tplot,file=pn+fnt
get_data,'FESAb',data=dd
store_data,'FESAb',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
get_data,'FESAb',data=dd
store_data,'fesab_2mev',data={x:dd.x,y:dd.y[*,21]}
ylim,'fesab_2mev',0.02,100,1
ylim,'FESAb',30,4000,1
tplot,'FESAb'
zlim,'FESAb',0,1d5

;-----------------------------------------------

payloads = ['2X']
rbsp_load_barrel_lc,payloads,'2014-01-05',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan05'
rbsp_load_barrel_lc,payloads,'2014-01-06',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='rcnt'
copy_data,'PeakDet_2X','PeakDet_2X_jan11'

get_data,'PeakDet_2X_jan05',data=dd1
get_data,'PeakDet_2X_jan06',data=dd2
get_data,'PeakDet_2X_jan07',data=dd3
get_data,'PeakDet_2X_jan08',data=dd4
get_data,'PeakDet_2X_jan09',data=dd5
get_data,'PeakDet_2X_jan10',data=dd6
get_data,'PeakDet_2X_jan11',data=dd7

data = [dd1.y,dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y]
tms = [dd1.x,dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x]
store_data,'PeakDet_2X',data={x:tms,y:data}



rbsp_load_barrel_lc,payloads,'2014-01-05',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan05'
rbsp_load_barrel_lc,payloads,'2014-01-06',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='ephm'
copy_data,'L_Kp2_2X','L_2X_jan11'


get_data,'L_2X_jan05',data=dd5
get_data,'L_2X_jan06',data=dd6
get_data,'L_2X_jan07',data=dd7
get_data,'L_2X_jan08',data=dd8
get_data,'L_2X_jan09',data=dd9
get_data,'L_2X_jan10',data=dd10
get_data,'L_2X_jan11',data=dd11

data = [dd1.y,dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y]
tms = [dd1.x,dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x]
store_data,'L_2X',data={x:tms,y:data}
ylim,'L_2X',0,20





;-----------------------------------------------
payloads = ['2K']
rbsp_load_barrel_lc,payloads,'2014-01-05',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan05'
rbsp_load_barrel_lc,payloads,'2014-01-06',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='rcnt'
copy_data,'PeakDet_2K','PeakDet_2K_jan11'

get_data,'PeakDet_2K_jan05',data=dd1
get_data,'PeakDet_2K_jan06',data=dd2
get_data,'PeakDet_2K_jan07',data=dd3
get_data,'PeakDet_2K_jan08',data=dd4
get_data,'PeakDet_2K_jan09',data=dd5
get_data,'PeakDet_2K_jan10',data=dd6
get_data,'PeakDet_2K_jan11',data=dd7

data = [dd1.y,dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y]
tms = [dd1.x,dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x]
store_data,'PeakDet_2K',data={x:tms,y:data}



rbsp_load_barrel_lc,payloads,'2014-01-05',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan05'
rbsp_load_barrel_lc,payloads,'2014-01-06',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='ephm'
copy_data,'L_Kp2_2K','L_2K_jan11'


get_data,'L_2K_jan05',data=dd5
get_data,'L_2K_jan06',data=dd6
get_data,'L_2K_jan07',data=dd7
get_data,'L_2K_jan08',data=dd8
get_data,'L_2K_jan09',data=dd9
get_data,'L_2K_jan10',data=dd10
get_data,'L_2K_jan11',data=dd11

data = [dd1.y,dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y]
tms = [dd1.x,dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x]
store_data,'L_2K',data={x:tms,y:data}
ylim,'L_2K',0,20





;-----------------------------------------------
payloads = ['2L']
rbsp_load_barrel_lc,payloads,'2014-01-06',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan11'
rbsp_load_barrel_lc,payloads,'2014-01-12',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan12'
rbsp_load_barrel_lc,payloads,'2014-01-13',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan13'
rbsp_load_barrel_lc,payloads,'2014-01-14',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan14'
rbsp_load_barrel_lc,payloads,'2014-01-15',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan15'
rbsp_load_barrel_lc,payloads,'2014-01-16',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan16'
rbsp_load_barrel_lc,payloads,'2014-01-17',type='rcnt'
copy_data,'PeakDet_2L','PeakDet_2L_jan18'

get_data,'PeakDet_2L_jan06',data=dd2
get_data,'PeakDet_2L_jan07',data=dd3
get_data,'PeakDet_2L_jan08',data=dd4
get_data,'PeakDet_2L_jan09',data=dd5
get_data,'PeakDet_2L_jan10',data=dd6
get_data,'PeakDet_2L_jan11',data=dd7
get_data,'PeakDet_2L_jan12',data=dd8
get_data,'PeakDet_2L_jan13',data=dd9
get_data,'PeakDet_2L_jan14',data=dd10
get_data,'PeakDet_2L_jan15',data=dd11
get_data,'PeakDet_2L_jan16',data=dd12

data = [dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y,dd8.y,dd9.y,dd10.y,dd11.y,dd12.y]
tms = [dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x,dd8.x,dd9.x,dd10.x,dd11.x,dd12.x]
store_data,'PeakDet_2L',data={x:tms,y:data}



rbsp_load_barrel_lc,payloads,'2014-01-06',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan11'
rbsp_load_barrel_lc,payloads,'2014-01-12',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan12'
rbsp_load_barrel_lc,payloads,'2014-01-13',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan13'
rbsp_load_barrel_lc,payloads,'2014-01-14',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan14'
rbsp_load_barrel_lc,payloads,'2014-01-15',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan15'
rbsp_load_barrel_lc,payloads,'2014-01-16',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan16'
rbsp_load_barrel_lc,payloads,'2014-01-17',type='ephm'
copy_data,'L_Kp2_2L','L_2L_jan18'




get_data,'L_2L_jan06',data=dd2
get_data,'L_2L_jan07',data=dd3
get_data,'L_2L_jan08',data=dd4
get_data,'L_2L_jan09',data=dd5
get_data,'L_2L_jan10',data=dd6
get_data,'L_2L_jan11',data=dd7
get_data,'L_2L_jan12',data=dd8
get_data,'L_2L_jan13',data=dd9
get_data,'L_2L_jan14',data=dd10
get_data,'L_2L_jan15',data=dd11
get_data,'L_2L_jan16',data=dd12

data = [dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y,dd8.y,dd9.y,dd10.y,dd11.y,dd12.y]
tms = [dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x,dd8.x,dd9.x,dd10.x,dd11.x,dd12.x]
store_data,'L_2L',data={x:tms,y:data}


;----------------------------------------------------
payloads = ['2I']
rbsp_load_barrel_lc,payloads,'2014-01-01',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan01'
rbsp_load_barrel_lc,payloads,'2014-01-02',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan02'
rbsp_load_barrel_lc,payloads,'2014-01-03',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan03'
rbsp_load_barrel_lc,payloads,'2014-01-04',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan04'
rbsp_load_barrel_lc,payloads,'2014-01-05',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan05'
rbsp_load_barrel_lc,payloads,'2014-01-06',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan11'
rbsp_load_barrel_lc,payloads,'2014-01-12',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan12'
rbsp_load_barrel_lc,payloads,'2014-01-13',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan13'
rbsp_load_barrel_lc,payloads,'2014-01-14',type='rcnt'
copy_data,'PeakDet_2I','PeakDet_2I_jan14'

get_data,'PeakDet_2I_jan01',data=dd1
get_data,'PeakDet_2I_jan02',data=dd2
get_data,'PeakDet_2I_jan03',data=dd3
get_data,'PeakDet_2I_jan04',data=dd4
get_data,'PeakDet_2I_jan05',data=dd5
get_data,'PeakDet_2I_jan06',data=dd6
get_data,'PeakDet_2I_jan07',data=dd7
get_data,'PeakDet_2I_jan08',data=dd8
get_data,'PeakDet_2I_jan09',data=dd9
get_data,'PeakDet_2I_jan10',data=dd10
get_data,'PeakDet_2I_jan11',data=dd11
get_data,'PeakDet_2I_jan12',data=dd12
get_data,'PeakDet_2I_jan13',data=dd13
get_data,'PeakDet_2I_jan14',data=dd14

data = [dd1.y,dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y,dd8.y,dd9.y,dd10.y,dd11.y,dd12.y,dd13.y,dd14.y]
tms = [dd1.x,dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x,dd8.x,dd9.x,dd10.x,dd11.x,dd12.x,dd13.x,dd14.x]
store_data,'PeakDet_2I',data={x:tms,y:data}



rbsp_load_barrel_lc,payloads,'2014-01-01',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan01'
rbsp_load_barrel_lc,payloads,'2014-01-02',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan02'
rbsp_load_barrel_lc,payloads,'2014-01-03',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan03'
rbsp_load_barrel_lc,payloads,'2014-01-04',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan04'
rbsp_load_barrel_lc,payloads,'2014-01-05',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan05'
rbsp_load_barrel_lc,payloads,'2014-01-06',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan06'
rbsp_load_barrel_lc,payloads,'2014-01-07',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan07'
rbsp_load_barrel_lc,payloads,'2014-01-08',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan08'
rbsp_load_barrel_lc,payloads,'2014-01-09',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan09'
rbsp_load_barrel_lc,payloads,'2014-01-10',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan10'
rbsp_load_barrel_lc,payloads,'2014-01-11',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan11'
rbsp_load_barrel_lc,payloads,'2014-01-12',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan12'
rbsp_load_barrel_lc,payloads,'2014-01-13',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan13'
rbsp_load_barrel_lc,payloads,'2014-01-14',type='ephm'
copy_data,'L_Kp2_2I','L_2I_jan14'


get_data,'L_2I_jan01',data=dd1
get_data,'L_2I_jan02',data=dd2
get_data,'L_2I_jan03',data=dd3
get_data,'L_2I_jan04',data=dd4
get_data,'L_2I_jan05',data=dd5
get_data,'L_2I_jan06',data=dd6
get_data,'L_2I_jan07',data=dd7
get_data,'L_2I_jan08',data=dd8
get_data,'L_2I_jan09',data=dd9
get_data,'L_2I_jan10',data=dd10
get_data,'L_2I_jan11',data=dd11
get_data,'L_2I_jan12',data=dd12
get_data,'L_2I_jan13',data=dd13
get_data,'L_2I_jan14',data=dd14

data = [dd1.y,dd2.y,dd3.y,dd4.y,dd5.y,dd6.y,dd7.y,dd8.y,dd9.y,dd10.y,dd11.y,dd12.y,dd13.y,dd14.y]
tms =  [dd1.x,dd2.x,dd3.x,dd4.x,dd5.x,dd6.x,dd7.x,dd8.x,dd9.x,dd10.x,dd11.x,dd12.x,dd13.x,dd14.x]
store_data,'L_2I',data={x:tms,y:data}
ylim,'L_2I',0,20









;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K',data={x:xv,y:yv}
options,'PeakDet_2K','colors',250

get_data,'PeakDet_2L',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2L',data={x:xv,y:yv}
options,'PeakDet_2L','colors',250

get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250

;--------------------------------------------------


get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
times = esvy.x






;Transform Bfield into MGSE
get_data,'rbspa_spinaxis_direction_gse',data=wsc
wsc_gse = reform(wsc.y[0,*])
rbsp_gse2mgse,'rbspa_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbspa_emfisis_l3_1sec_mgse_Mag'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag',times,newname='rbspa_emfisis_l3_1sec_mgse_Mag'


get_data,'FESAa',data=fesa
store_data,'fesaa30',data={x:fesa.x,y:fesa.y[*,3]}
store_data,'fesaa54',data={x:fesa.x,y:fesa.y[*,4]}
store_data,'fesaa80',data={x:fesa.x,y:fesa.y[*,5]}
store_data,'fesaa108',data={x:fesa.x,y:fesa.y[*,6]}
store_data,'fesaa144',data={x:fesa.x,y:fesa.y[*,8]}

get_data,'FPSAa',data=fpsa
store_data,'fpsaa58',data={x:fpsa.x,y:fpsa.y[*,0]}
store_data,'fpsaa70',data={x:fpsa.x,y:fpsa.y[*,1]}
store_data,'fpsaa83',data={x:fpsa.x,y:fpsa.y[*,2]}
store_data,'fpsaa99',data={x:fpsa.x,y:fpsa.y[*,3]}
store_data,'fpsaa118',data={x:fpsa.x,y:fpsa.y[*,4]}



;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************

;t0z = '2014-01-06/20:00'
;t1z = '2014-01-06/22:00'


;----------
;Background field direction
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag',60.*0.168
copy_data,'rbspa_emfisis_l3_1sec_mgse_Mag_smoothed','rbspa_emfisis_l3_1sec_mgse_Mag_sp'
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
rbsp_downsample,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_smoothed',1/2.

rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp',60.*20
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_sp','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend']
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend',60.*20.
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
store_data,'bcomb',data=['rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
options,'bcomb','colors',[0,250]
tplot,'bcomb'
fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_smoothed_DS')
tplot,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_FA_minvar'
split_vec,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend'
;-----------
;Background field using GSEz
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag',60.*0.168
copy_data,'rbspa_emfisis_l3_1sec_gse_Mag_smoothed','rbspa_emfisis_l3_1sec_gse_Mag_sp'
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_sp',60.*20.
tplot,['rbspa_emfisis_l3_1sec_gse_Mag_sp','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend']
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend',60.*20.
tplot,['rbspa_emfisis_l3_1sec_gse_Mag','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend']
split_vec,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend'
;----------
;Density
;rbsp_detrend,'densitya',60.*0.168
;copy_data,'densitya','densitya_sp'
;tplot,['densitya','densitya_sp']
;rbsp_detrend,'densitya_sp',60.*20.
;tplot,['densitya_sp','densitya_sp_detrend']
;rbsp_detrend,'densitya_sp_detrend',60.*20.
;tplot,['densitya_sp_detrend','densitya_sp_detrend_detrend']
;store_data,'dcomb',data=['densitya_sp_detrend','densitya_sp_detrend_detrend']
;options,'dcomb','colors',[0,250]
;tplot,'dcomb'
;----------
;FESA30
;rbsp_detrend,'fesa30',60.*0.168
;copy_data,'fesa30','fesa30_sp'
;tplot,['fesa30','fesa30_sp']
;rbsp_detrend,'fesa30_sp',60.*20.
;tplot,['fesa30_sp','fesa30_sp_detrend']
;rbsp_detrend,'fesa30_sp_detrend',60.*20.
;tplot,['fesa30_sp','fesa30_sp_detrend','fesa30_sp_detrend_detrend']
;----------
;FESA54
;rbsp_detrend,'fesa54',60.*0.168
;copy_data,'fesa54','fesa54_sp'
;tplot,['fesa54','fesa54_sp']
;rbsp_detrend,'fesa54_sp',60.*20.
;tplot,['fesa54_sp','fesa54_sp_detrend']
;rbsp_detrend,'fesa54_sp_detrend',60.*20.
;tplot,['fesa54_sp','fesa54_sp_detrend','fesa54_sp_detrend_detrend']
;----------
;FESA80
;rbsp_detrend,'fesa80',60.*0.168
;copy_data,'fesa80','fesa80_sp'
;tplot,['fesa80','fesa80_sp']
;rbsp_detrend,'fesa80_sp',60.*20.
;tplot,['fesa80_sp','fesa80_sp_detrend']
;rbsp_detrend,'fesa80_sp_detrend',60.*20.
;tplot,['fesa80_sp','fesa80_sp_detrend','fesa80_sp_detrend_detrend']
;----------
;FESA108
;rbsp_detrend,'fesa108',60.*0.168
;copy_data,'fesa108','fesa108_sp'
;tplot,['fesa108','fesa108_sp']
;rbsp_detrend,'fesa108_sp',60.*20.
;tplot,['fesa108_sp','fesa108_sp_detrend']
;rbsp_detrend,'fesa108_sp_detrend',60.*20.
;tplot,['fesa108_sp','fesa108_sp_detrend','fesa108_sp_detrend_detrend']
;----------
;FESA144
;rbsp_detrend,'fesa144',60.*0.168
;copy_data,'fesa144','fesa144_sp'
;tplot,['fesa144','fesa144_sp']
;rbsp_detrend,'fesa144_sp',60.*20.
;tplot,['fesa144_sp','fesa144_sp_detrend']
;rbsp_detrend,'fesa144_sp_detrend',60.*20.
;tplot,['fesa144_sp','fesa144_sp_detrend','fesa144_sp_detrend_detrend']
;----------
;Bfield hissint
;rbsp_detrend,'Bfield_hissint',60.*0.168
;copy_data,'Bfield_hissint','Bfield_hissint_sp'
;tplot,['Bfield_hissint','Bfield_hissint_sp']
;rbsp_detrend,'Bfield_hissint_sp',60.*20.
;tplot,['Bfield_hissint_sp','Bfield_hissint_sp_detrend']
;rbsp_detrend,'Bfield_hissint_sp_detrend',60.*40.
;tplot,['Bfield_hissint_sp_detrend','Bfield_hissint_sp_detrend_detrend']
;store_data,'hcomb',data=['Bfield_hissint_sp_detrend','Bfield_hissint_sp_detrend_detrend']
;options,'hcomb','colors',[0,250]
;tplot,'hcomb'
;----------
;PeakDet_2K
;rbsp_detrend,'PeakDet_2K',60.*0.168
;copy_data,'PeakDet_2K','PeakDet_2K_sp'
;tplot,['PeakDet_2K','PeakDet_2K_sp']
;rbsp_detrend,'PeakDet_2K_sp',60.*20.
;tplot,['PeakDet_2K_sp','PeakDet_2K_sp_detrend']
;rbsp_detrend,'PeakDet_2K_sp_detrend',60.*40.
;tplot,['PeakDet_2K_sp_detrend','PeakDet_2K_sp_detrend_detrend']
;store_data,'pcomb',data=['PeakDet_2K_sp_detrend','PeakDet_2K_sp_detrend_detrend']
;options,'pcomb','colors',[0,250]
;tplot,'pcomb'



;tplot_options,'title','products for correlation...12sec to 20min periods allowed'
;
;ylim,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',-4,4
;tplot,['PeakDet_2K_sp_detrend_detrend','Bfield_hissint_sp_detrend_detrend','densitya_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend_detrend','fesa54_sp_detrend_detrend','fesa80_sp_detrend_detrend','fesa108_sp_detrend_detrend','fesa144_sp_detrend_detrend']
;tplot,['PeakDet_2K_sp_detrend_detrend','Bfield_hissint_sp_detrend_detrend','densitya_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend_detrend','fesa54_sp_detrend_detrend']



;Run cross-correlations

;tinterpol_mxn,'Bfield_hissint_sp_detrend_detrend','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'densitya_sp_detrend_detrend','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'fesa30_sp_detrend_detrend','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'fesa54_sp_detrend_detrend','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'fesa80_sp_detrend_detrend','PeakDet_2K_sp_detrend_detrend'
;tinterpol_mxn,'fesa108_sp_detrend_detrend','PeakDet_2K_sp_detrend_detrend'

tinterpol_mxn,'Bfield_hissint','PeakDet_2K'


;T1='2014-01-06/19:00:00'
;T2='2014-01-06/21:50:00'
T1='2014-01-01/00:00:00'
T2='2014-01-07/24:00:00'



tlimit,T1,T2
;tplot,['PeakDet_2K_sp_detrend_detrend','Bfield_hissint_sp_detrend_detrend',$
;'densitya_sp_detrend_detrend','rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z',$
;'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',$
;'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x','fesa30_sp_detrend_detrend',$
;'fesa54_sp_detrend_detrend','fesa80_sp_detrend_detrend'];,'fesa108_sp_detrend_detrend','fesa144_sp_detrend_detrend']


Results1=cross_spec_tplot('PeakDet_2K',0,'Bfield_hissinta',0,T1,T2,sub_interval=3,overlap_index=4)
Results2=cross_spec_tplot('PeakDet_2L',0,'Bfield_hissinta',0,T1,T2,sub_interval=3,overlap_index=4)
Results3=cross_spec_tplot('PeakDet_2I',0,'Bfield_hissinta',0,T1,T2,sub_interval=3,overlap_index=4)
Results3=cross_spec_tplot('Bfield_hissinta',0,'Bfield_hissintb',0,T1,T2,sub_interval=3,overlap_index=4)


;Results1=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'Bfield_hissint_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results2=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'densitya_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results3=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results4=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results5=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'fesa30_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results6=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'fesa54_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results8=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'fesa80_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results9=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'fesa108_sp_detrend_detrend_interp',0,T1,T2,sub_interval=3,overlap_index=4)
;Results10=cross_spec_tplot('PeakDet_2K_sp_detrend_detrend',0,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z',0,T1,T2,sub_interval=3,overlap_index=4)

Time_rbsp=strmid(T1,0,10)+'_'+strmid(T1,11,2)+strmid(T1,14,2)+'UT'+'_to_'+strmid(T2,0,10)+'_'+strmid(T2,11,2)+strmid(T2,14,2)+'UT'


;plot power spectra
!p.charsize = 1.8
!p.multi = [0,0,7]
Plot,Results1[*,0],Results1[*,3],xtitle='f, Hz', ytitle='Power precip (counts^2/Hz)',title=rbspx+time_rbsp,xrange=[0,0.01],yrange=[1d5,1d7],/ylog
oplot,[0.0014,0.0014],[1,10d9],thick=2
oplot,[0.005,0.005],[1,10d9],thick=2
Plot,Results1[*,0],Results1[*,4],xtitle='f, Hz', ytitle='Power hiss (nT^2/Hz)',xrange=[0,0.01],yrange=[1d3,1d5],/ylog
oplot,[0.0014,0.0014],[1,10d9],thick=2
oplot,[0.005,0.005],[1,10d9],thick=2
Plot,Results2[*,0],Results2[*,4],xtitle='f, Hz', ytitle='Power dens (dens^2/Hz)',xrange=[0,0.01],yrange=[1d3,1d5],/ylog
oplot,[0.0014,0.0014],[1,10d9],thick=2
oplot,[0.005,0.005],[1,10d9],thick=2
Plot,Results10[*,0],Results10[*,4],xtitle='f, Hz', ytitle='Power BzGSE (nT^2/Hz)',xrange=[0,0.01],yrange=[0,60]
oplot,[0.0014,0.0014],[0,10d9],thick=2
oplot,[0.005,0.005],[0,10d9],thick=2
Plot,Results3[*,0],Results3[*,4],xtitle='f, Hz', ytitle='Power Bz (nT^2/Hz)',xrange=[0,0.01],yrange=[0,60]
oplot,[0.0014,0.0014],[0,10d9],thick=2
oplot,[0.005,0.005],[0,10d9],thick=2
Plot,Results4[*,0],Results4[*,4],xtitle='f, Hz', ytitle='Power Bx (nT^2/Hz)',xrange=[0,0.01],yrange=[0,4]
oplot,[0.0014,0.0014],[0,10d9],thick=2
oplot,[0.005,0.005],[0,10d9],thick=2
Plot,Results5[*,0],Results5[*,4],xtitle='f, Hz', ytitle='Power FESAa30 (counts^2/Hz)',xrange=[0,0.01],yrange=[1d6,1d7],/ylog
oplot,[0.0014,0.0014],[1,10d9],thick=2
oplot,[0.005,0.005],[1,10d9],thick=2


!p.multi = [0,0,2]
Plot,Results1[*,0],Results1[*,2],xtitle='f, Hz', ytitle='Coherence_Ey_Ez',title=rbspx+time_rbsp,xrange=[0,0.04],/nodata
oplot,[0.0014,0.0014],[0,1],thick=2
oplot,[0.005,0.005],[0,1],thick=2
oPlot,Results1[*,0],Results1[*,2],color=0	;precip and hiss
oPlot,Results2[*,0],Results2[*,2],color=50  ;precip and dens
oPlot,Results10[*,0],Results10[*,2],color=80  ;precip and BzGSE
oPlot,Results3[*,0],Results3[*,2],color=100 ;precip and Bz
oPlot,Results4[*,0],Results4[*,2],color=150 ;precip and Bx
oPlot,Results5[*,0],Results5[*,2],color=200 ;precip and FESA30
oPlot,Results9[*,0],Results9[*,2],color=250 ;precip and FESA108

Plot,Results1[*,0],Results1[*,1]/!dtor,xtitle='f, Hz', ytitle='Phase_Ey_Ez',title=rbspx+time_rbsp,xrange=[0,0.04],yrange=[-180,180],ystyle=1,/nodata
oplot,[0.0014,0.0014],[-180,180],thick=2
oplot,[0.005,0.005],[-180,180],thick=2
oPlot,Results1[*,0],Results1[*,1]/!dtor,color=0	;precip and hiss
oPlot,Results2[*,0],Results2[*,1]/!dtor,color=50  ;precip and dens
oPlot,Results10[*,0],Results10[*,1]/!dtor,color=50  ;precip and BzGSE
oPlot,Results3[*,0],Results3[*,1]/!dtor,color=100 ;precip and Bz
oPlot,Results4[*,0],Results4[*,1]/!dtor,color=150 ;precip and Bx
oPlot,Results5[*,0],Results5[*,1]/!dtor,color=200 ;precip and FESA30
oPlot,Results9[*,0],Results9[*,1]/!dtor,color=250 ;precip and FESA108




v1 = 'PeakDet_2K'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hiss'
get_data,'Precip_hiss_coherence',data=coh
get_data,'Precip_hiss_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_hiss_coherence',data=coh
store_data,'Precip_hiss_phase',data=ph
options,'Precip_hiss_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'Precip_hiss_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['Precip_hiss_coherence','Precip_hiss_phase'],-0.001,0.01
tplot,['Precip_hiss_coherence','Precip_hiss_phase',v1,v2]
timebar,0.0014,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.005,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.005,varname='Precip_hiss_phase',/databar,thick=2


v1 = 'PeakDet_2L'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hiss'
get_data,'Precip_hiss_coherence',data=coh
get_data,'Precip_hiss_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_hiss_coherence',data=coh
store_data,'Precip_hiss_phase',data=ph
options,'Precip_hiss_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'Precip_hiss_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['Precip_hiss_coherence','Precip_hiss_phase'],-0.001,0.01
ylim,'PeakDet_2L',3000,6000
tplot,['Precip_hiss_coherence','Precip_hiss_phase',v1,v2]
timebar,0.0014,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.005,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.005,varname='Precip_hiss_phase',/databar,thick=2


window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.8

rbsp_detrend,'PeakDet_2I',60.*20.
rbsp_detrend,'Bfield_hissinta',60.*20.

v1 = 'PeakDet_2I_detrend'
v2 = 'Bfield_hissinta_detrend'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hiss'
get_data,'Precip_hiss_coherence',data=coh
get_data,'Precip_hiss_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_hiss_coherence',data=coh
store_data,'Precip_hiss_phase',data=ph
options,'Precip_hiss_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
options,'Precip_hiss_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
ylim,['Precip_hiss_coherence','Precip_hiss_phase'],-0.001,0.01
tplot,['Precip_hiss_coherence','Precip_hiss_phase',v1,v2]
timebar,0.0014,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.005,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.005,varname='Precip_hiss_phase',/databar,thick=2





;v1 = 'PeakDet_2K_sp_detrend_detrend'
;v2 = 'Bfield_hissint_sp_detrend_detrend_interp'
;dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hiss'
;get_data,'Precip_hiss_coherence',data=coh
;get_data,'Precip_hiss_phase',data=ph
;goo = where(coh.y le cormin)
;if goo[0] ne -1 then coh.y[goo] = !values.f_nan
;if goo[0] ne -1 then ph.y[goo] = !values.f_nan
;boo = where(finite(coh.y) eq 0)
;if boo[0] ne -1 then ph.y[boo] = !values.f_nan
;store_data,'Precip_hiss_coherence',data=coh
;store_data,'Precip_hiss_phase',data=ph
;options,'Precip_hiss_coherence','ytitle','Precip vs hiss!CCoherence!Cfreq[Hz]'
;options,'Precip_hiss_phase','ytitle','Precip vs hiss!CPhase!Cfreq[Hz]'
;ylim,['Precip_hiss_coherence','Precip_hiss_phase'],-0.001,0.01
;tplot,['Precip_hiss_coherence','Precip_hiss_phase',v1,v2]
;timebar,0.0014,varname='Precip_hiss_coherence',/databar,thick=2
;timebar,0.005,varname='Precip_hiss_coherence',/databar,thick=2
;timebar,0.0014,varname='Precip_hiss_phase',/databar,thick=2
;timebar,0.005,varname='Precip_hiss_phase',/databar,thick=2


v2 = 'densitya_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_dens'
get_data,'Precip_dens_coherence',data=coh
get_data,'Precip_dens_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_dens_coherence',data=coh
store_data,'Precip_dens_phase',data=ph
options,'Precip_dens_coherence','ytitle','Precip vs dens!CCoherence!Cfreq[Hz]'
options,'Precip_dens_phase','ytitle','Precip vs dens!CPhase!Cfreq[Hz]'
ylim,['Precip_dens_coherence','Precip_dens_phase'],-0.001,0.01
tplot,['Precip_dens_coherence','Precip_dens_phase',v1,v2]
timebar,0.0014,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.005,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_dens_phase',/databar,thick=2
timebar,0.005,varname='Precip_dens_phase',/databar,thick=2


v2 = 'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BzFA'
get_data,'Precip_BzFA_coherence',data=coh
get_data,'Precip_BzFA_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_BzFA_coherence',data=coh
store_data,'Precip_BzFA_phase',data=ph
options,'Precip_BzFA_coherence','ytitle','Precip vs BzFA!CCoherence!Cfreq[Hz]'
options,'Precip_BzFA_phase','ytitle','Precip vs BzFA!CPhase!Cfreq[Hz]'
ylim,['Precip_BzFA_coherence','Precip_BzFA_phase'],-0.001,0.01
tplot,['Precip_BzFA_coherence','Precip_BzFA_phase',v1,v2]
timebar,0.0014,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.005,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.005,varname='Precip_BzFA_phase',/databar,thick=2


v2 = 'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_x_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BxFA'
get_data,'Precip_BxFA_coherence',data=coh
get_data,'Precip_BxFA_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_BxFA_coherence',data=coh
store_data,'Precip_BxFA_phase',data=ph
options,'Precip_BxFA_coherence','ytitle','Precip vs BxFA!CCoherence!Cfreq[Hz]'
options,'Precip_BxFA_phase','ytitle','Precip vs BxFA!CPhase!Cfreq[Hz]'
ylim,['Precip_BxFA_coherence','Precip_BxFA_phase'],-0.001,0.01
tplot,['Precip_BxFA_coherence','Precip_BxFA_phase',v1,v2]
timebar,0.0014,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.005,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.005,varname='Precip_BxFA_phase',/databar,thick=2



v2 = 'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend_z'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_BzGSE'
get_data,'Precip_BzGSE_coherence',data=coh
get_data,'Precip_BzGSE_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_BzGSE_coherence',data=coh
store_data,'Precip_BzGSE_phase',data=ph
options,'Precip_BzGSE_coherence','ytitle','Precip vs BzGSE!CCoherence!Cfreq[Hz]'
options,'Precip_BzGSE_phase','ytitle','Precip vs BzGSE!CPhase!Cfreq[Hz]'
ylim,['Precip_BzGSE_coherence','Precip_BzGSE_phase'],-0.001,0.01
tplot,['Precip_BzGSE_coherence','Precip_BzGSE_phase',v1,v2]
timebar,0.0014,varname='Precip_BzGSE_coherence',/databar,thick=2
timebar,0.005,varname='Precip_BzGSE_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_BzGSE_phase',/databar,thick=2
timebar,0.005,varname='Precip_BzGSE_phase',/databar,thick=2


v2 = 'fesaa30_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesaa30'
get_data,'Precip_fesaa30_coherence',data=coh
get_data,'Precip_fesaa30_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesaa30_coherence',data=coh
store_data,'Precip_fesaa30_phase',data=ph
options,'Precip_fesaa30_coherence','ytitle','Precip vs FESAa30!CCoherence!Cfreq[Hz]'
options,'Precip_fesaa30_phase','ytitle','Precip vs FESAa30!CPhase!Cfreq[Hz]'
ylim,['Precip_fesaa30_coherence','Precip_fesaa30_phase'],-0.001,0.01
tplot,['Precip_fesaa30_coherence','Precip_fesaa30_phase',v1,v2]
timebar,0.0014,varname='Precip_fesaa30_coherence',/databar,thick=2
timebar,0.005,varname='Precip_fesaa30_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_fesaa30_phase',/databar,thick=2
timebar,0.005,varname='Precip_fesaa30_phase',/databar,thick=2



v2 = 'fesaa54_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesaa54'
get_data,'Precip_fesaa54_coherence',data=coh
get_data,'Precip_fesaa54_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesaa54_coherence',data=coh
store_data,'Precip_fesaa54_phase',data=ph
options,'Precip_fesaa54_coherence','ytitle','Precip vs fesaa54!CCoherence!Cfreq[Hz]'
options,'Precip_fesaa54_phase','ytitle','Precip vs fesaa54!CPhase!Cfreq[Hz]'
ylim,['Precip_fesaa54_coherence','Precip_fesaa54_phase'],-0.001,0.01
tplot,['Precip_fesaa54_coherence','Precip_fesaa54_phase',v1,v2]
timebar,0.0014,varname='Precip_fesaa54_coherence',/databar,thick=2
timebar,0.005,varname='Precip_fesaa54_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_fesaa54_phase',/databar,thick=2
timebar,0.005,varname='Precip_fesaa54_phase',/databar,thick=2

v2 = 'fesaa80_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesaa80'
get_data,'Precip_fesaa80_coherence',data=coh
get_data,'Precip_fesaa80_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesaa80_coherence',data=coh
store_data,'Precip_fesaa80_phase',data=ph
options,'Precip_fesaa80_coherence','ytitle','Precip vs fesaa80!CCoherence!Cfreq[Hz]'
options,'Precip_fesaa80_phase','ytitle','Precip vs fesaa80!CPhase!Cfreq[Hz]'
ylim,['Precip_fesaa80_coherence','Precip_fesaa80_phase'],-0.001,0.01
tplot,['Precip_fesaa80_coherence','Precip_fesaa80_phase',v1,v2]
timebar,0.0014,varname='Precip_fesaa80_coherence',/databar,thick=2
timebar,0.005,varname='Precip_fesaa80_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_fesaa80_phase',/databar,thick=2
timebar,0.005,varname='Precip_fesaa80_phase',/databar,thick=2


v2 = 'fesaa108_sp_detrend_detrend_interp'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_fesaa108'
get_data,'Precip_fesaa108_coherence',data=coh
get_data,'Precip_fesaa108_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan
boo = where(finite(coh.y) eq 0)
if boo[0] ne -1 then ph.y[boo] = !values.f_nan
store_data,'Precip_fesaa108_coherence',data=coh
store_data,'Precip_fesaa108_phase',data=ph
options,'Precip_fesaa108_coherence','ytitle','Precip vs fesaa108!CCoherence!Cfreq[Hz]'
options,'Precip_fesaa108_phase','ytitle','Precip vs fesaa108!CPhase!Cfreq[Hz]'
ylim,['Precip_fesaa108_coherence','Precip_fesaa108_phase'],-0.001,0.01
tplot,['Precip_fesaa108_coherence','Precip_fesaa108_phase',v1,v2]
timebar,0.0014,varname='Precip_fesaa108_coherence',/databar,thick=2
timebar,0.005,varname='Precip_fesaa108_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_fesaa108_phase',/databar,thick=2
timebar,0.005,varname='Precip_fesaa108_phase',/databar,thick=2




zlim,'*_coherence*',0.4,1
tplot,['Precip_hiss_coherence','Precip_dens_coherence','Precip_BzFA_coherence','Precip_BxFA_coherence','Precip_fesa30_coherence',v1]
timebar,0.0014,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.005,varname='Precip_hiss_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.005,varname='Precip_dens_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.005,varname='Precip_BzFA_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.005,varname='Precip_BxFA_coherence',/databar,thick=2
timebar,0.0014,varname='Precip_fesa30_coherence',/databar,thick=2
timebar,0.005,varname='Precip_fesa30_coherence',/databar,thick=2




;zlim,'*_coherence*',0.5,1
tplot,['Precip_hiss_phase','Precip_dens_phase','Precip_BzFA_phase','Precip_BxFA_phase','Precip_fesaa30_phase',v1]
timebar,0.0014,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.005,varname='Precip_hiss_phase',/databar,thick=2
timebar,0.0014,varname='Precip_dens_phase',/databar,thick=2
timebar,0.005,varname='Precip_dens_phase',/databar,thick=2
timebar,0.0014,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.005,varname='Precip_BzFA_phase',/databar,thick=2
timebar,0.0014,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.005,varname='Precip_BxFA_phase',/databar,thick=2
timebar,0.0014,varname='Precip_fesaa30_phase',/databar,thick=2
timebar,0.005,varname='Precip_fesaa30_phase',/databar,thick=2






tplot,'rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend'

tx0 = time_double('2014-01-06/19:00')
tx1 = time_double('2014-01-06/22:50')
ts = tsample('rbspa_emfisis_l3_1sec_gse_Mag_sp_detrend_detrend',[tx0,tx1],times=tms)
store_data,'Bwtmp',data={x:tms,y:ts}

nfft = 1024;./2.
sl = nfft/2.
twavpol,'Bwtmp',nopfft=nfft,steplength=sl

get_data,'Bwtmp_waveangle',data=wa
store_data,'Bwtmp_waveangle',data={x:wa.x,y:wa.y/!dtor,v:wa.v}

;Remove noise values
get_data,'Bwtmp_degpol',data=dp
goo = where(dp.y lt 0.7)
dp.y[goo] = !values.f_nan
store_data,'Bwtmp_degpol',data=dp
get_data,'Bwtmp_waveangle',data=dp
dp.y[goo] = !values.f_nan
store_data,'Bwtmp_waveangle',data=dp
get_data,'Bwtmp_elliptict',data=dp
dp.y[goo] = !values.f_nan
store_data,'Bwtmp_elliptict',data=dp
get_data,'Bwtmp_helict',data=dp
dp.y[goo] = !values.f_nan
store_data,'Bwtmp_helict',data=dp

ylim,'Bwtmp',-1,1
zlim,'Bwtmp_waveangle',0,90
ylim,['Bwtmp_powspec','Bwtmp_degpol','Bwtmp_waveangle','Bwtmp_elliptict','Bwtmp_helict','Bwtmp_pspec3'],0,0.01,0
zlim,'Bwtmp_powspec',0.1,10,1
tplot,['Bwtmp','Bwtmp_powspec','Bwtmp_degpol','Bwtmp_waveangle','Bwtmp_elliptict','Bwtmp_helict']




end
