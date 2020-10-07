;Compare hiss on THEMIS-D and RBSP-B on Jan 3rd, 2014


;Load themis data (http://themis.ssl.berkeley.edu/data/themis/thd/l2/fft/2014/)

file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/thd_l2_fft_20140103_v01.cdf'
cdf2tplot,files=file

zlim,'thd_fff_32_scm2',1d-8,8d-4

  
probe = 'b'

tplot_options,'title','from thd_rbspb_hiss_compare.pro'

trange = timerange()

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL


tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	
tplot_options,'thick',1



rbsp_load_efw_spec,probe='b',type='calibrated'


tplot,['thd_fff_32_scm2','rbspb_efw_64_spec3']

;---------------------------------
;get freq of max amp hiss
get_data,'rbspb_efw_64_spec3',data=spec
;delete non hiss bands
spec.y[*,0:1] = 0.
spec.y[*,40:63] = 0.
freqm = fltarr(n_elements(spec.x))
ampm = fltarr(n_elements(spec.x))

for i=0L,n_elements(spec.x)-1 do begin $
	tmp = max(spec.y[i,*],wh)	& $
	freqm[i] = spec.v[wh]  & $
	ampm[i] = spec.y[i,wh]
;---------------------------------

store_data,'ampmax_rbspb',data={x:spec.x,y:ampm}


;---------------------------------
;get freq of max amp hiss
get_data,'thd_fff_32_scm2',data=spec
spec.y[*,0:1] = 0.
spec.y[*,21:31] = 0.
freqm = fltarr(n_elements(spec.x))
ampm = fltarr(n_elements(spec.x))

for i=0L,n_elements(spec.x)-1 do begin $
	tmp = max(spec.y[i,*],wh)	& $
	freqm[i] = spec.v[wh]  & $
	ampm[i] = spec.y[i,wh]
;---------------------------------

store_data,'ampmax_thd',data={x:spec.x,y:ampm}


tplot,['ampmax_rbspb','ampmax_thd']

rbsp_detrend,['ampmax_rbspb','ampmax_thd'],60.*1.

store_data,'ampmax_comb',data=['ampmax_rbspb_smoothed','ampmax_thd_smoothed']
options,'ampmax_comb','colors',[250,50]
tplot,'ampmax_comb'





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

;for j=0L,nelem-1 do bt[j] = total(sqrt(ball[j,*]*bandw))
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)


store_data,'Bfield_hissint',data={x:bu2.x,y:bt}
tplot,'Bfield_hissint'



  