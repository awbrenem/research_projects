;Reads the ASCII file outputted by the Python routine
;survey_combine_ascii within FBK_survey.py
;Creates tplot variables of the data from the "combined" ascii file
;To plot these values see rbsp_survey_fbk_crib


;Aaron Breneman
;2013-01-12


pro rbsp_survey_fbk_combine_tplot ;,info


  args = command_line_args()
  probe = args[0]
  path = args[1]
  filename = args[2]
  dt = args[3]
  optstr = args[4]

;; ;##### for testing
;; optstr = 'fbk00100'
;; filename = 'fbk13_RBSPa_'+optstr+'_Ew_combined.txt'

;; path = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/runtest_tmp2/'
;; probe = 'a'
;; dt = 60.
;; ;#################


  goo = strpos(filename,'combined')
  fn2 = strmid(filename,0,goo-1)

  rbspx = 'rbsp' + probe
;  rbsp_survey_set_filename,info,/norename



  if optstr ne 'fbk_ephem2' then begin
     ;; fn = ['timesc','npk','nav','pk','av','fce','fce_eq','Bx_gse','By_gse','Bz_gse','sax','say','saz']
     fn = ['timesc','npk','nav','pk','av']
     
     fl = [0,20,30,40,50]
     ft = replicate(4,5)
     ft[0] = 3
     
     t = {version:1.,$
          datastart:0L,$
          delimiter:32B,$
          missingvalue:!values.f_nan,$
          commentsymbol:'',$
          fieldcount:5L,$
          fieldtypes:ft,$
          fieldnames:fn,$
          fieldlocations:fl,$
          fieldgroups:indgen(5)}

  endif else begin
     fn = ['timesc','fce','fce_eq','Bx_gse','By_gse','Bz_gse','sax','say','saz']
     
     fl = [0,18,28,40,49,60,68,76,84]
     ft = [3,4,4,4,4,4,4,4,4]
     
     t = {version:1.,$
          datastart:0L,$
          delimiter:32B,$
          missingvalue:!values.f_nan,$
          commentsymbol:'',$
          fieldcount:9L,$
          fieldtypes:ft,$
          fieldnames:fn,$
          fieldlocations:fl,$
          fieldgroups:indgen(9)}
  endelse
  
  d = read_ascii(path + filename,template=t)


  print,'NAME OF FILE = ' + path + filename
  

  ;; store_data,rbspx+'_nfbk_pk',data={x:d.timesc,y:d.npk}
  ;; store_data,rbspx+'_nfbk_av',data={x:d.timesc,y:d.nav}
  ;; store_data,rbspx+'_fbk_pk',data={x:d.timesc,y:d.pk}
  ;; store_data,rbspx+'_fbk_av',data={x:d.timesc,y:d.av}


  if optstr ne 'fbk_ephem2' then begin
     optstr2 = strmid(optstr,3)

     store_data,rbspx+'_nfbk_pk'+optstr2,data={x:d.timesc,y:d.npk}
     store_data,rbspx+'_nfbk_av'+optstr2,data={x:d.timesc,y:d.nav}
     store_data,rbspx+'_fbk_pk'+optstr2,data={x:d.timesc,y:d.pk}
     store_data,rbspx+'_fbk_av'+optstr2,data={x:d.timesc,y:d.av}
     
     options,rbspx+'_nfbk_pk'+optstr2,'ytitle','number of FBK pk values!Cabove threshold each !C'+$
             strtrim(floor(float(dt)),2)+' !Csec'
     options,rbspx+'_nfbk_av'+optstr2,'ytitle','number of FBK av values!Cabove threshold each !C'+$
             strtrim(floor(float(dt)),2)+' !Csec'
     options,rbspx+'_fbk_pk'+optstr2,'ytitle','max pk value!Cabove threshold each !C'+$
             strtrim(floor(float(dt)),2)+' !Csec'
     options,rbspx+'_fbk_av'+optstr2,'ytitle','max av value!Cabove threshold each !C'+$
             strtrim(floor(float(dt)),2)+' !Csec'
     
     options,rbspx+'_'+['nfbk_pk','nfbk_av','fbk_pk','fbk_av']+optstr2,'labels',rbspx

  endif else begin

     store_data,rbspx+'_fce',data={x:d.timesc,y:d.fce}
     store_data,rbspx+'_fce_eq',data={x:d.timesc,y:d.fce_eq}
     store_data,rbspx+'_Bgse',data={x:d.timesc,y:[[d.Bx_gse],[d.By_gse],[d.Bz_gse]]}
     store_data,rbspx+'_spinaxis_gse',data={x:d.timesc,y:[[d.sax],[d.say],[d.saz]]}
     
     
  
     
     ;;--------------------------------------------------  
     ;;Create the tplot variable that is the angle b/t the spin axis and Bo  
     get_data,rbspx+'_Bgse',data=Bgse
     get_data,rbspx+'_fce',data=fce
     get_data,rbspx+'_spinaxis_gse',data=sa
     
     bmag = sqrt(Bgse.y[*,0]^2 + Bgse.y[*,1]^2 + Bgse.y[*,2]^2) 
     
     
     
     samag = sqrt(sa.y[*,0]^2 + sa.y[*,1]^2 + sa.y[*,2]^2)
     angle = fltarr(n_elements(Bgse.x))
     for q=0L,n_elements(Bgse.x)-1 do angle[q] = acos(total(Bgse.y[q]*sa.y[q])/bmag[q]/samag[q])/!dtor
     store_data,rbspx + '_angle_bo_sa',data={x:Bgse.x,y:angle}
     

  endelse
 
  tplot_save,'*',filename=path + fn2
  
end

