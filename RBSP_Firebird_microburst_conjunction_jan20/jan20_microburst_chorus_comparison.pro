;;Make plots of conjunctions between RBSP and the FIREBIRD satellites
;;sc -> RBSP 'a' or 'b'
;;fb -> FIREBIRD '3' or '4'
;;date -> '2016-01-20'

pro jan20_microburst_comparison,sc,fb,date,no_spice_load=no_spice_load

  tplot_options,'title','from jan20_microburst_chorus_comparison.pro'

  rbsp_load_efw_fbk,probe=sc,type='calibrated',/pt
  rbsp_load_efw_spec,probe=sc,type='calibrated'
  rbsp_load_efw_waveform,probe='a',datatype='vb2'

  rbsp_split_fbk,'a'


  ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk'],0,3000,0
  tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4','rbspa_efw_fbk_7_fb2_pk','rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5']


;  .compile /Users/aaronbreneman/Desktop/code/Aaron/RBSP/rbsp_efw_fbk_freq_interpolate.pro


  info = {probe:'a',fbk_mode:'7',fbk_type:'Bw'}

  t0 = time_double('2016-01-20/19:43:50')
  t1 = time_double('2016-01-20/19:44:20')
  tz = time_double('2016-01-20/19:44:00.615') ;selects the spectral bin that contains the triple peaked chorus/MB match

  v = tsample('rbspa_efw_fbk_7_fb2_pk',[t0,t1],times=tms)



  restore_ts04 = 1  ;restore the TS04 Lshell, MLT, etc quantities. These take a long time to create!!!

;;Load RBSP position in GSE
;  date = '2016-01-20'
  timespan,date

rbsp_load_spice_kernels



;;--------------------------------------------------
;;Load Firebird ASCII files
  if fb eq '3' then fname = 'FU3_LLA_LShell_ToDate_2016-01-14_2016-02-14_1min.csv'
  if fb eq '4' then fname = 'FU4_LLA_LShell_ToDate_2016-01-14_2016-02-14_1min.csv'

;  fname = 'FU3_LLA_LShell_ToDate_2015-07-01_2015-08-05_1min.csv'
;  fname = 'FU4_LLA_LShell_ToDate_2015-08-01_2015-08-31_1min.csv'

  path = '/Users/aaronbreneman/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/'

  ft = [7,4,4,4,4]
  fn = ['time','lat','lon','alt','lshell']
  fl = [0,24,31,39,50]
  fg = [0,1,2,3,4]

  template = {version:1.,$
              datastart:1L,$
              delimiter:44B,$
              missingvalue:!values.f_nan,$
              commentsymbol:'',$
              fieldcount:5,$
              fieldtypes:ft,$
              fieldnames:fn,$
              fieldlocations:fl,$
              fieldgroups:fg}

  x = read_ascii(path + fname,template=template)

  glats = x.lat
  glons = x.lon
  times = time_double(x.time)

  xgeo = (x.alt + 6370.)*cos(!dtor*glats)*sin(!dtor*glons)
  ygeo = (x.alt + 6370.)*cos(!dtor*glats)*cos(!dtor*glons)
  zgeo = (x.alt + 6370.)*sin(!dtor*glats)



  store_data,'firebird_lshell',data={x:times,y:x.lshell}
  store_data,'firebird_geo',$
             data={x:times,y:[[xgeo],[ygeo],[zgeo]]}

  cotrans,'firebird_geo','tmp',/geo2gei
  cotrans,'tmp','firebird_gse',/gei2gse
;;--------------------------------------------------
;;Load Firebird data files

  path = '/Users/aaronbreneman/Desktop/Research/OTHER/meetings/2016-Aerospace/'
  fname = 'FU_4_Hires_2016-01-20_L1_v02.txt'

  ft = replicate(4,27)
  ft[0] = 7
  fn = replicate('tmp',27)
  for i=0,26 do fn[i] = fn[i] + strtrim(i,2)
  fl = [0,27,31,35,39,43,47,51,55,59,63,67,71,75,79,83,87,91,95,99,103,107,111,115,129,143,157]
  fg = indgen(27)

  template = {version:1.,$
              datastart:108L,$
              delimiter:32B,$
              missingvalue:!values.f_nan,$
              commentsymbol:'',$
              fieldcount:27,$
              fieldtypes:ft,$
              fieldnames:fn,$
              fieldlocations:fl,$
              fieldgroups:fg}

  x = read_ascii(path + fname,template=template)



openr,lun,path+fname,/get_lun

jnk = ''
for i=0,107 do readf,lun,jnk

data = strarr(90000,27)
i=0L
while not eof(lun) do begin  $
   readf,lun,jnk   & $
   data[i,*] = strsplit(jnk,/extract)  & $
   i++


;   data = [data,jnk]

;endwhile

close,lun
free_lun,lun


times = data[*,0]
goo = where(times eq '')
v = goo[0]-1
times = times[0:v]

;;ad hoc time correction for the FB4 data on Jan 20th at ~19:40

stop
times = time_double(times)
;times = time_double(times) + 4.1



;; #    "hr0": {
;; #        "DEPEND_0": "Epoch",
;; #        "DEPEND_1": "Channel",
;; #        "DIMENSION": [6],
;; #        "ELEMENT_LABELS": ["251.5 kev", "333.5 kev", "452.0 kev", "620.5 kev", "852.8 kev", ">984 kev"],
;; #        "ELEMENT_NAMES": ["hr0_0", "hr0_1", "hr0_2", "hr0_3", "hr0_4", "hr0_5"],


store_data,'hr0_0',data={x:times,y:float(data[0:v,11])}
store_data,'hr0_1',data={x:times,y:float(data[0:v,12])}
store_data,'hr0_2',data={x:times,y:float(data[0:v,13])}
store_data,'hr0_3',data={x:times,y:float(data[0:v,14])}
store_data,'hr0_4',data={x:times,y:float(data[0:v,15])}
store_data,'hr0_5',data={x:times,y:float(data[0:v,16])}

options,'hr0_0','ytitle','hr0!C251.5 keV'
options,'hr0_1','ytitle','hr0!C333.5 keV'
options,'hr0_2','ytitle','hr0!C452 keV'
options,'hr0_3','ytitle','hr0!C620.5 keV'
options,'hr0_4','ytitle','hr0!C852.8 keV'
options,'hr0_5','ytitle','hr0!C>984 keV'


store_data,'hr0',data=['hr0_0','hr0_1','hr0_2','hr0_3']
options,'hr0','colors',[0,50,100,250]

copy_data,'hr0','hr0_v2'
ylim,'hr0_v2',1,1000,1

ylim,'rbspa_fbk1_7pk_5',0,2.5



;get rid of fuzz
rbsp_detrend,['hr0_0','hr0_1','hr0_2','hr0_3','hr0_4'],0.125/1.
;rbsp_detrend,'hr0_0_smoothed',0.05
rbsp_detrend,'hr0_?_smoothed',60./3.

tlimit,'2016-01-20/19:43:20','2016-01-20/19:44:40'
;tplot,['rbspa_fbk1_7pk_5','rbspa_fbk2_7pk_5','hr0_0','hr0_1','hr0_2','hr0_3','hr0_4'];,'hr0_5']


;rbsp_detrend,'hr0_0',5.

tplot,['rbspa_fbk2_7pk_5','hr0_1_smoothed_detrend'];,'hr0_5']





ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4'],20.,4000,1
tplot,['rbspa_efw_64_spec0','rbspa_efw_64_spec4'];,'hr0_5']

tlimit,'2016-01-20/19:43:20','2016-01-20/19:44:40'



;tplot,['rbspa_fbk2_7pk_5','hr0_0','hr0_1','hr0_2','hr0_3','hr0_4']
tlimit,'2016-01-20/19:43:52','2016-01-20/19:44:06'
tplot,['hr0_0','hr0_1','hr0_2','hr0_3','hr0_4'] + '_smoothed_detrend'


;;Search for dispersion in the microburst data



;; tmp = strsplit(data[0])

 ;; ;;Load more accurate Firebird H5 files

;; file_loaded = '20150813_firebird-fu3_T89D_MagEphem.h5'
;; ;; 20150813_firebird-fu4_T89D_MagEphem.h5
;; ;; 20150826_firebird-fu3_T89D_MagEphem.h5
;; ;; 20150827_firebird-fu3_T89D_MagEphem.h5
;; ;; 20150827_firebird-fu4_T89D_MagEphem.h5
;; ;; 20150828_firebird-fu3_T89D_MagEphem.h5
;; ;; 20150828_firebird-fu4_T89D_MagEphem.h5
;; fileroot = '/Users/aaronbreneman/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/FB_Mag_for_aaron/'


;;   unixtime = [0d]
;; l = [0.]

;; result = h5_parse(fileroot+file_loaded,/READ_DATA)

;; offset = time_double('1980-01-06/00:00:00') - time_double('1970-01-01/00:00:00')
;; gpstime = result.gpstime._data
;; unixtime = [unixtime,gpstime + offset]


;;                                 ;L*  (L-star parameter)
;; l = [l,transpose(result.l._data)]






;;--------------------------------------------------



;Calculate MLT
  get_data,'firebird_gse',data=pos_gse_fb
  angle_tmp = atan(pos_gse_fb.y[*,1],pos_gse_fb.y[*,0])/!dtor
  goo = where(angle_tmp lt 0.)
  if goo[0] ne -1 then angle_tmp[goo] = 360. - abs(angle_tmp[goo])
  angle_rad = angle_tmp * 12/180. + 12.
  goo = where(angle_rad ge 24.)
  if goo[0] ne -1 then angle_rad[goo] = angle_rad[goo] - 24
  store_data,'firebird_mlt',data={x:times,y:angle_rad}


;Calculate MLAT
  cotrans,'firebird_gse','firebird_gsm',/gse2gsm
  cotrans,'firebird_gsm','firebird_sm',/gsm2sm
  get_data,'firebird_sm',data=posfb_sm
  posfb_sm_mag = sqrt(posfb_sm.y[*,0]^2 + posfb_sm.y[*,1]^2 + posfb_sm.y[*,2]^2)


  rad_a = sqrt(pos_gse_fb.y[*,0]^2 + pos_gse_fb.y[*,1]^2 + pos_gse_fb.y[*,2]^2)/6370.
  store_data,'firebird_radius',data={x:pos_gse_fb.x,y:rad_a}


  dr2a = sqrt(posfb_sm.y[*,0]^2 + posfb_sm.y[*,1]^2)
  dz2a = posfb_sm.y[*,2]
  mlat_a = atan(dz2a,dr2a)

  store_data,'firebird_mlat',data={x:posfb_sm.x,y:mlat_a/!dtor}


;calculate Lshell and compare to what's in file

  Lshell_a = rad_a/(cos(mlat_a)^2) ;L-shell in centered dipole
  store_data,'firebird_lshell2',data={x:posfb_sm.x,y:lshell_a}

  ylim,['firebird_lshell','firebird_lshell2'],0,20
  tplot,['firebird_lshell','firebird_lshell2']


;;--------------------------------------------------
;;Load RBSP data
;;--------------------------------------------------

;;load accurate TSY04 model position. Set start time to just before
;;the solar wind pressure structure arrives that onsets the storm

;; if ~keyword_set(restore_ts04) then begin
;;    map_with_t04,'2016-01-19/19:00',4,'a'

;;    rbspa_state_pos_gsm
;;    rbsp_cotrans,'rbsp'+sc+'_state_pos_gsm','rbsp'+sc+'_state_pos_gse',/gsm2gse
;;    copy_data,'rbspa_state_pos_gse','rbspa_state_pos_gse_tsy'

;;    fnsave = ['RBSP'+sc+'!CL-shell-t04',$
;;              'RBSP'+sc+'!Cnorth-foot-ILAT!Ct04',$
;;              'RBSP'+sc+'!Cnorth-foot-MLT!Ct04',$
;;              'rbsp'+sc+'_out_iono_foot_north_gse',$
;;              'rbsp'+sc+'_out_iono_foot_north_gei',$
;;              'rbsp'+sc+'_out_iono_foot_north_geo',$
;;              'rbsp'+sc+'_out_iono_foot_north_glat_glon',$
;;              'RBSP'+sc+'!Csouth-foot-ILAT!Ct04',$
;;              'RBSP'+sc+'!Csouth-foot-MLT!Ct04',$
;;              'rbsp'+sc+'_out_iono_foot_south_gse',$
;;              'rbsp'+sc+'_out_iono_foot_south_gei',$
;;              'rbsp'+sc+'_out_iono_foot_south_geo',$
;;              'rbsp'+sc+'_out_iono_foot_south_glat_glon']

;; ;Save and restore specific files
;;    fileroot = '~/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/tplot/'
;;    tplot_save,fnsave,filename=fileroot+'ts04_vars_jan19-23' ;don't add .tplot

;;    endif else tplot_restore,filenames=fileroot+'ts04_vars_jan19-23.tplot'







;;--------------------

;Load Tsyganenko 04 model Lshell
;  rbsp_read_ect_mag_ephem,'a',type='TS04D'

;; ;;------------------------------
;; ;;For dates with no definitive spice use this
;; rbsp_read_ect_mag_ephem,sc,type='T89Q',/pre
;; copy_data,'rbsp'+sc+'_ME_pos_gse','rbsp'+sc+'_state_pos_gse'
;; copy_data,'rbsp'+sc+'_ME_pos_gsm','rbsp'+sc+'_state_pos_gsm'

;; stop
;; ;;------------------------------

;Load state data
  rbsp_load_spice_state,probe=sc,coord='gse',/no_spice_load






;Calculate MLT
  get_data,'rbsp'+sc+'_state_pos_gse',data=pos_gse
  angle_tmp = atan(pos_gse.y[*,1],pos_gse.y[*,0])/!dtor
  goo = where(angle_tmp lt 0.)
  if goo[0] ne -1 then angle_tmp[goo] = 360. - abs(angle_tmp[goo])
  angle_rad = angle_tmp * 12/180. + 12.
  goo = where(angle_rad ge 24.)
  if goo[0] ne -1 then angle_rad[goo] = angle_rad[goo] - 24
  store_data,'rbsp'+sc+'_mlt',data={x:pos_gse.x,y:angle_rad}


;Calculate MLAT
  cotrans,'rbsp'+sc+'_state_pos_gse','rbsp'+sc+'_state_pos_gsm',/gse2gsm
  cotrans,'rbsp'+sc+'_state_pos_gsm','rbsp'+sc+'_state_pos_sm',/gsm2sm
  get_data,'rbsp'+sc+'_state_pos_sm',data=pos_sm
  pos_sm_mag = sqrt(pos_sm.y[*,0]^2 + pos_sm.y[*,1]^2 + pos_sm.y[*,2]^2)

  dr2a = sqrt(pos_sm.y[*,0]^2 + pos_sm.y[*,1]^2)
  dz2a = pos_sm.y[*,2]
  mlat_a = atan(dz2a,dr2a)
  store_data,'rbsp'+sc+'_mlat',data={x:pos_sm.x,y:mlat_a/!dtor}



;calculate dipole Lshell
  get_data,'rbsp'+sc+'_state_pos_gse',data=pos_gse
  rad_a = sqrt(pos_gse.y[*,0]^2 + pos_gse.y[*,1]^2 + pos_gse.y[*,2]^2)/6370.
  store_data,'rbsp'+sc+'_state_radius',data={x:pos_gse.x,y:rad_a}

  Lshell_a = rad_a/(cos(!dtor*mlat_a)^2) ;L-shell in centered dipole
  store_data,'rbsp'+sc+'_lshell',data={x:pos_sm.x,y:lshell_a}


;;compare Tsy Lshell with dipole Lshell
dif_data,'RBSPa!CL-shell-t04','rbsp'+sc+'_lshell'
tplot,['RBSPa!CL-shell-t04-rbsp'+sc+'_lshell']


;;--------------------------------------------------
;;Calculate separations b/t RBSP and FIREBIRD
;;--------------------------------------------------

  ;; dif_data,'rbsp'+sc+'_mlt','firebird_mlt'
  ;; dif_data,'rbsp'+sc+'_ME_lshell','firebird_lshell'

  ;;Use the higher firebird cadence for differencing
  dif_data,'firebird_mlt','rbsp'+sc+'_mlt'
  get_data,'firebird_mlt-rbsp'+sc+'_mlt',data=dd
  store_data,'rbsp'+sc+'_mlt-firebird_mlt',data={x:dd.x,y:-1*dd.y}

  dif_data,'firebird_lshell','rbsp'+sc+'_lshell'
  get_data,'firebird_lshell-rbsp'+sc+'_lshell',data=dd
  store_data,'rbsp'+sc+'_lshell-firebird_lshell',data={x:dd.x,y:-1*dd.y}


;;Find absolute separation b/t payloads

  dif_data,'rbsp'+sc+'_state_pos_gse','firebird_gse',newname='gse_diff'
  get_data,'gse_diff',data=pos_diff
  store_data,'gse_diff',/delete

  dx = pos_diff.y[*,0]/1000.
  dy = pos_diff.y[*,1]/1000.
  dz = pos_diff.y[*,2]/1000.

  sc_sep = sqrt(dx^2 + dy^2 + dz^2)

  store_data,'sc_sep',data={x:pos_diff.x,y:sc_sep}
  options,'sc_sep','labflag',0
  options,'sc_sep','ytitle','SC GSE!Cabsolute!Cseparation!C[x1000 km]'

  store_data,'gse_sep',data={x:pos_diff.x,y:[[dx],[dy],[dz]]}
  options,'gse_sep','labels',['dx gse','dy gse','dz gse']
  options,'gse_sep','ytitle','SC GSE!Cseparation!C[x1000 km]'

  store_data,'mltzero',data={x:pos_diff.x,y:replicate(0.,n_elements(pos_diff.x))}
  store_data,'lshellzero',data={x:pos_diff.x,y:replicate(0.,n_elements(pos_diff.x))}
  options,['mltzero','lshellzero'],'linestyle',2
  store_data,'lshellcomb',data=['rbsp'+sc+'_lshell','firebird_lshell']
  store_data,'mltcomb',data=['rbsp'+sc+'_mlt','firebird_mlt']
  store_data,'mltcompare',data=['rbsp'+sc+'_mlt-firebird_mlt','mltzero']
  store_data,'lshellcompare',data=['rbsp'+sc+'_lshell-firebird_lshell','lshellzero']


  options,'lshellcomb','colors',[0,250]
  options,'mltcomb','colors',[0,250]
  options,'mltcompare','colors',[0,50]
  options,'lshellcompare','colors',[0,50]

  options,'mltcompare','ytitle','deltaMLT!CRBSP'+sc+'-FIREBIRD'+fb
  options,'lshellcompare','ytitle','deltaLSHELL!CRBSP'+sc+'-FIREBIRD'+fb
  options,'lshellcomb','ytitle','Lshell!CRBSP'+sc+' and!CFIREBIRD'+fb
  options,'mltcomb','ytitle','MLT!CRBSP'+sc+' and!CFIREBIRD'+fb

  ylim,'lshellcomb',0,10
  ylim,'mltcomb',0,24
  ylim,'mltcompare',-10,10
  ylim,'lshellcompare',-10,10


  store_data,'mlatcomb',data=['rbsp'+sc+'_mlat','firebird_mlat']
  options,'mlatcomb','colors',[0,250]
  options,'mlatcomb','ytitle','mlat!CRBSP'+sc+' and!CFIREBIRD'+fb

  tplot_options,'title','From rbsp_firebird_conjunctions.pro'
  tplot,['lshellcomb','mltcomb',$
         'sc_sep',$
         'mltcompare','lshellcompare']


  outname = 'firebird'+fb+'_RBSP'+sc+'_'+strmid(date,0,4)+strmid(date,5,2)+strmid(date,8,2)+$
            '_conjunction.ps'
  popen,'~/Desktop/Research/OTHER/Stuff_for_other_people/Crew_Alex/FIREBIRD_RBSP_campaign/'+outname
  !p.charsize = 0.8
  tplot
  pclose








;;Load FBK data on RBSP
  rbsp_load_efw_fbk,probe=sc,type='calibrated',/pt
  rbsp_load_efw_spec,probe=sc,type='calibrated'
  rbsp_split_fbk,sc,/combine,meansz=500,ysc=3.,verbose=5



  options,'*shell*','panel_size',0.5
  options,'*mlt*','panel_size',0.5
  options,'*mlat*','panel_size',0.5


  ylim,'rbsp'+sc+'_fbk2_7pk_?',0,0
  ylim,'rbsp'+sc+'_efw_64_spec0',100,10000,1
  tplot,['mlatcomb','lshellcomb','mltcomb',$
;         'sc_sep',$
         'mltcompare','lshellcompare',$
         'rbsp'+sc+'_efw_64_spec0',$
;         'rbsp'+sc+'_efw_64_spec4',$
;         'rbsp'+sc+'_fbk2_7pk_2',$
;         'rbsp'+sc+'_fbk2_7pk_3',$
;         'rbsp'+sc+'_fbk2_7pk_4',$
         'rbsp'+sc+'_fbk2_7pk_5',$
         'rbsp'+sc+'_fbk2_7pk_6']


  ylim,'rbsp'+sc+'_fbk1_7pk_?',0,2
  ylim,'rbsp'+sc+'_efw_64_spec4',50,1000,1

  tplot,['firebird_mlat','lshellcomb','mltcomb',$
         'sc_sep',$
         'mltcompare','lshellcompare',$
         'rbsp'+sc+'_efw_64_spec4',$
         'rbsp'+sc+'_fbk1_7pk_2',$
         'rbsp'+sc+'_fbk1_7pk_3',$
         'rbsp'+sc+'_fbk1_7pk_4',$
         'rbsp'+sc+'_fbk1_7pk_5',$
         'rbsp'+sc+'_fbk1_7pk_6']




  ylim,'rbsp'+sc+'_fbk2_7pk_?',0,0,0
  ylim,'rbsp'+sc+'_fbk2_7pk_1',0,50
  tplot_options,'thick',1

  tplot,['firebird_mlat','lshellcomb','mltcomb',$
         'mltcompare','lshellcompare',$
         'rbsp'+sc+'_efw_64_spec4',$
         'rbsp'+sc+'_fbk2_7pk_1',$
         'rbsp'+sc+'_fbk2_7pk_2',$
         'rbsp'+sc+'_fbk2_7pk_3',$
         'rbsp'+sc+'_fbk2_7pk_4']




  tplot,['mlatcomb','lshellcomb','mltcomb',$
         ;'sc_sep',$
         'mltcompare','lshellcompare',$
         'rbsp'+sc+'_efw_64_spec0',$
         'rbsp'+sc+'_efw_64_spec4']
;         'rbsp'+sc+'_efw_64_spec4',$
;         'rbsp'+sc+'_fbk2_7pk_2',$
;         'rbsp'+sc+'_fbk2_7pk_3',$
;         'rbsp'+sc+'_fbk2_7pk_4',$
;         'rbsp'+sc+'_fbk1_7pk_5',$
;         'rbsp'+sc+'_fbk1_7pk_4',$
;         'rbsp'+sc+'_fbk1_7pk_3',$
;         'rbsp'+sc+'_fbk1_7pk_2',$
;         'rbsp'+sc+'_fbk2_7pk_5',$
;         'rbsp'+sc+'_fbk2_7pk_4',$
;         'rbsp'+sc+'_fbk2_7pk_3',$
;         'rbsp'+sc+'_fbk2_7pk_2']



  tplot,['rbsp'+sc+'_efw_64_spec0',$
;         'rbsp'+sc+'_fbk2_7pk_2',$
;         'rbsp'+sc+'_fbk2_7pk_3',$
         'rbsp'+sc+'_fbk1_7pk_6',$
         'rbsp'+sc+'_fbk1_7pk_5',$
;         'rbsp'+sc+'_fbk1_7pk_4',$
         'rbsp'+sc+'_efw_64_spec4',$
         'rbsp'+sc+'_fbk2_7pk_6',$
         'rbsp'+sc+'_fbk2_7pk_5',$
         'rbsp'+sc+'_fbk2_7pk_4']

;         'rbsp'+sc+'_fbk1_7pk_4',$
;         'rbsp'+sc+'_fbk1_7pk_3',$
;         'rbsp'+sc+'_fbk1_7pk_2',$
;         'rbsp'+sc+'_fbk2_7pk_5',$
;         'rbsp'+sc+'_fbk2_7pk_4',$
;         'rbsp'+sc+'_fbk2_7pk_3',$
;         'rbsp'+sc+'_fbk2_7pk_2']

stop
end




;;   if ~keyword_set(model) then model = 't04'

;; ;;--------------------------------------------------
;; ;;Call the specific model
;; ;;--------------------------------------------------

;;   ;;Call the models without any solar wind input. Later, we'll
;;   ;;also call them with model input from OMNI, Wind, ACE
;;   ;; if model eq 't89' then call_procedure,'t'+model,posname,kp=2.0,period=0.5
;;   ;; if model eq 't96' then call_procedure,'t'+model,posname,pdyn=2.0D,dsti=-30.0D,$
;;   ;;                                       yimf=0.0D,zimf=-5.0D,period=0.5
;;   if model eq 't04' then call_procedure,'t'+model,posname,pdyn=2.0D,dsti=-30.0D,$
;;                                         yimf=0.0D,zimf=-5.0D,period=0.5

;;   ;;Vsw of 400 km/s and By=0, Bz=-5 nT (general default values from Tsyganenko02b)



;;   ;;The t01 model requires a time history of solar wind values.
;;   if model eq 't01' then begin
;;      timespan,x2[0],(x2[1] - x2[0]),/seconds

;;      g1 = 6.
;;      g2 = 10.
;;      if model eq 't01' then call_procedure,'t'+model,posname,pdyn=2.0D,dsti=-30.0D,$
;;                                            yimf=0.0D,zimf=-5.0D,g1=g1,g2=g2,period=0.5

;;      ;;return timespan to original
;;      timespan,x[0],(x[1]-x[0]),/seconds
;;      time_clip,'pos_gsm_bt01',x[0],x[1],/replace ;newname='POS_GSM_tclip'

;;   endif
