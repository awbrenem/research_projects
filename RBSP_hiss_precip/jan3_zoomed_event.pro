tplot_options,'title','from jan3_zoomed_event.pro'

;date = '2014-01-06'
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



;--------------------------------------------------
payloads = ['2I','2W']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'
;rbsp_load_barrel_lc,payloads,date,type='ephm'
rbsp_load_barrel_lc,payloads,date


;--------------------------------------------------------
;EMFISIS file with hiss spec
pn = '~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/'
fnt = 'rbsp-a_WFR-spectral-matrix_emfisis-L2_20140103_v1.3.2.cdf'
cdf2tplot,file=pn+fnt
get_data,'BwBw',data=dd
store_data,'BwBw',data={x:dd.x,y:1000.*1000.*dd.y,v:reform(dd.v)}
options,'BwBw','spec',1
zlim,'BwBw',1d-6,100,1
ylim,'BwBw',20,1000,1
;-------------------------------------------------------

rbspx = 'rbsp' + probe
;t0 = time_double('2014-01-06/20:00')
;t1 = time_double('2014-01-06/22:00')
t0 = time_double('2014-01-03/19:30')
t1 = time_double('2014-01-03/22:30')
timespan, date


rbsp_efw_init	
!rbsp_efw.user_agent = ''
tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
	

rbsp_load_efw_spec,probe=probe,type='calibrated',/pt

rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='vsvy'
split_vec,rbspx + '_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,rbspx + '_efw_vsvy_V1',data=v1
get_data,rbspx + '_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'density'+probe,data={x:v1.x,y:density}
ylim,'density?',100,1000,1
options,'density'+probe,'ytitle','density'+strupcase(probe)+'!Ccm^-3'


;Integrate spec RMS amplitude
trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2
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
store_data,'Bfield_hissint',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint'



rbsp_detrend,'densitya',60.*10.
copy_data,'densitya_smoothed','densitya_smoothed1'      
rbsp_detrend,'densitya',60.*0.1667
tplot,['densitya_smoothed1','densitya_detrend'] 
   

get_data,'densitya_smoothed1',data=ds
get_data,'densitya_smoothed',data=d
dn_n = 100.*(d.y - ds.y)/ds.y

store_data,'dn_n',data={x:ds.x,y:dn_n}
tplot,['densitya_smoothed1','densitya_smoothed','dn_n']
;rbsp_detrend,['Bfield_hissint','PeakDet_2I','LC1_2I','dn_n'],60.*0.1667



tlimit,'2014-01-03/20:00','2014-01-03/20:14'   
;tlimit,'2014-01-03/19:45','2014-01-03/20:10'   
;tlimit,'2014-01-03/19:25','2014-01-03/19:45'
ylim,'rbspa_efw_64_spec4',20,400,1
zlim,'BwBw',1d-2,20,1
ylim,'BwBw',20,400,1
options,'BwBw','ytitle','BwBw'
options,'BwBw','ysubtitle','[pT^2/Hz]'
;zlim,'rbspa_efw_64_spec4',10,600,1
ylim,'PeakDet_2I',7000,12000
ylim,'PeakDet_2I_smoothed',7000,12000
ylim,'Bfield_hissint_smoothed',10,50
ylim,'dn_n',-40,40

tplot,['BwBw','Bfield_hissint_smoothed','PeakDet_2I_smoothed','dn_n']


tplot,['rbspa_efw_64_spec4','BwBw']
