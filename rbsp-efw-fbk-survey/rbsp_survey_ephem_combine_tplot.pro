
;Read the combined ephemeris ascii file for a particular FBK
;survey run, save as tplot variables


;Written by Aaron Breneman




pro rbsp_survey_ephem_combine_tplot

  args = command_line_args()  
  path = args[0]
  probe = args[1]

  rbsp_efw_init

  rbspx = 'rbsp' + probe


  fn = ['time','bo','beq','lstar','lshell','lshell_dipole','mlat','radius','mlt','mlt_dipole',$
        'gsmx','gsmy','gsmz','gsex','gsey','gsez','smx','smy','smz',$
        'ae','dst',$
        'spinaxisx','spinaxisy','spinaxisz']
  fl = [0,14,22,30,37,44,50,58,65,73,80,89,98,104,113,121,128,137,144,152,158,164,172,180]
  ft = [3,3,3,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,4,4,4]	

  t = {version:1.,$
       datastart:0L,$
       delimiter:32B,$
       missingvalue:!values.f_nan,$
       commentsymbol:'',$
       fieldcount:24L,$
       fieldtypes:ft,$
       fieldnames:fn,$
       fieldlocations:fl,$
       fieldgroups:indgen(24)}

  d = read_ascii(path + 'ephem_RBSP'+strlowcase(probe)+'_combined.txt',template=t)
  
  times = d.time

  store_data,rbspx+'_fce_ect',data={x:times,y:28.*d.bo}
  store_data,rbspx+'_fce_eq_ect',data={x:times,y:28.*d.beq}
  store_data,rbspx+'_mlt_ect',data={x:times,y:d.mlt}
  store_data,rbspx+'_mlt',data={x:times,y:d.mlt_dipole}
  store_data,rbspx+'_lstar_ect',data={x:times,y:d.lstar}
  store_data,rbspx+'_lshell_ect',data={x:times,y:d.lshell}
  store_data,rbspx+'_lshell',data={x:times,y:d.lshell_dipole}
  store_data,rbspx+'_mlat',data={x:times,y:d.mlat}
  store_data,rbspx+'_radius',data={x:times,y:d.radius}
  store_data,rbspx+'_ae',data={x:times,y:d.ae}
  store_data,rbspx+'_dst',data={x:times,y:d.dst}
  store_data,rbspx+'_pos_gsm',data={x:times,y:[[d.gsmx],[d.gsmy],[d.gsmz]]}
  store_data,rbspx+'_pos_gse',data={x:times,y:[[d.gsex],[d.gsey],[d.gsez]]}
  store_data,rbspx+'_pos_sm',data={x:times,y:[[d.smx],[d.smy],[d.smz]]}
  store_data,rbspx+'_spinaxis_gse',data={x:times,y:[[d.spinaxisx],[d.spinaxisy],[d.spinaxisz]]}




                                ;Create the tplot variable that shows the precession of the orbit in MLT
  get_data,rbspx+'_mlt_ect',data=mlt
  get_data,rbspx+'_radius',data=rad

  goo = where(rad.y ge 5.5)
  mltgood = mlt.y[goo]
  store_data,rbspx+'_mlt_apogee',data={x:mlt.x[goo],y:mltgood}
  options,rbspx+'_mlt_apogee','psym',4
  
  



  options,rbspx+'_'+['fce_ect','fce_eq_ect','mlt_ect','mlt','lstar_ect','lshell_ect','lshell','mlat','radius',$
                     'ae','dst','pos_gsm','pos_gse','pos_sm','spinaxis_gse','_mlt_apogee'],'labels',rbspx


  tplot_save,'*',filename=path + 'ephem_RBSP'+probe

end

