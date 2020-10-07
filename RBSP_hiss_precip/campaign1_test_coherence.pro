;Determine the extent of the modulated hiss on Jan 3rd. The two sc are at their
;closest b/t 19-20 UT


date = '2013-02-02'
timespan,date
probe = 'b'
bal = '1U'

rbsp_efw_init	
!rbsp_efw.user_agent = ''

tplot_options,'xmargin',[20.,15.]
tplot_options,'ymargin',[3,6]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1	




;; ;--------------------------------------------------------
;; ;EMFISIS file with hiss spec
;; pn = '~/Desktop/Research/RBSP_hiss_precip/emfisis_cdfs/'
;; fnt = 'rbsp-b_WFR-spectral-matrix_emfisis-L2_20130202_v1.4.1.cdf'
;; cdf2tplot,file=pn+fnt
;; get_data,'BwBw',data=dd
;; store_data,'BwBw',data={x:dd.x,y:1000.*1000.*dd.y,v:reform(dd.v)}
;; options,'BwBw','spec',1
;; zlim,'BwBw',1d-6,100,1
;; ylim,'BwBw',20,1000,1
;; ;---------------------------------------------------------------------


rbsp_load_emfisis,probe=probe,level='l3',coord='gse'
                 
 

;Plot 2K's position in GSM

tplot_options,'title','from campaign1_test_coherence.pro'

payloads = ['1U']

t0 = date + '/' + '14:00'
t1 = date + '/' + '22:00'

timespan, date
rbspx = 'rbsp' + probe

rbsp_load_barrel_lc,payloads,date,type='rcnt'
rbsp_load_barrel_lc,payloads,date,type='ephm'
rbsp_load_barrel_lc,payloads,date
rbsp_load_efw_spec,probe=probe,type='calibrated'

rbsp_efw_position_velocity_crib,/noplot,/notrace


rbsp_load_efw_waveform,probe=probe,type='calibrated',datatype='vsvy'
split_vec,'rbsp'+probe+'_efw_vsvy', suffix='_V'+['1','2','3','4','5','6']

get_data,'rbsp'+probe+'_efw_vsvy_V1',data=v1a
get_data,'rbsp'+probe+'_efw_vsvy_V2',data=v2a

sum12a = (v1a.y + v2a.y)/2.

density = 7354.3897*exp(sum12a*2.8454878)+96.123628*exp(sum12a*0.43020781)
goo = where(density ge 10000.)
if goo[0] ne -1 then density[goo] = !values.f_nan
store_data,'density',data={x:v1a.x,y:density}

rbsp_detrend,'density',60.*10.
copy_data,'density_smoothed','density_smoothed1'      
rbsp_detrend,'density',60.*0.1667
   

get_data,'density_smoothed1',data=ds
get_data,'density_smoothed',data=d
dn_n = 100.*(d.y - ds.y)/ds.y

store_data,'dn_n',data={x:ds.x,y:dn_n}

tplot,['density','density_smoothed1','density_detrend','dn_n'] 




copy_data,'rbsp'+probe+'_emfisis_l3_4sec_gse_Magnitude','Bmag'
rbsp_detrend,'Bmag',60.*10.
copy_data,'Bmag_smoothed','Bmag_smoothed1'      
rbsp_detrend,'Bmag',60.*0.1667
   

get_data,'Bmag_smoothed1',data=ds
get_data,'Bmag_smoothed',data=d
dn_n = 100.*(d.y - ds.y)/ds.y

store_data,'db_b',data={x:ds.x,y:dn_n}

tplot,['Bmag','Bmag_smoothed1','Bmag_detrend','db_b'] 



;--------------------------------------------------
;Find payload separations

dif_data,'rbsp'+probe+'_state_mlt','MLT_Kp2_T89c_'+bal,newname='dmlt'
dif_data,'rbsp'+probe+'_state_lshell','L_Kp2_'+bal,newname='dlshell'

tplot,['rbsp'+probe+'_state_mlt','MLT_Kp2_T89c_'+bal,'dmlt']
tplot,['rbsp'+probe+'_state_lshell','L_Kp2_'+bal,'dlshell']

;----------------------------------------------------------------

fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

;; get_data,'rbsp'+probe+'_efw_64_spec2',data=bu2
;; get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
;; get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2
;; bu2.y[*,0:2] = 0.
;; bv2.y[*,0:2] = 0.
;; bw2.y[*,0:2] = 0.
;; bu2.y[*,45:63] = 0.
;; bv2.y[*,45:63] = 0.
;; bw2.y[*,45:63] = 0.


get_data,'rbsp'+probe+'_efw_64_spec0',data=bu2
;get_data,'rbsp'+probe+'_efw_64_spec3',data=bv2
;get_data,'rbsp'+probe+'_efw_64_spec4',data=bw2
bu2.y[*,0:31] = 0.   ;remove up to 500 Hz
;bv2.y[*,0:2] = 0.
;bw2.y[*,0:2] = 0.
;bu2.y[*,45:63] = 0.
;bv2.y[*,45:63] = 0.
;bw2.y[*,45:63] = 0.

nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y ;+ bv2.y + bw2.y

for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)

store_data,'Efield_chorusint',data={x:bu2.x,y:bt}
tplot,'Efield_chorusint'



;Now let's calculated dhiss/hiss %

rbsp_detrend,'Efield_chorusint',60.*20.
store_data,'tst2',data=['Efield_chorusint','Efield_chorusint_smoothed']
tplot,'tst2'

get_data,'Efield_chorusint',data=hd
get_data,'Efield_chorusint_smoothed',data=hs

dh_h = -1*100.*(hs.y - hd.y)/hs.y
store_data,'dh_h',data={x:hd.x,y:dh_h}
tplot,['tst2','dh_h']
;rbsp_detrend,'Efield_chorusinta',60.*20.

tplot,['Efield_chorusint','Efield_chorusint_detrend','Efield_chorusint_smoothed']

;----------------------------------------------------------------




;Get rid of NaN values in the peak detector data. This messes up the downsampling
get_data,'PeakDet_'+bal,data=dd
goo = where(dd.y lt 0.)
if goo[0] ne -1 then dd.y[goo] = !values.f_nan
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'PeakDet_'+bal,data={x:xv,y:yv}
options,'PeakDet_'+bal,'colors',250



;Now let's calculated hiss percent change

rbsp_detrend,'PeakDet_'+bal,60.*20.
store_data,'tst2k',data=['PeakDet_'+bal,'PeakDet_'+bal+'_smoothed']
tplot,'tst2k'

get_data,'PeakDet_'+bal,data=hd
get_data,'PeakDet_'+bal+'_smoothed',data=hs

;dx_x = (hs.y - hd.y);/hs.y
dx_x = -1*100.*(hs.y - hd.y)/hs.y
store_data,'dx_x',data={x:hd.x,y:dx_x}
tplot,['tst2k','dx_x']


tplot,['PeakDet_'+bal,'PeakDet_'+bal+'_detrend','PeakDet_'+bal+'_smoothed']


;---------------------------------------------------------------------

;; tplot,['density','PeakDet_'+bal,'PeakDet_'+bal+'_detrend','Efield_chorusint','Efield_chorusint_detrend',$
;;        'dmlt','dlshell','rbsp'+probe+'_state_mlt','MLT_Kp2_T89c_'+bal,'rbsp'+probe+'_state_lshell','L_Kp2_'+bal]

tplot,['dn_n','db_b','PeakDet_'+bal,'PeakDet_'+bal+'_detrend','Efield_chorusint','Efield_chorusint_detrend',$
       'dmlt','dlshell','rbsp'+probe+'_state_mlt','MLT_Kp2_T89c_'+bal,'rbsp'+probe+'_state_lshell','L_Kp2_'+bal]












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


	tinterpol_mxn,'mlt_2K','rbsp'+probe+'_state_mlt'
	get_data,'mlt_2K_interp',data=t
	mlt2K = t.y * 360./24.
	get_data,'rbsp'+probe+'_state_mlt',data=t
	mlta = t.y

	tinterpol_mxn,'l_2K','rbsp'+probe+'_state_lshell'
	get_data,'l_2K_interp',data=t
	l2K = t.y
	get_data,'rbsp'+probe+'_state_lshell',data=t
	la = t.y

	tinterpol_mxn,'alt_2K','rbsp'+probe+'_state_lshell'
	get_data,'alt_2K_interp',data=t
	alt2K = t.y
	r2K = (6370. + alt2K)/6370.

	;Can get 2K mlat from Lshell and altitude
	;Lshell = rad/(cos(!dtor*mlat)^2)  ;L-shell in centered dipole
	mlat2K = acos(sqrt(r2K/l2K))/!dtor
	mlat2K = -1*mlat2K  ;southern hemisphere
	store_data,'mlat_2K',data={x:t.x,y:mlat2K}

	get_data,'rbsp'+probe+'_state_mlat',data=t
	mlata = t.y
	colata = 90. - mlata
	store_data,'rbsp'+probe+'_state_colat',data={x:t.x,y:colata}

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
	get_data,'rbsp'+probe+'_state_radius',data=rada
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
	tplot,['rbsp'+probe+'_state_mlat','mlat_2K']
	tplot,['rbsp'+probe+'_state_colat','colat_2K']
	tplot,['xsma','xsm2K']
	tplot,['ysma','ysm2K']
	tplot,['zsma','zsm2K']
	tplot,['xdiff','ydiff','zdiff']


        dif_data,'rbsp'+probe+'_state_mlat','mlat_2K'
        dif_data,'longa','long2K'
        dif_data,'rbsp'+probe+'_state_mlt','mlt_2K'
        dif_data,'rbsp'+probe+'_state_lshell','l_2K'

  

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


	tinterpol_mxn,'mlt_2L','rbsp'+probe+'_state_mlt'
	get_data,'mlt_2L_interp',data=t
	mlt2L = t.y * 360./24.

	tinterpol_mxn,'l_2L','rbsp'+probe+'_state_lshell'
	get_data,'l_2L_interp',data=t
	l2L = t.y

	tinterpol_mxn,'alt_2L','rbsp'+probe+'_state_lshell'
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


        dif_data,'rbsp'+probe+'_state_mlt','mlt_2L'
        dif_data,'rbsp'+probe+'_state_lshell','l_2L'



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


	tinterpol_mxn,'mlt_2W','rbsp'+probe+'_state_mlt'
	get_data,'mlt_2W_interp',data=t
	mlt2W = t.y * 360./24.

	tinterpol_mxn,'l_2W','rbsp'+probe+'_state_lshell'
	get_data,'l_2W_interp',data=t
	l2W = t.y

	tinterpol_mxn,'alt_2W','rbsp'+probe+'_state_lshell'
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


	tinterpol_mxn,'mlt_2X','rbsp'+probe+'_state_mlt'
	get_data,'mlt_2X_interp',data=t
	mlt2X = t.y * 360./24.

	tinterpol_mxn,'l_2X','rbsp'+probe+'_state_lshell'
	get_data,'l_2X_interp',data=t
	l2X = t.y

	tinterpol_mxn,'alt_2X','rbsp'+probe+'_state_lshell'
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

rbsp_detrend,['Efield_chorusinta','PeakDet_'+bal,'dn_n'],60.*1

ylim,'BwBw',10,1000,1
zlim,'BwBw',0.001,20,1
ylim,'Efield_chorusinta_smoothed',0,0.12
ylim,'PeakDet_'+bal+'_smoothed',3400,5000
ylim,'dn_n_smoothed',-15,15

tplot,['BwBw','Efield_chorusinta_smoothed','PeakDet_'+bal+'_smoothed','dn_n_smoothed']





rbsp_detrend,['Efield_chorusinta','Efield_chorusintb','PeakDet_'+bal,'PeakDet_2L',$
			'PeakDet_2W'],60.*0.3
ylim,'Efield_chorusintb_smoothed',0.01,0.03
ylim,'PeakDet_'+bal+'_smoothed',3500,5000
ylim,'PeakDet_2L_smoothed',4000,10000
ylim,'PeakDet_2W_smoothed',4000,7000

tplot,['Efield_chorusinta','Efield_chorusintb','PeakDet_'+bal,'PeakDet_2L','PeakDet_2W'] + '_smoothed'


	



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


get_data,'rbsp'+probe+'_efw_esvy_mgse_vxb_removed',data=esvy
times = esvy.x

rbsp_boom_directions_crib,times,'a',/no_spice_load
tplot,['vecu_gse','vecv_gse','vecw_gse']


rbsp_load_emfisis,probe=probe,coord='gse',cadence='1sec',level='l3'  ;load this for the mag model subtract
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude',60.*5.

;-----------------------------------------------------------
;subtract off background field
rbsp_load_emfisis,probe=probe,coord='gse',cadence='4sec',level='l3'  ;load this for the mag model subtract
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag',60.*0.2

rbsp_detrend,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed',60.*20.
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed_detrend',60.*10.
split_vec,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed_detrend_detrend'
tplot,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed_detrend_detrend_z'

dif_data,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_smoothed'
tplot,['rbsp'+probe+'_emfisis_l3_1sec_gse_Mag','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_smoothed','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag-rbspa_emfisis_l3_1sec_gse_Mag_smoothed']


rbsp_detrend,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag',60.*0.2
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed',60.*20.
get_data,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed_smoothed',data=bodc
get_data,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag',data=bw

db_b = 100.*(bw.y[*,2] - bodc.y[*,2])/bodc.y[*,2]
store_data,'db_b',data={x:bodc.x,y:db_b}
tplot,['rbsp'+probe+'_emfisis_l3_4sec_gse_Mag_smoothed_detrend_detrend_z','db_b']
;-----------------------------------------------------------







tinterpol_mxn,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag',times,newname='rbsp'+probe+'_emfisis_l3_4sec_gse_Mag'
tinterpol_mxn,'rbsp'+probe+'_emfisis_l3_4sec_gse_Magnitude',times,newname='rbsp'+probe+'_emfisis_l3_4sec_gse_Magnitude'

get_data,'rbsp'+probe+'_emfisis_l3_4sec_gse_Mag',data=mag
get_data,'rbsp'+probe+'_emfisis_l3_4sec_gse_Magnitude',data=magnit
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
copy_data,'rbsp'+probe+'_efw_esvy','rbsp'+probe+'_efw_esvy_uvw'
get_data,'rbsp'+probe+'_efw_esvy_uvw',data=esvy_uvw

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
get_data,'rbsp'+probe+'_efw_esvy_mgse_vxb_removed',data=emgse

emgse.y[*,0] = eperp.y
store_data,'rbsp'+probe+'_efw_esvy_mgse_vxb_removed_fixed',data=emgse


;Transform Bfield into MGSE
get_data,'rbsp'+probe+'_spinaxis_direction_gse',data=wsc
wsc_gse = reform(wsc.y[0,*])
rbsp_gse2mgse,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag',wsc_gse,newname='rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag'
tinterpol_mxn,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag',times,newname='rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag'
split_vec,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag'


;Smooth the data over short timespan
rbsp_detrend,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_x','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_y','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_z'],60.*5.
join_vec,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_x_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_y_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_z_detrend'],'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend'
join_vec,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_x_smoothed','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_y_smoothed','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_z_smoothed'],'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed'



;Rotate fixed efield to Bo
fa = rbsp_rotate_field_2_vec('rbsp'+probe+'_efw_esvy_mgse_vxb_removed_fixed','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)
ylim,'rbsp'+probe+'_efw_esvy_mgse_vxb_removed_fixed_EFA_coord',-2,2


;Now rotate the detrended Bo to smoothed Bo
fa = rbsp_rotate_field_2_vec('rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)


;****************************
;Test wave with z MGSE = 0
;get_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend',data=dd
;
;wx = sin(indgen(n_elements(dd.x))/10.)
;wy = cos(indgen(n_elements(dd.x))/10.)
;wz = replicate(0.,n_elements(dd.x))
;
;
;tstwave = [[wx],[wy],[wz]]
;store_data,'tstwave',data={x:dd.x,y:tstwave}
;
;fa = rbsp_rotate_field_2_vec('tstwave','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed_DS')
;fa = rbsp_rotate_field_2_vec('tstwave','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed',/efa)
;
;;These both look good. The field-aligned z component is small
;tplot,['tstwave_FA_minvar','tstwave_EFA_coord']

;****************************



;*****TRY MINVAR COORD********
;Rotate fixed efield to Bo
;rbsp_downsample,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed',1/2
;fa = rbsp_rotate_field_2_vec('rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed_DS')

;****************************


split_vec,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag'
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_x',60.*5.
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_y',60.*5.
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_z',60.*5.
join_vec,['rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_x_detrend','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_y_detrend','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_z_detrend'],'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_detrend'

;VERY LITTLE FA EFIELD COMPONENT.
tplot,['rbsp'+probe+'_efw_esvy_mgse_vxb_removed_fixed_EFA_coord','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord']

;Check the GSE mag to be sure that there is a field-aligned component
tplot,'rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_detrend'

;OK, now I'm convinced that there is a FA compressional Bmag component
;Let's compare this to dn/n

split_vec,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord'

;Clearly the Bz component correlates well with dn/n much better than
;the perp components

tplot,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_x',$
	   'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_y',$
	   'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n']

;OK, let's overplot the phases of dn_n and FA Bw to see if it's slow or fast mode
rbsp_detrend,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n'],60.*20.
tplot,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','dn_n']+'_detrend'

;Normalize these and overplot
get_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z',data=tmp
tmp2 = tmp.y*10.
store_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10',data={x:tmp.x,y:tmp2}


;Test phase of dn_n
rbsp_detrend,'density',60.*5.
rbsp_detrend,'density_detrend',60.*0.2

store_data,'corr',data=['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','dn_n_detrend']
options,'corr','colors',[0,250]
options,'corr','ytitle','Black=10x Bw FA (nT)!CRed=dn_n percent!Cdetrended'
store_data,'corr2',data=['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','density_detrend_smoothed']
options,'corr2','colors',[0,250]
options,'corr2','ytitle','Black=10x Bw FA (nT)!CRed=density(cm-3)!Cdetrended'


;Density and FA Bw are out of phase, suggesting slow mode wave
ylim,['corr','corr2'],-10,10
tplot,['corr','corr2']

rbsp_detrend,['density','dens_emfisis','PeakDet_'+bal],60*30.
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude',60.*10.
tplot,['PeakDet_'+bal,'Efield_chorusinta','dens_emfisis_detrend','density_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z','rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_detrend']


;rbsp_detrend,['density','dens_emfisis','PeakDet_'+bal],60*30.
rbsp_detrend,['PeakDet_'+bal,'Efield_chorusinta','density','rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag'],60.*0.2
rbsp_detrend,['PeakDet_'+bal+'_smoothed','Efield_chorusinta_smoothed','density_smoothed','rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_smoothed','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_smoothed'],60.*20.
tplot,['PeakDet_'+bal+'_smoothed_detrend','Efield_chorusinta_smoothed_detrend','rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_smoothed_detrend','rbsp'+probe+'_emfisis_l3_1sec_gse_Mag_smoothed_detrend','density_smoothed_detrend']




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


get_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_x',data=mx
get_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_y',data=my
get_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z',data=mz
mag = sqrt(mx.y^2 + my.y^2 + mz.y^2)
store_data,'Bmag_10x',data={x:mx.x,y:mag*10.}
store_data,'Bmag',data={x:mx.x,y:mag}

get_data,'rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_detrend',data=dd
store_data,'rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_detrend_10x',data={x:dd.x,y:10*dd.y}
get_data,'fesa30_detrend',data=dd
store_data,'fesatmp',data={x:dd.x,y:dd.y/100.}
store_data,'comb1',data=['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','fesatmp']
store_data,'comb2',data=['density_detrend_smoothed','fesatmp']
store_data,'comb3',data=['rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_detrend_10x','fesatmp']
;store_data,'comb3',data=['Bmag','fesatmp']
store_data,'comb4',data=['Bmag','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z']
options,'comb1','colors',[0,250]
options,'comb2','colors',[50,250]
options,'comb3','colors',[0,250]
options,'comb1','ytitle','Bw_FA(nTx10)!CRed=FESA30keV!Cdetrend'
options,'comb2','ytitle','Density(cm-3)!CRed=FESA30keV!Cdetrend'
options,'comb3','ytitle','Bmag(nTx10)!CRed=FESA30keV!Cdetrend'

tplot,['comb1','comb2']

store_data,'comb2',data=['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord_z_x10','density_detrend_smoothed','fesatmp']
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


;tplot,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_detrend_EFA_coord','rbsp'+probe+'_emfisis_l3_1sec_gse_Magnitude_detrend']




;**********************************************************************
;SET UP VARIABLES FOR CROSS-CORRELATION
;**********************************************************************

t0z = '2014-01-06/19:00'
t1z = '2014-01-06/21:50'


tplot,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Magnitude','density']
tlimit,t0z,t1z

;----------
;Background field direction
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag',60.*0.168
copy_data,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_smoothed','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp'
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
rbsp_downsample,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_smoothed',1/2.

rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp',60.*20.
tplot,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend']
rbsp_detrend,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend',60.*40.
tplot,['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
store_data,'bcomb',data=['rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend']
options,'bcomb','colors',[0,250]
tplot,'bcomb'
fa = rbsp_rotate_field_2_vec('rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_smoothed_DS')
tplot,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_FA_minvar'
split_vec,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend'
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
rbsp_detrend,'Efield_chorusinta',60.*0.168
copy_data,'Efield_chorusinta','Efield_chorusinta_sp'
tplot,['Efield_chorusinta','Efield_chorusinta_sp']
rbsp_detrend,'Efield_chorusinta_sp',60.*20.
tplot,['Efield_chorusinta_sp','Efield_chorusinta_sp_detrend']
rbsp_detrend,'Efield_chorusinta_sp_detrend',60.*40.
tplot,['Efield_chorusinta_sp_detrend','Efield_chorusinta_sp_detrend_detrend']
store_data,'hcomb',data=['Efield_chorusinta_sp_detrend','Efield_chorusinta_sp_detrend_detrend']
options,'hcomb','colors',[0,250]
tplot,'hcomb'
;----------
;PeakDet_'+bal
rbsp_detrend,'PeakDet_'+bal,60.*0.168
copy_data,'PeakDet_'+bal,'PeakDet_'+bal+'_sp'
tplot,['PeakDet_'+bal,'PeakDet_'+bal+'_sp']
rbsp_detrend,'PeakDet_'+bal+'_sp',60.*20.
tplot,['PeakDet_'+bal+'_sp','PeakDet_'+bal+'_sp_detrend']
rbsp_detrend,'PeakDet_'+bal+'_sp_detrend',60.*40.
tplot,['PeakDet_'+bal+'_sp_detrend','PeakDet_'+bal+'_sp_detrend_detrend']
store_data,'pcomb',data=['PeakDet_'+bal+'_sp_detrend','PeakDet_'+bal+'_sp_detrend_detrend']
options,'pcomb','colors',[0,250]
tplot,'pcomb'




ylim,'rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z',-2,2
ylim,'density_sp_detrend_detrend',-40,40
ylim,'fesa30_sp_detrend',-1000,1000
ylim,'fesa54_sp_detrend',-500,500
ylim,'fesa80_sp_detrend',-500,500
ylim,'fesa108_sp_detrend',-300,300

tplot_options,'title','products for correlation...12sec to 20min periods allowed'
tplot,['PeakDet_'+bal+'_sp_detrend_detrend','Efield_chorusinta_sp_detrend_detrend','density_sp_detrend_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend','fesa80_sp_detrend','fesa108_sp_detrend','fesa144_sp_detrend']
tplot,['PeakDet_'+bal+'_sp_detrend_detrend','Efield_chorusinta_sp_detrend_detrend','density_sp_detrend_detrend','rbsp'+probe+'_emfisis_l3_1sec_mgse_Mag_sp_detrend_detrend_z','fesa30_sp_detrend','fesa54_sp_detrend']



date = '2012-10-13'
date2 = '20121013'
filename='rbsp_skeleton_' + date2 + '.cdf'


