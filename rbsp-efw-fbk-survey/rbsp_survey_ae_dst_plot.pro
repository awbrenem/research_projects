pro rbsp_survey_ae_dst_plot

get_data,'rbspa_fbk_pk',data=pk
get_data,'rbspa_ae',data=ae
get_data,'rbspa_dst',data=dst

plot,ae.y,pk.y,psym=2
plot,dst.y,pk.y,psym=1



;Find peak AE for each dt and use this value

dt = 12*3600. 

nbins = info.ndays * (86400./dt)


pk2 = fltarr(nbins)
ae2 = fltarr(nbins)
dst2 = fltarr(nbins)
pk2t = fltarr(nbins)
ae2t = fltarr(nbins)
dst2t = fltarr(nbins)



t0 = time_double(info.d0)
t1 = time_double(info.d0) + dt

for i=0,nbins-1 do begin	$
	wh = where((pk.x ge t0) and (pk.x le t1))  & $
	pktmp = pk.y[wh]	& $
	aetmp = ae.y[wh]	& $
	dsttmp = dst.y[wh]	& $
	pktmpt = pk.x[wh]	& $
	aetmpt = ae.x[wh]	& $
	dsttmpt = dst.x[wh]	& $
	pk2[i] = max(pktmp) 	& $
	ae2[i] = max(aetmp)	& $
	dst2[i] = min(dsttmp)	& $
	pk2t[i] = max(pktmpt)	& $
	ae2t[i] = max(aetmpt)	& $
	dst2t[i] = max(dsttmpt)	& $
	t0 = t0 + dt	& $
	t1 = t1 + dt

store_data,'ae2',data={x:ae2t,y:ae2}
store_data,'dst2',data={x:dst2t,y:dst2}
store_data,'pk2',data={x:pk2t,y:pk2}

tplot,['rbspa_ae','ae2']
tplot,['rbspa_dst','dst2']

get_data,'pk2',data=pk2
get_data,'ae2',data=ae2
get_data,'dst2',data=dst2

goo = where(pk2.y eq 0)
if goo[0] ne -1 then pk2.y[goo] = !values.f_nan

!p.multi = [0,0,2]
plot,ae2.y,pk2.y,psym=2,/ylog,yrange=[1,500],/xlog,xrange=[10,4000],ystyle=1,xstyle=1,$
	ytitle='FBK peak in '+ strtrim(string(dt/3600.,format='(i2)'),2) + ' hrs (mV/m)',$
	xtitle='AE peak in '+ strtrim(string(dt/3600.,format='(i2)'),2) + ' hrs (nT)',$
	title='2012-09-23 - 2013-03-15, amps>2.5 mV/m, 0.1fce<f<fce'
plot,abs(dst2.y),pk2.y,psym=2,/ylog,yrange=[1,500],/xlog,xrange=[1,400],ystyle=1,xstyle=1,$
	ytitle='FBK peak in '+ strtrim(string(dt/3600.,format='(i2)'),2) + ' hrs (mV/m)',$
	xtitle='|DST| peak in '+ strtrim(string(dt/3600.,format='(i2)'),2) + ' hrs (nT)'







