;Called from rbsp_survey_driver.py

;Get positional data for survey quantities
;Saves data in an ASCII file
;Note, must call one of the data read ASCII routines first (like rbsp_survey_fbk_read_ascii.pro)
;These programs populate the info structure with the appropriate times.


;Created by Aaron Breneman
;2013-01-12




pro rbsp_survey_create_ephem_ascii


  testing = 0


  if ~keyword_set(testing) then begin
     args = command_line_args()

     fn = args[0]
     currdate = args[1]
  endif else begin


;*****************
;***TESTING
     ;; fn = '~/Desktop/code/Aaron/RBSP/survey_programs/runtest_l=5.5_mlt=0..12/info.idl'
;     fn = '~/Desktop/code/Aaron/RBSP/survey_programs/runtest_l=2-5_mlt=5/info.idl'
;     currdate = '2013-01-03'
;***************
  endelse

  restore,fn                    ;restore the info structure

  rbsp_efw_init

  rbspx = 'rbsp' + info.probe
  currdate2 = strmid(currdate,0,4)+strmid(currdate,5,2)+strmid(currdate,8,2)

  timespan,currdate
  rbsp_load_spice_kernels

                                ;------------------------------
                                ;load all data
                                ;------------------------------

                                ;load state data
  rbsp_efw_position_velocity_crib,/noplot,/no_spice_load


                                ;load ECT definitive ephem data
;  rbsp_load_mageis_l2,probe=info.probe,/get_mag_ephem
  rbsp_read_ect_mag_ephem,info.probe



                                ;Get density and mag-model from L2 combo files
  rbsp_load_efw_waveform_l2_combo,probe=info.probe



                                ;Load the AE and DST indices
  kyoto_load_dst                ;,trange=['2012-01-01','2013-01-01']
  kyoto_load_ae



  timesc = time_double(currdate) + info.timesb + info.dt/2. ;center times for each bin

                                ;---------------------------------------
                                ;Interpolate all values to new times
                                ;---------------------------------------

  tinterpol_mxn,rbspx+'_state_pos_gsm',timesc,newname=rbspx+'_state_pos_gsm'
  tinterpol_mxn,rbspx+'_state_pos_gse',timesc,newname=rbspx+'_state_pos_gse'
  tinterpol_mxn,rbspx+'_state_pos_sm',timesc,newname=rbspx+'_state_pos_sm'
  tinterpol_mxn,rbspx+'_state_mlat',timesc,newname=rbspx+'_state_mlat'
  tinterpol_mxn,rbspx+'_state_lshell',timesc,newname=rbspx+'_state_lshell'
  tinterpol_mxn,rbspx+'_state_radius',timesc,newname=rbspx+'_state_radius'
  tinterpol_mxn,rbspx+'_state_mlt',timesc,newname=rbspx+'_state_mlt'
  tinterpol_mxn,rbspx+'_spinaxis_direction_gse',timesc,newname=rbspx+'_spinaxis_direction_gse'

  ;; tinterpol_mxn,rbspx+'_ect_mageis_L2_B_Eq',timesc,newname=rbspx+'_ect_mageis_L2_B_Eq'
  ;; tinterpol_mxn,rbspx+'_ect_mageis_L2_L_star',timesc,newname=rbspx+'_ect_mageis_L2_L_star'
  ;; tinterpol_mxn,rbspx+'_ect_mageis_L2_L',timesc,newname=rbspx+'_ect_mageis_L2_L'
  ;; tinterpol_mxn,rbspx+'_ect_mageis_L2_MLT',timesc,newname=rbspx+'_ect_mageis_L2_MLT'
  tinterpol_mxn,rbspx+'_ME_bmag',timesc,newname=rbspx+'_ect_mageis_L2_B'
  tinterpol_mxn,rbspx+'_ME_lstar',timesc,newname=rbspx+'_ect_mageis_L2_L_star'
  tinterpol_mxn,rbspx+'_ME_lshell',timesc,newname=rbspx+'_ect_mageis_L2_L'
  tinterpol_mxn,rbspx+'_ME_mlt_centereddipole',timesc,newname=rbspx+'_ect_mageis_L2_MLT'

  tinterpol_mxn,rbspx+'_efw_combo_density',timesc,newname=rbspx+'_efw_combo_density'
  tinterpol_mxn,rbspx+'_efw_combo_mag_minus_model_mgse',timesc,newname=rbspx+'_efw_combo_mag_minus_model_mgse'
  tinterpol_mxn,rbspx+'_efw_combo_magnitude_minus_modelmagnitude',timesc,newname=rbspx+'_efw_combo_magnitude_minus_modelmagnitude'


                                ;extrapolate magnetic field magnitude to magnetic equator
  get_data,rbspx+'_state_mlat',data=mlat
  get_data,rbspx+'_ect_mageis_L2_B',data=Bo

  Bo_eq = Bo.y*cos(2*mlat.y*!dtor)^3/sqrt(1+3*sin(mlat.y*!dtor)^2)
  store_data,rbspx+'_ect_mageis_L2_B_Eq',data={x:Bo.x,y:Bo_eq}





;; copy_data,rbspx+'_ect_mageis_L2_B_Eq',rbspx+'_ect_mageis_L2_B_Eq2'
;; dif_data,rbspx+'_ect_mageis_L2_B_Eq',rbspx+'_ect_mageis_L2_B_Eq2'
;; tplot,[rbspx+'_ect_mageis_L2_B_Eq',rbspx+'_ect_mageis_L2_B_Eq2']



  get_data,'kyoto_ae',data=ae
  get_data,'kyoto_dst',data=dst
  if is_struct(ae) then tinterpol_mxn,'kyoto_ae',timesc,newname='kyoto_ae'
  if is_struct(dst) then tinterpol_mxn,'kyoto_dst',timesc,newname='kyoto_dst'


  get_data,'kyoto_ae',data=ae
  get_data,'kyoto_dst',data=dst
  get_data,rbspx+'_state_pos_gsm',data=pos_gsm
  get_data,rbspx+'_state_pos_gse',data=pos_gse
  get_data,rbspx+'_state_pos_sm',data=pos_sm
  get_data,rbspx+'_state_mlat',data=mlat
  get_data,rbspx+'_state_mlt',data=mlt_dipole
  get_data,rbspx+'_state_lshell',data=lshell_dipole
  get_data,rbspx+'_state_radius',data=radius
  get_data,rbspx+'_spinaxis_direction_gse',data=spinaxis

  get_data,rbspx+'_ect_mageis_L2_B_Eq',data=Beq
  get_data,rbspx+'_ect_mageis_L2_L_star',data=lstar
  get_data,rbspx+'_ect_mageis_L2_L',data=lshell
  get_data,rbspx+'_ect_mageis_L2_MLT',data=mlt

  get_data,rbspx+'_efw_combo_density',data=dens
  get_data,rbspx+'_efw_combo_mag_minus_model_mgse',data=mmm
  get_data,rbspx+'_efw_combo_magnitude_minus_modelmagnitude',data=mmmm


  lstar = {x:lstar.x,y:lstar.y[*,0]}


  ;;Sometimes the ECT definitive ephem files don't contain any data in the "B_Calc"
  ;;slot. Here I'll determine it by backstepping the B_Eq values.
  if is_struct(Beq) and is_struct(mlat) then begin
     Bo = Beq.y * sqrt(1+3*sin(mlat.y*!dtor)^2)/cos(2*mlat.y*!dtor)^3
     ;Bo = {x:timesc,y:Bo}
  endif else Bo = replicate(!values.f_nan,n_elements(timesc))



  ;; store_data,'Bo_test',data=Bo
  ;; tplot,[rbspx+'_ect_mageis_L2_B','Bo_test']
  ;; store_data,'Bcomb',data=[rbspx+'_ect_mageis_L2_B','Bo_test']




  if keyword_set(testing) then begin

     ;;****************************
     ;; runname = 'runtest_l=4_mlt=0..12'

     ;; ;;special test run
     ;; info.path = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/'+runname+'/'
     ;; info.FN_INFO = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/'+runname+'/info.idl'
     ;; info.PATH_EPHEM = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/ephem_'+runname+'/'

stop

     ;; fce = 5000.  ;Hz
     ;; beq.y = fce/28.
     ;; lshell.y[*] = 5.5
     ;; lshell_dipole.y[*] = 5.5
     ;; radius.y[*] = 5.5

     ;; mlt.y = 12d*indgen(1440)/1439.
     ;; mlt_dipole.y = mlt.y
     ;; mlat.y[*] = 0.

     fce = 5000.  ;Hz
     beq.y = fce/28.
     lshell.y[*] = (7-2)*indgen(1440)/1439. + 2.
     lshell_dipole.y[*] = lshell.y
     radius.y[*] = lshell.y

     mlt.y[*] = 5.
     mlt_dipole.y[*] = 5.
     mlat.y[*] = 0.

     ;;****************************

  endif






                                ;Fill with NaN values if data don't exist
  if ~is_struct(ae) then ae = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(dst) then dst = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(dens) then dens = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(mmm) then mmm = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc),3)}
  if ~is_struct(mmmm) then mmmm = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}

  if ~is_struct(beq) then beq = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(lstar) then lstar = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(lshell) then lshell = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(mlt) then mlt = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}

  if ~is_struct(pos_gsm) then pos_gsm = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc),3)}
  if ~is_struct(pos_gse) then pos_gse = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc),3)}
  if ~is_struct(pos_sm) then pos_sm = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc),3)}
  if ~is_struct(mlat) then mlat = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(mlt_dipole) then mlt_dipole = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(lshell_dipole) then lshell_dipole = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(radius) then radius = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc))}
  if ~is_struct(spinaxis) then spinaxis = {x:timesc,y:replicate(!values.f_nan,n_elements(timesc),3)}

  ephname = 'ephem_RBSP'+info.probe+'_'+currdate2+'.txt'


;  openw,lun,info.path + info.filename_ephem,/get_lun,/append
  openw,lun,info.path_ephem + ephname,/get_lun
  for zz=0L,n_elements(timesc)-1 do printf,lun,$
                                           format='(I10,2x,I6,2x,I6,2x,F5.1,2x,F5.1,2x,F5.1,2x,F5.1,2x,F5.1,2x,F6.1,2x,F6.1,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I4,2x,I4,2x,F6.3,2x,F6.3,2x,F6.3,2x,I8,2x,I8)',$
                                           timesc[zz],$
                                           bo[zz],beq.y[zz],lstar.y[zz],lshell.y[zz],lshell_dipole.y[zz],$
                                           mlat.y[zz],radius.y[zz],mlt.y[zz],mlt_dipole.y[zz],$
                                           pos_gsm.y[zz,0],pos_gsm.y[zz,1],pos_gsm.y[zz,2],$
                                           pos_gse.y[zz,0],pos_gse.y[zz,1],pos_gse.y[zz,2],$
                                           pos_sm.y[zz,0],pos_sm.y[zz,1],pos_sm.y[zz,2],$
                                           ae.y[zz],dst.y[zz],$
                                           spinaxis.y[zz,0],spinaxis.y[zz,1],spinaxis.y[zz,2],$
                                           dens.y[zz],mmmm.y[zz]
  close,lun
  free_lun,lun


;; ;; 		;****FOR TESTING THE FORMATTING CODES****

;; 		;; times, I10
;; 		;; lshell, f5.1
;; 		;; mlat, f5.1
;; 		;; radius, f5.1
;; 		;; mlt, f6.1
;; 		;; pos, I6
;; 		;; fce, I7
;; 		;; ae, I4
;; 		;; dst, I4
;; 		;; spinaxis, f6.3

;; 		print,timesc[zz],lshell.y[zz],mlat.y[zz],radius.y[zz],mlt.y[zz],pos_gsm.y[zz,0],pos_gsm.y[zz,1],pos_gsm.y[zz,2],pos_gse.y[zz,0],pos_gse.y[zz,1],pos_gse.y[zz,2],pos_sm.y[zz,0],pos_sm.y[zz,1],pos_sm.y[zz,2],ae.y[zz],dst.y[zz],spinaxis.y[zz,0],spinaxis.y[zz,1],spinaxis.y[zz,2],$
;; 			format='(I10,2x,F5.1,2x,F5.1,2x,F5.1,2x,F6.1,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I6,2x,I4,2x,I4,2x,F6.3,2x,F6.3,2x,F6.3)'
;; ;; 		;*******************





;  rbsp_survey_set_filename,info,/ephem



end
