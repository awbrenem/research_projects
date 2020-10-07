;create a series of rays from two different locations and find the
;delta-time of arrival at FIREBIRD. Calls triangulate_rays.pro



;------------------------------------------------
;COUNTER-STREAMING CYCLOTRON (n=1) RESONANCE
;------------------------------------------------

FB_leq = 5.
chorus_leq = 5.39   ;value used for model calibration.
;(if you adjust L to make |B|-|Bmodel|=0)
;At this point EMFISIS Bo=146 nT and density<=10 cm-3

;Initial raytrace setup
ti = read_write_trace_in(freq=freqvt,$
mmult = .72,$
lat=0.,$
theta=0.,$
phi=0.,$
alt=(6370.*chorus_leq)-6370.,$
final_alt=4000.,$
model=0,$
final_lat=-50.,$
pplcp=3.,$
pplhw=0.5,$
drl=10000.)


;--------------------------------------------
;Set up model for observed density, Bo.
altv=(6370.*chorus_leq)-6370.
create_rays_general,1800.,theta=0,alt=altv,lat=0,title='uB3'
dens_bo_profile,1800.,dens_sc=8,bo_sc=146,L_sc=chorus_leq;,/ps
;--------------------------------------------


noplot = 0

;freqsALL = float([1000,1100,1200,1300,1400,1500,1600,1700,1800])
freqsALL = float([1800])
;freqsAll = 1600.
nrayss = 80.  ;number of rays for each point source
;nlvals = 40.  ;number of point sources
nlvals = 3.  ;number of point sources
;allLvals = (7-3.4)*indgen(nlvals)/(nlvals-1)+3.4
allLvals = (4.8-4.4)*indgen(nlvals)/(nlvals-1)+4.4

lval_extract = 5.
thetav = reverse(((45+0)*indgen(nrayss)/(nrayss-1))- 180.)
latv = replicate(0.,nrayss)


filename = 'counterstream_'+string(freqsALL,format='(I4)')+'Hz_L=3.4-7_nrays='+string(nrayss,format='(I2)')+'.idl'


for qqq=0,n_elements(freqsALL)-1 do begin

	freqvt = freqsALL[qqq]
	freqv = replicate(freqvt,nrayss)

	;Subset of values with the correct resonant energy
	mlatrange = -1*indgen(90.)


	;Value along L=5 cut at each mlat for each ray
	energiesL = replicate(!values.f_nan,90,n_elements(allLvals))
	totaltimeL = energiesL
	lval0_finL = energiesL  ;0 denotes initial value
	thk_finL =  energiesL
	thk0_finL = energiesL
	lval_finL = energiesL
	mlat0_finL = energiesL
	;Same as above but only where the resonance energies falls b/t 220-985 keV
	energiesL2 = energiesL
	totaltimeL2 = energiesL
	lval0_finL2 = energiesL
	thk_finL2 =  energiesL
	thk0_finL2 = energiesL


	for bbq=0,n_elements(allLvals)-1 do begin

		chorus_leqv = replicate(allLvals[bbq],nrayss)
		;;********************

		altv=(6370.*chorus_leqv)-6370.

		create_rays_general,freqv,theta=thetav,alt=altv,lat=latv,title='uB3'


		;restore multiple rays
		restore,'/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/raytrace/uB3_rays.sav'

		freqs = make_array(n_elements(thk[*,0]),n_elements(thk[0,*]),value=0)
		for i=0,n_elements(freqv)-1 do freqs[*,i] = freqv[i]


		fce = freqs/f_fce
		kvec = 2*!pi/wavelength   ;1/km
		pa = replicate(5.,n_elements(thk[*,0]),n_elements(freqv))
		evals = cycl_energies(freqs,thk,pa,fce,kvec,dens,1)
		eplot = evals.e_cycl_counterstream
		vz = evals.vz_cycl_counterstream

		;plot resonance energy

		if ~keyword_set(noplot) then plot_rays,xcoord,ycoord,zcoord,ray_vals=eplot,$
		xrangeM=[0,6],zrangeM=[-3,3],minv=220,maxv=985.;,/psonly

		stop

		;fill in holes by triangulating
		triangulate_rays,xcoord,zcoord,eplot,minv=1,maxv=1000.,Lsc=[chorus_leq,FB_leq],$
		limits=[0,-3,6,3],nlvls=50,$
		xgrid=xg,ygrid=yg,result=eres,mlats=mlats,lvals=lvals,rads=rads,$
		ilats=ilats,noplot=noplot;,/zbuffer;,/psonly

			stop

		;Extract slice along single L-value
		energiesL[*,bbq] = extract_lshell_mlat_slice(lval_extract,mlatrange,xg,yg,eres,gridpts=pts)



		;Find distance scattered e- have to travel to arrive at FIREBIRD FU-4
		alt = 500.;rough altitude of FB4 (632 by 433 km orbit)
		dist_remaining = distance_to_atmosphere(lval,lat,offset_alt=alt,/opposite_hemisphere)


		;calculate time for scattered e- to arrive at FB
		tarr = 6370.*dist_remaining/vz
		tarr = 1000.*tarr ;msec for better plotting
		;	plot_rays,xcoord,ycoord,zcoord,ray_vals=tarr,$
		;		xrangeM=[0,6],zrangeM=[-3,3],$
		;		Lsc=[chorus_leq,FB_leq],minval=20,maxval=400;,/ps

		;	triangulate_rays,xcoord,zcoord,tarr,minv=20.,maxv=400.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
		;		limits=[0,-3,6,3],nlvls=50;,xgrid=xg,ygrid=yg,result=result1



		;Now add together the time it takes for chorus wave to propagate
		;to a particular point with time it would take electron scattered at
		;that point to reach FIREBIRD

		ttotal = tarr + timeg*1000.

		if ~KEYWORD_SET(noplot) then plot_rays,xcoord,ycoord,zcoord,ray_vals=ttotal,$
		xrangeM=[0,6],zrangeM=[-3,3],$
		Lsc=[chorus_leq,FB_leq],minval=200,maxval=1000,/psonly


		triangulate_rays,xcoord,zcoord,ttotal,minv=200.,maxv=1000.,Lsc=[chorus_leq,FB_leq],$
		limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=totaltime,noplot=noplot;,/zbuffer

		totaltimeL[*,bbq] = extract_lshell_mlat_slice(lval_extract,mlatrange,xg,yg,totaltime,gridpts=pts)


		;Test to make sure that we have some rays on L=5
		tdifftest = max(totaltimeL[*,bbq],/nan) - min(totaltimeL[*,bbq],/nan)
		;If there are no rays

		if ~(finite(tdifftest) eq 0) then begin
			if ~(tdifftest eq 0.) then begin




				;********
				;extract other values using the identified grid points

				;Extract L-values
				triangulate_rays,xcoord,zcoord,lval,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
				limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,noplot=noplot;,/zbuffer
				ptsx = pts[*,0]
				ptsz = pts[*,1]
				for i=0,89 do lval_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,lval_finL[*,bbq]   ;these should be the same value I selected for my Lshell slice

				;Extract initial L-values
				triangulate_rays,xcoord,zcoord,lval0,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
				limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,noplot=noplot;,/zbuffer
				ptsx = pts[*,0]
				ptsz = pts[*,1]
				for i=0,89 do lval0_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,lval0_finL[*,bbq]

				;Extract inital mlat values
				triangulate_rays,xcoord,zcoord,lat0,minv=0.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
				limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,noplot=noplot;,/zbuffer
				ptsx = pts[*,0]
				ptsz = pts[*,1]
				for i=0,89 do mlat0_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,mlat0_finL[*,bbq]

				;Extract initial theta_kb values for ray slice
				triangulate_rays,xcoord,zcoord,180-thk0,minv=0.,maxv=60.,Lsc=[chorus_leq,FB_leq],$
				limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,noplot=noplot;,/zbuffer
				ptsx = pts[*,0]
				ptsz = pts[*,1]
				for i=0,89 do thk0_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,thk0_finL[*,bbq]

				;Extract in situ theta_kb values for ray slice
				triangulate_rays,xcoord,zcoord,180-thk,minv=0.,maxv=60.,Lsc=[chorus_leq,FB_leq],$
				limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=tmpvar,noplot=noplot;,/zbuffer
				ptsx = pts[*,0]
				ptsz = pts[*,1]
				for i=0,89 do thk_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,thk_finL[*,bbq]



				;Subset of values with the correct resonant energy
				energiesL2[*,bbq] = energiesL[*,bbq]
				totaltimeL2[*,bbq] = totaltimeL[*,bbq]
				lval0_finL2[*,bbq] = lval0_finL[*,bbq]
				thk_finL2[*,bbq] = thk_finL[*,bbq]
				thk0_finL2[*,bbq] = thk0_finL[*,bbq]


				bade = where((energiesL[*,bbq] lt 220.) or (energiesL[*,bbq] gt 985.))
				if bade[0] ne -1 then begin
					energiesL2[bade,bbq] = !values.f_nan
					totaltimeL2[bade,bbq] = !values.f_nan
					lval0_finL2[bade,bbq] = !values.f_nan
					thk_finL2[bade,bbq] = !values.f_nan
					thk0_finL2[bade,bbq] = !values.f_nan
				endif



				;Calculate max time diff b/t arrival of 985 keV e- and 220 keV e-
				tdiff = max(totaltimeL2[*,bbq],/nan) - min(totaltimeL2[*,bbq],/nan)
				L0diff = max(lval0_finL2[*,bbq],/nan) - min(lval0_finL2[*,bbq],/nan)
				print,'TIME OF ARRIVAL DIFFERENCE = '+strtrim(tdiff,2)+ ' (MSEC)'

				;if finite(tdiff) eq 0. then print,'****NO SOLUTION FOUND****'


				if ~KEYWORD_SET(noplot) then begin

					!p.multi = [0,2,3]
					rbsp_efw_init
					plot,mlatrange,energiesL[*,bbq],yrange=[0,1000],xrange=[0,-50],$
					xtitle='mlat',ytitle='counterstream energy (keV)',$
					title='ray energy vs mlat for L='+strtrim(lval_extract,2)
					oplot,mlatrange,energiesL2[*,bbq],color=250,thick=3
					boomin = min(energiesL2[*,bbq],mintmp,/nan)
					boomax = max(energiesL2[*,bbq],maxtmp,/nan)
					oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
					oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
					mlatstr = 'mlat = '+strtrim(mlatrange[mintmp],2) + '-' + strtrim(mlatrange[maxtmp],2)+' deg'
					xyouts,0.2,0.8,mlatstr,/normal

					plot,mlatrange,totaltimeL[*,bbq],yrange=[0,1000],xrange=[0,-50],$
					xtitle='mlat',ytitle='Precip time at FB (msec)',$
					title='Precip time after chorus onset!Cvs mlat for L='+strtrim(lval_extract,2)
					oplot,mlatrange,totaltimeL2[*,bbq],color=250,thick=3
					boomin = min(totaltimeL2[*,bbq],mintmp,/nan)
					boomax = max(totaltimeL2[*,bbq],maxtmp,/nan)
					oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
					oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
					tstr = string(tdiff,format='(f4.0)')+' msec'
					xyouts,0.7,0.8,'Delta time = '+tstr,/normal

					plot,mlatrange,lval0_finL[*,bbq],yrange=[2,8],xrange=[0,-50],$
					xtitle='mlat',ytitle='Initial Lshell of ray',$
					title='ray L0 vs mlat for L='+strtrim(lval_extract,2)
					oplot,mlatrange,lval0_finL2[*,bbq],color=250,thick=3
					boomin = min(lval0_finL2[*,bbq],mintmp,/nan)
					boomax = max(lval0_finL2[*,bbq],maxtmp,/nan)
					oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
					oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
					lstr = string(min(lval0_finL2[*,bbq],/nan),format='(f4.1)')+'-'+$
					string(max(lval0_finL2[*,bbq],/nan),format='(f4.1)')
					xyouts,0.2,0.42,'L0 range='+lstr,/normal

					plot,mlatrange,thk_finL[*,bbq],yrange=[0,70],xrange=[0,-50],$
					xtitle='mlat',ytitle='theta_kb of ray',$
					title='ray theta_kb vs mlat for L='+strtrim(lval_extract,2)
					oplot,mlatrange,thk_finL2[*,bbq],color=250,thick=3
					boomin = min(thk_finL2[*,bbq],mintmp,/nan)
					boomax = max(thk_finL2[*,bbq],maxtmp,/nan)
					oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
					oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2

					plot,mlatrange,thk0_finL[*,bbq],yrange=[0,70],xrange=[0,-50],$
					xtitle='mlat',ytitle='Inital theta_kb of ray',$
					title='ray initial theta_kb vs mlat for L='+strtrim(lval_extract,2)
					oplot,mlatrange,thk0_finL2[*,bbq],color=250,thick=3
					boomin = min(thk0_finL2[*,bbq],mintmp,/nan)
					boomax = max(thk0_finL2[*,bbq],maxtmp,/nan)
					oplot,[mlatrange[mintmp],mlatrange[mintmp]],[0,boomin],linestyle=2
					oplot,[mlatrange[maxtmp],mlatrange[maxtmp]],[0,boomax],linestyle=2
					t0str = string(min(thk0_finL2[*,bbq],/nan),format='(f4.0)')+'-'+$
					string(max(thk0_finL2[*,bbq],/nan),format='(f4.0)')
					xyouts,0.2,0.22,'theta_kb0 range='+t0str+' deg',/normal
stop
				endif ;noplot

			endif  ;tdiff ne 0
		endif else print,'****NO SOLUTION FOUND****' ;tdiff ne NaN


	endfor  ;all the rays in a single freq

	;xyouts,0.2,0.13,'L0 range = '+strtrim(L0diff,2)+' RE',/normal



	save,mlatrange,lval_extract,tdiff,$
	totaltimeL,energiesL,lval_finL,$
	lval0_finL,thk_finL,thk0_finL,$
	allLvals,$
	filename='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/raytrace_files/'+filename[qqq]


endfor















;;*************************************
;;Test that I've calculated lshell, mlat, radial distance correctly
;;*************************************

;minv=3
;maxv=max(lvals)
;contour,lvals,xg,yg,nlevels=10,min_value=minv,max_value=maxv,$
;/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1,$
;background=255,position=aspect(1),color=2

;triangulate_rays,xcoord,zcoord,lval0,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
;limits=[0,-3,6,3],nlvls=50,xgrid=xg,ygrid=yg,result=eres,mlats=mlats,lvals=lvals,rads=rads,ilats=ilats,/zbuffer


;;************
;;Test of ray initial values held constant throughout trajectory (raypath should be a single color...test with single ray)
;plot_rays,xcoord,ycoord,zcoord,ray_vals=lval0,$
;xrangeM=[0,6],zrangeM=[-3,3],minv=1,maxv=7.

;plot_rays,xcoord,ycoord,zcoord,ray_vals=radius0,$
;xrangeM=[0,6],zrangeM=[-3,3],minv=1,maxv=7.

;plot_rays,xcoord,ycoord,zcoord,ray_vals=lat,$
;xrangeM=[0,6],zrangeM=[-3,3],minv=1,maxv=10.
;;************



;minv=3
;maxv=max(rads)
;contour,rads,xg,yg,nlevels=10,min_value=minv,max_value=maxv,$
;/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1,$
;background=255,position=aspect(1),color=2

;minv=0
;maxv=max(mlats)
;contour,mlats,xg,yg,nlevels=30,min_value=minv,max_value=maxv,$
;/cell_fill,xrange=[0,6],yrange=[-3,3],xstyle=1,ystyle=1,$
;background=255,position=aspect(1),color=2


;L2 = dipole(2.)
;L4 = dipole(4.)
;L6 = dipole(6.)
;L5 = dipole(5.)
;L8 = dipole(8.)
;earthx = COS((2*!PI/99.0)*FINDGEN(100))
;earthy = SIN((2*!PI/99.0)*FINDGEN(100))
;oplot,earthx,earthy,color=60
;;oplot,replicate(1.078,360.),indgen(360.)*!dtor,/polar,color=80

;oplot,replicate(1.078,360.)*cos(indgen(360.)*!dtor),replicate(1.078,360.)*sin(indgen(360.)*!dtor),color=80
;oplot,L2.R/6370.*cos(L2.lat*!dtor),L2.R/6370.*sin(L2.lat*!dtor),color=120
;oplot,L2.R/6370.*cos(L2.lat*!dtor),-1*L2.R/6370.*sin(L2.lat*!dtor),color=120

;oplot,L4.R/6370.*cos(L4.lat*!dtor),L4.R/6370.*sin(L4.lat*!dtor),color=120
;oplot,L4.R/6370.*cos(L4.lat*!dtor),-1*L4.R/6370.*sin(L4.lat*!dtor),color=120

;oplot,L6.R/6370.*cos(L6.lat*!dtor),L6.R/6370.*sin(L6.lat*!dtor),color=120
;oplot,L6.R/6370.*cos(L6.lat*!dtor),-1*L6.R/6370.*sin(L6.lat*!dtor),color=120

;oplot,L5.R/6370.*cos(L5.lat*!dtor),L5.R/6370.*sin(L5.lat*!dtor),color=120
;oplot,L5.R/6370.*cos(L5.lat*!dtor),-1*L5.R/6370.*sin(L5.lat*!dtor),color=120

;oplot,L8.R/6370.*cos(L8.lat*!dtor),L8.R/6370.*sin(L8.lat*!dtor),color=120
;oplot,L8.R/6370.*cos(L8.lat*!dtor),-1*L8.R/6370.*sin(L8.lat*!dtor),color=120

;;latitude lines
;latstmp = [0,10,20,30,40,50,60,70,80]
;latstmp = [-1*reverse(latstmp[1:n_elements(latstmp)-1]),latstmp]
;for i=0,n_elements(latstmp)-1 do oplot,[1,50]*cos([latstmp[i]*!dtor,latstmp[i]*!dtor]),[1,50]*sin([latstmp[i]*!dtor,latstmp[i]*!dtor]),linestyle=3,color=100


;loadct,39  ;need the first element to be black
;nticks = 10.
;tn = (indgen(nticks)/(nticks-1))*(maxv-minv)  + minv
;tn = strtrim(string(tn,format='(f8.2)'),2)
;colorbar,POSITION=[0.15, 0.75, 0.85, 0.77],$
;divisions=nticks-1,ticknames=tn,charsize = 0.8,range=[minv,maxv],color=2

;*************************************

;stop

end
