;Perform cross-correlations on the Jan 3 data


pro jan3_correlations_allpayloads


skip_load = 'n'

tplot_options,'title','from jan6_zoomed_event.pro'

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




if skip_load ne 'y' then begin

;t0 = time_double('2014-01-06/20:00')
;t1 = time_double('2014-01-06/22:00')

rbsp_load_efw_spec,probe='a',type='calibrated',/pt
rbsp_load_efw_spec,probe='b',type='calibrated',/pt
rbsp_efw_position_velocity_crib,/noplot,/notrace
;rbsp_efw_vxb_subtract_crib,probe,/no_spice_load;,/hires
;rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract

dif_data,'rbspa_state_lshell','rbspb_state_lshell',newname='rbsp_state_lshell_diff'

;-----------------------------------------------
rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspa_efw_vsvy_V1',data=v1
get_data,'rbspa_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densitya',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densitya','ytitle','density'+strupcase(probe)+'!Ccm^-3'

;-----------------------------------------------
rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
get_data,'rbspb_efw_vsvy_V1',data=v1
get_data,'rbspb_efw_vsvy_V2',data=v2
sum12 = (v1.y + v2.y)/2.
density = 7354.3897*exp(sum12*2.8454878)+96.123628*exp(sum12*0.43020781)
store_data,'densityb',data={x:v1.x,y:density}
ylim,'density?',1,10000,1
options,'densityb','ytitle','density'+strupcase(probe)+'!Ccm^-3'
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
;tplot,'Bfield_hissinta'
;-----------------------------------------------
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
;tplot,'Bfield_hissintb'
;-----------------------------------------------
;MAGEIS file
;pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
;fnt = 'rbspa_rel02_ect-mageis-L2_20140106_v3.0.0.cdf'
;cdf2tplot,file=pn+fnt
;get_data,'FESA',data=dd
;store_data,'FESA',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
;get_data,'FESA',data=dd
;store_data,'fesa_2mev',data={x:dd.x,y:dd.y[*,21]}
;ylim,'fesa_2mev',0.02,100,1
;ylim,'FESA',30,4000,1
;tplot,'FESA'
;zlim,'FESA',0,1d5
;-----------------------------------------------
payloads = ['2I']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2I',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2I',data={x:xv,y:yv}
options,'PeakDet_2I','colors',250
;-----------------------------------------------


rbsp_load_barrel_lc,payloads,date,type='ephm'


path = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/'

restore, path+"barrel_template.sav"
myfile = path+"BAR_2I_mag.dat"
data = read_ascii(myfile, template = res)
tms = time_double('2014-01-03/00:00') + data.utsec
copy_data,'L_Kp2_2I','l_2I'
copy_data,'MLT_Kp2_T89c_2I','mlt_2I'


;store_data,'mlt_2I',data={x:tms,y:data.mlt}
;store_data,'l_2I',data={x:tms,y:abs(data.l)}
store_data,'mlat_2I',data={x:tms,y:data.lat}
store_data,'alt_2I',data={x:tms,y:data.alt}

endif




tinterpol_mxn,'mlt_2I','rbspa_state_mlt',newname='mlt_2I'

tinterpol_mxn,'l_2I','rbspa_state_mlt',newname='l_2I'

;get_data,'mlt_2K',data=dd
;times = dd.x

dif_data,'rbspa_state_mlt','mlt_2I',newname='dmlt_ai'

dif_data,'rbspb_state_mlt','mlt_2I',newname='dmlt_bi'

dif_data,'rbspa_state_lshell','l_2I',newname='dl_ai'

dif_data,'rbspb_state_lshell','l_2I',newname='dl_bi'


;tplot,'dmlt_a'+['k','w','l','x']
;tplot,'dmlt_b'+['k','w','l','x']
;tplot,'dl_a'+['k','w','l','x']
;tplot,'dl_b'+['k','w','l','x']


;Calculate separation in azimuthal plane

get_data,'rbspa_state_mlt',data=mlt_a
get_data,'rbspa_state_lshell',data=lshell_a
get_data,'rbspb_state_mlt',data=mlt_b
get_data,'rbspb_state_lshell',data=lshell_b
get_data,'mlt_2I',data=mlt_2i
get_data,'l_2I',data=lshell_2i


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


t1 = (mlt_a.y - 12)*360./24.
t2 = (mlt_2i.y - 12)*360./24.
x1 = lshell_a.y * sin(t1*!dtor)
y1 = lshell_a.y * cos(t1*!dtor)
x2 = lshell_2i.y * sin(t2*!dtor)
y2 = lshell_2i.y * cos(t2*!dtor)
dai = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dai',data={x:mlt_a.x,y:dai}
store_data,'mai',data={x:mlt_a.x,y:(mlt_a.y-mlt_2i.y)}
store_data,'lai',data={x:mlt_a.x,y:(lshell_a.y-lshell_2i.y)}


t1 = (mlt_b.y - 12)*360./24.
t2 = (mlt_2i.y - 12)*360./24.
x1 = lshell_b.y * sin(t1*!dtor)
y1 = lshell_b.y * cos(t1*!dtor)
x2 = lshell_2i.y * sin(t2*!dtor)
y2 = lshell_2i.y * cos(t2*!dtor)
dbi = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dbi',data={x:mlt_b.x,y:dbi}
store_data,'mbi',data={x:mlt_b.x,y:(mlt_b.y-mlt_2i.y)}
store_data,'lbi',data={x:mlt_b.x,y:(lshell_b.y-lshell_2i.y)}


;tplot,['dak','dal','daw','dax']
;tplot,['dbk','dbl','dbw','dbx']






;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************


;Run cross-correlations



T1='2014-01-03/17:00:00'	
T2='2014-01-03/24:00:00'	


;window = length in seconds
;lag = seconds to slide window each time  
;coherence_time = larger than window length (2x window length)

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.01

;num = 9   ;array number
num = 2   ;array number


v1 = 'PeakDet_2I'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
ai = coh.y[*,num]

tinterpol_mxn,'dai','Precip_hissa_coherence',newname='dai_interp'
tinterpol_mxn,'mai','Precip_hissa_coherence',newname='mai_interp'
tinterpol_mxn,'lai','Precip_hissa_coherence',newname='lai_interp'


v1 = 'PeakDet_2I'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
get_data,'Precip_hissb_coherence',data=coh
get_data,'Precip_hissb_phase',data=ph
bi = coh.y[*,num]


tinterpol_mxn,'dbi','Precip_hissb_coherence',newname='dbi_interp'
tinterpol_mxn,'mbi','Precip_hissb_coherence',newname='mbi_interp'
tinterpol_mxn,'lbi','Precip_hissb_coherence',newname='lbi_interp'

;tinterpol_mxn,'mlt_2K','Precip_hissa_coherence',newname='mlt_2k_interp'
;tinterpol_mxn,'mlt_2W','Precip_hissa_coherence',newname='mlt_2w_interp'
;tinterpol_mxn,'mlt_2L','Precip_hissa_coherence',newname='mlt_2l_interp'
;tinterpol_mxn,'mlt_2X','Precip_hissa_coherence',newname='mlt_2x_interp'


;mincoh = 0.01
;goo = where(ak lt mincoh)
;ak[goo] = !values.f_nan
;goo = where(aw lt mincoh)
;aw[goo] = !values.f_nan
;goo = where(al lt mincoh)
;al[goo] = !values.f_nan
;goo = where(ax lt mincoh)
;ax[goo] = !values.f_nan

;goo = where(bk lt mincoh)
;bk[goo] = !values.f_nan
;goo = where(bw lt mincoh)
;bw[goo] = !values.f_nan
;goo = where(bl lt mincoh)
;bl[goo] = !values.f_nan
;goo = where(bx lt mincoh)
;bx[goo] = !values.f_nan



get_data,'dai_interp',data=dai

get_data,'dbi_interp',data=dbi

get_data,'mai_interp',data=mai

get_data,'mbi_interp',data=mbi

get_data,'lai_interp',data=lai

get_data,'lbi_interp',data=lbi



!p.multi = [0,0,3]

pa=5
pb=6
plot,dai.y,ai,xrange=[0,8],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only',$
	xtitle='Straight-line separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,dai.y,ai,thick=1.5,psym=pa

oplot,dbi.y,bi,psym=pb,thick=1.5

;xyouts,0.5,0.9,'RBSP-A(B) and 2K',/normal
;xyouts,0.5,0.8,'RBSP-A(B) and 2W',/normal,color=50
;xyouts,0.5,0.7,'RBSP-A(B) and 2L',/normal,color=250




pa=5
pb=6
plot,mai.y,ai,xrange=[-6,6],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only',$
	xtitle='MLT separation b/t payloads (hrs)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,mai.y,ai,thick=1.5,psym=pa
oplot,mbi.y,bi,psym=pb,thick=1.5

;xyouts,0.5,0.9,'RBSP-A(B) and 2K',/normal
;xyouts,0.5,0.8,'RBSP-A(B) and 2W',/normal,color=50
;xyouts,0.5,0.7,'RBSP-A(B) and 2L',/normal,color=250



pa=5
pb=6
plot,lai.y,ai,xrange=[-4,4],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only',$
	xtitle='Lshell separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,lai.y,ai,thick=1.5,psym=pa
oplot,lbi.y,bi,psym=pb,thick=1.5






pa=5
pb=6
plot,lbi.y,bi,xrange=[-4,4],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only',$
	xtitle='Lshell separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,lai.y,ai,thick=1.5,psym=pa
oplot,lbi.y,bi,psym=pb,thick=1.5


;xyouts,0.5,0.9,'RBSP-A(B) and 2K',/normal
;xyouts,0.5,0.8,'RBSP-A(B) and 2W',/normal,color=50
;xyouts,0.5,0.7,'RBSP-A(B) and 2L',/normal,color=170



;**************************************************

;Average the coherence values in discrete bins....this simplifies the plots
;; cohs = [ai,bi]
;; dists = [dai.y,dbi.y]
;; mlts = [mai.y,mbi.y]
;; lshells = [lai.y,lbi.y]
cohs = [ai]
dists = [dai.y]
mlts = [mai.y]
lshells = [lai.y]

;remove cohs < 0.5
goo = where(cohs le 0.5)
cohs[goo] = !values.f_nan

nsamples = histogram(lshells,/nan,reverse_indices=ri,locations=loc,min=-4,max=2)


avgs = fltarr(n_elements(nsamples))
meds = fltarr(n_elements(nsamples))
ns = fltarr(n_elements(nsamples))

goo = where((lshells ge loc[0]) and (lshells le loc[1]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[0] = total(cohtmp)/n_elements(cohtmp)
meds[0] = median(cohtmp)
ns[0] = n_elements(cohtmp)

goo = where((lshells ge loc[1]) and (lshells le loc[2]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[1] = total(cohtmp)/n_elements(cohtmp)
meds[1] = median(cohtmp)
ns[1] = n_elements(cohtmp)

goo = where((lshells ge loc[2]) and (lshells le loc[3]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[2] = total(cohtmp)/n_elements(cohtmp)
meds[2] = median(cohtmp)
ns[2] = n_elements(cohtmp)

goo = where((lshells ge loc[3]) and (lshells le loc[4]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[3] = total(cohtmp)/n_elements(cohtmp)
meds[3] = median(cohtmp)
ns[3] = n_elements(cohtmp)

goo = where((lshells ge loc[4]) and (lshells le loc[5]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[4] = total(cohtmp)/n_elements(cohtmp)
meds[4] = median(cohtmp)
ns[4] = n_elements(cohtmp)

goo = where((lshells ge loc[5]) and (lshells le loc[6]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[5] = total(cohtmp)/n_elements(cohtmp)
meds[5] = median(cohtmp)
ns[5] = n_elements(cohtmp)

avgs_lshell = avgs
loc_lshell = loc
ns_lshell = ns
meds_lshell = meds
;nsamples_lshell = nsamples

!p.multi = [0,0,2]
plot,loc_lshell+0.5,avgs_lshell,xtitle='delta-Lshell',ytitle='average coherence!C(>0.5)',yrange=[0,1],title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only'
;plot,loc_lshell+0.5,meds_lshell,xtitle='delta-Lshell',ytitle='median coherence!C(>0.5)',yrange=[0,1]
plot,loc_lshell+0.5,ns_lshell,xtitle='delta-Lshell',ytitle='counts',title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only'

;--------------






nsamples = histogram(mlts,/nan,reverse_indices=ri,locations=loc,min=-5,max=5,nbins=6)


avgs = fltarr(n_elements(nsamples))
meds = fltarr(n_elements(nsamples))
ns = fltarr(n_elements(nsamples))

goo = where((mlts ge loc[0]) and (mlts le loc[1]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[0] = total(cohtmp)/n_elements(cohtmp)
meds[0] = median(cohtmp)
ns[0] = n_elements(cohtmp)

goo = where((mlts ge loc[1]) and (mlts le loc[2]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[1] = total(cohtmp)/n_elements(cohtmp)
meds[1] = median(cohtmp)
ns[1] = n_elements(cohtmp)

goo = where((mlts ge loc[2]) and (mlts le loc[3]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[2] = total(cohtmp)/n_elements(cohtmp)
meds[2] = median(cohtmp)
ns[2] = n_elements(cohtmp)

goo = where((mlts ge loc[3]) and (mlts le loc[4]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[3] = total(cohtmp)/n_elements(cohtmp)
meds[3] = median(cohtmp)
ns[3] = n_elements(cohtmp)

goo = where((mlts ge loc[4]) and (mlts le loc[5]))
cohtmp = cohs[goo]
boo = where(finite(cohtmp) ne 0)
cohtmp = cohtmp[boo]
print,cohtmp
avgs[4] = total(cohtmp)/n_elements(cohtmp)
meds[4] = median(cohtmp)
ns[4] = n_elements(cohtmp)

;goo = where((mlts ge loc[5]) and (mlts le loc[6]))
;cohtmp = cohs[goo]
;boo = where(finite(cohtmp) ne 0)
;cohtmp = cohtmp[boo]
;print,cohtmp
;avgs[5] = total(cohtmp)/n_elements(cohtmp)
;ns[5] = n_elements(cohtmp)

;goo = where((mlts ge loc[6]) and (mlts le loc[7]))
;cohtmp = cohs[goo]
;boo = where(finite(cohtmp) ne 0)
;cohtmp = cohtmp[boo]
;print,cohtmp
;avgs[6] = total(cohtmp)/n_elements(cohtmp)
;ns[6] = n_elements(cohtmp)

;goo = where((mlts ge loc[7]) and (mlts le loc[8]))
;cohtmp = cohs[goo]
;boo = where(finite(cohtmp) ne 0)
;cohtmp = cohtmp[boo]
;print,cohtmp
;avgs[7] = total(cohtmp)/n_elements(cohtmp)
;ns[7] = n_elements(cohtmp)

;goo = where((mlts ge loc[8]) and (mlts le loc[9]))
;cohtmp = cohs[goo]
;boo = where(finite(cohtmp) ne 0)
;cohtmp = cohtmp[boo]
;print,cohtmp
;avgs[8] = total(cohtmp)/n_elements(cohtmp)
;ns[8] = n_elements(cohtmp)

;goo = where((mlts ge loc[9]) and (mlts le loc[10]))
;cohtmp = cohs[goo]
;boo = where(finite(cohtmp) ne 0)
;cohtmp = cohtmp[boo]
;print,cohtmp
;avgs[9] = total(cohtmp)/n_elements(cohtmp)
;ns[9] = n_elements(cohtmp)



avgs_mlt = avgs
meds_mlt = meds
loc_mlt = loc
ns_mlt = ns


!p.multi = [0,0,2]
plot,loc_mlt+1,avgs_mlt,xtitle='delta-MLT',ytitle='average coherence!C(>0.5)',xrange=[-5,6],yrange=[0,1],title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only'
;plot,loc_mlt+1,meds_mlt,xtitle='delta-MLT',ytitle='median coherence!C(>0.5)',xrange=[-5,6],yrange=[0,1]
plot,loc_mlt+1,ns_mlt,xtitle='delta-MLT',ytitle='counts',xrange=[-5,6],title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only'






;**************************************************







;result = histogram(lshells,locations=[1,2,3,4,5,6,7],/nan,reverse_indices=ri)
cov = cohs
ncohs = n_elements(cohs)

for b=0,ncohs-1 do if ri[b] ne ri[b+1] then cov[b] = total(cohs[ri[ri[b]:ri[b+1]-1]],/nan)/nsamples[b]






stop









;**************************************************
;**************************************************
;**************************************************
;**************************************************
;PLOT CORRELATIONS FOR A FEW SELECT FREQS



tinterpol_mxn,'dai','Precip_hissa_coherence',newname='dai_interp'
tinterpol_mxn,'mai','Precip_hissa_coherence',newname='mai_interp'
tinterpol_mxn,'lai','Precip_hissa_coherence',newname='lai_interp'

tinterpol_mxn,'dbi','Precip_hissb_coherence',newname='dbi_interp'
tinterpol_mxn,'mbi','Precip_hissb_coherence',newname='mbi_interp'
tinterpol_mxn,'lbi','Precip_hissb_coherence',newname='lbi_interp'

get_data,'dai_interp',data=dai
get_data,'dbi_interp',data=dbi
get_data,'mai_interp',data=mai
get_data,'mbi_interp',data=mbi
get_data,'lai_interp',data=lai
get_data,'lbi_interp',data=lbi



T1='2014-01-03/18:30:00'	
T2='2014-01-03/24:00:00'	


;window = length in seconds
;lag = seconds to slide window each time  
;coherence_time = larger than window length (2x window length)

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.01


;; window = 60.*5.
;; lag = window/1.
;; coherence_time = window*2.5
;; cormin = 0.01


;num = 9   ;array number
;num = 2   ;array number



print,'period = ',1/coh.v[num]/60.
v1 = 'PeakDet_2I'
v2 = 'Bfield_hissinta'

dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
goo = where(coh.y le cormin)
if goo[0] ne -1 then coh.y[goo] = !values.f_nan
if goo[0] ne -1 then ph.y[goo] = !values.f_nan

store_data,'Precip_hissa_coherence',data=coh
store_data,'Precip_hissa_phase',data=ph
ylim,'Precip_hissa_coherence',0,0.02
tplot,'Precip_hissa_coherence'





periods_elem = [1,2,3,4,5,6,9,12,15,20,25,30]
periods = 1/coh.v[periods_elem]/60.

ai = coh.y[*,periods_elem]


;; v1 = 'PeakDet_2I'
;; v2 = 'Bfield_hissintb'
;; dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
;; get_data,'Precip_hissb_coherence',data=coh
;; get_data,'Precip_hissb_phase',data=ph
;; bi = coh.y[*,num]

tmin = time_double('2014-01-03/19:30')
tmax = time_double('2014-01-03/22:40')

goodt = where((coh.x ge tmin) and (coh.x le tmax))

!p.multi = [0,0,2]
pa=0
plot,mai.y[goodt],ai,xrange=[1,4],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro',$
	xtitle='MLT separation b/t payloads (hrs)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,mai.y[goodt],ai[goodt,1],thick=1.5,psym=pa,color=0  ;15m
oplot,mai.y[goodt],ai[goodt,2],thick=1.5,psym=pa,color=50 ;10m
;oplot,mai.y[goodt],ai[goodt,3],thick=1.5,psym=pa,color=100 ;7.5m
;oplot,mai.y[goodt],ai[goodt,6],thick=1.5,psym=pa,color=150 ;3.3m
oplot,mai.y[goodt],ai[goodt,10],thick=1.5,psym=pa,color=250 ;1.2m
;oplot,mai.y[goodt],ai[goodt,11],thick=1.5,psym=pa,color=250 ;1m

xyouts,/normal,0.1,0.85,'Black = 15m period fluctuations'
xyouts,/normal,0.1,0.80,'Blue = 10m period fluctuations'
xyouts,/normal,0.1,0.75,'Red = 1.2m period fluctuations'


plot,lai.y[goodt],ai,xrange=[-4,1],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro',$
	xtitle='Lshell separation b/t payloads (hrs)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,lai.y[goodt],ai[goodt,1],thick=1.5,psym=pa,color=0  ;15m
oplot,lai.y[goodt],ai[goodt,2],thick=1.5,psym=pa,color=50 ;10m
;oplot,lai.y[goodt],ai[goodt,3],thick=1.5,psym=pa,color=100 ;7.5m
;oplot,lai.y[goodt],ai[goodt,5],thick=1.5,psym=pa,color=150 ;3.3m
oplot,lai.y[goodt],ai[goodt,10],thick=1.5,psym=pa,color=250 ;1.2m
;oplot,lai.y[goodt],ai[goodt,11],thick=1.5,psym=pa,color=250 ;1m

xyouts,/normal,0.1,0.45,'Black = 15m period fluctuations'
xyouts,/normal,0.1,0.40,'Blue = 10m period fluctuations'
xyouts,/normal,0.1,0.35,'Red = 1.2m period fluctuations'






oplot,mbi.y,bi,psym=pb,thick=1.5

plot,lai.y,ai,xrange=[-4,4],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only',$
	xtitle='Lshell separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,lai.y,ai,thick=1.5,psym=pa
oplot,lbi.y,bi,psym=pb,thick=1.5

plot,lbi.y,bi,xrange=[-4,4],yrange=[0.0,1],/nodata,title='from jan3_correlations_allpayloads.pro!C'+strtrim(1/coh.v[num]/60.,2)+'min periods only',$
	xtitle='Lshell separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,lai.y,ai,thick=1.5,psym=pa
oplot,lbi.y,bi,psym=pb,thick=1.5












end
