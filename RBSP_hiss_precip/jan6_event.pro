;Determine the extent of the modulated hiss on Jan 3rd. The two sc are at their
;closest b/t 19-20 UT


date = '2014-01-06'
timespan,date
probe = 'a'

rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	




;--------------------------------------------------------
;EMFISIS file with hiss spec
pn = '~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/'
fnt = 'rbsp-a_WFR-spectral-matrix_emfisis-L2_20140106_v1.3.4.cdf'
cdf2tplot,file=pn+fnt
get_data,'BwBw',data=dd
store_data,'BwBw',data={x:dd.x,y:1000.*1000.*dd.y,v:reform(dd.v)}
options,'BwBw','spec',1
zlim,'BwBw',1d-6,100,1
ylim,'BwBw',20,1000,1
;---------------------------------------------------------------------


;--------------------------------------------------------
;MAGEIS file
pn = '~/Desktop/Research/RBSP_hiss_precip/mageis_cdfs/'
fnt = 'rbspa_rel02_ect-mageis-L2_20140106_v3.0.0.cdf'
cdf2tplot,file=pn+fnt
get_data,'FESA',data=dd
store_data,'FESA',data={x:dd.x,y:dd.y,v:reform(dd.v[0,*])}
get_data,'FESA',data=dd
store_data,'fesa_2mev',data={x:dd.x,y:dd.y[*,21]}
ylim,'fesa_2mev',0.02,100,1
ylim,'FESA',30,4000,1
tplot,'FESA'
zlim,'FESA',0,1d5



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

tplot_options,'title','from jan6_event.pro'

;spinperiod = 11.8
;2K is at an Lshell b/t 5-6

;the nice correlation b/t RBSP-A and 2K lasts from L=5 down to L=3.5 (dipole model)
;and a timespan from 18:40 - 22:20

payloads = ['2K']

t0 = date + '/' + '20:00'
t1 = date + '/' + '22:00'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,payloads,date,type='rcnt'
rbsp_load_barrel_lc,payloads,date
rbsp_load_efw_spec,probe='a',type='calibrated'

rbsp_efw_position_velocity_crib,/noplot,/notrace


rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='vsvy'
split_vec,'rbspa_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']

get_data,'rbspa_efw_vsvy_V1',data=v1a
get_data,'rbspa_efw_vsvy_V2',data=v2a

sum12a = (v1a.y + v2a.y)/2.

density = 7354.3897*exp(sum12a*2.8454878)+96.123628*exp(sum12a*0.43020781)
store_data,'density',data={x:v1a.x,y:density}

rbsp_detrend,'density',60.*10.
copy_data,'density_smoothed','density_smoothed1'      
rbsp_detrend,'density',60.*0.1667
tplot,['density_smoothed1','density_detrend'] 
   

get_data,'density_smoothed1',data=ds
get_data,'density_smoothed',data=d
dn_n = 100.*(d.y - ds.y)/ds.y

store_data,'dn_n',data={x:ds.x,y:dn_n}




;----------------------------------------------------------------

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



;Now let's calculated dhiss/hiss %

rbsp_detrend,'Bfield_hissinta',60.*20.
store_data,'tst2',data=['Bfield_hissinta','Bfield_hissinta_smoothed']
tplot,'tst2'

get_data,'Bfield_hissinta',data=hd
get_data,'Bfield_hissinta_smoothed',data=hs

dh_h = -1*100.*(hs.y - hd.y)/hs.y
store_data,'dh_h',data={x:hd.x,y:dh_h}
tplot,['tst2','dh_h']
;rbsp_detrend,'Bfield_hissinta',60.*20.

tplot,['Bfield_hissinta','Bfield_hissinta_detrend','Bfield_hissinta_smoothed']

;----------------------------------------------------------------

;--------------------------------------------------
;BARREL diffusion results
file = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip/barrel_cdfs/For_Aaron2014_01_06_200000_12.0.hdf5'
R2 = FILE_INFO(file)
help,r2,/st

print,H5F_IS_HDF5(file)
result = h5_parse(file,/READ_DATA)

avebounce = transpose(result.avebounce._DATA)
avelocal =  transpose(result.avelocal._DATA)
energy = 1000.*result.energy._DATA   ;keV
time = time_double(time_string(result.time._DATA)) + 30.  ;shift bins by 30 seconds

store_data,'2K_avebounce',data={x:time,y:avebounce,v:energy}
options,'2K_avebounce','spec',1
zlim,'2K_avebounce',1d-8,1d-2,1
tplot,'2K_avebounce'
store_data,'2K_avebounce30',data={x:time,y:avebounce[*,30]}
store_data,'2K_avebounce50',data={x:time,y:avebounce[*,50]}
store_data,'2K_avebounce75',data={x:time,y:avebounce[*,75]}
store_data,'2K_avebounce150',data={x:time,y:avebounce[*,150]}

tots = avebounce[*,30] + avebounce[*,50] + avebounce[*,75] + avebounce[*,150]
store_data,'2K_avebouncetots',data={x:time,y:tots}
tplot,['2K_avebounce','2K_avebounce30','2K_avebounce50','2K_avebounce75','2K_avebounce150','2K_avebouncetots']


store_data,'2K_avelocal',data={x:time,y:avelocal,v:energy}
options,'2K_avelocal','spec',1
zlim,'2K_avelocal',1d-8,1d-2,1
tplot,'2K_avelocal'
store_data,'2K_avelocal30',data={x:time,y:avelocal[*,30]}
store_data,'2K_avelocal50',data={x:time,y:avelocal[*,50]}
store_data,'2K_avelocal75',data={x:time,y:avelocal[*,75]}
store_data,'2K_avelocal150',data={x:time,y:avelocal[*,150]}

tots = avelocal[*,30] + avelocal[*,50] + avelocal[*,75] + avelocal[*,150]
store_data,'2K_avelocaltots',data={x:time,y:tots}
tplot,['2K_avelocal','2K_avelocal30','2K_avelocal50','2K_avelocal75','2K_avelocal150','2K_avelocaltots']



;Now let's calculated dhiss/hiss %

rbsp_detrend,'2K_avebouncetots',60.*20.
store_data,'tst3',data=['2K_avebouncetots','2K_avebouncetots_smoothed']
tplot,'tst3'

get_data,'2K_avebouncetots',data=hd
get_data,'2K_avebouncetots_smoothed',data=hs

dh_h = -1*100.*(hs.y - hd.y)/hs.y
store_data,'db_b',data={x:hd.x,y:dh_h}
tplot,['tst3','db_b']
tplot,['2K_avebouncetots','2K_avebouncetots_detrend','2K_avebouncetots_smoothed']



;--------------------------------------------------










;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_2K',data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_2K',data={x:xv,y:yv}
options,'PeakDet_2K','colors',250



;Now let's calculated hiss percent change

rbsp_detrend,'PeakDet_2K',60.*20.
store_data,'tst2k',data=['PeakDet_2K','PeakDet_2K_smoothed']
tplot,'tst2k'

get_data,'PeakDet_2K',data=hd
get_data,'PeakDet_2K_smoothed',data=hs

;dx_x = (hs.y - hd.y);/hs.y
dx_x = -1*100.*(hs.y - hd.y)/hs.y
store_data,'dx_x',data={x:hd.x,y:dx_x}
tplot,['tst2k','dx_x']


tplot,['PeakDet_2K','PeakDet_2K_detrend','PeakDet_2K_smoothed']


;---------------------------------------------------------------------







ylim,'FESA',30,300,1

store_data,'mlt_both',data=['rbspa_state_mlt','mlt_2I']
store_data,'l_both',data=['rbspa_state_lshell','l_2I']
options,'mlt_both','colors',[0,250]
options,'l_both','colors',[0,250]

tplot,['density','fesa_2mev','FESA','rbspa_state_lshell','rbspa_state_mlt','mlt_both','l_both','PeakDet_2I']
timebar,[t0,t1]










path = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/'


;------------------------------------------------
;Find absolute separation b/t VAPa and 2K

	restore, path+"barrel_template.sav"
	myfile = path+"BAR_2K_mag.dat"
	data = read_ascii(myfile, template = res)

	tms = time_double('2014-01-06/00:00') + data.utsec
	store_data,'mlt_2K',data={x:tms,y:data.mlt}
	store_data,'l_2K',data={x:tms,y:abs(data.l)}
	store_data,'mlat_2K',data={x:tms,y:data.lat}
	store_data,'alt_2K',data={x:tms,y:data.alt}


	tinterpol_mxn,'mlt_2K','rbspa_state_mlt'
	get_data,'mlt_2K_interp',data=t
	mlt2K = t.y * 360./24.
	get_data,'rbspa_state_mlt',data=t
	mlta = t.y

	tinterpol_mxn,'l_2K','rbspa_state_lshell'
	get_data,'l_2K_interp',data=t
	l2K = t.y
	get_data,'rbspa_state_lshell',data=t
	la = t.y

	tinterpol_mxn,'alt_2K','rbspa_state_lshell'
	get_data,'alt_2K_interp',data=t
	alt2K = t.y
	r2K = (6370. + alt2K)/6370.

	;Can get 2K mlat from Lshell and altitude
	;Lshell = rad/(cos(!dtor*mlat)^2)  ;L-shell in centered dipole
	mlat2K = acos(sqrt(r2K/l2K))/!dtor
	mlat2K = -1*mlat2K  ;southern hemisphere
	store_data,'mlat_2K',data={x:t.x,y:mlat2K}

	get_data,'rbspa_state_mlat',data=t
	mlata = t.y
	colata = 90. - mlata
	store_data,'rbspa_state_colat',data={x:t.x,y:colata}

	get_data,'mlat_2K',data=t
	mlat2K = t.y
	colat2K = 90. - mlat2K
	store_data,'colat_2K',data={x:t.x,y:colat2K}


	;Calculate SM coord (using MLT as longitude...shouldn't matter b/c I only want to know
	;the absolute separation b/t VAPa and 2I)
	longa = mlta*360./24.
	long2K = mlt2K
	store_data,'longa',data={x:t.x,y:longa}
	store_data,'long2K',data={x:t.x,y:long2K}
	get_data,'rbspa_state_radius',data=rada
	rada = rada.y
	rad2K = r2K
	colata = colata
	colat2K = colat2K


	x_sma = rada*sin(colata*!dtor)*cos(longa*!dtor)
	y_sma = rada*sin(colata*!dtor)*sin(longa*!dtor)
	z_sma = rada*cos(colata*!dtor)

	x_sm2K = rad2K*sin(colat2K*!dtor)*cos(long2K*!dtor)
	y_sm2K = rad2K*sin(colat2K*!dtor)*sin(long2K*!dtor)
	z_sm2K = rad2K*cos(colat2K*!dtor)

	smdiff = sqrt((abs(x_sma-x_sm2K))^2 + (abs(y_sma-y_sm2K))^2 + (abs(z_sma-z_sm2K))^2)
	store_data,'separation_KA',data={x:t.x,y:smdiff*6370.}

	store_data,'xsma',data={x:t.x,y:x_sma}
	store_data,'ysma',data={x:t.x,y:y_sma}
	store_data,'zsma',data={x:t.x,y:z_sma}
	store_data,'xsm2K',data={x:t.x,y:x_sm2K}
	store_data,'ysm2K',data={x:t.x,y:y_sm2K}
	store_data,'zsm2K',data={x:t.x,y:z_sm2K}
	store_data,'xdiff',data={x:t.x,y:(x_sma-x_sm2K)}
	store_data,'ydiff',data={x:t.x,y:(y_sma-y_sm2K)}
	store_data,'zdiff',data={x:t.x,y:(z_sma-z_sm2K)}

	tplot,'separation_KA'
	tplot,['longa','long2K']
	tplot,['rbspa_state_mlat','mlat_2K']
	tplot,['rbspa_state_colat','colat_2K']
	tplot,['xsma','xsm2K']
	tplot,['ysma','ysm2K']
	tplot,['zsma','zsm2K']
	tplot,['xdiff','ydiff','zdiff']


        dif_data,'rbspa_state_mlat','mlat_2K'
        dif_data,'longa','long2K'
        dif_data,'rbspa_state_mlt','mlt_2K'
        dif_data,'rbspa_state_lshell','l_2K'

  

;------------------------------------------------
;Find absolute separation b/t VAPa and 2L


	restore, path+"barrel_template.sav"
	myfile = path+"BAR_2L_mag.dat"
	data = read_ascii(myfile, template = res)

	tms = time_double('2014-01-06/00:00') + data.utsec
	store_data,'mlt_2L',data={x:tms,y:data.mlt}
	store_data,'l_2L',data={x:tms,y:abs(data.l)}
	store_data,'mlat_2L',data={x:tms,y:data.lat}
	store_data,'alt_2L',data={x:tms,y:data.alt}


	tinterpol_mxn,'mlt_2L','rbspa_state_mlt'
	get_data,'mlt_2L_interp',data=t
	mlt2L = t.y * 360./24.

	tinterpol_mxn,'l_2L','rbspa_state_lshell'
	get_data,'l_2L_interp',data=t
	l2L = t.y

	tinterpol_mxn,'alt_2L','rbspa_state_lshell'
	get_data,'alt_2L_interp',data=t
	alt2L = t.y
	r2L = (6370. + alt2L)/6370.

	;Can get 2L mlat from Lshell and altitude
	mlat2L = acos(sqrt(r2L/l2L))/!dtor
	mlat2L = -1*mlat2L  ;southern hemisphere
	store_data,'mlat_2L',data={x:t.x,y:mlat2L}

	get_data,'mlat_2L',data=t
	mlat2L = t.y
	colat2L = 90. - mlat2L
	store_data,'colat_2L',data={x:t.x,y:colat2L}


	;Calculate SM coord (using MLT as longitude...shouldn't matter b/c I only want to know
	;the absolute separation b/t VAPa and 2I)
	long2L = mlt2L
	store_data,'long2L',data={x:t.x,y:long2L}
	rad2L = r2L
	colat2L = colat2L

	x_sm2L = rad2L*sin(colat2L*!dtor)*cos(long2L*!dtor)
	y_sm2L = rad2L*sin(colat2L*!dtor)*sin(long2L*!dtor)
	z_sm2L = rad2L*cos(colat2L*!dtor)

	smdiff = sqrt((abs(x_sma-x_sm2L))^2 + (abs(y_sma-y_sm2L))^2 + (abs(z_sma-z_sm2L))^2)
	store_data,'separation_LA',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_sm2K-x_sm2L))^2 + (abs(y_sm2K-y_sm2L))^2 + (abs(z_sm2K-z_sm2L))^2)
	store_data,'separation_KL',data={x:t.x,y:smdiff*6370.}


	store_data,'xsm2L',data={x:t.x,y:x_sm2L}
	store_data,'ysm2L',data={x:t.x,y:y_sm2L}
	store_data,'zsm2L',data={x:t.x,y:z_sm2L}

	tplot,['separation_LA','separation_KL']


        dif_data,'rbspa_state_mlt','mlt_2L'
        dif_data,'rbspa_state_lshell','l_2L'



;------------------------------------------------
;2W


	restore, path+"barrel_template.sav"
	myfile = path+"BAR_2W_mag.dat"
	data = read_ascii(myfile, template = res)

	tms = time_double('2014-01-06/00:00') + data.utsec
	store_data,'mlt_2W',data={x:tms,y:data.mlt}
	store_data,'l_2W',data={x:tms,y:abs(data.l)}
	store_data,'mlat_2W',data={x:tms,y:data.lat}
	store_data,'alt_2W',data={x:tms,y:data.alt}


	tinterpol_mxn,'mlt_2W','rbspa_state_mlt'
	get_data,'mlt_2W_interp',data=t
	mlt2W = t.y * 360./24.

	tinterpol_mxn,'l_2W','rbspa_state_lshell'
	get_data,'l_2W_interp',data=t
	l2W = t.y

	tinterpol_mxn,'alt_2W','rbspa_state_lshell'
	get_data,'alt_2W_interp',data=t
	alt2W = t.y
	r2W = (6370. + alt2W)/6370.

	;Can get 2W mlat from Lshell and altitude
	mlat2W = acos(sqrt(r2W/l2W))/!dtor
	mlat2W = -1*mlat2W  ;southern hemisphere
	store_data,'mlat_2W',data={x:t.x,y:mlat2W}

	get_data,'mlat_2W',data=t
	mlat2W = t.y
	colat2W = 90. - mlat2W
	store_data,'colat_2W',data={x:t.x,y:colat2W}


	;Calculate SM coord (using MLT as longitude...shouldn't matter b/c I only want to know
	;the absolute separation b/t VAPa and 2I)
	long2W = mlt2W
	store_data,'long2W',data={x:t.x,y:long2W}
	rad2W = r2W
	colat2W = colat2W

	x_sm2W = rad2W*sin(colat2W*!dtor)*cos(long2W*!dtor)
	y_sm2W = rad2W*sin(colat2W*!dtor)*sin(long2W*!dtor)
	z_sm2W = rad2W*cos(colat2W*!dtor)

	smdiff = sqrt((abs(x_sma-x_sm2W))^2 + (abs(y_sma-y_sm2W))^2 + (abs(z_sma-z_sm2W))^2)
	store_data,'separation_WA',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_sm2L-x_sm2W))^2 + (abs(y_sm2L-y_sm2W))^2 + (abs(z_sm2L-z_sm2W))^2)
	store_data,'separation_LW',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_sm2K-x_sm2W))^2 + (abs(y_sm2K-y_sm2W))^2 + (abs(z_sm2K-z_sm2W))^2)
	store_data,'separation_KW',data={x:t.x,y:smdiff*6370.}


	store_data,'xsm2W',data={x:t.x,y:x_sm2W}
	store_data,'ysm2W',data={x:t.x,y:y_sm2W}
	store_data,'zsm2W',data={x:t.x,y:z_sm2W}

	tplot,['separation_LA','separation_KL','separation_LW','separation_WA']


;------------------------------------------------
;2X


	restore, path+"barrel_template.sav"
	myfile = path+"BAR_2X_mag.dat"
	data = read_ascii(myfile, template = res)

	tms = time_double('2014-01-06/00:00') + data.utsec
	store_data,'mlt_2X',data={x:tms,y:data.mlt}
	store_data,'l_2X',data={x:tms,y:abs(data.l)}
	store_data,'mlat_2X',data={x:tms,y:data.lat}
	store_data,'alt_2X',data={x:tms,y:data.alt}


	tinterpol_mxn,'mlt_2X','rbspa_state_mlt'
	get_data,'mlt_2X_interp',data=t
	mlt2X = t.y * 360./24.

	tinterpol_mxn,'l_2X','rbspa_state_lshell'
	get_data,'l_2X_interp',data=t
	l2X = t.y

	tinterpol_mxn,'alt_2X','rbspa_state_lshell'
	get_data,'alt_2X_interp',data=t
	alt2X = t.y
	r2X = (6370. + alt2X)/6370.

	;Can get 2X mlat from Lshell and altitude
	mlat2X = acos(sqrt(r2X/l2X))/!dtor
	mlat2X = -1*mlat2X  ;southern hemisphere
	store_data,'mlat_2X',data={x:t.x,y:mlat2X}

	get_data,'mlat_2X',data=t
	mlat2X = t.y
	colat2X = 90. - mlat2X
	store_data,'colat_2X',data={x:t.x,y:colat2X}


	;Calculate SM coord (using MLT as longitude...shouldn't matter b/c I only want to know
	;the absolute separation b/t VAPa and 2I)
	long2X = mlt2X
	store_data,'long2X',data={x:t.x,y:long2X}
	rad2X = r2X
	colat2X = colat2X

	x_sm2X = rad2X*sin(colat2X*!dtor)*cos(long2X*!dtor)
	y_sm2X = rad2X*sin(colat2X*!dtor)*sin(long2X*!dtor)
	z_sm2X = rad2X*cos(colat2X*!dtor)

	smdiff = sqrt((abs(x_sma-x_sm2X))^2 + (abs(y_sma-y_sm2X))^2 + (abs(z_sma-z_sm2X))^2)
	store_data,'separation_XA',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_sm2L-x_sm2X))^2 + (abs(y_sm2L-y_sm2X))^2 + (abs(z_sm2L-z_sm2X))^2)
	store_data,'separation_XL',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_sm2W-x_sm2X))^2 + (abs(y_sm2W-y_sm2X))^2 + (abs(z_sm2W-z_sm2X))^2)
	store_data,'separation_XW',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_sm2K-x_sm2X))^2 + (abs(y_sm2K-y_sm2X))^2 + (abs(z_sm2K-z_sm2X))^2)
	store_data,'separation_XK',data={x:t.x,y:smdiff*6370.}


	store_data,'xsm2X',data={x:t.x,y:x_sm2X}
	store_data,'ysm2X',data={x:t.x,y:y_sm2X}
	store_data,'zsm2X',data={x:t.x,y:z_sm2X}

	tplot,['separation_LA','separation_KL','separation_LW','separation_WA','separation_XA',$
		'separation_XL','separation_XW','separation_XK']





;------------------------------------------------
;B


	get_data,'rbspb_state_mlat',data=t
	mlatb = t.y
	colatb = 90. - mlatb
	store_data,'rbspb_state_colat',data={x:t.x,y:colatb}
	get_data,'rbspb_state_mlt',data=t
	mltb = t.y



	;Calculate SM coord (using MLT as longitude...shouldn't matter b/c I only want to know
	;the absolute separation b/t VAPa and 2I)
	longb = mltb*360./24.
	store_data,'longb',data={x:t.x,y:longb}
	get_data,'rbspb_state_radius',data=radb
	radb = radb.y
	colatb = colatb


	x_smb = radb*sin(colatb*!dtor)*cos(longb*!dtor)
	y_smb = radb*sin(colatb*!dtor)*sin(longb*!dtor)
	z_smb = radb*cos(colatb*!dtor)

	smdiff = sqrt((abs(x_smb-x_sm2K))^2 + (abs(y_smb-y_sm2K))^2 + (abs(z_smb-z_sm2K))^2)
	store_data,'separation_BK',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_smb-x_sm2X))^2 + (abs(y_smb-y_sm2X))^2 + (abs(z_smb-z_sm2X))^2)
	store_data,'separation_BX',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_smb-x_sm2L))^2 + (abs(y_smb-y_sm2L))^2 + (abs(z_smb-z_sm2L))^2)
	store_data,'separation_BL',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_smb-x_sm2W))^2 + (abs(y_smb-y_sm2W))^2 + (abs(z_smb-z_sm2W))^2)
	store_data,'separation_BW',data={x:t.x,y:smdiff*6370.}

	smdiff = sqrt((abs(x_smb-x_sma))^2 + (abs(y_smb-y_sma))^2 + (abs(z_smb-z_sma))^2)
	store_data,'separation_AB',data={x:t.x,y:smdiff*6370.}


	store_data,'xsmb',data={x:t.x,y:x_sma}
	store_data,'ysmb',data={x:t.x,y:y_sma}
	store_data,'zsmb',data={x:t.x,y:z_sma}

	tplot,['separation_LA','separation_KL','separation_LW','separation_WA','separation_XA',$
		'separation_XL','separation_XW','separation_XK','separation_BK','separation_BX',$
		'separation_BL','separation_BW','separation_AB','separation_KA','separation_KW']








;---------------------------------------
;compare all 4 payloads

rbsp_detrend,['Bfield_hissinta','PeakDet_2K','dn_n'],60.*1

ylim,'BwBw',10,1000,1
zlim,'BwBw',0.001,20,1
ylim,'Bfield_hissinta_smoothed',0,0.12
ylim,'PeakDet_2K_smoothed',3400,5000
ylim,'dn_n_smoothed',-15,15

tplot,['BwBw','Bfield_hissinta_smoothed','PeakDet_2K_smoothed','dn_n_smoothed']





rbsp_detrend,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L',$
			'PeakDet_2W'],60.*0.3
ylim,'Bfield_hissintb_smoothed',0.01,0.03
ylim,'PeakDet_2K_smoothed',3500,5000
ylim,'PeakDet_2L_smoothed',4000,10000
ylim,'PeakDet_2W_smoothed',4000,7000

tplot,['Bfield_hissinta','Bfield_hissintb','PeakDet_2K','PeakDet_2L','PeakDet_2W'] + '_smoothed'


	



;store_data,'density',data={x:v1a.x,y:density}
;store_data,'densityb',data={x:v1b.x,y:densityb}
;ylim,'density?',100,1000,1
;options,'density','ytitle','density!Ccm^-3'
;options,'densityb','ytitle','densityB!Ccm^-3'

;options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
;	'rbsp_state_lshell_both'],'panel_size',0.25
;options,['rbsp_state_sc_sep','rbsp_state_mlt_diff','rbsp_state_lshell_diff',$
;	'rbsp_state_lshell_both'],'thick',2



;-------------------------------------------------------------------







;------------------------------------------------------------------
;Look for wave fluctuations in Bfield and Efield survey products
;------------------------------------------------------------------

t0 = time_double('2014-01-06/20:00')
t1 = time_double('2014-01-06/22:00')

rbsp_efw_position_velocity_crib,/noplot,/notrace
rbsp_efw_vxb_subtract_crib,probe,/hires,/no_spice_load


get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=esvy
times = esvy.x

rbsp_boom_directions_crib,times,'a',/no_spice_load
tplot,['vecu_gse','vecv_gse','vecw_gse']


rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Magnitude',60.*5.

;-----------------------------------------------------------
;subtract off background field
rbsp_load_emfisis,probe=probe,coord='gse',cadence='4sec',level='l3'  ;load this for the mag model subtract
rbsp_detrend,'rbspa_emfisis_l3_4sec_gse_Mag',60.*0.2

rbsp_detrend,'rbspa_emfisis_l3_4sec_gse_Mag_smoothed',60.*20.
rbsp_detrend,'rbspa_emfisis_l3_4sec_gse_Mag_smoothed_detrend',60.*10.
split_vec,'rbspa_emfisis_l3_4sec_gse_Mag_smoothed_detrend_detrend'
tplot,'rbspa_emfisis_l3_4sec_gse_Mag_smoothed_detrend_detrend_z'

dif_data,'rbspa_emfisis_l3_1sec_gse_Mag','rbspa_emfisis_l3_1sec_gse_Mag_smoothed'
tplot,['rbspa_emfisis_l3_1sec_gse_Mag','rbspa_emfisis_l3_1sec_gse_Mag_smoothed','rbspa_emfisis_l3_1sec_gse_Mag-rbspa_emfisis_l3_1sec_gse_Mag_smoothed']


rbsp_detrend,'rbspa_emfisis_l3_4sec_gse_Mag',60.*0.2
rbsp_detrend,'rbspa_emfisis_l3_4sec_gse_Mag_smoothed',60.*20.
get_data,'rbspa_emfisis_l3_4sec_gse_Mag_smoothed_smoothed',data=bodc
get_data,'rbspa_emfisis_l3_4sec_gse_Mag',data=bw

db_b = 100.*(bw.y[*,2] - bodc.y[*,2])/bodc.y[*,2]
store_data,'db_b',data={x:bodc.x,y:db_b}
tplot,['rbspa_emfisis_l3_4sec_gse_Mag_smoothed_detrend_detrend_z','db_b']
;-----------------------------------------------------------







tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Mag',times,newname='rbspa_emfisis_l3_4sec_gse_Mag'
tinterpol_mxn,'rbspa_emfisis_l3_4sec_gse_Magnitude',times,newname='rbspa_emfisis_l3_4sec_gse_Magnitude'

get_data,'rbspa_emfisis_l3_4sec_gse_Mag',data=mag
get_data,'rbspa_emfisis_l3_4sec_gse_Magnitude',data=magnit
magnit = magnit.y
mag_uvec = [[mag.y[*,0]],[mag.y[*,1]],[mag.y[*,2]]]
mag_uvec[*,0] /= magnit
mag_uvec[*,1] /= magnit
mag_uvec[*,2] /= magnit



;Find out when the u and v antennas are roughly perp and parallel to Bo
get_data,'vecu_gse',data=vecu
get_data,'vecv_gse',data=vecv
get_data,'vecw_gse',data=vecw

angleub = fltarr(n_elements(vecu.x))
for i=0L,n_elements(vecu.x)-1 do angleub[i] = acos(total(mag_uvec[i,*] * vecu.y[i,*]))/!dtor
store_data,'angleub',data={x:times,y:angleub}
anglevb = fltarr(n_elements(vecu.x))
for i=0L,n_elements(vecu.x)-1 do anglevb[i] = acos(total(mag_uvec[i,*] * vecv.y[i,*]))/!dtor
store_data,'anglevb',data={x:times,y:anglevb}
anglewb = fltarr(n_elements(vecu.x))
for i=0L,n_elements(vecu.x)-1 do anglewb[i] = acos(total(mag_uvec[i,*] * vecw.y[i,*]))/!dtor
store_data,'anglewb',data={x:times,y:anglewb}


;plot angle b/t antennas and Bo
tplot,['angleub','anglevb','anglewb']



;Load the Esvy in UVW to see what the parallel and perp (to Bo) components are

rbsp_load_efw_waveform,probe='a',type='calibrated',datatype='esvy',coord='uvw'
copy_data,'rbspa_efw_esvy','rbspa_efw_esvy_uvw'
get_data,'rbspa_efw_esvy_uvw',data=esvy_uvw

esvy_u = esvy_uvw.y[*,0]
goo = where((angleub le 87) or (angleub ge 92))
esvy_u[goo] = !values.f_nan
store_data,'esvy_u_perp',data={x:times,y:esvy_u}

esvy_u = esvy_uvw.y[*,0]
goo = where(angleub ge 2)
esvy_u[goo] = !values.f_nan
store_data,'esvy_u_para',data={x:times,y:esvy_u}


ylim,['esvy_u_perp','esvy_u_para'],-2,2
tplot,['esvy_u_perp','esvy_u_para']


;Replace the spinaxis MGSE component with the perp component from E12
get_data,'esvy_u_perp',data=eperp
get_data,'rbspa_efw_esvy_mgse_vxb_removed',data=emgse

emgse.y[*,0] = eperp.y
store_data,'rbspa_efw_esvy_mgse_vxb_removed_fixed',data=emgse


;Transform Bfield into MGSE
get_data,'rbspa_spinaxis_direction_gse',data=wsc
wsc_gse = reform(wsc.y[0,*])
rbsp_gse2mgse,'rbspa_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbspa_emfisis_l3_1sec_mgse_Mag'
tinterpol_mxn,'rbspa_emfisis_l3_1sec_mgse_Mag',times,newname='rbspa_emfisis_l3_1sec_mgse_Mag'
split_vec,'rbspa_emfisis_l3_1sec_mgse_Mag'


;Smooth the data over short timespan
rbsp_detrend,['rbspa_emfisis_l3_1sec_mgse_Mag_x','rbspa_emfisis_l3_1sec_mgse_Mag_y','rbspa_emfisis_l3_1sec_mgse_Mag_z'],60.*5.
join_vec,['rbspa_emfisis_l3_1sec_mgse_Mag_x_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_y_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_z_detrend'],'rbspa_emfisis_l3_1sec_mgse_Mag_detrend'
join_vec,['rbspa_emfisis_l3_1sec_mgse_Mag_x_smoothed','rbspa_emfisis_l3_1sec_mgse_Mag_y_smoothed','rbspa_emfisis_l3_1sec_mgse_Mag_z_smoothed'],'rbspa_emfisis_l3_1sec_mgse_Mag_smoothed'



;Rotate fixed efield to Bo
fa = rbsp_rotate_field_2_vec('rbspa_efw_esvy_mgse_vxb_removed_fixed','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)
ylim,'rbspa_efw_esvy_mgse_vxb_removed_fixed_EFA_coord',-2,2


;Now rotate the detrended Bo to smoothed Bo
fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)


;****************************
;Test wave with z MGSE = 0
;get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend',data=dd
;
;wx = sin(indgen(n_elements(dd.x))/10.)
;wy = cos(indgen(n_elements(dd.x))/10.)
;wz = replicate(0.,n_elements(dd.x))
;
;
;tstwave = [[wx],[wy],[wz]]
;store_data,'tstwave',data={x:dd.x,y:tstwave}
;
;fa = rbsp_rotate_field_2_vec('tstwave','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed_DS')
;fa = rbsp_rotate_field_2_vec('tstwave','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)
;
;;These both look good. The field-aligned z component is small
;tplot,['tstwave_FA_minvar','tstwave_EFA_coord']

;****************************



;*****TRY MINVAR COORD********
;Rotate fixed efield to Bo
;rbsp_downsample,'rbspa_emfisis_l3_1sec_mgse_Mag_smoothed',1/2
;fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_smoothed_DS')

;****************************


split_vec,'rbspa_emfisis_l3_1sec_gse_Mag'
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_x',60.*5.
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_y',60.*5.
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Mag_z',60.*5.
join_vec,['rbspa_emfisis_l3_1sec_gse_Mag_x_detrend','rbspa_emfisis_l3_1sec_gse_Mag_y_detrend','rbspa_emfisis_l3_1sec_gse_Mag_z_detrend'],'rbspa_emfisis_l3_1sec_gse_Mag_detrend'

;VERY LITTLE FA EFIELD COMPONENT.
tplot,['rbspa_efw_esvy_mgse_vxb_removed_fixed_EFA_coord','rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord']

;Check the GSE mag to be sure that there is a field-aligned component
tplot,'rbspa_emfisis_l3_1sec_gse_Mag_detrend'

;OK, now I'm convinced that there is a FA compressional Bmag component
;Let's compare this to dn/n

split_vec,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord'

;Clearly the Bz component correlates well with dn/n much better than
;the perp components

tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_x',$
	   'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_y',$
	   'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n']

;OK, let's overplot the phases of dn_n and FA Bw to see if it's slow or fast mode
rbsp_detrend,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n'],60.*20.
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n']+'_detrend'

;Normalize these and overplot
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z',data=tmp
tmp2 = tmp.y*10.
store_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10',data={x:tmp.x,y:tmp2}


;Test phase of dn_n
rbsp_detrend,'density',60.*5.
rbsp_detrend,'density_detrend',60.*0.2

store_data,'corr',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','dn_n_detrend']
options,'corr','colors',[0,250]
options,'corr','ytitle','Black=10x Bw FA (nT)!CRed=dn_n percent!Cdetrended'
store_data,'corr2',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','density_detrend_smoothed']
options,'corr2','colors',[0,250]
options,'corr2','ytitle','Black=10x Bw FA (nT)!CRed=density(cm-3)!Cdetrended'


;Density and FA Bw are out of phase, suggesting slow mode wave
ylim,['corr','corr2'],-10,10
tplot,['corr','corr2']

rbsp_detrend,['density','dens_emfisis','PeakDet_2K'],60*30.
rbsp_detrend,'rbspa_emfisis_l3_1sec_gse_Magnitude',60.*10.
tplot,['PeakDet_2K','Bfield_hissinta','dens_emfisis_detrend','density_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','rbspa_emfisis_l3_1sec_gse_Magnitude_detrend']


;rbsp_detrend,['density','dens_emfisis','PeakDet_2K'],60*30.
rbsp_detrend,['PeakDet_2K','Bfield_hissinta','density','rbspa_emfisis_l3_1sec_gse_Magnitude','rbspa_emfisis_l3_1sec_gse_Mag'],60.*0.2
rbsp_detrend,['PeakDet_2K_smoothed','Bfield_hissinta_smoothed','density_smoothed','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed','rbspa_emfisis_l3_1sec_gse_Mag_smoothed'],60.*20.
tplot,['PeakDet_2K_smoothed_detrend','Bfield_hissinta_smoothed_detrend','rbspa_emfisis_l3_1sec_gse_Magnitude_smoothed_detrend','rbspa_emfisis_l3_1sec_gse_Mag_smoothed_detrend','density_smoothed_detrend']




get_data,'FESA',data=fesa

store_data,'fesa30',data={x:fesa.x,y:fesa.y[*,3]}
store_data,'fesa54',data={x:fesa.x,y:fesa.y[*,4]}
store_data,'fesa80',data={x:fesa.x,y:fesa.y[*,5]}
store_data,'fesa108',data={x:fesa.x,y:fesa.y[*,6]}
store_data,'fesa144',data={x:fesa.x,y:fesa.y[*,8]}

rbsp_detrend,'fesa*',60.*3.
store_data,'fesas',data=['fesa30','fesa54','fesa80','fesa108','fesa144']+'_detrend'
options,'fesas','colors',[0,50,100,150,200]

tplot,['corr2','fesa30_detrend','fesa54_detrend','fesa80_detrend','fesa108_detrend','fesa144_detrend']


get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_x',data=mx
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_y',data=my
get_data,'rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z',data=mz
mag = sqrt(mx.y^2 + my.y^2 + mz.y^2)
store_data,'Bmag_10x',data={x:mx.x,y:mag*10.}
store_data,'Bmag',data={x:mx.x,y:mag}

get_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_detrend',data=dd
store_data,'rbspa_emfisis_l3_1sec_gse_Magnitude_detrend_10x',data={x:dd.x,y:10*dd.y}
get_data,'fesa30_detrend',data=dd
store_data,'fesatmp',data={x:dd.x,y:dd.y/100.}
store_data,'comb1',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','fesatmp']
store_data,'comb2',data=['density_detrend_smoothed','fesatmp']
store_data,'comb3',data=['rbspa_emfisis_l3_1sec_gse_Magnitude_detrend_10x','fesatmp']
;store_data,'comb3',data=['Bmag','fesatmp']
store_data,'comb4',data=['Bmag','rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z']
options,'comb1','colors',[0,250]
options,'comb2','colors',[50,250]
options,'comb3','colors',[0,250]
options,'comb1','ytitle','Bw_FA(nTx10)!CRed=FESA30keV!Cdetrend'
options,'comb2','ytitle','Density(cm-3)!CRed=FESA30keV!Cdetrend'
options,'comb3','ytitle','Bmag(nTx10)!CRed=FESA30keV!Cdetrend'

tplot,['comb1','comb2']

store_data,'comb2',data=['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','density_detrend_smoothed','fesatmp']
options,'comb2','colors',[0,50,250]



get_data,'FPSA',data=fpsa

store_data,'fpsa58',data={x:fpsa.x,y:fpsa.y[*,0]}
store_data,'fpsa70',data={x:fpsa.x,y:fpsa.y[*,1]}
store_data,'fpsa83',data={x:fpsa.x,y:fpsa.y[*,2]}
store_data,'fpsa99',data={x:fpsa.x,y:fpsa.y[*,3]}
store_data,'fpsa118',data={x:fpsa.x,y:fpsa.y[*,4]}

rbsp_detrend,'fpsa*',60.*3.
store_data,'fpsas',data=['fpsa58','fpsa70','fpsa83','fpsa99','fpsa118']+'_detrend'
options,'fpsas','colors',[0,50,100,150,200]

tplot,['corr2','fpsa58_detrend','fpsa70_detrend','fpsa83_detrend','fpsa99_detrend','fpsa118_detrend']

tplot,['corr2','fpsas']


;tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord','rbspa_emfisis_l3_1sec_gse_Magnitude_detrend']




;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************

t0z = '2014-01-06/19:00'
t1z = '2014-01-06/21:50'


tplot,['rbspa_emfisis_l3_1sec_mgse_Magnitude','density']
tlimit,t0z,t1z

;----------
;Background field direction
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag',60.*0.168
copy_data,'rbspa_emfisis_l3_1sec_mgse_Mag_smoothed','rbspa_emfisis_l3_1sec_mgse_Mag_sp'
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
rbsp_downsample,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_smoothed',1/2.

rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_sp','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend']
rbsp_detrend,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend',60.*40.
tplot,['rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
store_data,'bcomb',data=['rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
options,'bcomb','colors',[0,250]
tplot,'bcomb'
fa = rbsp_rotate_field_2_vec('rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_smoothed_DS')
tplot,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_FA_minvar'
split_vec,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend'
;----------
;Density

rbsp_detrend,'density',60.*0.168
copy_data,'density','density_sp'
tplot,['density','density_sp']
rbsp_detrend,'density_sp',60.*20.
tplot,['density_sp','density_sp_detrend']
rbsp_detrend,'density_sp_detrend',60.*40.
tplot,['density_sp_detrend','density_sp_detrend_detrend']
store_data,'dcomb',data=['density_sp_detrend','density_sp_detrend_detrend']
options,'dcomb','colors',[0,250]
tplot,'dcomb'
;----------
;FESA30
rbsp_detrend,'fesa30',60.*0.168
copy_data,'fesa30','fesa30_sp'
tplot,['fesa30','fesa30_sp']
rbsp_detrend,'fesa30_sp',60.*20.
tplot,['fesa30_sp','fesa30_sp_detrend']
;----------
;FESA54
rbsp_detrend,'fesa54',60.*0.168
copy_data,'fesa54','fesa54_sp'
tplot,['fesa54','fesa54_sp']
rbsp_detrend,'fesa54_sp',60.*20.
tplot,['fesa54_sp','fesa54_sp_detrend']
;----------
;FESA80
rbsp_detrend,'fesa80',60.*0.168
copy_data,'fesa80','fesa80_sp'
tplot,['fesa80','fesa80_sp']
rbsp_detrend,'fesa80_sp',60.*20.
tplot,['fesa80_sp','fesa80_sp_detrend']
;----------
;FESA108
rbsp_detrend,'fesa108',60.*0.168
copy_data,'fesa108','fesa108_sp'
tplot,['fesa108','fesa108_sp']
rbsp_detrend,'fesa108_sp',60.*20.
tplot,['fesa108_sp','fesa108_sp_detrend']
;----------
;FESA144
rbsp_detrend,'fesa144',60.*0.168
copy_data,'fesa144','fesa144_sp'
tplot,['fesa144','fesa144_sp']
rbsp_detrend,'fesa144_sp',60.*20.
tplot,['fesa144_sp','fesa144_sp_detrend']
;----------
;Bfield hissint
rbsp_detrend,'Bfield_hissinta',60.*0.168
copy_data,'Bfield_hissinta','Bfield_hissinta_sp'
tplot,['Bfield_hissinta','Bfield_hissinta_sp']
rbsp_detrend,'Bfield_hissinta_sp',60.*20.
tplot,['Bfield_hissinta_sp','Bfield_hissinta_sp_detrend']
rbsp_detrend,'Bfield_hissinta_sp_detrend',60.*40.
tplot,['Bfield_hissinta_sp_detrend','Bfield_hissinta_sp_detrend_detrend']
store_data,'hcomb',data=['Bfield_hissinta_sp_detrend','Bfield_hissinta_sp_detrend_detrend']
options,'hcomb','colors',[0,250]
tplot,'hcomb'
;----------
;PeakDet_2K
rbsp_detrend,'PeakDet_2K',60.*0.168
copy_data,'PeakDet_2K','PeakDet_2K_sp'
tplot,['PeakDet_2K','PeakDet_2K_sp']
rbsp_detrend,'PeakDet_2K_sp',60.*20.
tplot,['PeakDet_2K_sp','PeakDet_2K_sp_detrend']
rbsp_detrend,'PeakDet_2K_sp_detrend',60.*40.
tplot,['PeakDet_2K_sp_detrend','PeakDet_2K_sp_detrend_detrend']
store_data,'pcomb',data=['PeakDet_2K_sp_detrend','PeakDet_2K_sp_detrend_detrend']
options,'pcomb','colors',[0,250]
tplot,'pcomb'




ylim,'rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',-2,2
ylim,'density_sp_detrend_detrend',-40,40
ylim,'fesa30_sp_detrend',-1000,1000
ylim,'fesa54_sp_detrend',-500,500
ylim,'fesa80_sp_detrend',-500,500
ylim,'fesa108_sp_detrend',-300,300

tplot_options,'title','products for correlation...12sec to 20min periods allowed'
tplot,['PeakDet_2K_sp_detrend_detrend','Bfield_hissinta_sp_detrend_detrend','density_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend','fesa80_sp_detrend','fesa108_sp_detrend','fesa144_sp_detrend']
tplot,['PeakDet_2K_sp_detrend_detrend','Bfield_hissinta_sp_detrend_detrend','density_sp_detrend_detrend','rbspa_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend']



date = '2012-10-13'
date2 = '20121013'
filename='rbsp_skeleton_' + date2 + '.cdf'


