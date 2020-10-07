;Plot the raytracing results produced from crib_raytracing_scenarios

;Rays are simulated over a wide range of L, but lines are only plotted
;when there are ray values at L=5, the location of FIREBIRD FU-4 near 19:44 UT
;on Jan 20, 2016 during the chorus/uB event.
;When rays are highlighted (bold lines) that means that energies that
;can be detected in the FB channels 1 to 5 (220-985 keV max span)
;are scattered, and furthermore that they arrive at FIREBIRD with a total delta-time
;defined by maxtdiff
;Note however that the max span of 220-985 is the max range of energies.
;Channels 1-5 on FB can be lit up by e- of energies from 283-721 keV. Since
;I can't tell the exact range of e- energies, I'll require that the observations
;fall b/t 283-721 keV



;.compile /Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/IDL/gang_plot_pos.pro

rbsp_efw_init
path='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/raytrace_files/'
plot_type = 1

;fn = ['costream_1800Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1700Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1600Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1500Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1400Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1300Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1200Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1100Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl',$
;'costream_1000Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=30.idl']

;fn = ['counterstream_1800Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1700Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1600Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1500Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1400Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1300Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1200Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1100Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl',$
;'counterstream_1000Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=210.idl']

;fn = ['costream_1800Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1700Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1600Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1500Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1400Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1300Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1200Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1100Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1000Hz_harmonics=1-5_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=6.0.idl']


;fn = ['counterstream_1200Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_1100Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_1000Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_900Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_800Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_700Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_600Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl',$
;'counterstream_500Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=210_Lslice=6.0.idl']


;fn = ['costream_1200Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1100Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_1000Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_900Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_800Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_700Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_600Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl',$
;'costream_500Hz_harmonics=1-3_L=5.5-7.0_nrays=30_nsources=15_maxthetakb=30_Lslice=6.0.idl']

;fn = ['counterstream_1500Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl',$
;'counterstream_1400Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl',$
;'counterstream_1300Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl',$
;'counterstream_1200Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl',$
;'counterstream_1100Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl',$
;'counterstream_1000Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl',$
;'counterstream_900Hz_harmonics=1-3_L=5.0-7.0_nrays=30_nsources=20_maxthetakb=210_Lslice=5.5.idl']

fn = ['costream_1800Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1700Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1600Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1500Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1400Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1300Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1200Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1100Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl',$
'costream_1000Hz_harmonics=1-3_L=4.5-6.6_nrays=30_nsources=21_maxthetakb=30_Lslice=5.0.idl']

type = strmid(fn[0],0,13)
if type ne 'counterstream' then type = 'costream'


;fn = 'counterstream_1800Hz_harmonics=1-5_L=4.0-6.8_nrays=20_nsources=28_maxthetakb=180.idl'
;fn = 'counterstream_1800Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl'
;fn = ['counterstream_1800Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1700Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1600Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1500Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1400Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1300Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1200Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1100Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1000Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl']

;fn = ['counterstream_1400Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1300Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1200Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1100Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl',$
;'counterstream_1000Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl']

;fn = ['counterstream_1700Hz_harmonics=1-2_L=4.6-6.2_nrays=30_nsources=31_maxthetakb=180.idl']
;fn = ['costream_1700Hz_L=4.0-6.9_nrays=60_nsources=29_maxthetakb=30.idl']
;fn = ['counterstream_1500Hz_n=1_L=4.0-6.9_nrays=40_nsources=29_maxthetakb=180.idl']

restore,path+fn[0]

nsources = n_elements(allLvals)
nharmonics = n_elements(energiesL_nh[0,0,*])

if plot_type eq 2 then begin
	!p.multi = [0,0,n_elements(fn)]

	;	fqpos = strpos(fn[freq],'Hz')
	fn2 = 'allfreqs_'+type+'_'+$
	'harmonic='+strtrim(floor(min(nharmonic)),2)+'-'+ $
	strtrim(floor(max(nharmonic)),2)+ $
	'_L='+string(minL,format="(f3.1)")+$
	'-'+string(maxL,format="(f3.1)")+$
	'_nrays='+strtrim(floor(nrayss),2)+$
	'_nsources='+strtrim(floor(nsources),2)+$
	'_maxthetakb='+strtrim(floor(max(abs(thetav))),2)+'_Lslice='+string(lval_extract,format='(f3.1)')+'.idl'

	popen,'~/Desktop/'+fn2+'.ps'
endif




for freq=0,n_elements(fn)-1 do begin

	restore,path+fn[freq]
	;stop



	;	nsources = n_elements(allLvals)
	;	nharmonics = n_elements(energiesL_nh[0,0,*])

	;Filter based on max allowable time difference b/t arrival of 250 keV and 850 keV
	tdiff = fltarr(nsources,nharmonics)
	ediff = fltarr(nsources,nharmonics)
	maxtdiff = 50.


	;--------------------------------------------------------
	;Interpolate values to have much better energy resolution
	;--------------------------------------------------------

	;new x-axis has 10x the resolution of old one
	newxvals = float(max(mlatrange)-min(mlatrange))*indgen(10.*90)/(10.*90.-1) + min(mlatrange)

	;create interpolated arrays
	energiesLi_nh = fltarr(n_elements(newxvals),nsources,nharmonics)
	totaltimeLi_nh = fltarr(n_elements(newxvals),nsources,nharmonics)
	thk_finLi = fltarr(n_elements(newxvals),nsources,nharmonics)
	thk0_finLi = fltarr(n_elements(newxvals),nsources,nharmonics)

	;Same as above but only where the resonance energies falls b/t 250-850 keV
	allLi2 = energiesLi_nh
	energiesLi2_nh = energiesLi_nh
	totaltimeLi2_nh = energiesLi_nh
	totaltimeLi2_min_nh = energiesLi_nh  ;used for calculating delta time diff b/t 283-721 keV instead of 220-985 keV
	thk_finLi2 =  energiesLi_nh
	thk0_finLi2 = energiesLi_nh



	for bbq=0,n_elements(allLvals)-1 do allLi2[*,bbq,*] = allLvals[bbq]

	goo = where(thk_finL eq 0.)
	if goo[0] ne -1 then thk_finL[goo] = !values.f_nan
	goo = where(thk0_finL eq 0.)
	if goo[0] ne -1 then thk0_finL[goo] = !values.f_nan



	for bbq=0,nsources-1 do begin

		print,'L=',allLvals[bbq]

		for h=0,nharmonics-1 do begin


			thk_finLi[*,bbq,h] = interp(thk_finL[*,bbq],mlatrange,newxvals)
			thk0_finLi[*,bbq,h] = interp(thk0_finL[*,bbq],mlatrange,newxvals)

			goo = where(thk_finLi[*,bbq,h] eq 0.)
			if goo[0] ne -1 then thk_finLi[goo,i,h] = !values.f_nan
			goo = where(thk0_finLi[*,bbq,h] eq 0.)
			if goo[0] ne -1 then thk0_finLi[goo,i,h] = !values.f_nan

			thk_finLi2[*,bbq,h] = thk_finLi[*,bbq,h]
			thk0_finLi2[*,bbq,h] = thk0_finLi[*,bbq,h]

			;			for i=0,89 do print,energiesL_nh[i,bbq,h],totaltimeL_nh[i,bbq,h]
			;stop

			;Remove zero values
			goo = where(energiesL_nh[*,bbq,h] eq 0.)
			if goo[0] ne -1 then energiesL_nh[goo,bbq,h] = !values.f_nan
			goo = where(totaltimeL_nh[*,bbq,h] eq 0.)
			if goo[0] ne -1 then totaltimeL_nh[goo,bbq,h] = !values.f_nan

			energiesLi_nh[*,bbq,h] = interp(energiesL_nh[*,bbq,h],mlatrange,newxvals)
			totaltimeLi_nh[*,bbq,h] = interp(totaltimeL_nh[*,bbq,h],mlatrange,newxvals)


			goo = where(energiesLi_nh[*,bbq,h] eq 0.)
			if goo[0] ne -1 then energiesLi_nh[goo,i,h] = !values.f_nan
			goo = where(totaltimeLi_nh[*,bbq,h] eq 0.)
			if goo[0] ne -1 then totaltimeLi_nh[goo,i,h] = !values.f_nan


			;Subset of values with the correct resonant energy
			energiesLi2_nh[*,bbq,h] = energiesLi_nh[*,bbq,h]
			totaltimeLi2_nh[*,bbq,h] = totaltimeLi_nh[*,bbq,h]
			totaltimeLi2_min_nh[*,bbq,h] = totaltimeLi_nh[*,bbq,h]

			;;The L2 variables contain only the parts of the ray path that COUNTER-STREAMING
			;;the correct energies (250-850 keV) and correct delta-time (<=50 msec)


			;joo = where((finite(energiesLi_nh[*,bbq,h]) ne 0.) and (energiesLi_nh[*,bbq,h] ne 0.))
			;if joo[0] ne -1 then print,energiesLi_nh[joo,bbq,h] else print,'No ENERGIES***'


			;			for i=0,300 do print,energiesLi_nh[i,bbq,h],totaltimeLi_nh[i,bbq,h]

			;Remove energies outside of range
			bade = where((energiesLi_nh[*,bbq,h] lt 220.) or (energiesLi_nh[*,bbq,h] gt 985.))
			bade_min = where((energiesLi_nh[*,bbq,h] lt 283.) or (energiesLi_nh[*,bbq,h] gt 721.))
			if bade[0] ne -1 then begin
				energiesLi2_nh[bade,bbq,h] = !values.f_nan
				totaltimeLi2_nh[bade,bbq,h] = !values.f_nan
				thk_finLi2[bade,bbq,h] = !values.f_nan
				thk0_finLi2[bade,bbq,h] = !values.f_nan
			endif
			if bade_min[0] ne -1 then totaltimeLi2_min_nh[bade_min,bbq,h] = !values.f_nan



			bade = where(finite(energiesLi_nh[*,bbq,h]) eq 0.)
			if bade[0] ne -1 then begin
				energiesLi2_nh[bade,bbq,h] = !values.f_nan
				totaltimeLi2_nh[bade,bbq,h] = !values.f_nan
				totaltimeLi2_min_nh[bade,bbq,h] = !values.f_nan
				thk_finLi2[bade,bbq,h] = !values.f_nan
				thk0_finLi2[bade,bbq,h] = !values.f_nan
			endif


			;Remove spurious 0 time values. These probably show up in the interpolation
			goo = where((totaltimeLi2_nh[*,bbq,h] eq 0.) or (finite(totaltimeLi2_nh[*,bbq,h]) eq 0.))

			if goo[0] ne -1 then begin
				totaltimeLi2_nh[goo,bbq,h] = !values.f_nan
				energiesLi2_nh[goo,bbq,h] = !values.f_nan
				totaltimeLi2_nh[goo,bbq,h] = !values.f_nan
				totaltimeLi2_min_nh[goo,bbq,h] = !values.f_nan
				thk_finLi2[goo,bbq,h] = !values.f_nan
				thk0_finLi2[goo,bbq,h] = !values.f_nan
				allLi2[goo,bbq,h] = !values.f_nan
			endif
			goo = where(totaltimeLi2_min_nh[*,bbq,h] eq 0.)
			if goo[0] ne -1 then begin
				totaltimeLi2_min_nh[goo,bbq,h] = !values.f_nan
			endif


			;Remove NaN values in totaltime array


			;			for i=0,300 do print,energiesLi2_nh[i,bbq,h],totaltimeLi2_min_nh[i,bbq,h],totaltimeLi2_nh[i,bbq,h]


			;Remove all ray values if they produce a larger dt than maxtdiff
			tdiff[bbq,h] = max(totaltimeLi2_min_nh[*,bbq,h],/nan) - min(totaltimeLi2_min_nh[*,bbq,h],/nan)
			print,'tdiff=',tdiff[bbq,h]

			if tdiff[bbq,h] ge maxtdiff then begin
				energiesLi2_nh[*,bbq,h] = !values.f_nan
				totaltimeLi2_nh[*,bbq,h] = !values.f_nan
				totaltimeLi2_min_nh[*,bbq,h] = !values.f_nan
				thk_finLi2[*,bbq,h] = !values.f_nan
				thk0_finLi2[*,bbq,h] = !values.f_nan
			endif

			;Remove highlighted ray values if they don't span the entire energy range
			;This is equivalent to requiring that the energies fall in detector Channels
			;1-5 (and not 6), or the energy difference can be as small as 283-721 keV
			ediff[bbq,h] = max(energiesLi2_nh[*,bbq,h],/nan) - min(energiesLi2_nh[*,bbq,h],/nan)
			print,'ediff=',ediff[bbq,h]

			if min(energiesLi2_nh[*,bbq,h],/nan) gt 283 or max(energiesLi2_nh[*,bbq,h],/nan) lt 721 or finite(ediff[bbq,h]) eq 0 then begin
				energiesLi2_nh[*,bbq,h] = !values.f_nan
				totaltimeLi2_nh[*,bbq,h] = !values.f_nan
				totaltimeLi2_min_nh[*,bbq,h] = !values.f_nan
				thk_finLi2[*,bbq,h] = !values.f_nan
				thk0_finLi2[*,bbq,h] = !values.f_nan
			endif

			goo = where(finite(energiesLi2_nh[*,bbq,h]) eq 0)
			if goo[0] ne -1 then allLi2[goo,bbq,h] = !values.f_nan


			;Sometimes solutions show up that satisfy the energy range but have
			;a bunch of missing values in the middle. This happens b/c there are
			;missing values b/t 220 and 283 keV. I'm not sure if this is due to
			;rays crossing over other rays, or what. Doesn't happen too often.
			;For now I'll remove these.


;			if freq eq 1 and allLvals[bbq] eq 6.7 then stop

			goo = where((energiesLi2_nh[*,bbq,h] gt 220) and (energiesLi2_nh[*,bbq,h] lt 985))
			if goo[0] ne -1 then begin
				sstart = goo[0]
				sstop = goo[n_elements(goo)-1]
				etester = energiesLi2_nh[sstart:sstop,bbq,h]
				missingtst = total(etester)
				if finite(missingtst) eq 0. then begin
					print,'REMOVING SOME MISSING VALUES (NANS)'
					print,'-----------------------------------'
					print,energiesLi2_nh[sstart:sstop,bbq,h]
					print,'-----------------------------------'

					energiesLi2_nh[sstart:sstop,bbq,h] = !values.f_nan
					totaltimeLi2_nh[sstart:sstop,bbq,h] = !values.f_nan
					totaltimeLi2_min_nh[sstart:sstop,bbq,h] = !values.f_nan
					thk_finLi2[sstart:sstop,bbq,h] = !values.f_nan
					thk0_finLi2[sstart:sstop,bbq,h] = !values.f_nan
					allLi2[sstart:sstop,bbq,h] = !values.f_nan

					print,energiesLi2_nh[sstart:sstop,bbq,h]
				endif
			endif
			;print,energiesLi2_nh[goo,5,h]


			;if fn[freq] eq 'counterstream_1400Hz_harmonics=1-5_L=4.0-6.8_nrays=20_nsources=28_maxthetakb=180.idl' and alllvals[bbq] eq 4.9 then stop
			;print,energiesLi2_nh[*,bbq,h]

			;for o=0,900 do print,energiesLi2_nh[o,bbq,h],totaltimeLi2_nh[o,bbq,h]
		endfor  ;for each harmonic
	endfor  ;bbq (each source)




	;--------------------------------------------------------------------------
	;First plot type
	;--------------------------------------------------------------------------

	if plot_type eq 1 then begin

		for h=0,nharmonics-1 do begin


			colors = bytscl(indgen(nsources)-1)
			colors[nsources-1] = 254
			for i=0,nsources-1 do print,'L='+strtrim(allLvals[i],2)+' is color ' + strtrim(float(colors[i]),2)

			fqpos = strpos(fn[freq],'Hz')
			fn2 = strmid(fn[freq],0,fqpos+2)+'_harmonic='+strtrim(floor(nharmonic[h]),2)+ $
			'_L='+string(minL,format="(f3.1)")+'-'+string(maxL,format="(f3.1)")+$
			'_nrays='+strtrim(floor(nrayss),2)+'_nsources='+strtrim(floor(nsources),2)+'_maxthetakb='+strtrim(floor(max(abs(thetav))),2)+'.idl'



			popen,'~/Desktop/' + fn2


			!p.multi = [0,2,4]
			loadct,39
			!p.charsize = 1.5
			if type eq 'costream' then xmin = 0.
			if type eq 'costream' then xmax = 50.
			if type eq 'counterstream' then xmin = -40.
			if type eq 'counterstream' then xmax = 0.
			if type eq 'costream' then thmin = 0.
			if type eq 'costream' then thmax = 90.
			if type eq 'counterstream' then thmin = 90.
			if type eq 'counterstream' then thmax = 180.
			if type eq 'costream' then thminI = 0.
			if type eq 'costream' then thmaxI = 90.
			if type eq 'counterstream' then thminI = 90.
			if type eq 'counterstream' then thmaxI = 180.

			lmin = 4.5
			lmax = 7.0
			pdtmin=0   ;precip delta-time range
			pdtmax = 20





			;plot energy vs time
			;	plot,totaltimeLi[*,0]-min(totaltimeLi2[*,0],/nan),energiesLi[*,0],yrange=[0,1200],xrange=[0,100],$
			;	xtitle='relative arrival time (msec)',ytitle='costream energy (keV)',$
			;	title='ray energy vs time for L='+strtrim(lval_extract,2),/nodata
			plot,[0,0],yrange=[200,2000],xrange=[0,100],$
			xtitle='relative arrival time (msec)',ytitle=type+' energy (keV)',$
			title='ray energy vs time for L='+strtrim(lval_extract,2),/nodata,/ylog,ystyle=1,$
			position=[0.1,0.85,0.9,0.99]

			for bbq=0,nsources-1 do begin
				;Find the absolute min time over both appropriate energy ranges
				goo2 = where((energiesLi2_nh[*,bbq,h] gt 220) and (energiesLi2_nh[*,bbq,h] lt 985))
				tsubtract = min(totaltimeLi_nh[goo2,bbq,h],/nan)
				oplot,totaltimeLi_nh[*,bbq,h]-tsubtract,energiesLi_nh[*,bbq,h],color=colors[bbq];,psym=-4
				oplot,totaltimeLi_nh[*,bbq,h]-tsubtract,energiesLi2_nh[*,bbq,h],color=colors[bbq],thick=7
				oplot,[0,200],[220,220],linestyle=4,color=250
				oplot,[0,200],[283,283],linestyle=4,color=250
				oplot,[0,200],[721,721],linestyle=4,color=50
				oplot,[0,200],[985,985],linestyle=4,color=50
				oplot,[-20,-20],[0.1,10000],linestyle=5
				oplot,[-40,-40],[0.1,10000],linestyle=5
				oplot,[-60,-60],[0.1,10000],linestyle=5
				oplot,[-80,-80],[0.1,10000],linestyle=5
				oplot,[20,20],[0.1,10000],linestyle=5
				oplot,[40,40],[0.1,10000],linestyle=5
				oplot,[60,60],[0.1,10000],linestyle=5
				oplot,[80,80],[0.1,10000],linestyle=5
			endfor


			;Color scale as defined by L-value
;			ytitle='Color scale defined by!Cinitial Lshell of ray'
			plot,[0,0],yrange=[lmin,lmax],xrange=[xmin,xmax],ystyle=1,$
			/nodata,xtitle='Initial L!Cof each ray',$
			_extra=gang_plot_pos(6,1,1)
			for bbq=0,nsources-1 do oplot,[xmin,xmax],[allLvals[bbq],allLvals[bbq]],color=colors[bbq]
			for bbq=0,nsources-1 do oplot,newxvals,allLi2[*,bbq,h],color=colors[bbq],thick=7
			oplot,[-10,-10],[0,10],linestyle=5
			oplot,[-20,-20],[0,10],linestyle=5
			oplot,[-30,-30],[0,10],linestyle=5
			oplot,[-40,-40],[0,10],linestyle=5
			oplot,[10,10],[0,10],linestyle=5
			oplot,[20,20],[0,10],linestyle=5
			oplot,[30,30],[0,10],linestyle=5
			oplot,[40,40],[0,10],linestyle=5

			goo = where(totaltimeLi_nh ne 0.)
			if goo[0] ne -1 then ymin = min(totaltimeLi_nh[goo],/nan) else ymin = 0
			if goo[0] ne -1 then ymax = max(totaltimeLi_nh[goo],/nan) else ymax = 1000.

;			title='Precip time after chorus onset'
			plot,[0,0],yrange=[ymin,2000],xrange=[xmin,xmax],$
			ytitle='Precip time at FB!C(msec)',ystyle=1,/nodata,$
			_extra=gang_plot_pos(6,1,2)
			for bbq=0,nsources-1 do oplot,newxvals,totaltimeLi_nh[*,bbq,h],color=colors[bbq]
			for bbq=0,nsources-1 do oplot,newxvals,totaltimeLi2_nh[*,bbq,h],color=colors[bbq],thick=7
			oplot,[-10,-10],[0,10000],linestyle=5
			oplot,[-20,-20],[0,10000],linestyle=5
			oplot,[-30,-30],[0,10000],linestyle=5
			oplot,[-40,-40],[0,10000],linestyle=5
			oplot,[10,10],[0,10000],linestyle=5
			oplot,[20,20],[0,10000],linestyle=5
			oplot,[30,30],[0,10000],linestyle=5
			oplot,[40,40],[0,10000],linestyle=5

;			title='Precip delta time'
			plot,[0,0],yrange=[pdtmin,pdtmax],xrange=[xmin,xmax],ystyle=1,$
			ytitle='Precip delta time!Cb/t 250 and 850 keV!C at FB (msec)',/nodata,$
			_extra=gang_plot_pos(6,1,3)

			for bbq=0,nsources-1 do begin
				;Find the absolute min time over both appropriate energy ranges
				goo2 = where((energiesLi2_nh[*,bbq,h] gt 220) and (energiesLi2_nh[*,bbq,h] lt 985))
				tsubtract = min(totaltimeLi_nh[goo2,bbq,h],/nan)

				oplot,newxvals,totaltimeLi_nh[*,bbq,h]-tsubtract,color=colors[bbq]
				oplot,newxvals,totaltimeLi2_nh[*,bbq,h]-tsubtract,color=colors[bbq],thick=7
				oplot,[0,-50],[maxtdiff,maxtdiff],linestyle=2
				oplot,[-10,-10],[0,10000],linestyle=5
				oplot,[-20,-20],[0,10000],linestyle=5
				oplot,[-30,-30],[0,10000],linestyle=5
				oplot,[-40,-40],[0,10000],linestyle=5
				oplot,[10,10],[0,10000],linestyle=5
				oplot,[20,20],[0,10000],linestyle=5
				oplot,[30,30],[0,10000],linestyle=5
				oplot,[40,40],[0,10000],linestyle=5
			endfor


			;title='ray initial theta_kb'
			plot,[0,0],yrange=[thminI,thmaxI],xrange=[xmin,xmax],$
			ytitle='Inital theta_kb!Cof ray',/nodata,$
			_extra=gang_plot_pos(6,1,4)
			for bbq=0,nsources-1 do oplot,newxvals,thk0_finLi[*,bbq,h],color=colors[bbq]
			for bbq=0,nsources-1 do begin
				tst = where(finite(allLi2[*,bbq,h]) ne 0.)
				if tst[0] ne -1 then oplot,newxvals,thk0_finLi2[*,bbq,h],color=colors[bbq],thick=7
			endfor
			oplot,[-10,-10],[-180,180],linestyle=5
			oplot,[-20,-20],[-180,180],linestyle=5
			oplot,[-30,-30],[-180,180],linestyle=5
			oplot,[-40,-40],[-180,180],linestyle=5
			oplot,[10,10],[-180,180],linestyle=5
			oplot,[20,20],[-180,180],linestyle=5
			oplot,[30,30],[-180,180],linestyle=5
			oplot,[40,40],[-180,180],linestyle=5

;			title='ray in situ theta_kb'
			plot,[0,0],yrange=[thmin,thmax],xrange=[xmin,xmax],$
			xtitle='mlat',ytitle='theta_kb!Cof ray',/nodata,$
			_extra=gang_plot_pos(6,1,5)
			for bbq=0,nsources-1 do oplot,newxvals,thk_finLi[*,bbq,h],color=colors[bbq]
			for bbq=0,nsources-1 do begin
				tst = where(finite(allLi2[*,bbq,h]) ne 0.)
				if tst[0] ne -1 then oplot,newxvals,thk_finLi2[*,bbq,h],color=colors[bbq],thick=7
			endfor
			oplot,[-10,-10],[-180,180],linestyle=5
			oplot,[-20,-20],[-180,180],linestyle=5
			oplot,[-30,-30],[-180,180],linestyle=5
			oplot,[-40,-40],[-180,180],linestyle=5
			oplot,[10,10],[-180,180],linestyle=5
			oplot,[20,20],[-180,180],linestyle=5
			oplot,[30,30],[-180,180],linestyle=5
			oplot,[40,40],[-180,180],linestyle=5

			;		print,'fn = '+fn2

			pclose
		endfor ;for each harmonic

	endif ;plot_type = 1


	;--------------------------------------------------------------------------
	;Second plot type
	;--------------------------------------------------------------------------

	;colors for the various cyclotron harmonics
	hcolor = [254,75,130,160,200]

	if plot_type eq 2 then begin

		colors = bytscl(indgen(nsources)-1)
		colors[nsources-1] = 254
		for i=0,nsources-1 do print,'L='+strtrim(allLvals[i],2)+' is color ' + strtrim(float(colors[i]),2)


		loadct,39
		!p.charsize = 1.5
		if type eq 'costream' then xmin = 0.
		if type eq 'costream' then xmax = 40.
		if type eq 'counterstream' then xmin = -40.
		if type eq 'counterstream' then xmax = 0.
		if type eq 'costream' then thmin = 0.
		if type eq 'costream' then thmax = 90.
		if type eq 'counterstream' then thmin = 90.
		if type eq 'counterstream' then thmax = 180.

		lmin = 4.5
		lmax = 7.0
		pdtmin=0   ;precip delta-time range
		pdtmax = 60


		;only plot the x-axis label on last plot
		if freq eq n_elements(fn)-1 then plot,[0,0],yrange=[lmin,lmax],xrange=[xmin,xmax],$
		xtitle='mlat',ytitle='Lshell!C'+strtrim(floor(freqsall[n_elements(fn)-1-freq]),2)+' Hz',$
		title='Color scale defined by initial Lshell of ray',/nodata,$
		_extra=gang_plot_pos(n_elements(fn),1,n_elements(fn)-1-freq)

		if freq ne n_elements(fn)-1 then plot,[0,0],yrange=[lmin,lmax],xrange=[xmin,xmax],$
		/nodata,ytitle='Lshell!C'+strtrim(floor(freqsall[n_elements(fn)-1-freq]),2)+' Hz',$
		_extra=gang_plot_pos(n_elements(fn),1,n_elements(fn)-1-freq)

		for h=0,nharmonics-1 do for bbq=0,nsources-1 do oplot,newxvals,allLi2[*,bbq,h],color=hcolor[h],thick=8

		;stop


	endif ;for plot_type = 2




endfor ;for each freq


if plot_type eq 2 then pclose





end
