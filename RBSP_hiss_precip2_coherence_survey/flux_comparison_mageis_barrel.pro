;Crib sheet to compare fluxes on MagEIS and BARREL on Jan 10, 11, 2014.

;NOTE: I couldn't figure out how to use SPEDAS to load THEMIS energy/PA pads.
;so, I contacted Xiaojia Zheng for help with the data.




timespan,'2014-01-11',1,/days


;--------------------------------------------------------------
;Use particles/ESA/thm_crib_esa_dist2scpot.pro
;...some relevant lines of code are:
;----NOTE: can get the energy spectra averaged over all PA, but not
;----------the PA-resolved spectra
thm_load_esa_pkt, probe='a'
thm_part_moments, probe='a', inst=['peer','peir'], sc_pot_name='tha_esa_pot_def', suffix = '_def'
thm_part_moments, probe='a', inst=['peer','peir'], sc_pot_name='tha_esa_pot_dist2scpot', suffix = '_dist2scpot'
tplot, ['tha_peer_density_def', 'tha_peer_density_dist2scpot']

;--------------------------------------------------------------




;--------------------------------------------------------------
;Get THEMIS A ESA energy flux (eV).
;----NOTE: can get the energy spectra averaged over all PA, but not
;----------the PA-resolved spectra
thm_part_dist2tplot,probe='a',datatype='peef'
tplot,['tha_peef_en_eflux','tha_peef_en_counts']
;--------------------------------------------------------------




;-------------------------------------------
;Get THEMIS A PADs by running thm_sst_crib
;----NOTE: these are integrated over all energies


tplot,['tha_psif_ang','tha_psef_ang']
tlimit,'2014-01-11/22:00','2014-01-11/23:30'
get_data,'tha_psef_ang',data=d

yv = tsample('tha_psef_ang',time_double('2014-01-11/22:30'),times=tms)
plot,d.v,yv


;-------------------------------------------

;Try running Lynn's code
;---NOTE: I can't figure out how to get the VELOCITY data added to the dat
;structure. This is required by Lynn's program themis_esa_pad.pro



;[see get_th?_pe%$.pro, ? = a-f, % = i,e, $ = b,f,r]
timespan,'2014-01-11'
thm_load_esa_pkt, probe='a',/get_support_data

thm_load_esa,PROBE='a',DATAT=' pee?_velocity_dsl pei?_velocity_dsl ',LEVEL=2


time = time_double('2014-01-11/22:00')
dat = get_tha_peif(time)


FUNCTION themis_esa_pad,dat,MAGF=magf,ESTEPS=esteps,BINS=bins,NUM_PA=num_pa,$
                            NUM_EN_OUT=num_en_out


;I need to add the velocity to the data structure:
;Try   wind_3dp_cribs/themis_esa_correct_bulk_flow_crib.txt

r = themis_esa_pad(dat)




;--------------------------------------------------------------------
;TRY USING thm_esa_slice2d.pro to get distribution functions
;----NOTE: this just produces a PAD plot...not sure how to get the data
;--------------------------------------------------------------------


pro thm_esa_slice2d,sc,typ,current_time,timeinterval,species=species,rotation = rotation,$
    angle = angle,ThirdDirlim = ThirdDirlim,filetype = filetype,outputfile = outputfile,thebdata = thebdata,$
    finished = finished,xrange = xrange,range = range,erange = erange,units = units,nozlog = nozlog,$
    position = position,nofill = nofill,nlines = nlines,noolines = noolines,numolines = numolines,$
    removezero = removezero,showdata = showdata,vel=vel,nogrid=nogrid,nosmooth=nosmooth,nosun = nosun,$
    novelline = novelline,subtract = subtract,resolution = resolution,rmbins = rmbins,theta = theta,phi = phi,$
    nr = nr,noiselevel = noiselevel,bottom = bottom,sr = sr,rs = rs,rm2=rm2,nlow = nlow,m = m,vel2 = vel2,$
    phb = phb,filename = filename,_EXTRA = e


    pro thm_load_fgm, probe = probe, datatype = datatype, trange = trange, $
                      level = level, verbose = verbose, downloadonly = downloadonly, $
                      relpathnames_all = relpathnames_all, no_download = no_download, $

thm_load_fgm,probe='a'

typ = 'f'
current_time = time_double('2014-01-11/18:50')
timeinterval = 10.
thebdata = 'tha_fge'

thm_esa_slice2d,'a',typ,current_time,timeinterval,species='ele',rotation='BV',thebdata=thebdata


;+
;Procedure:	thm_esa_slice2d
;
;Purpose:	creates a 2-D slice of the 3-D ESA ion or electron distribution function.
;
;Call:		thm_esa_slice2d,sc,typ,current_time,timeinterval,[keywords]

;Keywords:	SPECIES: 'ion' or 'ele'
;           ROTATION: suggesting the x and y axis, which can be specified as the followings:
;             'BV': the x axis is V_para (to the magnetic field) and the bulk velocity is in the x-y plane. (DEFAULT)
;             'BE': the x axis is V_para (to the magnetic field) and the VxB direction is in the x-y plane.
;             'xy': the x axis is V_x and the y axis is V_y.
;             'xz': the x axis is V_x and the y axis is V_z.
;             'yz': the x axis is V_y and the y axis is V_z.
;             'perp': the x-y plane is perpendicular to the B field, while the x axis is the velocity projection on the plane.
;             'perp_xy': the x-y plane is perpendicular to the B field, while the x axis is the x projection on the plane.
;             'perp_xz': the x-y plane is perpendicular to the B field, while the x axis is the x projection on the plane.
;             'perp_yz': the x-y plane is perpendicular to the B field, while the x axis is the y projection on the plane.
;           ANGLE: the lower and upper angle limits of the slice selected to plot (DEFAULT [-20,20]).
;           THIRDDIRLIM: the velocity limits of the slice. Once activated, the ANGLE keyword would be invalid..
;           FILETYPE: 'png' or 'ps'. (DEFAULT 'png')
;           OUTPUTFILE: the name of the output file.
;			THEBDATA: specifies magnetic data to use.
;			FINISHED: makes the output publication quality when using ps (NOT WORKING WELL).
;			XRANGE: vector specifying the xrange
;			RANGE: vector specifying the color range
;			ERANGE: specifies the energy range to be used
;			UNITS: specifies the units ('eflux','df',etc.) (Def. is 'df')
;			NOZLOG: specifies a linear Z axis
;			POSITION: positions the plot using a 4-vector
;			NOFILL: doesn't fill the contour plot with colors
;			NLINES: says how many lines to use if using NOFILL (DEFAULT 60, MAX 60)
;			NOOLINES: suppresses the black contour lines
;			NUMOLINES: how many black contour lines (DEFAULT 20, MAX 60)
;           REMOVEZERO: removes the data with zero counts for plotting
;			SHOWDATA: plots all the data points over the contour
;			VEL: tplot variable containing the velocity data
;			     (default is calculated with v_3d)
;			NOGRID: forces no triangulation
;			NOSMOOTH: suppresses smoothing (IF NOT SET, DEFAULT IS SMOOTH)
;			NOSUN: suppresses the sun direction line
;			NOVELLINE: suppresses the velocity line
;           SUBTRACT: subtract the bulk velocity before plot
;			RESOLUTION: resolution of the mesh (DEFAULT 51)
;			RMBINS: removes the sun noise by cutting out certain bins
;			THETA: specifies the theta range for RMBINS (def 20)
;			PHI: specifies the phi range for RMBINS (def 40)
;			NR: removes background noise from ph using noise_remove
;			NOISELEVEL: background level in eflux
;			BOTTOM: level to set as min eflux for background. def. is 0.
;			SR, RS, RM2: removes the sun noise using subtraction
;				REQUIRES write_ph.doc to run
;			NLOW: used with rm2.  Sets bottom of eflux noise level
;				def. 1e4
;			M: marks the tplot at the current time
;			VEL2: takes a 3-vector velocity and puts it on the plot
;CREATED BY:		Arjun Raj
;EXAMPLES:  see the crib file: themis_cut_crib.pro
;REMARKS:		when calling with phb and rm2, use file='write_phb.doc'
;			also, set the noiselevel to 1e5.  This gives the best
;			results
;
;LAST EDITED BY XUZHI ZHOU 4-24-2008
;-




;--------------------------------------------------------------------









































themis_load_all_inst.pro


themis_load_all_inst,DATE='110114',PROBE='a',/LOAD_EESA_DF

.compile /Users/aaronbreneman/Desktop/code/Lynn/IDL/spec_code-3.8.0/IDL_stuff/themis_pros/themis_clean_cal_efi.pro
.compile /Users/aaronbreneman/Desktop/code/Lynn/IDL/spec_code-3.8.0/IDL_stuff/themis_pros/thm_calculate_poynting_flux.pro
.compile /Users/aaronbreneman/Desktop/code/Lynn/IDL/spec_code-3.8.0/IDL_stuff/themis_pros/themis_load_all_inst.pro
.compile /Users/aaronbreneman/Desktop/code/Lynn/IDL/spec_code-3.8.0/IDL_stuff/themis_pros/wrapper_thm_load_efiscm.pro

LOAD_EFI=loadefi,LOAD_SCM=loadscm,        $
                         TRAN_FAC=tran_fac,TCLIP_FIELDS=tclip_fs,SE_T_EFI_OUT=se_tefi,   $
                         SE_T_SCM_OUT=se_tscm,LOAD_EESA_DF=loadeesa,EESA_DF_OUT=eesa_out,$
                         LOAD_IESA_DF=loadiesa,IESA_DF_OUT=iesa_out,                     $
                         ESA_BF_TYPE=esa_df_type,NO_EXTRA=no_extra,NO_SPEC=no_spec,      $
                         DIRECT_CROSS=direct,POYNT_FLUX=poynt_flux,TRANGE=trange


;r = thm_part_dist('tha_peef','2014-01-11/22:00',type='peer',probe='a')





;-------------------------------------------













;BARREL 2X flux levels on Jan 10 from Leslie's fits.

;Peak flux is at 40 keV
Peakval = 2.5   ;e-/s-keV-cm^2

;1/e of 2.5 e-/s-keV-cm^2 is 0.9. This corresponds to an energy of 75 keV
;So, the BARREL fit is
fluxE = 2.5*exp(-E/75.)

;flux at 50 keV:
flux50 = 2.5*exp(-50./75.)   ;=1.3 e-/s-keV-cm^2
