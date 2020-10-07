;Reads the "combined" ASCII file of the amplitude distribution data outputted by rbsp_survey_fbk_create_ascii.pro
;Creates tplot variables of the data
;To plot these values see rbsp_survey_fbk_crib

;type -> set to select which type of ampdist file to read. Options are:
;			'avg'
;			'avg4s'
;			'ratio'
;			'ratio4s'
;Defaults to read the peak values

;This has taken the place of rbsp_survey_fbk_combine_tplot_freqdist.pro


;Aaron Breneman
;2013-11-13

pro rbsp_survey_fbk_combine_tplot_ampfreqdist

  args = command_line_args()

  fn_info = args[0]
  probe = args[1]
  path = args[2]
  filename = args[3]
  dt = args[4]
  bins = args[5]
  optstr = args[6]
  fbk_type = args[7]

  restore,fn_info

  bins = strmid(bins,1,strlen(bins)-2)
  bins = float(strsplit(bins,',',/extract))


;; ;; ;##### for testing

  ;; filename = 'fbk13_RBSPa_ampdist_pk0910_Ew_combined.txt'

  ;; path = '/Users/aaronbreneman/Desktop/code/Aaron/RBSP/survey_programs/runtest_tmp/'
  ;; probe = 'a'
  ;; dt = 60.
  ;; optstr = 'ampdist_pk0910'

  ;; bins = 10*[0.0125000,0.0176567,    0.0249408,    0.0352298,    0.0497634,    0.0702927,    0.0992910,     0.140252,     0.198112,     0.279840,     0.395285,     0.558355,     0.788697,      1.11406,      1.57366,      2.22285,      3.13986,      4.43517,      6.26484,      8.84933,      12.5000,      17.6567,      24.9408,      35.2298,      49.7634]

  ;; fbk_type = 'Ew'
  ;; restore,path + 'info.idl'
;; ;#################



  if fbk_type eq 'Ew' then units = 'mV/m' else units = 'nT'

  goo = strpos(filename,'combined')
  fn2 = strmid(filename,0,goo-1)


  rbspx = 'rbsp' + probe

  ;;----------------------------------------------------------------
  ;;Read in the data
  ;;----------------------------------------------------------------
  
  ft = replicate(3,n_elements(bins)+1)
  fl = [0,19,24,29,34,39,44,49,54,59,64,69,74,79,84,89,94,99,104,109,114,119,124,129,134,139]
  fn = 'f' + strtrim(indgen(n_elements(bins)+1),2)
  fn[0] = 'times'
  fg = indgen(n_elements(bins)+1)
  fc = n_elements(bins)+1


  x = {version:1.,$
       datastart:1L,$
       delimiter:32B,$
       missingvalue:!values.f_nan,$
       commentsymbol:'',$
       fieldcount:n_elements(bins)+1,$
       fieldtypes:ft,$
       fieldnames:fn,$
       fieldlocations:fl,$
       fieldgroups:fg}


;Dummy read to get file size
  str = read_ascii(path + filename[0],template=x)
  filelength = n_elements(str.times)

;  data = replicate(0,[filelength, 25, 10])
  binsS = strtrim(string(bins,format='(f20.2)'),2)


  
  str = read_ascii(path + filename,template=x)
  
  
  data = [[str.f1],[str.f2],[str.f3],[str.f4],[str.f5],[str.f6],[str.f7],[str.f8],[str.f9],$
          [str.f10],[str.f11],[str.f12],[str.f13],[str.f14],[str.f15],[str.f16],[str.f17],$
          [str.f18],[str.f19],[str.f20],[str.f21],[str.f22],[str.f23],[str.f24],[str.f25]]
  

  ;;----------------------------------------------------------------
  ;;Store all of the amplitude counts in one tplot variable
  ;;----------------------------------------------------------------

  fnames = 'counts'


  store_data,rbspx+'_amp_'+optstr+'_'+fnames,data={x:str.times,y:data,v:bins}
  options,rbspx+'_amp_'+optstr+'_'+fnames,'ytitle','Counts_'+optstr+'!C'+units


;Add the various amplitude and frequency bins to the info structure
  if strmid(optstr,0,10) eq 'ampdist_pk' then str_element,info,'amp_bins_pk',bins,/add_replace
  if strmid(optstr,0,11) eq 'ampdist_avg' then str_element,info,'amp_bins_avg',bins,/add_replace
  if strmid(optstr,0,15) eq 'ampdist_avg4sec' then str_element,info,'amp_bins_avg4s',bins,/add_replace
  if strmid(optstr,0,4) eq 'freq' then str_element,info,'freq_bins',bins,/add_replace
  if strmid(optstr,0,5) eq 'ratio' then str_element,info,'amp_bins_ratio',bins,/add_replace
  if strmid(optstr,0,9) eq 'ratio4sec' then str_element,info,'amp_bins_ratio4s',bins,/add_replace



  print,'SAVING HERE: ' + path + fn2
  tplot_save,'*',filename=path + fn2
  save,info,filename=fn_info

end
