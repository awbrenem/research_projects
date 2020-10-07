;Creates the info structure (called from rbsp_survey_driver.py) and
;saves it to an IDL save file, to be recalled at will.
;Further info is added to this structure by programs that are called later.

pro rbsp_survey_create_info_struct

  args = command_line_args()


  probe = args[0]
  dt0 = args[1]
  dt1 = args[2]
  dt = float(args[3])
  ndays = float(args[4])
  fbk_mode = args[5]
  fbk_type = args[6]
  f_fceB = args[7]
  f_fceT = args[8]
  minamp_pk = float(args[9])
  maxamp_pk = float(args[10])
  minamp_av = float(args[11])
  maxamp_av = float(args[12])
  path = args[13]
  fn_info = args[14]
  path_ephem = args[15]
  scale_fac_lim = args[16]


  f_fceB = strmid(f_fceB,1,strlen(f_fceB)-2)
  f_fceB = float(strsplit(f_fceB,',',/extract))
  f_fceT = strmid(f_fceT,1,strlen(f_fceT)-2)
  f_fceT = float(strsplit(f_fceT,',',/extract))



;static freq variables
  fbk13_binsL = [0.8,1.5,3,6,12,25,50,100,200,400,800,1600,3200]
  fbk13_binsH = [1.5,3,6,12,25,50,100,200,400,800,1600,3200,6500]
  fbk7_binsL = fbk13_binsL[lindgen(7)*2]
  fbk7_binsH = fbk13_binsH[lindgen(7)*2]

  fbk13_binsC = (fbk13_binsH + fbk13_binsL)/2.
  fbk7_binsC = (fbk7_binsH + fbk7_binsL)/2.

  fbk_freqs = {fbk13_binsL:fbk13_binsL,$
               fbk13_binsH:fbk13_binsH,$
               fbk7_binsL:fbk7_binsL,$
               fbk7_binsH:fbk7_binsH,$
               fbk13_binsC:fbk13_binsC,$
               fbk7_binsC:fbk7_binsC}


  days = strmid(time_string(time_double(dt0) + (86400*indgen(ndays)+1)),0,10)



;Create general time tags to be used for each day
  ntimes = 86400./dt	

  timesb = dt*indgen(ntimes) ;times at beginning of each bin

  info = {probe:probe,$
          d0:dt0,$
          d1:dt1,$
          ndays:ndays,$
          days:days,$
          dt:dt,$
          tag:'fbk',$
          fbk_mode:fbk_mode,$
          fbk_type:fbk_type,$
          f_fceB:f_fceB,$
          f_fceT:f_fceT,$
          minamp_pk:minamp_pk,$ ;mV/m or nT
          maxamp_pk:maxamp_pk,$		
          minamp_av:minamp_av,$
          maxamp_av:maxamp_av,$
          fbk_freqs:fbk_freqs,$
          path:path,$
          fn_info:fn_info,$
          path_ephem:path_ephem,$
          timesb:timesb,$
          scale_fac_lim:scale_fac_lim}


  save,info,filename=fn_info


  
end
