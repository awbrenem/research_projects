;Determine the extent of the modulated hiss on Jan 3rd. The two sc are at their
;closest b/t 19-20 UT




rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	


;Load EMFISIS density file

ft = [7,4,7,4,3,4,4,4,4,7,3]
fn = replicate('',11)
fl = [0, 25, 35, 60, 67, 73,83, 90,100,107,111]
fg = indgen(11)
fn = ['tms','freq','tms2','bmag','fce','fpe','wpe2wce','fuh','dens','type','tmp']	

t = {version:1.,$
	datastart:1L,$
	delimiter:9B,$
	missingvalue:!values.f_nan,$
	commentsymbol:'',$
	fieldcount:11L,$
	fieldtypes:ft,$
	fieldnames:fn,$
	fieldlocations:fl,$
	fieldgroups:fg}

fn = '~/Desktop/Research/RBSP_hiss_precip/plots/jan6_a/rbsp-a_20140106_orbit-01322_density_box20131014_wsk.dat'
x = read_ascii(fn,template=t)

t2 = strarr(n_elements(x.tms2))
for bb=0,n_elements(x.tms2)-1 do t2[bb] = strmid(x.tms2[bb],0,20)

t3 = strmid(t2,0,10) + '/' + strmid(t2,11,8)

store_data,'dens_emfisis',data={x:time_double(t3),y:x.dens}

;-----------------------------------------------------------------------------


;Plot 2K's position in GSM

tplot_options,'title','from jan6_zoomplot.pro'

date = '2014-01-06'
payloads = ['2K','2L','2W']


spinperiod = 11.8
;2K is at an Lshell b/t 5-6

;the nice correlation b/t RBSP-A and 2K lasts from L=5 down to L=3.5 (dipole model)
;and a timespan from 18:40 - 22:20

t0 = date + '/' + '20:00'
t1 = date + '/' + '22:00'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,payloads,date,type='rcnt'
rbsp_load_barrel_lc,payloads,date
rbsp_load_efw_spec,probe='a',type='calibrated'
rbsp_load_efw_spec,probe='b',type='calibrated'

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

probe='a'
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



probe='b'
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

store_data,'Bfield_hissintb',data={x:bu2.x,y:bt}
tplot,'Bfield_hissintb'





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
get_data,'PeakDet_2W',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2W',data={x:xv,y:yv}
options,'PeakDet_2W','colors',250


;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2L',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2L',data={x:xv,y:yv}
options,'PeakDet_2L','colors',250



;---------------------------------------
;compare all 4 payloads

tplot,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L','PeakDet_2W']


t0z = '2014-01-06/20:40'
t1z = '2014-01-06/21:10'
tlimit,t0z,t1z



rbsp_detrend,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L',$
			'PeakDet_2W'],60.*5.
tplot,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L','PeakDet_2W'] + '_detrend'


rbsp_detrend,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L',$
			'PeakDet_2W'],60.*0.3
ylim,'Bfield_hissintb_smoothed',0.01,0.03
ylim,'PeakDet_2K_smoothed',3500,5000
ylim,'PeakDet_2L_smoothed',4000,10000
ylim,'PeakDet_2W_smoothed',4000,7000

tplot,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L','PeakDet_2W'] + '_smoothed'


;rbsp_efw_position_velocity_crib,/noplot
	

;rbsp_load_emfisis,probe='a b',/quicklook

;rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
;rbsp_load_efw_fbk,probe='b',type='calibrated',/pt
;rbsp_split_fbk,'a'
;rbsp_split_fbk,'b'


;rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
;rbsp_load_efw_waveform,probe='b',type='calibrated',datatype='vsvy'
;rbsp_downsample,'rbspa' +'_efw_vsvy',1/spinperiod,/nochange	
;rbsp_downsample,'rbspb' +'_efw_vsvy',1/spinperiod,/nochange	
;split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']
;split_vec,'rbspb_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']

;get_data,'rbspa_efw_vsvy_V1',data=v1a
;get_data,'rbspa_efw_vsvy_V2',data=v2a
;get_data,'rbspb_efw_vsvy_V1',data=v1b
;get_data,'rbspb_efw_vsvy_V2',data=v2b

;sum12a = (v1a.y + v2a.y)/2.
;sum12b = (v1b.y + v2b.y)/2.

;densitya = 7354.3897*exp(sum12a*2.8454878)+96.123628*exp(sum12a*0.43020781)
;densityb = 7354.3897*exp(sum12b*2.8454878)+96.123628*exp(sum12b*0.43020781)


;store_data,'densitya',data={x:v1a.x,y:densitya}
;store_data,'densityb',data={x:v1b.x,y:densityb}
;ylim,'density?',100,1000,1
;options,'densitya','ytitle','densityA!Ccm^-3'
;options,'densityb','ytitle','densityB!Ccm^-3'

;options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
;	'rbsp_state_lshell_both'],'panel_size',0.25
;options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
;	'rbsp_state_lshell_both'],'thick',2



;-------------------------------------------------------------------











