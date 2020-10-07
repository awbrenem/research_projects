rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	


payloads = ['2I']
probe = 'a'
sc = 'a'

date = '2014-01-03'

t0 = date + '/' + '19:30'
t1 = date + '/' + '22:30'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,payloads,date,type='rcnt'
rbsp_load_barrel_lc,payloads,date,type='ephm'


rbsp_efw_position_velocity_crib,/noplot,/notrace






;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250



;rbsp_load_barrel_lc,payloads,date
rbsp_load_efw_spec,probe='a',type='calibrated'

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

store_data,'Bfield_hissinta',data={x:bu2.x,y:bt}
tplot,'Bfield_hissinta'


tinterpol_mxn,'PeakDet_2I','Bfield_hissinta'
tinterpol_mxn,'rbspa_state_mlt','Bfield_hissinta'
tinterpol_mxn,'rbspa_state_lshell','Bfield_hissinta'
tinterpol_mxn,'MLT_Kp2_T89c_2I','Bfield_hissinta'
tinterpol_mxn,'L_Kp2_2I','Bfield_hissinta'


get_data,'rbspa_state_mlt_interp',data=mlt_a
get_data,'rbspa_state_lshell_interp',data=lshell_a
get_data,'MLT_Kp2_T89c_2I_interp',data=mlt_2i
get_data,'L_Kp2_2I_interp',data=lshell_2i

t1z = (mlt_a.y - 12)*360./24.
t2z = (mlt_2I.y - 12)*360./24.
x1 = lshell_a.y * sin(t1z*!dtor)
y1 = lshell_a.y * cos(t1z*!dtor)
x2 = lshell_2I.y * sin(t2z*!dtor)
y2 = lshell_2I.y * cos(t2z*!dtor)
dai = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dai',data={x:mlt_a.x,y:dai}
store_data,'mai',data={x:mlt_a.x,y:(mlt_a.y-mlt_2i.y)}
store_data,'lai',data={x:mlt_a.x,y:(lshell_a.y-lshell_2i.y)}







;file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_06_200000_10deg.hdf5'
;file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_06_5deg.hdf5'
file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_03_193000.hdf5'

R2 = FILE_INFO(file)
;help,r2,/st

print,H5F_IS_HDF5(file)
result = h5_parse(file,/READ_DATA)

avebounce = transpose(result.avebounce._DATA)
avelocal =  transpose(result.avelocal._DATA)
energy = 1000.*result.energy._DATA   ;keV
time = time_double(time_string(result.time._DATA)) + 30.  ;shift bins by 30 seconds

store_data,'2I_avebounce',data={x:time,y:avebounce,v:energy}
options,'2I_avebounce','spec',1
zlim,'2I_avebounce',1d-8,1d-2,1
tplot,'2I_avebounce'
store_data,'2I_avebounce30',data={x:time,y:avebounce[*,30]}
store_data,'2I_avebounce50',data={x:time,y:avebounce[*,50]}
store_data,'2I_avebounce75',data={x:time,y:avebounce[*,75]}
store_data,'2I_avebounce150',data={x:time,y:avebounce[*,150]}

tots = avebounce[*,30] + avebounce[*,50] + avebounce[*,75] + avebounce[*,150]
store_data,'2I_avebouncetots',data={x:time,y:tots}
tplot,['2I_avebounce','2I_avebounce50','2I_avebouncetots']



tinterpol_mxn,'2I_avebounce50','PeakDet_2I_interp'
tinterpol_mxn,'2I_avebouncetots','PeakDet_2I_interp'



;Now let's limit all variables to range t0-t1 so that I can 
;do x-y plots
x = tsample('2I_avebounce50_interp',time_double([t0,t1]),times=tms)
store_data,'Daa',data={x:tms,y:x}
x = tsample('2I_avebouncetots_interp',time_double([t0,t1]),times=tms)
store_data,'DaaT',data={x:tms,y:x}
x = tsample('PeakDet_2I_interp',time_double([t0,t1]),times=tms)
store_data,'PeakDet_2I',data={x:tms,y:x}
x = tsample('Bfield_hissinta',time_double([t0,t1]),times=tms)
store_data,'Bfield_hissinta',data={x:tms,y:x}

tplot,['Daa','DaaT','PeakDet_2I','Bfield_hissinta']





get_data,'Daa',data=daa
get_data,'DaaT',data=daaT
get_data,'PeakDet_2I',data=pk
get_data,'Bfield_hissinta',data=b1
store_data,'Bfield_hissinta',data={x:b1.x,y:1000.*b1.y}
get_data,'Bfield_hissinta',data=b1
store_data,'Bfield_hissinta2',data={x:b1.x,y:b1.y^2}
get_data,'Bfield_hissinta2',data=b2


!p.charsize = 1.5
!p.multi = [0,0,4]
plot,pk.y-3500.,b1.y,psym=4,ytitle='Bw (pT)',xtitle='PeakDet2I_counts',/ylog,xrange=[0,1500],yrange=[1,300],ystyle=1
plot,pk.y-3500.,b2.y,psym=4,ytitle='Bw^2 (pT^2)',xtitle='PeakDet2I_counts',/ylog,xrange=[0,1500]
plot,pk.y-3500.,daa.y,psym=4,ytitle='<Daa>',xtitle='PeakDet2I_counts',/ylog,yrange=[1d-8,1d-2],xrange=[0,1500]
plot,pk.y-3500.,daaT.y,psym=4,ytitle='<DaaT>',xtitle='PeakDet2I_counts',/ylog,yrange=[1d-8,1d-2],xrange=[0,1500]



!p.charsize = 1.5
!p.multi = [0,0,4]
plot,pk.y-3500.,b1.y,psym=4,ytitle='Bw (pT)',xtitle='PeakDet2I_counts',xrange=[0,1500],yrange=[0,150],ystyle=1
plot,pk.y-3500.,b2.y,psym=4,ytitle='Bw^2 (pT^2)',xtitle='PeakDet2I_counts',xrange=[0,1500]
plot,pk.y-3500.,daa.y,psym=4,ytitle='<Daa>',xtitle='PeakDet2I_counts',xrange=[0,1500],yrange=[0,0.0005]
plot,pk.y-3500.,daaT.y,psym=4,ytitle='<DaaT>',xtitle='PeakDet2I_counts',xrange=[0,1500],yrange=[0,0.0005]


;--------------------------------------------------
;Detrend values - compare fluctuations in hiss with fluctuations in
;                 x-rays
;--------------------------------------------------

rbsp_detrend,'Bfield_hissinta',60.*15.
rbsp_detrend,'Bfield_hissinta2',60.*15.

tplot,['Bfield_hissinta_smoothed','Bfield_hissinta']
store_data,'Bcomb',data=['Bfield_hissinta_smoothed','Bfield_hissinta']

tplot,['Bfield_hissinta2_smoothed','Bfield_hissinta2']
store_data,'Bcomb2',data=['Bfield_hissinta2_smoothed','Bfield_hissinta2']

rbsp_detrend,'PeakDet_2I_interp',60.*15.
store_data,'2Icomb',data=['PeakDet_2I_interp_smoothed','PeakDet_2I_interp']

tplot,['Bcomb','Bcomb2','2Icomb']


tplot,['Bfield_hissinta_detrend','Bfield_hissinta2_detrend','PeakDet_2I_interp_detrend']

;; get_data,'Bfield_hissinta_detrend',data=b1d
;; ;; goo = where(b1d.y lt 0.)
;; ;; b1d.y[goo] = !values.f_nan
;; store_data,'Bfield_hissinta_detrend2',data={x:b1d.x,y:b1d.y}
;; store_data,'Bfield_hissinta2_detrend2',data={x:b1d.x,y:b1d.y^2}

get_data,'PeakDet_2I_interp_detrend',data=pk
;; goo = where(pk.y lt 0.)
;; pk.y[goo] = !values.f_nan
store_data,'PeakDet_2I_interp_detrend2',data={x:pk.x,y:pk.y}

rbsp_detrend,'Daa',60.*15.
store_data,'Dcomb',data=['Daa_smoothed','Daa']
tplot,'Dcomb'

rbsp_detrend,'DaaT',60.*15.
store_data,'DcombT',data=['DaaT_smoothed','DaaT']
tplot,'DcombT'

get_data,'Daa_detrend',data=d
;; goo = where(d.y lt 0.)
;; d.y[goo] = !values.f_nan
store_data,'Daa_detrend2',data={x:d.x,y:d.y}

get_data,'DaaT_detrend',data=d
;; goo = where(d.y lt 0.)
;; d.y[goo] = !values.f_nan
store_data,'DaaT_detrend2',data={x:d.x,y:d.y}

options,'PeakDet_2I_interp_detrend2','colors',250
tplot,['PeakDet_2I_interp_detrend2','Bfield_hissinta_detrend','Bfield_hissinta2_detrend','Daa_detrend2','DaaT_detrend2']

get_data,'Bfield_hissinta_detrend',data=b12
get_data,'Bfield_hissinta2_detrend',data=b22
get_data,'PeakDet_2I_interp_detrend',data=pk2
get_data,'Daa_detrend2',data=daa2
get_data,'DaaT_detrend2',data=daaT2



!p.charsize = 1.5
!p.multi = [0,0,4]
plot,pk2.y,b12.y,psym=4,ytitle='Bw fluctuations (pT)',xtitle='PeakDet2I_count fluctuations',xrange=[0,1000],yrange=[0,80]
plot,pk2.y,b22.y,psym=4,ytitle='Bw^2 fluctuations (pT^2)',xtitle='PeakDet2I_count fluctuations',xrange=[0,1000],yrange=[0,5000]
plot,pk2.y,daa2.y,psym=4,ytitle='<Daa> fluctuations',xtitle='PeakDet2I_count fluctuations',xrange=[0,1000],yrange=[0,0.0003]
plot,pk2.y,daaT2.y,psym=4,ytitle='<DaaT> fluctuations',xtitle='PeakDet2I_count fluctuations',xrange=[0,1000],yrange=[0,0.0003]


options,'PeakDet_2I_interp_detrend2','ytitle','xray counts!C2I!Cdetrend'
options,'Bfield_hissinta_detrend','ytitle','Bfield RMS amp!Cdetrend'
options,'Bfield_hissinta2_detrend','ytitle','Bfield^2!Cdetrend'
options,'Daa_detrend2','ytitle','<Daa>50 keV'
options,'DaaT_detrend2','ytitle','<Daa> total keV'

tplot_options,'title','Hiss/xray fluctuation comparison'


;store_data,'B1n',data={x:b12.x,y:b12.y/max(b12.y)}
store_data,'B1n',data={x:b12.x,y:b12.y/25.}
;store_data,'B2n',data={x:b22.x,y:b22.y/max(b22.y)}
store_data,'B2n',data={x:b22.x,y:b22.y/2000.}
;store_data,'pkn',data={x:pk2.x,y:pk2.y/max(pk2.y)}
store_data,'pkn',data={x:pk2.x,y:pk2.y/3000.}
;store_data,'pkn2',data={x:pk2.x,y:abs(pk2.y/max(pk2.y))}
store_data,'daan',data={x:daa2.x,y:daa2.y/max(daa2.y)}
store_data,'daanT',data={x:daaT2.x,y:daaT2.y/max(daaT2.y)}

ylim,['B1n','B2n','pkn','daan','daanT'],0,1
tplot,['pkn','B1n','B2n','daan','daanT']

store_data,'b1p',data=['B1n','pkn']
store_data,'b2p',data=['B2n','pkn']
store_data,'daap',data=['daan','pkn']
store_data,'daapT',data=['daanT','pkn']
options,'b1p','ytitle','Bw RMS amp!Cand xrays(red)!Cdetrend and normalized'
options,'b2p','ytitle','Bw^2!Cand xrays(red)!Cdetrend and normalized'
options,'daap','ytitle','<Daa>50keV!Cand xrays(red)!Cdetrend and normalized'
options,'daapT','ytitle','<Daa>Total keV!Cand xrays(red)!Cdetrend and normalized'
options,'b1p','colors',[0,250]
options,'b2p','colors',[0,250]
options,'daap','colors',[0,250]
options,'daapT','colors',[0,250]

;normalized version
;ylim,['b2p'],0,1
ylim,['b1p','b2p','daap','daapT'],-1,1

tplot_options,'title','Hiss/xray fluctuation comparison!C<Daa> for 5 deg to loss cone'
tplot,['b1p','b2p','daapT','dai','mai','lai']



;unnormalized version
tplot,['PeakDet_2I_interp_detrend2','Bfield_hissinta_detrend','Bfield_hissinta2_detrend','Daa_detrend2','DaaT_detrend2']

get_data,'PeakDet_2I_interp_detrend2',data=pk2
get_data,'Bfield_hissinta_detrend',data=b12
get_data,'Bfield_hissinta2_detrend',data=b22

plot,pk2.y,b12.y
plot,pk2.y,b22.y


stop

end
