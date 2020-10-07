;Perform cross-correlations on the Jan 6 data


pro jan6_correlations_allpayloads


skip_load = 'n'

tplot_options,'title','from jan6_zoomed_event.pro'

date = '2014-01-06'
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
payloads = ['2K','2W','2L','2X']
spinperiod = 11.8
rbsp_load_barrel_lc,payloads,date,type='rcnt'

;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K',data={x:xv,y:yv}
options,'PeakDet_2K','colors',250
;-----------------------------------------------
get_data,'PeakDet_2W',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2W',data={x:xv,y:yv}
options,'PeakDet_2W','colors',250
;-----------------------------------------------
get_data,'PeakDet_2L',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2L',data={x:xv,y:yv}
options,'PeakDet_2L','colors',250
;-----------------------------------------------
get_data,'PeakDet_2X',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2X',data={x:xv,y:yv}
options,'PeakDet_2X','colors',250
;-----------------------------------------------




path = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/'

restore, path+"barrel_template.sav"
myfile = path+"BAR_2K_mag.dat"
data = read_ascii(myfile, template = res)
tms = time_double('2014-01-06/00:00') + data.utsec
store_data,'mlt_2K',data={x:tms,y:data.mlt}
store_data,'l_2K',data={x:tms,y:abs(data.l)}
store_data,'mlat_2K',data={x:tms,y:data.lat}
store_data,'alt_2K',data={x:tms,y:data.alt}

restore, path+"barrel_template.sav"
myfile = path+"BAR_2L_mag.dat"
data = read_ascii(myfile, template = res)
tms = time_double('2014-01-06/00:00') + data.utsec
store_data,'mlt_2L',data={x:tms,y:data.mlt}
store_data,'l_2L',data={x:tms,y:abs(data.l)}
store_data,'mlat_2L',data={x:tms,y:data.lat}
store_data,'alt_2L',data={x:tms,y:data.alt}

restore, path+"barrel_template.sav"
myfile = path+"BAR_2W_mag.dat"
data = read_ascii(myfile, template = res)
tms = time_double('2014-01-06/00:00') + data.utsec
store_data,'mlt_2W',data={x:tms,y:data.mlt}
store_data,'l_2W',data={x:tms,y:abs(data.l)}
store_data,'mlat_2W',data={x:tms,y:data.lat}
store_data,'alt_2W',data={x:tms,y:data.alt}

restore, path+"barrel_template.sav"
myfile = path+"BAR_2X_mag.dat"
data = read_ascii(myfile, template = res)
tms = time_double('2014-01-06/00:00') + data.utsec
store_data,'mlt_2X',data={x:tms,y:data.mlt}
store_data,'l_2X',data={x:tms,y:abs(data.l)}
store_data,'mlat_2X',data={x:tms,y:data.lat}
store_data,'alt_2X',data={x:tms,y:data.alt}


endif




tinterpol_mxn,'mlt_2K','rbspa_state_mlt',newname='mlt_2K'
tinterpol_mxn,'mlt_2W','rbspa_state_mlt',newname='mlt_2W'
tinterpol_mxn,'mlt_2L','rbspa_state_mlt',newname='mlt_2L'
tinterpol_mxn,'mlt_2X','rbspa_state_mlt',newname='mlt_2X'

tinterpol_mxn,'l_2K','rbspa_state_mlt',newname='l_2K'
tinterpol_mxn,'l_2W','rbspa_state_mlt',newname='l_2W'
tinterpol_mxn,'l_2L','rbspa_state_mlt',newname='l_2L'
tinterpol_mxn,'l_2X','rbspa_state_mlt',newname='l_2X'

;get_data,'mlt_2K',data=dd
;times = dd.x

dif_data,'rbspa_state_mlt','mlt_2K',newname='dmlt_ak'
dif_data,'rbspa_state_mlt','mlt_2W',newname='dmlt_aw'
dif_data,'rbspa_state_mlt','mlt_2L',newname='dmlt_al'
dif_data,'rbspa_state_mlt','mlt_2X',newname='dmlt_ax'

dif_data,'rbspb_state_mlt','mlt_2K',newname='dmlt_bk'
dif_data,'rbspb_state_mlt','mlt_2W',newname='dmlt_bw'
dif_data,'rbspb_state_mlt','mlt_2L',newname='dmlt_bl'
dif_data,'rbspb_state_mlt','mlt_2X',newname='dmlt_bx'

dif_data,'rbspa_state_lshell','l_2K',newname='dl_ak'
dif_data,'rbspa_state_lshell','l_2W',newname='dl_aw'
dif_data,'rbspa_state_lshell','l_2L',newname='dl_al'
dif_data,'rbspa_state_lshell','l_2X',newname='dl_ax'

dif_data,'rbspb_state_lshell','l_2K',newname='dl_bk'
dif_data,'rbspb_state_lshell','l_2W',newname='dl_bw'
dif_data,'rbspb_state_lshell','l_2L',newname='dl_bl'
dif_data,'rbspb_state_lshell','l_2X',newname='dl_bx'


;tplot,'dmlt_a'+['k','w','l','x']
;tplot,'dmlt_b'+['k','w','l','x']
;tplot,'dl_a'+['k','w','l','x']
;tplot,'dl_b'+['k','w','l','x']


;Calculate separation in azimuthal plane

get_data,'rbspa_state_mlt',data=mlt_a
get_data,'rbspa_state_lshell',data=lshell_a
get_data,'rbspb_state_mlt',data=mlt_b
get_data,'rbspb_state_lshell',data=lshell_b
get_data,'mlt_2K',data=mlt_2k
get_data,'l_2K',data=lshell_2k
get_data,'mlt_2L',data=mlt_2l
get_data,'l_2L',data=lshell_2l
get_data,'mlt_2W',data=mlt_2w
get_data,'l_2W',data=lshell_2w
get_data,'mlt_2X',data=mlt_2x
get_data,'l_2X',data=lshell_2x


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
t2 = (mlt_2k.y - 12)*360./24.
x1 = lshell_a.y * sin(t1*!dtor)
y1 = lshell_a.y * cos(t1*!dtor)
x2 = lshell_2k.y * sin(t2*!dtor)
y2 = lshell_2k.y * cos(t2*!dtor)
dak = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dak',data={x:mlt_a.x,y:dak}
store_data,'mak',data={x:mlt_a.x,y:(mlt_a.y-mlt_2k.y)}
store_data,'lak',data={x:mlt_a.x,y:(lshell_a.y-lshell_2k.y)}

t1 = (mlt_a.y - 12)*360./24.
t2 = (mlt_2w.y - 12)*360./24.
x1 = lshell_a.y * sin(t1*!dtor)
y1 = lshell_a.y * cos(t1*!dtor)
x2 = lshell_2w.y * sin(t2*!dtor)
y2 = lshell_2w.y * cos(t2*!dtor)
daw = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'daw',data={x:mlt_a.x,y:daw}
store_data,'maw',data={x:mlt_a.x,y:(mlt_a.y-mlt_2w.y)}
store_data,'law',data={x:mlt_a.x,y:(lshell_a.y-lshell_2w.y)}

t1 = (mlt_a.y - 12)*360./24.
t2 = (mlt_2l.y - 12)*360./24.
x1 = lshell_a.y * sin(t1*!dtor)
y1 = lshell_a.y * cos(t1*!dtor)
x2 = lshell_2l.y * sin(t2*!dtor)
y2 = lshell_2l.y * cos(t2*!dtor)
dal = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dal',data={x:mlt_a.x,y:dal}
store_data,'mal',data={x:mlt_a.x,y:(mlt_a.y-mlt_2l.y)}
store_data,'lal',data={x:mlt_a.x,y:(lshell_a.y-lshell_2l.y)}

t1 = (mlt_a.y - 12)*360./24.
t2 = (mlt_2x.y - 12)*360./24.
x1 = lshell_a.y * sin(t1*!dtor)
y1 = lshell_a.y * cos(t1*!dtor)
x2 = lshell_2x.y * sin(t2*!dtor)
y2 = lshell_2x.y * cos(t2*!dtor)
dax = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dax',data={x:mlt_a.x,y:dax}
store_data,'max',data={x:mlt_a.x,y:(mlt_a.y-mlt_2x.y)}
store_data,'lax',data={x:mlt_a.x,y:(lshell_a.y-lshell_2x.y)}

t1 = (mlt_b.y - 12)*360./24.
t2 = (mlt_2k.y - 12)*360./24.
x1 = lshell_b.y * sin(t1*!dtor)
y1 = lshell_b.y * cos(t1*!dtor)
x2 = lshell_2k.y * sin(t2*!dtor)
y2 = lshell_2k.y * cos(t2*!dtor)
dbk = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dbk',data={x:mlt_b.x,y:dbk}
store_data,'mbk',data={x:mlt_b.x,y:(mlt_b.y-mlt_2k.y)}
store_data,'lbk',data={x:mlt_b.x,y:(lshell_b.y-lshell_2k.y)}

t1 = (mlt_b.y - 12)*360./24.
t2 = (mlt_2w.y - 12)*360./24.
x1 = lshell_b.y * sin(t1*!dtor)
y1 = lshell_b.y * cos(t1*!dtor)
x2 = lshell_2w.y * sin(t2*!dtor)
y2 = lshell_2w.y * cos(t2*!dtor)
dbw = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dbw',data={x:mlt_b.x,y:dbw}
store_data,'mbw',data={x:mlt_b.x,y:(mlt_b.y-mlt_2w.y)}
store_data,'lbw',data={x:mlt_b.x,y:(lshell_b.y-lshell_2w.y)}

t1 = (mlt_b.y - 12)*360./24.
t2 = (mlt_2l.y - 12)*360./24.
x1 = lshell_b.y * sin(t1*!dtor)
y1 = lshell_b.y * cos(t1*!dtor)
x2 = lshell_2l.y * sin(t2*!dtor)
y2 = lshell_2l.y * cos(t2*!dtor)
dbl = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dbl',data={x:mlt_b.x,y:dbl}
store_data,'mbl',data={x:mlt_b.x,y:(mlt_b.y-mlt_2l.y)}
store_data,'lbl',data={x:mlt_b.x,y:(lshell_b.y-lshell_2l.y)}

t1 = (mlt_b.y - 12)*360./24.
t2 = (mlt_2x.y - 12)*360./24.
x1 = lshell_b.y * sin(t1*!dtor)
y1 = lshell_b.y * cos(t1*!dtor)
x2 = lshell_2x.y * sin(t2*!dtor)
y2 = lshell_2x.y * cos(t2*!dtor)
dbx = sqrt((abs(x1-x2))^2 + (abs(y1-y2))^2)
store_data,'dbx',data={x:mlt_b.x,y:dbx}
store_data,'mbx',data={x:mlt_b.x,y:(mlt_b.y-mlt_2x.y)}
store_data,'lbx',data={x:mlt_b.x,y:(lshell_b.y-lshell_2x.y)}


;tplot,['dak','dal','daw','dax']
;tplot,['dbk','dbl','dbw','dbx']






;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************


;Run cross-correlations



T1='2014-01-06/16:00:00'	
T2='2014-01-06/22:30:00'	

;T1='2014-01-06/13:00:00'	
;T2='2014-01-06/23:30:00'	



;window = length in seconds
;lag = seconds to slide window each time  
;coherence_time = larger than window length (2x window length)

window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.01

num = 9   ;array number


v1 = 'PeakDet_2K'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
ak = coh.y[*,num]

tinterpol_mxn,'dak','Precip_hissa_coherence',newname='dak_interp'
tinterpol_mxn,'mak','Precip_hissa_coherence',newname='mak_interp'
tinterpol_mxn,'lak','Precip_hissa_coherence',newname='lak_interp'

v1 = 'PeakDet_2W'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
aw = coh.y[*,num]

tinterpol_mxn,'daw','Precip_hissa_coherence',newname='daw_interp'
tinterpol_mxn,'maw','Precip_hissa_coherence',newname='maw_interp'
tinterpol_mxn,'law','Precip_hissa_coherence',newname='law_interp'

v1 = 'PeakDet_2L'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
al = coh.y[*,num]

tinterpol_mxn,'dal','Precip_hissa_coherence',newname='dal_interp'
tinterpol_mxn,'mal','Precip_hissa_coherence',newname='mal_interp'
tinterpol_mxn,'lal','Precip_hissa_coherence',newname='lal_interp'

v1 = 'PeakDet_2X'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissa'  
get_data,'Precip_hissa_coherence',data=coh
get_data,'Precip_hissa_phase',data=ph
ax = coh.y[*,num]

tinterpol_mxn,'dax','Precip_hissa_coherence',newname='dax_interp'
tinterpol_mxn,'max','Precip_hissa_coherence',newname='max_interp'
tinterpol_mxn,'lax','Precip_hissa_coherence',newname='lax_interp'

v1 = 'PeakDet_2K'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
get_data,'Precip_hissb_coherence',data=coh
get_data,'Precip_hissb_phase',data=ph
bk = coh.y[*,num]

tinterpol_mxn,'dbk','Precip_hissb_coherence',newname='dbk_interp'
tinterpol_mxn,'mbk','Precip_hissb_coherence',newname='mbk_interp'
tinterpol_mxn,'lbk','Precip_hissb_coherence',newname='lbk_interp'

v1 = 'PeakDet_2W'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
get_data,'Precip_hissb_coherence',data=coh
get_data,'Precip_hissb_phase',data=ph
bw = coh.y[*,num]

tinterpol_mxn,'dbw','Precip_hissb_coherence',newname='dbw_interp'
tinterpol_mxn,'mbw','Precip_hissb_coherence',newname='mbw_interp'
tinterpol_mxn,'lbw','Precip_hissb_coherence',newname='lbw_interp'

v1 = 'PeakDet_2L'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
get_data,'Precip_hissb_coherence',data=coh
get_data,'Precip_hissb_phase',data=ph
bl = coh.y[*,num]

tinterpol_mxn,'dbl','Precip_hissb_coherence',newname='dbl_interp'
tinterpol_mxn,'mbl','Precip_hissb_coherence',newname='mbl_interp'
tinterpol_mxn,'lbl','Precip_hissb_coherence',newname='lbl_interp'

v1 = 'PeakDet_2X'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip_hissb'  
get_data,'Precip_hissb_coherence',data=coh
get_data,'Precip_hissb_phase',data=ph
bx = coh.y[*,num]

tinterpol_mxn,'dbx','Precip_hissb_coherence',newname='dbx_interp'
tinterpol_mxn,'mbx','Precip_hissb_coherence',newname='mbx_interp'
tinterpol_mxn,'lbx','Precip_hissb_coherence',newname='lbx_interp'



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



get_data,'dak_interp',data=dak
get_data,'daw_interp',data=daw
get_data,'dal_interp',data=dal
get_data,'dax_interp',data=dax

get_data,'dbk_interp',data=dbk
get_data,'dbw_interp',data=dbw
get_data,'dbl_interp',data=dbl
get_data,'dbx_interp',data=dbx

get_data,'mak_interp',data=mak
get_data,'maw_interp',data=maw
get_data,'mal_interp',data=mal
get_data,'max_interp',data=max

get_data,'mbk_interp',data=mbk
get_data,'mbw_interp',data=mbw
get_data,'mbl_interp',data=mbl
get_data,'mbx_interp',data=mbx

get_data,'lak_interp',data=lak
get_data,'law_interp',data=law
get_data,'lal_interp',data=lal
get_data,'lax_interp',data=lax

get_data,'lbk_interp',data=lbk
get_data,'lbw_interp',data=lbw
get_data,'lbl_interp',data=lbl
get_data,'lbx_interp',data=lbx



!p.multi = [0,0,3]

pa=5
pb=6
plot,dak.y,ak,xrange=[0,8],yrange=[0.0,1],/nodata,title='from jan6_correlations_allpayloads.pro!C3.3min periods only',$
	xtitle='Straight-line separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,dak.y,ak,thick=1.5,psym=pa
oplot,daw.y,aw,color=50,thick=1.5,psym=pa
oplot,dal.y,al,color=250,thick=1.5,psym=pa

oplot,dbk.y,bk,psym=pb,thick=1.5
oplot,dbw.y,bw,color=50,psym=pb,thick=1.5
oplot,dbl.y,bl,color=250,psym=pb,thick=1.5

;xyouts,0.5,0.9,'RBSP-A(B) and 2K',/normal
;xyouts,0.5,0.8,'RBSP-A(B) and 2W',/normal,color=50
;xyouts,0.5,0.7,'RBSP-A(B) and 2L',/normal,color=250




pa=5
pb=6
plot,mak.y,ak,xrange=[-6,6],yrange=[0.0,1],/nodata,title='from jan6_correlations_allpayloads.pro!C3.3min periods only',$
	xtitle='MLT separation b/t payloads (hrs)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,mak.y,ak,thick=1.5,psym=pa
oplot,maw.y,aw,color=50,thick=1.5,psym=pa
oplot,mal.y,al,color=250,thick=1.5,psym=pa

oplot,mbk.y,bk,psym=pb,thick=1.5
oplot,mbw.y,bw,color=50,psym=pb,thick=1.5
oplot,mbl.y,bl,color=250,psym=pb,thick=1.5

;xyouts,0.5,0.9,'RBSP-A(B) and 2K',/normal
;xyouts,0.5,0.8,'RBSP-A(B) and 2W',/normal,color=50
;xyouts,0.5,0.7,'RBSP-A(B) and 2L',/normal,color=250



pa=5
pb=6
plot,lak.y,ak,xrange=[-4,4],yrange=[0.0,1],/nodata,title='from jan6_correlations_allpayloads.pro!C3.3min periods only',$
	xtitle='Lshell separation b/t payloads (RE)',ytitle='coherence',xstyle=1,ystyle=1,psym=pa
oplot,lak.y,ak,thick=1.5,psym=pa
oplot,law.y,aw,color=50,thick=1.5,psym=pa
oplot,lal.y,al,color=250,thick=1.5,psym=pa

oplot,lbk.y,bk,psym=pb,thick=1.5
oplot,lbw.y,bw,color=50,psym=pb,thick=1.5
oplot,lbl.y,bl,color=250,psym=pb,thick=1.5

;xyouts,0.5,0.9,'RBSP-A(B) and 2K',/normal
;xyouts,0.5,0.8,'RBSP-A(B) and 2W',/normal,color=50
;xyouts,0.5,0.7,'RBSP-A(B) and 2L',/normal,color=170





;Average the coherence values in discrete bins....this simplifies the plots
cohs = [ak,aw,al,bk,bw,bl]
dists = [dak.y,daw.y,dal.y,dbk.y,dbw.y,dbl.y]
mlts = [mak.y,maw.y,mal.y,mbk.y,mbw.y,mbl.y]
lshells = [lak.y,law.y,lal.y,lbk.y,lbw.y,lbl.y]

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
plot,loc_lshell+0.5,avgs_lshell,xtitle='delta-Lshell',ytitle='average coherence!C(>0.5)',yrange=[0,1]
;plot,loc_lshell+0.5,meds_lshell,xtitle='delta-Lshell',ytitle='median coherence!C(>0.5)',yrange=[0,1]
plot,loc_lshell+0.5,ns_lshell,xtitle='delta-Lshell',ytitle='counts'

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
plot,loc_mlt+1,avgs_mlt,xtitle='delta-MLT',ytitle='average coherence!C(>0.5)',xrange=[-5,6],yrange=[0,1]
;plot,loc_mlt+1,meds_mlt,xtitle='delta-MLT',ytitle='median coherence!C(>0.5)',xrange=[-5,6],yrange=[0,1]
plot,loc_mlt+1,ns_mlt,xtitle='delta-MLT',ytitle='counts',xrange=[-5,6]











;result = histogram(lshells,locations=[1,2,3,4,5,6,7],/nan,reverse_indices=ri)
cov = cohs
ncohs = n_elements(cohs)

for b=0,ncohs-1 do if ri[b] ne ri[b+1] then cov[b] = total(cohs[ri[ri[b]:ri[b+1]-1]],/nan)/nsamples[b]






stop






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
plot, lshell3x, lshell3y, xrange=[-10,10], yrange=[-10,10],XSTYLE=4, YSTYLE=4, $
  title="Jan. 6, 2014 (L vs MLT Kp=1)!Cfrom jan6_correlations.pro"
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






window = 60.*30.
lag = window/4.
coherence_time = window*2.5
cormin = 0.4


T1='2014-01-06/15:00:00'	
T2='2014-01-06/23:00:00'	


v1 = 'PeakDet_2K'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2k_hissa'  
var = 'Precip2k_hissa_coherence'

get_data,'Precip2k_hissa_coherence',data=ddd
times = ddd.x


get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.

payload = '2K'
restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/barrel_template.sav'
;myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_2K_mag.dat'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_'+payload+'_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-06') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspa_state_lshell',times
tinterpol_mxn,'rbspa_state_mlt',times
tinterpol_mxn,'xv_'+payload,times
tinterpol_mxn,'yv_'+payload,times

get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2k
get_data,'yv_'+payload+'_interp',data=y2k



;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
xvafin = xva
yvafin = yva
x2k = x2k.y
y2k = y2k.y

datavals2ka = hc3m
datavals2ka[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals2ka[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals2ka[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals2ka[goo] = 75
goo = where((hc3m ge 0.6) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals2ka[goo] = 50
goo = where((hc3m ge 0.0) and (hc3m lt 0.6))
if goo[0] ne -1 then datavals2ka[goo] = 1

;----------------------------------------------------------------------------------------

v1 = 'PeakDet_2W'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2w_hissa'  
var = 'Precip2w_hissa_coherence'
tinterpol_mxn,'Precip2w_hissa_coherence',times,newname='Precip2w_hissa_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.

payload = '2W'
restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/barrel_template.sav'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_'+payload+'_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-06') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspa_state_lshell',times
tinterpol_mxn,'rbspa_state_mlt',times
tinterpol_mxn,'xv_'+payload,times
tinterpol_mxn,'yv_'+payload,times

get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2w
get_data,'yv_'+payload+'_interp',data=y2w



;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
x2w = x2w.y
y2w = y2w.y

datavals2wa = hc3m
datavals2wa[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals2wa[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals2wa[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals2wa[goo] = 75
goo = where((hc3m ge 0.6) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals2wa[goo] = 50
goo = where((hc3m ge 0.0) and (hc3m lt 0.6))
if goo[0] ne -1 then datavals2wa[goo] = 1



;----------------------------------------------------------------------------------------

v1 = 'PeakDet_2L'
v2 = 'Bfield_hissinta'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2l_hissa'  
var = 'Precip2l_hissa_coherence'
tinterpol_mxn,'Precip2l_hissa_coherence',times,newname='Precip2l_hissa_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.

payload = '2L'
restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/barrel_template.sav'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_'+payload+'_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-06') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspa_state_lshell',times
tinterpol_mxn,'rbspa_state_mlt',times
tinterpol_mxn,'xv_'+payload,times
tinterpol_mxn,'yv_'+payload,times

get_data,'rbspa_state_lshell_interp',data=la
get_data,'rbspa_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2l
get_data,'yv_'+payload+'_interp',data=y2l



;plot hiss correlations for A and B
xva = la.y*cos(mlta.y*360.*!dtor/24.)
yva = la.y*sin(mlta.y*360.*!dtor/24.)
x2l = x2l.y
y2l = y2l.y

datavals2la = hc3m
datavals2la[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals2la[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals2la[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals2la[goo] = 75
goo = where((hc3m ge 0.6) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals2la[goo] = 50
goo = where((hc3m ge 0.0) and (hc3m lt 0.6))
if goo[0] ne -1 then datavals2la[goo] = 1



;----------------------------------------------------------------------------------------

v1 = 'PeakDet_2K'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2k_hissb'  
var = 'Precip2k_hissb_coherence'
tinterpol_mxn,'Precip2k_hissb_coherence',times,newname='Precip2k_hissb_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.

payload = '2K'
restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/barrel_template.sav'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_'+payload+'_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-06') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspb_state_lshell',times
tinterpol_mxn,'rbspb_state_mlt',times
tinterpol_mxn,'xv_'+payload,times
tinterpol_mxn,'yv_'+payload,times

get_data,'rbspb_state_lshell_interp',data=la
get_data,'rbspb_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2l
get_data,'yv_'+payload+'_interp',data=y2l



;plot hiss correlations for A and B
xvb = la.y*cos(mlta.y*360.*!dtor/24.)
yvb = la.y*sin(mlta.y*360.*!dtor/24.)
xvbfin = xvb
yvbfin = yvb
x2k = x2l.y
y2k = y2l.y

datavals2kb = hc3m
datavals2kb[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals2kb[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals2kb[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals2kb[goo] = 75
goo = where((hc3m ge 0.6) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals2kb[goo] = 50
goo = where((hc3m ge 0.0) and (hc3m lt 0.6))
if goo[0] ne -1 then datavals2kb[goo] = 1



;----------------------------------------------------------------------------------------

v1 = 'PeakDet_2W'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2w_hissb'  
var = 'Precip2w_hissb_coherence'
tinterpol_mxn,'Precip2w_hissb_coherence',times,newname='Precip2w_hissb_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.

payload = '2W'
restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/barrel_template.sav'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_'+payload+'_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-06') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspb_state_lshell',times
tinterpol_mxn,'rbspb_state_mlt',times
tinterpol_mxn,'xv_'+payload,times
tinterpol_mxn,'yv_'+payload,times

get_data,'rbspb_state_lshell_interp',data=la
get_data,'rbspb_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2l
get_data,'yv_'+payload+'_interp',data=y2l



;plot hiss correlations for A and B
xvb = la.y*cos(mlta.y*360.*!dtor/24.)
yvb = la.y*sin(mlta.y*360.*!dtor/24.)
x2w = x2l.y
y2w = y2l.y

datavals2wb = hc3m
datavals2wb[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals2wb[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals2wb[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals2wb[goo] = 75
goo = where((hc3m ge 0.6) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals2wb[goo] = 50
goo = where((hc3m ge 0.0) and (hc3m lt 0.6))
if goo[0] ne -1 then datavals2wb[goo] = 1



;----------------------------------------------------------------------------------------

v1 = 'PeakDet_2L'
v2 = 'Bfield_hissintb'
dynamic_cross_spec_tplot,v1,0,v2,0,T1,T2,window,lag,coherence_time,new_name='Precip2l_hissb'  
var = 'Precip2l_hissb_coherence'
tinterpol_mxn,'Precip2l_hissb_coherence',times,newname='Precip2l_hissb_coherence'
get_data,var,data=dat
hc3m = dat.y[*,9]
print,1/dat.v[9]/60.

payload = '2L'
restore,'~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/barrel_template.sav'
myfile = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/bar_'+payload+'_mag.dat'
data = read_ascii(myfile, template = res)

data.mlt = data.mlt*360.0/24.0
x = abs(data.l)*cos(data.mlt*!pi/180.0)
y = abs(data.l)*sin(data.mlt*!pi/180.0)
tms = time_double('2014-01-06') + data.utsec
store_data,'xv_'+payload,data={x:tms,y:x}
store_data,'yv_'+payload,data={x:tms,y:y}
xtmp = tsample('xv_'+payload,time_double([T1,T2]),times=tmssx)
ytmp = tsample('yv_'+payload,time_double([T1,T2]),times=tmssy)
store_data,'xv_'+payload,data={x:tmssx,y:xtmp}
store_data,'yv_'+payload,data={x:tmssy,y:ytmp}

tinterpol_mxn,'rbspb_state_lshell',times
tinterpol_mxn,'rbspb_state_mlt',times
tinterpol_mxn,'xv_'+payload,times
tinterpol_mxn,'yv_'+payload,times

get_data,'rbspb_state_lshell_interp',data=la
get_data,'rbspb_state_mlt_interp',data=mlta
get_data,'xv_'+payload+'_interp',data=x2l
get_data,'yv_'+payload+'_interp',data=y2l



;plot hiss correlations for A and B
xvb = la.y*cos(mlta.y*360.*!dtor/24.)
yvb = la.y*sin(mlta.y*360.*!dtor/24.)
x2l = x2l.y
y2l = y2l.y

datavals2lb = hc3m
datavals2lb[*] = 0.
goo = where((hc3m ge 0.9) and (hc3m lt 1))
if goo[0] ne -1 then datavals2lb[goo] = 254
goo = where((hc3m ge 0.8) and (hc3m lt 0.9))
if goo[0] ne -1 then datavals2lb[goo] = 205
goo = where((hc3m ge 0.7) and (hc3m lt 0.8))
if goo[0] ne -1 then datavals2lb[goo] = 75
goo = where((hc3m ge 0.6) and (hc3m lt 0.7))
if goo[0] ne -1 then datavals2lb[goo] = 50
goo = where((hc3m ge 0.0) and (hc3m lt 0.6))
if goo[0] ne -1 then datavals2lb[goo] = 1






;popen,'~/Desktop/grab1.ps'

plot, lshell3x, lshell3y, xrange=[-10,10], yrange=[-10,10],XSTYLE=4, YSTYLE=4, $
  title="Jan. 6, 2014 (L vs MLT Kp=1)!Cfrom jan6_correlations_allpayloads.pro"
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


st = sort(datavals2ka)
datavals2 = (datavals2ka[st])
xva2fin = xva[st]
yva2fin = yva[st]
st = sort(datavals2kb)
datavals2 = (datavals2kb[st])
xvb2fin = xvb[st]
yvb2fin = yvb[st]



oplot,[xvafin,xvafin],[yvafin,yvafin],psym=4
oplot,[xvbfin,xvbfin],[yvbfin,yvbfin],psym=4,color=254


stop

;diamonds
dX = [-2, 0, 2, 0, -2]
dY = [0, 2, 0, -2, 0]
USERSYM, dX, dY,/fill,color=250


;Plot straight line connections b/t each sc with the color of the line indicating the correlation
;Sort by color so that the best correlations plot over the weaker ones
st = sort(datavals2ka)
datavals2 = (datavals2ka[st])
xva2 = xva[st]
xvb2 = x2k[st]
yva2 = yva[st]
yvb2 = y2k[st]
;for i=0,n_elements(datavals2)-1 do begin  $
;	print,datavals2[i] & $
;	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
for i=0,n_elements(datavals2)-1 do begin 
	print,datavals2[i]
	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
endfor

stop

st = sort(datavals2wa)
datavals2 = (datavals2wa[st])
xva2 = xva[st]
xvb2 = x2w[st]
yva2 = yva[st]
yvb2 = y2w[st]
;for i=0,n_elements(datavals2)-1 do begin  $
;	print,datavals2[i] & $
;	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
for i=0,n_elements(datavals2)-1 do begin  
	print,datavals2[i] 
	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
endfor

stop

st = sort(datavals2la)
datavals2 = (datavals2la[st])
xva2 = xva[st]
xvb2 = x2l[st]
yva2 = yva[st]
yvb2 = y2l[st]
;for i=0,n_elements(datavals2)-1 do begin  $
;	print,datavals2[i] & $
;	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
for i=0,n_elements(datavals2)-1 do begin  
	print,datavals2[i]
	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
endfor

stop

st = sort(datavals2kb)
datavals2 = (datavals2kb[st])
xva2 = xvb[st]
xvb2 = x2k[st]
yva2 = yvb[st]
yvb2 = y2k[st]
;for i=0,n_elements(datavals2)-1 do begin  $
;	print,datavals2[i] & $
;	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
for i=0,n_elements(datavals2)-1 do begin  
	print,datavals2[i]
	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
endfor

stop

st = sort(datavals2wb)
datavals2 = (datavals2wb[st])
xva2 = xvb[st]
xvb2 = x2w[st]
yva2 = yvb[st]
yvb2 = y2w[st]
;for i=0,n_elements(datavals2)-1 do begin  $
;	print,datavals2[i] & $
;	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
for i=0,n_elements(datavals2)-1 do begin  
	print,datavals2[i] 
	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
endfor

stop

st = sort(datavals2lb)
datavals2 = (datavals2lb[st])
xva2 = xvb[st]
xvb2 = x2l[st]
yva2 = yvb[st]
yvb2 = y2l[st]
;for i=0,n_elements(datavals2)-1 do begin  $
;	print,datavals2[i] & $
;	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
for i=0,n_elements(datavals2)-1 do begin 
	print,datavals2[i]
	if finite(datavals2[i]) then oplot,[xva2[i],xvb2[i]],[yva2[i],yvb2[i]],color=datavals2[i]
endfor


;pclose
stop


end
