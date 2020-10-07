;I've plugged in the exact times of each correlation for Jan6th from 20:00-22:00UT
;on all of the payloads and RBSP-A,B. I use these times to get the exact location
;of each payload. I store these results in a .idl file which is recalled by 
;barrel_polar_jan6_kp1_correlations.pro which plots these correlations on an 
;MLT vs Lshell plot and also makes histograms of delta-lshell and delta-mlt

;Black = strong correlation w/ no delay (bounce loss cone)
;Red = strong correlation w/ delay (drift loss cone)
;Orange = probably correlations (delay or not)


pro jan3_individual_correlation_coord_find


path = '~/Desktop/Research/RBSP_hiss_precip/barrel_mapping/BARREL_RBSP_Kp1/'
ID =[ '2I', '2X','2K','2T','2L','2W' ]



;***************************************************
;Get the locations of all payloads at times of correlations
;***************************************************


AB_black = time_double('2014-01-06/' + ['20:01','20:45','20:49','20:52','21:19','20:58'])
AK_black = time_double('2014-01-06/' + ['21:07','20:54','20:57'])
AW_black = time_double('2014-01-06/' + ['20:48','21:30','20:54'])
BK_black = time_double('2014-01-06/' + ['20:44','20:47','20:57'])
BW_black = time_double('2014-01-06/' + ['20:21','20:48','20:51','20:58','21:15','20:33','20:35','21:01','21:12'])
KW_black = time_double('2014-01-06/' + ['20:47','20:54','20:56'])

AB_red = time_double('2014-01-06/' + ['20:47','20:54'])
AK_red = time_double('2014-01-06/' + ['20:23','20:25','20:44','20:47','21:35'])
AW_red = time_double('2014-01-06/' + ['20:44','21:40','20:47','20:51','20:57'])
BK_red = time_double('2014-01-06/' + ['20:54'])
BW_red = time_double('2014-01-06/' + ['20:01','20:11','20:14','20:17','20:44','21:18','20:31','20:51','20:54'])
KL_red = time_double('2014-01-06/' + ['20:07','20:10','20:14','20:44'])
KW_red = time_double('2014-01-06/' + ['20:44','20:57'])

AB_orange = time_double('2014-01-06/' + ['20:11','20:14','21:20','21:29','21:33','21:36','21:40','21:43','21:14','21:18'])
AK_orange = time_double('2014-01-06/' + ['20:07','20:10','20:14','20:19','20:40','21:09','21:14','21:18','21:06'])
AW_orange = time_double('2014-01-06/' + ['20:14','21:18','21:14'])
AL_orange = time_double('2014-01-06/' + ['20:07','20:11','20:44','20:47','20:50','20:55','20:57'])
BK_orange = time_double('2014-01-06/' + ['20:01','20:10','20:13','21:14','21:18','21:21','21:32','21:35','20:31','20:32','20:34'])
BW_orange = time_double('2014-01-06/' + ['21:08','21:12','21:29','21:40','21:43','21:46','21:50','20:36','20:37'])
BL_orange = time_double('2014-01-06/' + ['20:10','20:14','20:44','20:47','20:51','20:54','20:57'])
KL_orange = time_double('2014-01-06/' + ['20:25','21:32','21:35','21:38','20:11','20:14','20:47','20:50','20:55','20:57'])
KW_orange = time_double('2014-01-06/' + ['21:15','21:18'])
LW_orange = time_double('2014-01-06/' + ['20:11','20:14','20:44','20:47','20:50','21:28','21:32','21:37','20:55','20:57'])



;&&&&&&&&&&&&&&&&&&
;K - L correlations
;&&&&&&&&&&&&&&&&&&

	restore, path+"barrel_template.sav"
	myfile = path+"bar_2K_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2L_mag.dat"
	data2 = read_ascii(myfile, template = res)

	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


;Get rid of NaN values
get_data,'x1',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'x1',data={x:xv,y:yv}

get_data,'y1',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'y1',data={x:xv,y:yv}

get_data,'x2',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'x2',data={x:xv,y:yv}

get_data,'y2',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'y2',data={x:xv,y:yv}

get_data,'mlt1',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'mlt1',data={x:xv,y:yv}

get_data,'lsh1',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'lsh1',data={x:xv,y:yv}

get_data,'mlt2',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'mlt2',data={x:xv,y:yv}

get_data,'lsh2',data=dd
xv = dd.x
yv = dd.y
interp_gap,xv,yv
store_data,'lsh2',data={x:xv,y:yv}

get_data,'mlt1',data=dd
mlt1 = dd.y
get_data,'mlt2',data=dd
mlt2 = dd.y
get_data,'lsh1',data=dd
l1 = dd.y
get_data,'lsh2',data=dd
l2 = dd.y
get_data,'x1',data=dd
x1 = dd.y
get_data,'y1',data=dd
y1 = dd.y
get_data,'x2',data=dd
x2 = dd.y
get_data,'y2',data=dd
y2 = dd.y




	valkl_kx_red = fltarr(n_elements(kl_red))
	valkl_ky_red = fltarr(n_elements(kl_red))
	valkl_lx_red = fltarr(n_elements(kl_red))
	valkl_ly_red = fltarr(n_elements(kl_red))
	valkl_kx_orange = fltarr(n_elements(kl_orange))
	valkl_ky_orange = fltarr(n_elements(kl_orange))
	valkl_lx_orange = fltarr(n_elements(kl_orange))
	valkl_ly_orange = fltarr(n_elements(kl_orange))

	valkl_kmlt_red = fltarr(n_elements(kl_red))
	valkl_klsh_red = fltarr(n_elements(kl_red))
	valkl_lmlt_red = fltarr(n_elements(kl_red))
	valkl_llsh_red = fltarr(n_elements(kl_red))
	valkl_kmlt_orange = fltarr(n_elements(kl_orange))
	valkl_klsh_orange = fltarr(n_elements(kl_orange))
	valkl_lmlt_orange = fltarr(n_elements(kl_orange))
	valkl_llsh_orange = fltarr(n_elements(kl_orange))


	for r=0,n_elements(kL_red)-1 do valkl_kx_red[r] = tsample('x1',reform(KL_red[r]))
	for r=0,n_elements(kL_red)-1 do valkl_ky_red[r] = tsample('y1',reform(KL_red[r]))
	for r=0,n_elements(kL_red)-1 do valkl_lx_red[r] = tsample('x2',reform(KL_red[r]))
	for r=0,n_elements(kL_red)-1 do valkl_ly_red[r] = tsample('y2',reform(KL_red[r]))
	for r=0,n_elements(kL_orange)-1 do valkl_kx_orange[r] = tsample('x1',reform(KL_orange[r]))
	for r=0,n_elements(kL_orange)-1 do valkl_ky_orange[r] = tsample('y1',reform(KL_orange[r]))
	for r=0,n_elements(kL_orange)-1 do valkl_lx_orange[r] = tsample('x2',reform(KL_orange[r]))
	for r=0,n_elements(kL_orange)-1 do valkl_ly_orange[r] = tsample('y2',reform(KL_orange[r]))

	for r=0,n_elements(kL_red)-1 do valkl_kmlt_red[r] = tsample('mlt1',reform(KL_red[r]))
	for r=0,n_elements(kL_red)-1 do valkl_klsh_red[r] = abs(tsample('lsh1',reform(KL_red[r])))
	for r=0,n_elements(kL_red)-1 do valkl_lmlt_red[r] = tsample('mlt2',reform(KL_red[r]))
	for r=0,n_elements(kL_red)-1 do valkl_llsh_red[r] = abs(tsample('lsh2',reform(KL_red[r])))
	for r=0,n_elements(kL_orange)-1 do valkl_kmlt_orange[r] = tsample('mlt1',reform(KL_orange[r]))
	for r=0,n_elements(kL_orange)-1 do valkl_klsh_orange[r] = abs(tsample('lsh1',reform(KL_orange[r])))
	for r=0,n_elements(kL_orange)-1 do valkl_lmlt_orange[r] = tsample('mlt2',reform(KL_orange[r]))
	for r=0,n_elements(kL_orange)-1 do valkl_llsh_orange[r] = abs(tsample('lsh2',reform(KL_orange[r])))


;&&&&&&&&&&&&&&&&&&
;K - W correlations
;&&&&&&&&&&&&&&&&&&

	restore, path+"barrel_template.sav"
	myfile = path+"bar_2K_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2W_mag.dat"
	data2 = read_ascii(myfile, template = res)

	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}

	valkw_kx_black = fltarr(n_elements(kw_black))
	valkw_ky_black = fltarr(n_elements(kw_black))
	valkw_wx_black = fltarr(n_elements(kw_black))
	valkw_wy_black = fltarr(n_elements(kw_black))
	valkw_kx_red = fltarr(n_elements(kw_red))
	valkw_ky_red = fltarr(n_elements(kw_red))
	valkw_wx_red = fltarr(n_elements(kw_red))
	valkw_wy_red = fltarr(n_elements(kw_red))
	valkw_kx_orange = fltarr(n_elements(kw_orange))
	valkw_ky_orange = fltarr(n_elements(kw_orange))
	valkw_wx_orange = fltarr(n_elements(kw_orange))
	valkw_wy_orange = fltarr(n_elements(kw_orange))

	valkw_kmlt_black = fltarr(n_elements(kw_black))
	valkw_klsh_black = fltarr(n_elements(kw_black))
	valkw_wmlt_black = fltarr(n_elements(kw_black))
	valkw_wlsh_black = fltarr(n_elements(kw_black))
	valkw_kmlt_red = fltarr(n_elements(kw_red))
	valkw_klsh_red = fltarr(n_elements(kw_red))
	valkw_wmlt_red = fltarr(n_elements(kw_red))
	valkw_wlsh_red = fltarr(n_elements(kw_red))
	valkw_kmlt_orange = fltarr(n_elements(kw_orange))
	valkw_klsh_orange = fltarr(n_elements(kw_orange))
	valkw_wmlt_orange = fltarr(n_elements(kw_orange))
	valkw_wlsh_orange = fltarr(n_elements(kw_orange))


	for r=0,n_elements(kw_black)-1 do valkw_kx_black[r] = tsample('x1',reform(kw_black[r]))
	for r=0,n_elements(kw_black)-1 do valkw_ky_black[r] = tsample('y1',reform(kw_black[r]))
	for r=0,n_elements(kw_black)-1 do valkw_wx_black[r] = tsample('x2',reform(kw_black[r]))
	for r=0,n_elements(kw_black)-1 do valkw_wy_black[r] = tsample('y2',reform(kw_black[r]))
	for r=0,n_elements(kw_red)-1 do valkw_kx_red[r] = tsample('x1',reform(kw_red[r]))
	for r=0,n_elements(kw_red)-1 do valkw_ky_red[r] = tsample('y1',reform(kw_red[r]))
	for r=0,n_elements(kw_red)-1 do valkw_wx_red[r] = tsample('x2',reform(kw_red[r]))
	for r=0,n_elements(kw_red)-1 do valkw_wy_red[r] = tsample('y2',reform(kw_red[r]))
	for r=0,n_elements(kw_orange)-1 do valkw_kx_orange[r] = tsample('x1',reform(kw_orange[r]))
	for r=0,n_elements(kw_orange)-1 do valkw_ky_orange[r] = tsample('y1',reform(kw_orange[r]))
	for r=0,n_elements(kw_orange)-1 do valkw_wx_orange[r] = tsample('x2',reform(kw_orange[r]))
	for r=0,n_elements(kw_orange)-1 do valkw_wy_orange[r] = tsample('y2',reform(kw_orange[r]))

	for r=0,n_elements(kw_black)-1 do valkw_kmlt_black[r] = tsample('mlt1',reform(kw_black[r]))
	for r=0,n_elements(kw_black)-1 do valkw_klsh_black[r] = abs(tsample('lsh1',reform(kw_black[r])))
	for r=0,n_elements(kw_black)-1 do valkw_wmlt_black[r] = tsample('mlt2',reform(kw_black[r]))
	for r=0,n_elements(kw_black)-1 do valkw_wlsh_black[r] = abs(tsample('lsh2',reform(kw_black[r])))
	for r=0,n_elements(kw_red)-1 do valkw_kmlt_red[r] = tsample('mlt1',reform(kw_red[r]))
	for r=0,n_elements(kw_red)-1 do valkw_klsh_red[r] = abs(tsample('lsh1',reform(kw_red[r])))
	for r=0,n_elements(kw_red)-1 do valkw_wmlt_red[r] = tsample('mlt2',reform(kw_red[r]))
	for r=0,n_elements(kw_red)-1 do valkw_wlsh_red[r] = abs(tsample('lsh2',reform(kw_red[r])))
	for r=0,n_elements(kw_orange)-1 do valkw_kmlt_orange[r] = tsample('mlt1',reform(kw_orange[r]))
	for r=0,n_elements(kw_orange)-1 do valkw_klsh_orange[r] = abs(tsample('lsh1',reform(kw_orange[r])))
	for r=0,n_elements(kw_orange)-1 do valkw_wmlt_orange[r] = tsample('mlt2',reform(kw_orange[r]))
	for r=0,n_elements(kw_orange)-1 do valkw_wlsh_orange[r] = abs(tsample('lsh2',reform(kw_orange[r])))



;&&&&&&&&&&&&&&&&&&
;L - W correlations
;&&&&&&&&&&&&&&&&&&

	restore, path+"barrel_template.sav"
	myfile = path+"bar_2L_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2W_mag.dat"
	data2 = read_ascii(myfile, template = res)

	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}

	vallw_lx_orange = fltarr(n_elements(lw_orange))
	vallw_ly_orange = fltarr(n_elements(lw_orange))
	vallw_wx_orange = fltarr(n_elements(lw_orange))
	vallw_wy_orange = fltarr(n_elements(lw_orange))

	vallw_lmlt_orange = fltarr(n_elements(lw_orange))
	vallw_llsh_orange = fltarr(n_elements(lw_orange))
	vallw_wmlt_orange = fltarr(n_elements(lw_orange))
	vallw_wlsh_orange = fltarr(n_elements(lw_orange))


	for r=0,n_elements(lw_orange)-1 do vallw_lx_orange[r] = tsample('x1',reform(lw_orange[r]))
	for r=0,n_elements(lw_orange)-1 do vallw_ly_orange[r] = tsample('y1',reform(lw_orange[r]))
	for r=0,n_elements(lw_orange)-1 do vallw_wx_orange[r] = tsample('x2',reform(lw_orange[r]))
	for r=0,n_elements(lw_orange)-1 do vallw_wy_orange[r] = tsample('y2',reform(lw_orange[r]))

	for r=0,n_elements(lw_orange)-1 do vallw_lmlt_orange[r] = tsample('mlt1',reform(lw_orange[r]))
	for r=0,n_elements(lw_orange)-1 do vallw_llsh_orange[r] = abs(tsample('lsh1',reform(lw_orange[r])))
	for r=0,n_elements(lw_orange)-1 do vallw_wmlt_orange[r] = tsample('mlt2',reform(lw_orange[r]))
	for r=0,n_elements(lw_orange)-1 do vallw_wlsh_orange[r] = abs(tsample('lsh2',reform(lw_orange[r])))



;&&&&&&&&&&&&&&&&&&
;A - B correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_a_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"rbsp_b_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valab_ax_black = fltarr(n_elements(ab_black))
	valab_ay_black = fltarr(n_elements(ab_black))
	valab_bx_black = fltarr(n_elements(ab_black))
	valab_by_black = fltarr(n_elements(ab_black))
	valab_ax_red = fltarr(n_elements(ab_red))
	valab_ay_red = fltarr(n_elements(ab_red))
	valab_bx_red = fltarr(n_elements(ab_red))
	valab_by_red = fltarr(n_elements(ab_red))
	valab_ax_orange = fltarr(n_elements(ab_orange))
	valab_ay_orange = fltarr(n_elements(ab_orange))
	valab_bx_orange = fltarr(n_elements(ab_orange))
	valab_by_orange = fltarr(n_elements(ab_orange))

	valab_amlt_black = fltarr(n_elements(ab_black))
	valab_alsh_black = fltarr(n_elements(ab_black))
	valab_bmlt_black = fltarr(n_elements(ab_black))
	valab_blsh_black = fltarr(n_elements(ab_black))
	valab_amlt_red = fltarr(n_elements(ab_red))
	valab_alsh_red = fltarr(n_elements(ab_red))
	valab_bmlt_red = fltarr(n_elements(ab_red))
	valab_blsh_red = fltarr(n_elements(ab_red))
	valab_amlt_orange = fltarr(n_elements(ab_orange))
	valab_alsh_orange = fltarr(n_elements(ab_orange))
	valab_bmlt_orange = fltarr(n_elements(ab_orange))
	valab_blsh_orange = fltarr(n_elements(ab_orange))

	for r=0,n_elements(ab_black)-1 do valab_ax_black[r] = tsample('x1',reform(ab_black[r]))
	for r=0,n_elements(ab_black)-1 do valab_ay_black[r] = tsample('y1',reform(ab_black[r]))
	for r=0,n_elements(ab_black)-1 do valab_bx_black[r] = tsample('x2',reform(ab_black[r]))
	for r=0,n_elements(ab_black)-1 do valab_by_black[r] = tsample('y2',reform(ab_black[r]))
	for r=0,n_elements(ab_red)-1 do valab_ax_red[r] = tsample('x1',reform(ab_red[r]))
	for r=0,n_elements(ab_red)-1 do valab_ay_red[r] = tsample('y1',reform(ab_red[r]))
	for r=0,n_elements(ab_red)-1 do valab_bx_red[r] = tsample('x2',reform(ab_red[r]))
	for r=0,n_elements(ab_red)-1 do valab_by_red[r] = tsample('y2',reform(ab_red[r]))
	for r=0,n_elements(ab_orange)-1 do valab_ax_orange[r] = tsample('x1',reform(ab_orange[r]))
	for r=0,n_elements(ab_orange)-1 do valab_ay_orange[r] = tsample('y1',reform(ab_orange[r]))
	for r=0,n_elements(ab_orange)-1 do valab_bx_orange[r] = tsample('x2',reform(ab_orange[r]))
	for r=0,n_elements(ab_orange)-1 do valab_by_orange[r] = tsample('y2',reform(ab_orange[r]))

	for r=0,n_elements(ab_black)-1 do valab_amlt_black[r] = tsample('mlt1',reform(ab_black[r]))
	for r=0,n_elements(ab_black)-1 do valab_alsh_black[r] = abs(tsample('lsh1',reform(ab_black[r])))
	for r=0,n_elements(ab_black)-1 do valab_bmlt_black[r] = tsample('mlt2',reform(ab_black[r]))
	for r=0,n_elements(ab_black)-1 do valab_blsh_black[r] = abs(tsample('lsh2',reform(ab_black[r])))
	for r=0,n_elements(ab_red)-1 do valab_amlt_red[r] = tsample('mlt1',reform(ab_red[r]))
	for r=0,n_elements(ab_red)-1 do valab_alsh_red[r] = abs(tsample('lsh1',reform(ab_red[r])))
	for r=0,n_elements(ab_red)-1 do valab_bmlt_red[r] = tsample('mlt2',reform(ab_red[r]))
	for r=0,n_elements(ab_red)-1 do valab_blsh_red[r] = abs(tsample('lsh2',reform(ab_red[r])))
	for r=0,n_elements(ab_orange)-1 do valab_amlt_orange[r] = tsample('mlt1',reform(ab_orange[r]))
	for r=0,n_elements(ab_orange)-1 do valab_alsh_orange[r] = abs(tsample('lsh1',reform(ab_orange[r])))
	for r=0,n_elements(ab_orange)-1 do valab_bmlt_orange[r] = tsample('mlt2',reform(ab_orange[r]))
	for r=0,n_elements(ab_orange)-1 do valab_blsh_orange[r] = abs(tsample('lsh2',reform(ab_orange[r])))



;&&&&&&&&&&&&&&&&&&
;A - K correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_a_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2K_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valak_ax_black = fltarr(n_elements(ak_black))
	valak_ay_black = fltarr(n_elements(ak_black))
	valak_kx_black = fltarr(n_elements(ak_black))
	valak_ky_black = fltarr(n_elements(ak_black))
	valak_ax_red = fltarr(n_elements(ak_red))
	valak_ay_red = fltarr(n_elements(ak_red))
	valak_kx_red = fltarr(n_elements(ak_red))
	valak_ky_red = fltarr(n_elements(ak_red))
	valak_ax_orange = fltarr(n_elements(ak_orange))
	valak_ay_orange = fltarr(n_elements(ak_orange))
	valak_kx_orange = fltarr(n_elements(ak_orange))
	valak_ky_orange = fltarr(n_elements(ak_orange))

	valak_amlt_black = fltarr(n_elements(ak_black))
	valak_alsh_black = fltarr(n_elements(ak_black))
	valak_kmlt_black = fltarr(n_elements(ak_black))
	valak_klsh_black = fltarr(n_elements(ak_black))
	valak_amlt_red = fltarr(n_elements(ak_red))
	valak_alsh_red = fltarr(n_elements(ak_red))
	valak_kmlt_red = fltarr(n_elements(ak_red))
	valak_klsh_red = fltarr(n_elements(ak_red))
	valak_amlt_orange = fltarr(n_elements(ak_orange))
	valak_alsh_orange = fltarr(n_elements(ak_orange))
	valak_kmlt_orange = fltarr(n_elements(ak_orange))
	valak_klsh_orange = fltarr(n_elements(ak_orange))


	for r=0,n_elements(ak_black)-1 do valak_ax_black[r] = tsample('x1',reform(ak_black[r]))
	for r=0,n_elements(ak_black)-1 do valak_ay_black[r] = tsample('y1',reform(ak_black[r]))
	for r=0,n_elements(ak_black)-1 do valak_kx_black[r] = tsample('x2',reform(ak_black[r]))
	for r=0,n_elements(ak_black)-1 do valak_ky_black[r] = tsample('y2',reform(ak_black[r]))
	for r=0,n_elements(ak_red)-1 do valak_ax_red[r] = tsample('x1',reform(ak_red[r]))
	for r=0,n_elements(ak_red)-1 do valak_ay_red[r] = tsample('y1',reform(ak_red[r]))
	for r=0,n_elements(ak_red)-1 do valak_kx_red[r] = tsample('x2',reform(ak_red[r]))
	for r=0,n_elements(ak_red)-1 do valak_ky_red[r] = tsample('y2',reform(ak_red[r]))
	for r=0,n_elements(ak_orange)-1 do valak_ax_orange[r] = tsample('x1',reform(ak_orange[r]))
	for r=0,n_elements(ak_orange)-1 do valak_ay_orange[r] = tsample('y1',reform(ak_orange[r]))
	for r=0,n_elements(ak_orange)-1 do valak_kx_orange[r] = tsample('x2',reform(ak_orange[r]))
	for r=0,n_elements(ak_orange)-1 do valak_ky_orange[r] = tsample('y2',reform(ak_orange[r]))

	for r=0,n_elements(ak_black)-1 do valak_amlt_black[r] = tsample('mlt1',reform(ak_black[r]))
	for r=0,n_elements(ak_black)-1 do valak_alsh_black[r] = abs(tsample('lsh1',reform(ak_black[r])))
	for r=0,n_elements(ak_black)-1 do valak_kmlt_black[r] = tsample('mlt2',reform(ak_black[r]))
	for r=0,n_elements(ak_black)-1 do valak_klsh_black[r] = abs(tsample('lsh2',reform(ak_black[r])))
	for r=0,n_elements(ak_red)-1 do valak_amlt_red[r] = tsample('mlt1',reform(ak_red[r]))
	for r=0,n_elements(ak_red)-1 do valak_alsh_red[r] = abs(tsample('lsh1',reform(ak_red[r])))
	for r=0,n_elements(ak_red)-1 do valak_kmlt_red[r] = tsample('mlt2',reform(ak_red[r]))
	for r=0,n_elements(ak_red)-1 do valak_klsh_red[r] = abs(tsample('lsh2',reform(ak_red[r])))
	for r=0,n_elements(ak_orange)-1 do valak_amlt_orange[r] = tsample('mlt1',reform(ak_orange[r]))
	for r=0,n_elements(ak_orange)-1 do valak_alsh_orange[r] = abs(tsample('lsh1',reform(ak_orange[r])))
	for r=0,n_elements(ak_orange)-1 do valak_kmlt_orange[r] = tsample('mlt2',reform(ak_orange[r]))
	for r=0,n_elements(ak_orange)-1 do valak_klsh_orange[r] = abs(tsample('lsh2',reform(ak_orange[r])))


;&&&&&&&&&&&&&&&&&&
;A - W correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_a_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2W_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valaw_ax_black = fltarr(n_elements(aw_black))
	valaw_ay_black = fltarr(n_elements(aw_black))
	valaw_wx_black = fltarr(n_elements(aw_black))
	valaw_wy_black = fltarr(n_elements(aw_black))
	valaw_ax_red = fltarr(n_elements(aw_red))
	valaw_ay_red = fltarr(n_elements(aw_red))
	valaw_wx_red = fltarr(n_elements(aw_red))
	valaw_wy_red = fltarr(n_elements(aw_red))
	valaw_ax_orange = fltarr(n_elements(aw_orange))
	valaw_ay_orange = fltarr(n_elements(aw_orange))
	valaw_wx_orange = fltarr(n_elements(aw_orange))
	valaw_wy_orange = fltarr(n_elements(aw_orange))

	valaw_amlt_black = fltarr(n_elements(aw_black))
	valaw_alsh_black = fltarr(n_elements(aw_black))
	valaw_wmlt_black = fltarr(n_elements(aw_black))
	valaw_wlsh_black = fltarr(n_elements(aw_black))
	valaw_amlt_red = fltarr(n_elements(aw_red))
	valaw_alsh_red = fltarr(n_elements(aw_red))
	valaw_wmlt_red = fltarr(n_elements(aw_red))
	valaw_wlsh_red = fltarr(n_elements(aw_red))
	valaw_amlt_orange = fltarr(n_elements(aw_orange))
	valaw_alsh_orange = fltarr(n_elements(aw_orange))
	valaw_wmlt_orange = fltarr(n_elements(aw_orange))
	valaw_wlsh_orange = fltarr(n_elements(aw_orange))

	for r=0,n_elements(aw_black)-1 do valaw_ax_black[r] = tsample('x1',reform(aw_black[r]))
	for r=0,n_elements(aw_black)-1 do valaw_ay_black[r] = tsample('y1',reform(aw_black[r]))
	for r=0,n_elements(aw_black)-1 do valaw_wx_black[r] = tsample('x2',reform(aw_black[r]))
	for r=0,n_elements(aw_black)-1 do valaw_wy_black[r] = tsample('y2',reform(aw_black[r]))
	for r=0,n_elements(aw_red)-1 do valaw_ax_red[r] = tsample('x1',reform(aw_red[r]))
	for r=0,n_elements(aw_red)-1 do valaw_ay_red[r] = tsample('y1',reform(aw_red[r]))
	for r=0,n_elements(aw_red)-1 do valaw_wx_red[r] = tsample('x2',reform(aw_red[r]))
	for r=0,n_elements(aw_red)-1 do valaw_wy_red[r] = tsample('y2',reform(aw_red[r]))
	for r=0,n_elements(aw_orange)-1 do valaw_ax_orange[r] = tsample('x1',reform(aw_orange[r]))
	for r=0,n_elements(aw_orange)-1 do valaw_ay_orange[r] = tsample('y1',reform(aw_orange[r]))
	for r=0,n_elements(aw_orange)-1 do valaw_wx_orange[r] = tsample('x2',reform(aw_orange[r]))
	for r=0,n_elements(aw_orange)-1 do valaw_wy_orange[r] = tsample('y2',reform(aw_orange[r]))

	for r=0,n_elements(aw_black)-1 do valaw_amlt_black[r] = tsample('mlt1',reform(aw_black[r]))
	for r=0,n_elements(aw_black)-1 do valaw_alsh_black[r] = abs(tsample('lsh1',reform(aw_black[r])))
	for r=0,n_elements(aw_black)-1 do valaw_wmlt_black[r] = tsample('mlt2',reform(aw_black[r]))
	for r=0,n_elements(aw_black)-1 do valaw_wlsh_black[r] = abs(tsample('lsh2',reform(aw_black[r])))
	for r=0,n_elements(aw_red)-1 do valaw_amlt_red[r] = tsample('mlt1',reform(aw_red[r]))
	for r=0,n_elements(aw_red)-1 do valaw_alsh_red[r] = abs(tsample('lsh1',reform(aw_red[r])))
	for r=0,n_elements(aw_red)-1 do valaw_wmlt_red[r] = tsample('mlt2',reform(aw_red[r]))
	for r=0,n_elements(aw_red)-1 do valaw_wlsh_red[r] = abs(tsample('lsh2',reform(aw_red[r])))
	for r=0,n_elements(aw_orange)-1 do valaw_amlt_orange[r] = tsample('mlt1',reform(aw_orange[r]))
	for r=0,n_elements(aw_orange)-1 do valaw_alsh_orange[r] = abs(tsample('lsh1',reform(aw_orange[r])))
	for r=0,n_elements(aw_orange)-1 do valaw_wmlt_orange[r] = tsample('mlt2',reform(aw_orange[r]))
	for r=0,n_elements(aw_orange)-1 do valaw_wlsh_orange[r] = abs(tsample('lsh2',reform(aw_orange[r])))



;&&&&&&&&&&&&&&&&&&
;A - L correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_a_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2L_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valal_ax_orange = fltarr(n_elements(al_orange))
	valal_ay_orange = fltarr(n_elements(al_orange))
	valal_lx_orange = fltarr(n_elements(al_orange))
	valal_ly_orange = fltarr(n_elements(al_orange))

	valal_amlt_orange = fltarr(n_elements(al_orange))
	valal_alsh_orange = fltarr(n_elements(al_orange))
	valal_lmlt_orange = fltarr(n_elements(al_orange))
	valal_llsh_orange = fltarr(n_elements(al_orange))

	for r=0,n_elements(al_orange)-1 do valal_ax_orange[r] = tsample('x1',reform(al_orange[r]))
	for r=0,n_elements(al_orange)-1 do valal_ay_orange[r] = tsample('y1',reform(al_orange[r]))
	for r=0,n_elements(al_orange)-1 do valal_lx_orange[r] = tsample('x2',reform(al_orange[r]))
	for r=0,n_elements(al_orange)-1 do valal_ly_orange[r] = tsample('y2',reform(al_orange[r]))

	for r=0,n_elements(al_orange)-1 do valal_amlt_orange[r] = tsample('mlt1',reform(al_orange[r]))
	for r=0,n_elements(al_orange)-1 do valal_alsh_orange[r] = abs(tsample('lsh1',reform(al_orange[r])))
	for r=0,n_elements(al_orange)-1 do valal_lmlt_orange[r] = tsample('mlt2',reform(al_orange[r]))
	for r=0,n_elements(al_orange)-1 do valal_llsh_orange[r] = abs(tsample('lsh2',reform(al_orange[r])))



;&&&&&&&&&&&&&&&&&&
;B - K correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_b_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2K_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valbk_bx_black = fltarr(n_elements(bk_black))
	valbk_by_black = fltarr(n_elements(bk_black))
	valbk_kx_black = fltarr(n_elements(bk_black))
	valbk_ky_black = fltarr(n_elements(bk_black))
	valbk_bx_red = fltarr(n_elements(bk_red))
	valbk_by_red = fltarr(n_elements(bk_red))
	valbk_kx_red = fltarr(n_elements(bk_red))
	valbk_ky_red = fltarr(n_elements(bk_red))
	valbk_bx_orange = fltarr(n_elements(bk_orange))
	valbk_by_orange = fltarr(n_elements(bk_orange))
	valbk_kx_orange = fltarr(n_elements(bk_orange))
	valbk_ky_orange = fltarr(n_elements(bk_orange))

	valbk_bmlt_black = fltarr(n_elements(bk_black))
	valbk_blsh_black = fltarr(n_elements(bk_black))
	valbk_kmlt_black = fltarr(n_elements(bk_black))
	valbk_klsh_black = fltarr(n_elements(bk_black))
	valbk_bmlt_red = fltarr(n_elements(bk_red))
	valbk_blsh_red = fltarr(n_elements(bk_red))
	valbk_kmlt_red = fltarr(n_elements(bk_red))
	valbk_klsh_red = fltarr(n_elements(bk_red))
	valbk_bmlt_orange = fltarr(n_elements(bk_orange))
	valbk_blsh_orange = fltarr(n_elements(bk_orange))
	valbk_kmlt_orange = fltarr(n_elements(bk_orange))
	valbk_klsh_orange = fltarr(n_elements(bk_orange))


	for r=0,n_elements(bk_black)-1 do valbk_bx_black[r] = tsample('x1',reform(bk_black[r]))
	for r=0,n_elements(bk_black)-1 do valbk_by_black[r] = tsample('y1',reform(bk_black[r]))
	for r=0,n_elements(bk_black)-1 do valbk_kx_black[r] = tsample('x2',reform(bk_black[r]))
	for r=0,n_elements(bk_black)-1 do valbk_ky_black[r] = tsample('y2',reform(bk_black[r]))
	for r=0,n_elements(bk_red)-1 do valbk_bx_red[r] = tsample('x1',reform(bk_red[r]))
	for r=0,n_elements(bk_red)-1 do valbk_by_red[r] = tsample('y1',reform(bk_red[r]))
	for r=0,n_elements(bk_red)-1 do valbk_kx_red[r] = tsample('x2',reform(bk_red[r]))
	for r=0,n_elements(bk_red)-1 do valbk_ky_red[r] = tsample('y2',reform(bk_red[r]))
	for r=0,n_elements(bk_orange)-1 do valbk_bx_orange[r] = tsample('x1',reform(bk_orange[r]))
	for r=0,n_elements(bk_orange)-1 do valbk_by_orange[r] = tsample('y1',reform(bk_orange[r]))
	for r=0,n_elements(bk_orange)-1 do valbk_kx_orange[r] = tsample('x2',reform(bk_orange[r]))
	for r=0,n_elements(bk_orange)-1 do valbk_ky_orange[r] = tsample('y2',reform(bk_orange[r]))

	for r=0,n_elements(bk_black)-1 do valbk_bmlt_black[r] = tsample('mlt1',reform(bk_black[r]))
	for r=0,n_elements(bk_black)-1 do valbk_blsh_black[r] = abs(tsample('lsh1',reform(bk_black[r])))
	for r=0,n_elements(bk_black)-1 do valbk_kmlt_black[r] = tsample('mlt2',reform(bk_black[r]))
	for r=0,n_elements(bk_black)-1 do valbk_klsh_black[r] = abs(tsample('lsh2',reform(bk_black[r])))
	for r=0,n_elements(bk_red)-1 do valbk_bmlt_red[r] = tsample('mlt1',reform(bk_red[r]))
	for r=0,n_elements(bk_red)-1 do valbk_blsh_red[r] = abs(tsample('lsh1',reform(bk_red[r])))
	for r=0,n_elements(bk_red)-1 do valbk_kmlt_red[r] = tsample('mlt2',reform(bk_red[r]))
	for r=0,n_elements(bk_red)-1 do valbk_klsh_red[r] = abs(tsample('lsh2',reform(bk_red[r])))
	for r=0,n_elements(bk_orange)-1 do valbk_bmlt_orange[r] = tsample('mlt1',reform(bk_orange[r]))
	for r=0,n_elements(bk_orange)-1 do valbk_blsh_orange[r] = abs(tsample('lsh1',reform(bk_orange[r])))
	for r=0,n_elements(bk_orange)-1 do valbk_kmlt_orange[r] = tsample('mlt2',reform(bk_orange[r]))
	for r=0,n_elements(bk_orange)-1 do valbk_klsh_orange[r] = abs(tsample('lsh2',reform(bk_orange[r])))


;&&&&&&&&&&&&&&&&&&
;B - W correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_b_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2W_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valbw_bx_black = fltarr(n_elements(bw_black))
	valbw_by_black = fltarr(n_elements(bw_black))
	valbw_wx_black = fltarr(n_elements(bw_black))
	valbw_wy_black = fltarr(n_elements(bw_black))
	valbw_bx_red = fltarr(n_elements(bw_red))
	valbw_by_red = fltarr(n_elements(bw_red))
	valbw_wx_red = fltarr(n_elements(bw_red))
	valbw_wy_red = fltarr(n_elements(bw_red))
	valbw_bx_orange = fltarr(n_elements(bw_orange))
	valbw_by_orange = fltarr(n_elements(bw_orange))
	valbw_wx_orange = fltarr(n_elements(bw_orange))
	valbw_wy_orange = fltarr(n_elements(bw_orange))

	valbw_bmlt_black = fltarr(n_elements(bw_black))
	valbw_blsh_black = fltarr(n_elements(bw_black))
	valbw_wmlt_black = fltarr(n_elements(bw_black))
	valbw_wlsh_black = fltarr(n_elements(bw_black))
	valbw_bmlt_red = fltarr(n_elements(bw_red))
	valbw_blsh_red = fltarr(n_elements(bw_red))
	valbw_wmlt_red = fltarr(n_elements(bw_red))
	valbw_wlsh_red = fltarr(n_elements(bw_red))
	valbw_bmlt_orange = fltarr(n_elements(bw_orange))
	valbw_blsh_orange = fltarr(n_elements(bw_orange))
	valbw_wmlt_orange = fltarr(n_elements(bw_orange))
	valbw_wlsh_orange = fltarr(n_elements(bw_orange))


	for r=0,n_elements(bw_black)-1 do valbw_bx_black[r] = tsample('x1',reform(bw_black[r]))
	for r=0,n_elements(bw_black)-1 do valbw_by_black[r] = tsample('y1',reform(bw_black[r]))
	for r=0,n_elements(bw_black)-1 do valbw_wx_black[r] = tsample('x2',reform(bw_black[r]))
	for r=0,n_elements(bw_black)-1 do valbw_wy_black[r] = tsample('y2',reform(bw_black[r]))
	for r=0,n_elements(bw_red)-1 do valbw_bx_red[r] = tsample('x1',reform(bw_red[r]))
	for r=0,n_elements(bw_red)-1 do valbw_by_red[r] = tsample('y1',reform(bw_red[r]))
	for r=0,n_elements(bw_red)-1 do valbw_wx_red[r] = tsample('x2',reform(bw_red[r]))
	for r=0,n_elements(bw_red)-1 do valbw_wy_red[r] = tsample('y2',reform(bw_red[r]))
	for r=0,n_elements(bw_orange)-1 do valbw_bx_orange[r] = tsample('x1',reform(bw_orange[r]))
	for r=0,n_elements(bw_orange)-1 do valbw_by_orange[r] = tsample('y1',reform(bw_orange[r]))
	for r=0,n_elements(bw_orange)-1 do valbw_wx_orange[r] = tsample('x2',reform(bw_orange[r]))
	for r=0,n_elements(bw_orange)-1 do valbw_wy_orange[r] = tsample('y2',reform(bw_orange[r]))

	for r=0,n_elements(bw_black)-1 do valbw_bmlt_black[r] = tsample('mlt1',reform(bw_black[r]))
	for r=0,n_elements(bw_black)-1 do valbw_blsh_black[r] = abs(tsample('lsh1',reform(bw_black[r])))
	for r=0,n_elements(bw_black)-1 do valbw_wmlt_black[r] = tsample('mlt2',reform(bw_black[r]))
	for r=0,n_elements(bw_black)-1 do valbw_wlsh_black[r] = abs(tsample('lsh2',reform(bw_black[r])))
	for r=0,n_elements(bw_red)-1 do valbw_bmlt_red[r] = tsample('mlt1',reform(bw_red[r]))
	for r=0,n_elements(bw_red)-1 do valbw_blsh_red[r] = abs(tsample('lsh1',reform(bw_red[r])))
	for r=0,n_elements(bw_red)-1 do valbw_wmlt_red[r] = tsample('mlt2',reform(bw_red[r]))
	for r=0,n_elements(bw_red)-1 do valbw_wlsh_red[r] = abs(tsample('lsh2',reform(bw_red[r])))
	for r=0,n_elements(bw_orange)-1 do valbw_bmlt_orange[r] = tsample('mlt1',reform(bw_orange[r]))
	for r=0,n_elements(bw_orange)-1 do valbw_blsh_orange[r] = abs(tsample('lsh1',reform(bw_orange[r])))
	for r=0,n_elements(bw_orange)-1 do valbw_wmlt_orange[r] = tsample('mlt2',reform(bw_orange[r]))
	for r=0,n_elements(bw_orange)-1 do valbw_wlsh_orange[r] = abs(tsample('lsh2',reform(bw_orange[r])))


;&&&&&&&&&&&&&&&&&&
;B - L correlations
;&&&&&&&&&&&&&&&&&&


	myfile = path+"rbsp_b_mag.dat"
	data1 = read_ascii(myfile, template = res)
	myfile = path+"bar_2L_mag.dat"
	data2 = read_ascii(myfile, template = res)


	t1 = time_double('2014-01-06/00:00') + data1.utsec
	t2 = time_double('2014-01-06/00:00') + data2.utsec
	mlt1 = data1.mlt
	mlt2 = data2.mlt
	mlt1 = mlt1*360.0/24.0
	mlt2 = mlt2*360.0/24.0
	l1 = data1.l
	l2 = data2.l
	x1 = abs(l1)*cos(mlt1*!pi/180.0)
	y1 = abs(l1)*sin(mlt1*!pi/180.0)
	x2 = abs(l2)*cos(mlt2*!pi/180.0)
	y2 = abs(l2)*sin(mlt2*!pi/180.0)

	store_data,'x1',data={x:t1,y:x1}
	store_data,'y1',data={x:t1,y:y1}
	store_data,'x2',data={x:t2,y:x2}
	store_data,'y2',data={x:t2,y:y2}
	store_data,'mlt1',data={x:t1,y:mlt1}
	store_data,'mlt2',data={x:t2,y:mlt2}
	store_data,'lsh1',data={x:t1,y:l1}
	store_data,'lsh2',data={x:t2,y:l2}


	valbl_bx_orange = fltarr(n_elements(bl_orange))
	valbl_by_orange = fltarr(n_elements(bl_orange))
	valbl_lx_orange = fltarr(n_elements(bl_orange))
	valbl_ly_orange = fltarr(n_elements(bl_orange))

	valbl_bmlt_orange = fltarr(n_elements(bl_orange))
	valbl_blsh_orange = fltarr(n_elements(bl_orange))
	valbl_lmlt_orange = fltarr(n_elements(bl_orange))
	valbl_llsh_orange = fltarr(n_elements(bl_orange))

	for r=0,n_elements(bl_orange)-1 do valbl_bx_orange[r] = tsample('x1',reform(bl_orange[r]))
	for r=0,n_elements(bl_orange)-1 do valbl_by_orange[r] = tsample('y1',reform(bl_orange[r]))
	for r=0,n_elements(bl_orange)-1 do valbl_lx_orange[r] = tsample('x2',reform(bl_orange[r]))
	for r=0,n_elements(bl_orange)-1 do valbl_ly_orange[r] = tsample('y2',reform(bl_orange[r]))

	for r=0,n_elements(bl_orange)-1 do valbl_bmlt_orange[r] = tsample('mlt1',reform(bl_orange[r]))
	for r=0,n_elements(bl_orange)-1 do valbl_blsh_orange[r] = abs(tsample('lsh1',reform(bl_orange[r])))
	for r=0,n_elements(bl_orange)-1 do valbl_lmlt_orange[r] = tsample('mlt2',reform(bl_orange[r]))
	for r=0,n_elements(bl_orange)-1 do valbl_llsh_orange[r] = abs(tsample('lsh2',reform(bl_orange[r])))




;Combine all results into single variable

all_deltamlt_black = [abs(valkw_kmlt_black - valkw_wmlt_black),$
					abs(valab_amlt_black - valab_bmlt_black),$
					abs(valak_amlt_black - valak_kmlt_black),$
					abs(valaw_amlt_black - valaw_wmlt_black),$
					abs(valbk_bmlt_black - valbk_kmlt_black),$
					abs(valbw_bmlt_black - valbw_wmlt_black)]

all_deltalsh_black = [abs(valkw_klsh_black - valkw_wlsh_black),$
					abs(valab_alsh_black - valab_blsh_black),$
					abs(valak_alsh_black - valak_klsh_black),$
					abs(valaw_alsh_black - valaw_wlsh_black),$
					abs(valbk_blsh_black - valbk_klsh_black),$
					abs(valbw_blsh_black - valbw_wlsh_black)]


all_deltamlt_red = [abs(valkl_kmlt_red - valkl_lmlt_red),$
					abs(valkw_kmlt_red - valkw_wmlt_red),$
					abs(valab_amlt_red - valab_bmlt_red),$
					abs(valak_amlt_red - valak_kmlt_red),$
					abs(valaw_amlt_red - valaw_wmlt_red),$
					abs(valbk_bmlt_red - valbk_kmlt_red),$
					abs(valbw_bmlt_red - valbw_wmlt_red)]

all_deltalsh_red = [abs(valkl_klsh_red - valkl_llsh_red),$
					abs(valkw_klsh_red - valkw_wlsh_red),$
					abs(valab_alsh_red - valab_blsh_red),$
					abs(valak_alsh_red - valak_klsh_red),$
					abs(valaw_alsh_red - valaw_wlsh_red),$
					abs(valbk_blsh_red - valbk_klsh_red),$
					abs(valbw_blsh_red - valbw_wlsh_red)]

all_deltamlt_orange = [abs(valkl_kmlt_orange - valkl_lmlt_orange),$
					abs(valkw_kmlt_orange - valkw_wmlt_orange),$
					abs(valab_amlt_orange - valab_bmlt_orange),$
					abs(valak_amlt_orange - valak_kmlt_orange),$
					abs(valaw_amlt_orange - valaw_wmlt_orange),$
					abs(valal_amlt_orange - valal_lmlt_orange),$
					abs(valbk_bmlt_orange - valbk_kmlt_orange),$
					abs(valbw_bmlt_orange - valbw_wmlt_orange),$
					abs(valbl_bmlt_orange - valbl_lmlt_orange),$
					abs(vallw_lmlt_orange - vallw_wmlt_orange)]

all_deltalsh_orange = [abs(valkl_klsh_orange - valkl_llsh_orange),$
					abs(valkw_klsh_orange - valkw_wlsh_orange),$
					abs(valab_alsh_orange - valab_blsh_orange),$
					abs(valak_alsh_orange - valak_klsh_orange),$
					abs(valaw_alsh_orange - valaw_wlsh_orange),$
					abs(valal_alsh_orange - valal_llsh_orange),$
					abs(valbk_blsh_orange - valbk_klsh_orange),$
					abs(valbw_blsh_orange - valbw_wlsh_orange),$
					abs(valbl_blsh_orange - valbl_llsh_orange),$
					abs(vallw_llsh_orange - vallw_wlsh_orange)]



save,filename='~/Desktop/Research/RBSP_hiss_precip/idl/jan3_correlations.idl'


end



