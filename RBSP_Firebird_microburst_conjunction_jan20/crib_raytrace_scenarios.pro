;From each desired location (typically single L and mlat=0), create a series
;of rays spanning range of theta_kb. Triangulate these rays onto a grid pattern,
;then extract slice of various ray values at L=5 (FIREBIRD Lshell).
;Plot various ray parameters along this slice such as:
;...resonant energy (from desired cyclotron resonance harmonic)
;...total travel time of precipitated e- from onset of chorus emission to detection at FB.
;...Initial ray values like theta_kb, L, mlat, etc.
;...In situ ray values like theta_kb, L, mlat, etc.
;Results are saved in IDL save file. To plot them see plot_raytrace_results_costream.pro
;or plot_raytrace_results_counterstream.pro, etc.

;------------------------------------------------------
;see call_raytrace_scenarios.pro to call this program
;------------------------------------------------------


pro crib_raytrace_scenarios,type,nharmonic,freqsALL,smlat_fin,$
	nrayss,thetav,minL,maxL,dl,FB_leq


	nharmonics = n_elements(nharmonic)


	;----set up ray tracing model (STATIC)
	chorus_leq = 5.39   ;value for calibrating Bmodel
	mlatSM = 0.
	mlongSM = 0.
	freqvt = 1800.;Only used for setting up model Bo magnitude


	;Initial raytrace setup
	ti = read_write_trace_in(freq=freqvt,$
	bmodel = 0,$
	mmult = 0.8,$
	lat=mlatSM,$
	theta=0.,$
	phi=0.,$
	longit=mlongSM,$
	alt=6370.*chorus_leq-6370.,$
	final_alt=4000.,$
	model=0,$
	final_lat=smlat_fin,$
	pplcp=3.,$
	pplhw=0.5,$
	arl=27391.,$
	drl=10.)

	;--------------------------------------------
	;Set up model for observed density, Bo.
	altv=(6370.*chorus_leq)-6370.
	create_rays_general,1800.,theta=0,alt=altv,lat=mlatSM,long=mlongSM,title='uB3'
	dens_bo_profile,1800.,dens_sc=8,bo_sc=146,L_sc=chorus_leq;,/ps
	;--------------------------------------------
	;Calibrate the dipole model. This is used in electron_precipitation_time.pro
	dipmult = 0.87
	Ltst = dipole(chorus_leq[0],dipmult)
	print,Ltst.B[0]


	nlvals = (maxL-minL)/dl
	allLvals = (maxL-minL)*indgen(nlvals+1)/(nlvals)+minL


	lval_extract = fb_leq



	latSM_input = replicate(mlatSM,nrayss)
	longSM_input = replicate(mlongSM,nrayss)

	lmin = string(min(allLvals),format='(f3.1)')
	lmax = string(max(allLvals),format='(f3.1)')
	nlstr = strtrim(floor(nlvals),2)
	mtkb = strtrim(floor(max(abs(thetav))),2)
	harstr = strtrim(floor(min(nharmonic)),2)+'-'+strtrim(floor(max(nharmonic)),2)

	;Subset of values with the correct resonant energy
	if type eq 'costream' then mlatrange = indgen(90.)
	if type eq 'counterstream' then mlatrange = -1*indgen(90.)


	filenames = type+'_'+strtrim(string(freqsALL,format='(I4)'),2)+$
	'Hz_harmonics='+harstr+'_L='+lmin+'-'+lmax+'_nrays='+string(nrayss,format='(I2)')+$
	'_nsources='+nlstr+'_maxthetakb='+mtkb+'_Lslice='+string(FB_leq,format='(F3.1)')+'.idl'



	for nfreq=0,n_elements(freqsALL)-1 do begin

		freqvt = freqsALL[nfreq]
		freqv = replicate(freqvt,nrayss)


		;Value along Lvalue (lval_extract) cut at each mlat for each ray and each harmonic
		energiesL_nh = replicate(!values.f_nan,90.,n_elements(allLvals),nharmonics)
		totaltimeL_nh = energiesL_nh
		lval0_finL = replicate(!values.f_nan,90.,n_elements(allLvals))  ;0 denotes initial value
		thk_finL =  lval0_finL
		thk0_finL = lval0_finL
		lval_finL = lval0_finL
		mlat0_finL = lval0_finL
		mlat_finL = lval0_finL



		for bbq=0,n_elements(allLvals)-1 do begin

			;----------CREATE THE RAYS. ONLY HAS TO BE DONE ONCE FOR EACH SOURCE
			chorus_leqv = replicate(allLvals[bbq],nrayss)
			altv=replicate((6370.*allLvals[bbq])-6370.,nrayss)


			create_rays_general,freqv,theta=thetav,alt=altv,lat=latSM_input,long=longSM_input,title='uB3'

			;restore multiple rays
			restore,'/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/raytrace/uB3_rays.sav'

			freqs = make_array(n_elements(thk[*,0]),n_elements(thk[0,*]),value=0)
			for i=0,n_elements(freqv)-1 do freqs[*,i] = freqv[i]

			fce = freqs/f_fce
			kvec = 2*!pi/wavelength   ;1/km

			pa = replicate(5.,n_elements(thk[*,0]),n_elements(freqv))


			;----------ANALYZE RESONANCE ENERGIES FOR EACH HARMONIC------------
			for h=0,nharmonics-1 do begin

				print,'()()()()()()()()()()()()()()'
				print,'L=',allLvals[bbq]
				print,'harmonic=',nharmonic[h]
				print,'()()()()()()()()()()()()()()'


				evals = cycl_energies(freqs,thk,pa,fce,kvec,dens,nharmonic[h])


				if type eq 'costream' then begin
					eplot = evals.e_cycl_costream
					vz = evals.vz_cycl_costream
				endif
				if type eq 'counterstream' then begin
					eplot = evals.e_cycl_counterstream
					vz = evals.vz_cycl_counterstream
				endif

						;plot resonance energy
;						plot_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,ray_vals=eplot,$
;						xrangeM=[2,6.5],zrangeM=[-2.5,2.5],minv=1,maxv=1000.,outsidecolor='fill',/ps


;stop
;				stop
				;;Use for testing ray accessibility to L=lval_extract
				;goto, jump1

				limitsstatic = [2,-3,8,3]  ;MUST BE THE SAME FOR ALL CALLS TO TRINAGULATE_RAYS.
																	 ;THIS CREATES A COMMON REFERENCE GRID FOR THE L=lval_extract EXTRACTION

				;fill in holes by triangulating
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,eplot,minv=220,maxv=985.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,xgrid=xgfinal,ygrid=zgfinal,result=eres,mlats=mlats,$
				lvals=lvals,rads=rads,ilats=ilats,/zbuffer;,/psonly



				;Extract slice along single L-value
				energiesL_nh[*,bbq,h] = extract_lshell_mlat_slice(lval_extract,mlatrange,xgfinal,zgfinal,eres,gridpts=ptsfinal)
				;These are L=lval_extract extracted values for xgfinal, zgfinal
				ptsx = ptsfinal[*,0]
				ptsz = ptsfinal[*,1]
				;print,'Energies along slice = ',energiesL_nh[*,bbq,h]

				;test out the L-value for extracted grid points
				radtst = sqrt(xgfinal[ptsx]^2 + zgfinal[ptsz]^2)
				mlattst = 90. - acos(zgfinal[ptsz]/radtst)/!dtor
				ltest = radtst/cos(mlattst*!dtor)^2
				;make sure the extracted slice lies along the desired L-value
				;note that once there are no rays along the desired L the values
				;will no longer be correct. Didn't test to see why this is, but it's
				;OK, these bad values are filtered out later
				;print,'Ltest = ',ltest

				;print out the mlat values for extracted slice
				mlattst = atan(zgfinal[ptsz]/xgfinal[ptsx])/!dtor
				;print,'mlat test = ',mlattst


				;TEST CONDITION FOR CONTINUING
				;if there are some rays along the desired Lvalue then continue
				poo = where((energiesL_nh[*,bbq,h] ge 220.) and (energiesL_nh[*,bbq,h] le 985.))

				if total(poo[0] eq -1) then print,'*****NO RAYS ALONG DESIRED L*****'
				if total(poo[0] ne -1) then begin
					print,'#####RAYS ALONG DESIRED L IN CORRECT ENERGY RANGE#####'



					;calculate time for scattered e- to arrive at FB
;					alt = 500.  ;altitude of FB
					if type eq 'costream' then $
					pt = electron_precipitation_time(lval,latSM,500.,evals.E_CYCL_COSTREAM,5.,bmult=dipmult)
					if type eq 'counterstream' then $
					pt = electron_precipitation_time(lval,latSM,500.,evals.E_CYCL_COUNTERSTREAM,5.,bmult=dipmult,/opposite_hemisphere)



					tarr = 1000.*pt  ;msec
					noo = where(tarr) eq -1000.
					if noo[0] ne -1 then tarr[noo] = -1

					boox = where(xgfinal ge 4.45)
					booz = where(zgfinal ge -1.)
					print,boox[0]
					print,booz[0]
					print,'Energy of resonance = ',eres[boox[0],booz[0]]


					triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,tarr,minv=1.,maxv=300.,Lsc=[chorus_leq,FB_leq],$
					limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
					;Extract L-values at the L slice. Note that these had better be equal
					;to the value of the L slice lval_extract
					tarr_finL = lval_finL
					tarr_finL[*] = 0.
					for i=0,89 do tarr_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
					print,'L value along slice = ',tarr_finL[*,bbq]


print,'Msec it takes for e- to arrive after scattering = ',tmpvar[boox[0],booz[0]]

	;				plot_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,ray_vals=timeG*1000.,$
	;				xrangeM=[2,6],zrangeM=[-2,2],outsidecolor='fill',$
	;				minval=1,maxval=500,/psonly


	;									plot_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,ray_vals=tarr,$
	;									xrangeM=[2,6],zrangeM=[-2,2],outsidecolor='fill',$
	;									minval=1,maxval=300,/psonly




					;;Constant velocity method
					;				alt = 500.;rough altitude of FB4 (632 by 433 km orbit)
					;				dist_remaining = distance_to_atmosphere(lval,latSM,offset_alt=alt)
					;
					;		tarr = 6370.*dist_remaining/vz
					;		tarr = 1000.*tarr ;msec for better plotting
					;
					;			plot_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,ray_vals=tarr,$
					;				xrangeM=[0,6],zrangeM=[-3,3],$
					;				minval=1,maxval=100


					;	plot_rays,xcoord,ycoord,zcoord,ray_vals=tarr,$
					;		xrangeM=[0,6],zrangeM=[-3,3],$
					;		Lsc=[chorus_leq,FB_leq],minval=20,maxval=400

					;	triangulate_rays,xcoord,zcoord,longit,tarr,minv=20.,maxv=400.,Lsc=[RBSPa_leq1,RBSPa_leq2,FB_leq1,FB_leq2],$
					;		limits=limitsstatic,nlvls=50;,result=result1



					;Now add together the time it takes for chorus wave to propagate
					;to a particular point with time it would take electron scattered at
					;that point to reach FIREBIRD
					ttotal = tarr + timeg*1000.
										plot_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,ray_vals=ttotal,$
										xrangeM=[2,6],zrangeM=[-2,2],outsidecolor='nofill',$
									Lsc=[chorus_leq,FB_leq],minval=250,maxval=550,/psonly


;stop

					triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,ttotal,minv=200.,maxv=800.,$
					limits=limitsstatic,nlvls=50,result=totaltime,/noplot;/psonly;,/zbuffer,/noplot;,/zbuffer

					totaltimeL_nh[*,bbq,h] = extract_lshell_mlat_slice(lval_extract,mlatrange,xgfinal,zgfinal,totaltime)


;for yy=0,89 do print,energiesL_nh[yy,bbq,h],totaltimeL_nh[yy,bbq,h]
;stop


				endif ;no rays along L=lval_extract slice
			endfor  ;for each harmonic h



			;Test to make sure that we have some rays on L=lval_extract
			existtest = max(totaltimeL_nh[*,bbq,0],/nan) - min(totaltimeL_nh[*,bbq,0],/nan)

			if ~(finite(existtest) eq 0) then begin

				;Get ray L-values
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,lval,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
				;Extract L-values at the L slice. Note that these had better be equal
				;to the value of the L slice lval_extract
				for i=0,89 do lval_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,'L value along slice = ',lval_finL[*,bbq]

print,'Lval of scattering = ',tmpvar[boox[0],booz[0]]


				;Get ray initial L-values
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,lval0,minv=1.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
				for i=0,89 do lval0_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,'L value initial along slice = ',lval0_finL[*,bbq]

				;Get ray inital mlat values
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,latSM0,minv=0.,maxv=10.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
				for i=0,89 do mlat0_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,'mlat initial value along slice = ',mlat0_finL[*,bbq]



				;Get ray in situ mlat values
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,latSM,minv=0.,maxv=90.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
				for i=0,89 do mlat_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,'mlat in situ value along slice = ',mlat_finL[*,bbq]

				print,'mlat of scattering = ',tmpvar[boox[0],booz[0]]

				;Get ray initial theta_kb values
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,thk0,minv=1.,maxv=60.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
				for i=0,89 do thk0_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,'theta_kb initial value along slice = ',thk0_finL[*,bbq]

				;Get in situ theta_kb values
				triangulate_rays,xcoordSM,ycoordSM,zcoordSM,longitSM,thk,minv=1.,maxv=60.,Lsc=[chorus_leq,FB_leq],$
				limits=limitsstatic,nlvls=50,result=tmpvar,/noplot;,/zbuffer
				for i=0,89 do thk_finL[i,bbq] = tmpvar[ptsx[i],ptsz[i]]
				print,'theta_kb value along slice = ',thk_finL[*,bbq]

			endif  ;rays exist along L=lval_extract

;			jump1: print,'jumped here'
		endfor  ;all the rays in a single freq


		save,mlatrange,lval_extract,$
		totaltimeL_nh,energiesL_nh,$
		lval_finL,lval0_finL,thk_finL,thk0_finL,mlat_finL,$
		allLvals,type,nharmonic,freqsALL,smlat_fin,nrayss,thetav,minL,maxL,dl,$
		filename='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/raytrace_files/'+filenames[nfreq]

	endfor  ;for each freq
end
