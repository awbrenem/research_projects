;Crib sheet to plot the peak/average values for a given day
;Plots this in:
;	-tplot form 
;	-as a peak vs average plot


date = '2012-11-14'
probe = 'a'
timespan,date
rbspx = 'rbsp' + probe

tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2

fbk13_binsL = [0.8,1.5,3,6,12,25,50,100,200,400,800,1600,3200]
fbk13_binsH = [1.5,3,6,12,25,50,100,200,400,800,1600,3200,6500]
fbk7_binsL = fbk13_binsL[lindgen(7)*2]
fbk7_binsH = fbk13_binsH[lindgen(7)*2]

fbk13_binsC = (fbk13_binsH + fbk13_binsL)/2.
fbk7_binsC = (fbk7_binsH + fbk7_binsL)/2.




yellow_to_orange

rbsp_load_efw_fbk,probe=probe,type='calibrated' 
rbsp_load_efw_spec,probe=probe,type='calibrated' 
rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'
rbsp_split_fbk,'a'


tplot,['rbspa_efw_64_spec0','rbspa_fbk1_13pk_12','rbspa_fbk1_13pk_11','rbspa_fbk1_13pk_10','rbspa_fbk1_13pk_9']



;Add the fce lines to the spec plot

get_data,rbspx+'_efw_64_spec0',data=dat
get_data,'rbspa_emfisis_l3_1sec_gse_Magnitude',data=magnit


fce = 28.*magnit.y
fce = interpol(fce,magnit.x,dat.x)

store_data,'fce',data={x:dat.x,y:fce}
store_data,'fce_2',data={x:dat.x,y:fce/2.}
store_data,'fci',data={x:dat.x,y:fce/1836.}
store_data,'flh',data={x:dat.x,y:sqrt(fce*fce/1836.)}

;add the FBk bin limits
store_data,'f13h',data={x:dat.x,y:replicate(fbk13_binsH[12],n_elements(dat.x))}
store_data,'f13l',data={x:dat.x,y:replicate(fbk13_binsL[12],n_elements(dat.x))}
store_data,'f12h',data={x:dat.x,y:replicate(fbk13_binsH[11],n_elements(dat.x))}
store_data,'f12l',data={x:dat.x,y:replicate(fbk13_binsL[11],n_elements(dat.x))}
store_data,'f11h',data={x:dat.x,y:replicate(fbk13_binsH[10],n_elements(dat.x))}
store_data,'f11l',data={x:dat.x,y:replicate(fbk13_binsL[10],n_elements(dat.x))}
store_data,'f10h',data={x:dat.x,y:replicate(fbk13_binsH[9],n_elements(dat.x))}
store_data,'f10l',data={x:dat.x,y:replicate(fbk13_binsL[9],n_elements(dat.x))}

options,['f13h','f12h','f11h','f10h','f10l'],'thick',2
store_data,'spec0comb',data=['rbspa_efw_64_spec0','fce','fce_2','fci','flh','f13h','f12h','f11h','f10h','f10l']






div_data,'rbspa_fbk1_13pk_12','rbspa_fbk1_13av_12',newname='diff12'
div_data,'rbspa_fbk1_13pk_11','rbspa_fbk1_13av_11',newname='diff11'
div_data,'rbspa_fbk1_13pk_10','rbspa_fbk1_13av_10',newname='diff10'
div_data,'rbspa_fbk1_13pk_9','rbspa_fbk1_13av_9',newname='diff9'

tplot,['rbspa_fbk1_13pk_12','rbspa_fbk1_13av_12','rbspa_efw_64_spec0','diff12','diff11','diff10','diff9']


;Plot only values corresponding to peak values above a threshold
minpk = 5.  ;mV/m
minav = 0.1
minpks = strtrim(floor(minpk),2)
minavs = strtrim(floor(minav),2)

get_data,'rbspa_fbk1_13pk_12',data=pk12
get_data,'rbspa_fbk1_13pk_11',data=pk11
get_data,'rbspa_fbk1_13pk_10',data=pk10
get_data,'rbspa_fbk1_13pk_9',data=pk9
get_data,'rbspa_fbk1_13av_12',data=av12
get_data,'rbspa_fbk1_13av_11',data=av11
get_data,'rbspa_fbk1_13av_10',data=av10
get_data,'rbspa_fbk1_13av_9',data=av9

get_data,'diff12',data=d12
get_data,'diff11',data=d11
get_data,'diff10',data=d10
get_data,'diff9',data=d9

g12 = where(pk12.y lt minpk)
g11 = where(pk11.y lt minpk)
g10 = where(pk10.y lt minpk)
g9 = where(pk9.y lt minpk)

if g12[0] ne -1 then d12.y[g12] = !values.f_nan
if g11[0] ne -1 then d11.y[g11] = !values.f_nan
if g10[0] ne -1 then d10.y[g10] = !values.f_nan
if g9[0] ne -1 then d9.y[g9] = !values.f_nan

f12 = where(av12.y lt minav)
f11 = where(av11.y lt minav)
f10 = where(av10.y lt minav)
f9 = where(av9.y lt minav)

if f12[0] ne -1 then d12.y[f12] = !values.f_nan
if f11[0] ne -1 then d11.y[f11] = !values.f_nan
if f10[0] ne -1 then d10.y[f10] = !values.f_nan
if f9[0] ne -1 then d9.y[f9] = !values.f_nan



store_data,'diff12r',data={x:d12.x,y:d12.y}
store_data,'diff11r',data={x:d12.x,y:d11.y}
store_data,'diff10r',data={x:d12.x,y:d10.y}
store_data,'diff9r',data={x:d12.x,y:d9.y}

options,'diff12r','ytitle','pk/avg!C3.2-6.5kHz!Cpk>'+minpks+'(mV/m)'
options,'diff11r','ytitle','pk/avg!C1.6-3.2kHz!Cpk>'+minpks+'(mV/m)'
options,'diff10r','ytitle','pk/avg!C0.8-1.8kHz!Cpk>'+minpks+'(mV/m)'
options,'diff9r','ytitle','pk/avg!C0.4-0.8kHz!Cpk>'+minpks+'(mV/m)'
options,['diff12r','diff11r','diff10r','diff9r'],'psym',4

ylim,['diff12r','diff11r','diff10r','diff9r'],0,50
ylim,'spec0comb',10,10000,1

store_data,'fcomb',data=['rbspa_fbk1_13pk_12','rbspa_fbk1_13pk_11','rbspa_fbk1_13pk_10','rbspa_fbk1_13pk_9']
options,'fcomb','colors',[10,50,210,250]
options,'fcomb','ytitle','FBK pk!C3.2-6.5(black)!C1.6-3.2(blue)!C0.8-1.8(orange)!C0.4-0.8(red)!CkHz!C(mV/m)'


store_data,'diffr_comb',data=['diff12r','diff11r','diff10r','diff9r']
options,'diffr_comb','colors',[10,50,210,250]
options,'diffr_comb','ytitle','pk/avg!C3.2-6.5(black)!C1.6-3.2(blue)!C0.8-1.8(orange)!C0.4-0.8(red)!CkHz!Cpk>'+minpks+'(mV/m)'
ylim,'diffr_comb',0,50

tplot_options,'title','FBK peak/average comparison!Cfor pk>'+minpks+'(mV/m)'
tplot,['fcomb','spec0comb','diffr_comb']



!p.charsize = 0.8
popen,'~/Desktop/fbk_pk2av_comp.ps'
tplot,['fcomb','spec0comb','diffr_comb']
pclose
!p.charsize = 1.4


;-------------------------------------------------------------
;Make a full-cadence plot of peak-vs-avg
;-------------------------------------------------------------

if g12[0] ne -1 then d12.y[g12] = !values.f_nan
if g11[0] ne -1 then d11.y[g11] = !values.f_nan
if g10[0] ne -1 then d10.y[g10] = !values.f_nan
if g9[0] ne -1 then d9.y[g9] = !values.f_nan

if f12[0] ne -1 then d12.y[f12] = !values.f_nan
if f11[0] ne -1 then d11.y[f11] = !values.f_nan
if f10[0] ne -1 then d10.y[f10] = !values.f_nan
if f9[0] ne -1 then d9.y[f9] = !values.f_nan

p12 = pk12.y
p11 = pk11.y
p10 = pk10.y
p9 = pk9.y
a12 = av12.y
a11 = av11.y
a10 = av10.y
a9 = av9.y

if g12[0] ne -1 then p12[g12] = !values.f_nan
if g11[0] ne -1 then p11[g11] = !values.f_nan
if g10[0] ne -1 then p10[g10] = !values.f_nan
if g9[0] ne -1 then p9[g9] = !values.f_nan
if g12[0] ne -1 then a12[g12] = !values.f_nan
if g11[0] ne -1 then a11[g11] = !values.f_nan
if g10[0] ne -1 then a10[g10] = !values.f_nan
if g9[0] ne -1 then a9[g9] = !values.f_nan

if f12[0] ne -1 then p12[f12] = !values.f_nan
if f11[0] ne -1 then p11[f11] = !values.f_nan
if f10[0] ne -1 then p10[f10] = !values.f_nan
if f9[0] ne -1 then p9[f9] = !values.f_nan
if f12[0] ne -1 then a12[f12] = !values.f_nan
if f11[0] ne -1 then a11[f11] = !values.f_nan
if f10[0] ne -1 then a10[f10] = !values.f_nan
if f9[0] ne -1 then a9[f9] = !values.f_nan


;*****************************************************
;Remove additional values that are not chorus

;	;ECH in the top FBK bin
;	t0 = time_double('2012-10-13/06:30')
;	t1 = time_double('2012-10-13/10:00')
;	goob = where((pk12.x ge t0) and (pk12.x le t1))
;	p12[goob] = !values.f_nan
;	a12[goob] = !values.f_nan


;Broadband bursts in all freq bins
	t0 = time_double('2012-11-14/01:30')
	t1 = time_double('2012-11-14/05:00')
	goob = where((pk12.x ge t0) and (pk12.x le t1))
	p12[goob] = !values.f_nan
	p11[goob] = !values.f_nan
	p10[goob] = !values.f_nan
	p9[goob] = !values.f_nan
	a12[goob] = !values.f_nan
	a11[goob] = !values.f_nan
	a10[goob] = !values.f_nan
	a9[goob] = !values.f_nan

;*****************************************************



pks = [p12,p11,p10,p9]
avs = [a12,a11,a10,a9]

tt = 'FBK chorus!C Instantaneous Peak vs average!C' + date + ' for amps>'+minpks+'(mV/m)'

plot,avs,pks,psym=3,xtitle='av (over 1/8s) (mV/m)',ytitle='pk (mV/m)',title=tt
;plot,avs,pks,/xlog,/ylog,xrange=[0.1,100],yrange=[10,100],psym=4,xtitle='av (over 1/8s) (mV/m)',ytitle='pk (mV/m)',title=tt



!p.charsize = 0.8
popen,'~/Desktop/peak_vs_average.ps'
plot,avs,pks,psym=3,xtitle='av (over 1/8s) (mV/m)',ytitle='pk (mV/m)',title=tt, Position=Aspect(1.0/1.0)
pclose
!p.charsize = 1.4


