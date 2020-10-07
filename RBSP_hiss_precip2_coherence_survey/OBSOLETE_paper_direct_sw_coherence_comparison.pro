
  tplot_options,'xmargin',[20.,16.]
  tplot_options,'ymargin',[3,9]
  tplot_options,'xticklen',0.08
  tplot_options,'yticklen',0.02
  tplot_options,'xthick',2
  tplot_options,'ythick',2
  tplot_options,'labflag',-1	
 

tplot_options,'title','from direct_sw_coherence_comparison.pro'

;; Choose event

;;--------------------------------------------------
;; date = '2014-01-07'
;; payloads = ['K','L']
;; combo = 'KL'
;; pre = '2'
;; ndays = 1
;;--------------------------------------------------
date = '2014-01-08'  ;;event on the 9th is at beginning of day, so I need to load 8th too in order to time-shift the data
payloads = ['K','X']
;; payloads = ['I','K','L','T','W','X']
combo = 'KX'
p1 = 'K'
p2 = 'X'
pre = '2'
ndays = 2
;;--------------------------------------------------
;; date = '2014-02-09'  ;;event on the 9th is at beginning of day, so I need to load 8th too in order to time-shift the data
;; payloads = ['E','P']
;; combo = 'EP'
;; pre = '2'
;; ndays = 2
;;--------------------------------------------------
;; date = '2014-01-07'  ;;event on the 9th is at beginning of day, so I need to load 8th too in order to time-shift the data
;; payloads = ['T','W']
;; combo = 'TW'
;; pre = '2'
;; ndays = 2
;;--------------------------------------------------
;; date = '2014-02-09'
;; payloads = ['E','P']
;; combo = 'EP'
;; pre = '2'
;; ndays = 2




timespan,date,ndays,/days
fspc = 1
noplot = 1

combo = strupcase(combo)
fspc = floor(float(fspc))


if fspc then fspcS = 'FSPC1a' else fspcS = 'PeakDet'


rbsp_load_barrel_lc,pre+payloads,type='ephm'
rbsp_load_barrel_lc,pre+payloads,type='fspc'
rbsp_load_barrel_lc,pre+payloads,type='rcnt'
rbsp_load_barrel_lc,pre+payloads,type='mspc'
rbsp_load_barrel_lc,pre+payloads,type='sspc'



;  Load the data from the barrel_missionwide text files
;  Turn this into tplot variables here
fspcS = 'fspc'
path = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide/'
path2 = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/barrel_missionwide_plots/'


  template = {VERSION:1,$
              DATASTART:2L,$
              DELIMITER:32B,$
              MISSINGVALUE:!values.f_nan,$
              COMMENTSYMBOL:'',$
              FIELDCOUNT:5L,$
              FIELDTYPES:[5,7,4,4,4],$
              FIELDNAMES:['unix','qual','fspc','lshell','mlt'],$
              FIELDLOCATIONS:[1,18,27,37,43],$
              FIELDGROUPS:[0,1,2,3,4]}

plds = ['i','t','w','k','l','x']

;; for i=0,n_elements(plds)-1 do begin  $
;;    fni = 'barrel_'+pre+plds[i]+'_'+fspcS+'_fullmission.txt' & $
;;    data1 = read_ascii(path+fni,template=template)  & $
;;    store_data,fspcS + '_' + pre+plds[i],data={x:data1.unix,y:data1.fspc}


for i=0,n_elements(plds)-1 do rbsp_load_barrel_lc,pre+plds[i],type='fspc'
rbsp_detrend,'*FSPC1a*',60.*0.4


lvals = fltarr(n_elements(plds))
mlts = fltarr(n_elements(plds))

for i=0,n_elements(plds)-1 do rbsp_load_barrel_lc,pre+plds[i],type='ephm'
for i=0,n_elements(plds)-1 do lvals[i] = tsample('L_Kp2_2'+plds[i],time_double('2014-01-08/21:35'))
for i=0,n_elements(plds)-1 do mlts[i] = tsample('MLT_Kp2_2'+plds[i],time_double('2014-01-08/21:35'))


tplot,'L_Kp2_2?'
tplot,'MLT_Kp2_2?'



;;precip due to pressure pulse observed on K,L,X but not I,T,W
tplot,'*FSPC1a_2?_smoothed'   



rbsp_detrend,'fspcs_'+pre+plds,60.*1
tplot,'fspc_'+pre+plds+'_smoothed'



fn1 = 'barrel_'+pre+p1+'_'+fspcS+'_fullmission.txt'
fn2 = 'barrel_'+pre+p2+'_'+fspcS+'_fullmission.txt'



  data1 = read_ascii(path+fn1,template=template)
  data2 = read_ascii(path+fn2,template=template)


  store_data,fspcS + '_' + pre+p1,data={x:data1.unix,y:data1.fspc}
  store_data,fspcS + '_' + pre+p2,data={x:data2.unix,y:data2.fspc}

  v1 = fspcS + '_'+pre+p1
  v2 = fspcS + '_'+pre+p2






dif_data,'L_Kp2_2'+payloads[0],'L_Kp2_2'+payloads[1],newname='delta_lshell'
dif_data,'MLT_Kp2_2'+payloads[0],'MLT_Kp2_2'+payloads[1],newname='delta_mlt'

get_data,'delta_lshell',data=goo
store_data,'delta_lshell',data={x:goo.x,y:abs(goo.y)}
get_data,'delta_mlt',data=goo
store_data,'delta_mlt',data={x:goo.x,y:abs(goo.y)}

ylim,'delta_lshell',0,10,0
ylim,'delta_mlt',0,24
ylim,'lshell?',0,10
ylim,'mlt?',0,24

store_data,'lshellboth',data=['lshell1','lshell2','delta_lshell']
store_data,'mltboth',data=['mlt1','mlt2','delta_mlt']
options,'lshellboth','colors',[0,50,250]
options,'mltboth','colors',[0,50,250]
ylim,'lshellboth',0,10
ylim,'mltboth',0,24



;; v1 = fspcS + '_'+pre+payloads[0]
;; v2 = fspcS + '_'+pre+payloads[1]


;;Reduce these to a single "coherence storm" event
rbsp_detrend,[v1,v2],60.*0.4


v1 = v1 + '_smoothed'
v2 = v2 + '_smoothed'



get_data,v1,data=v1v
get_data,v2,data=v2v

;Find T1 and T2 based on common times in tplot variables v1 and v2
;; T1 = data1.unix[0] > data2.unix[0]
;; T2 = data1.unix[n_elements(data1.unix)-1] < data2.unix[n_elements(data2.unix)-1]
T1 = v1v.x > v2v.x
T2 = v1v.x[n_elements(v1v.x)-1] < v2v.x[n_elements(v2v.x)-1]

timespan,T1,(T2-T1),/seconds






;;Restore distance from plasmapause files
  fileroot = '~/Desktop/code/Aaron/RBSP/efw_barrel_coherence_analysis/distance_from_pp_files/'
  tplot_restore,filenames=fileroot+'2K'+'.tplot' ;need .tplot
  tplot_restore,filenames=fileroot+'2X'+'.tplot' ;need .tplot
  tplot_restore,filenames=fileroot+'2L'+'.tplot' ;need .tplot
  tplot_restore,filenames=fileroot+'2W'+'.tplot' ;need .tplot
  ylim,'dist_pp_2?_bin*',-2,2
  options,'dist_pp_2?_bin*','colors',50
  options,'dist_pp_2?_bin*','thick',2

  store_data,'FSPC1_all_2K',data=['FSPC1a_2K_smoothed',$
             'FSPC1b_2K_smoothed',$
             'FSPC1c_2K_smoothed']
  store_data,'FSPC1_all_2X',data=['FSPC1a_2X_smoothed',$
             'FSPC1b_2X_smoothed',$
             'FSPC1c_2X_smoothed']
  store_data,'FSPC1_all_2L',data=['FSPC1a_2L_smoothed',$
             'FSPC1b_2L_smoothed',$
             'FSPC1c_2L_smoothed']
  store_data,'FSPC1_all_2W',data=['FSPC1a_2W_smoothed',$
             'FSPC1b_2W_smoothed',$
             'FSPC1c_2W_smoothed']

options,['FSPC1_all_2K','FSPC1_all_2X','FSPC1_all_2L','FSPC1_all_2W'],'colors',[0,50,250]
options,'dist_pp_2?_bin_0.5','panel_size',0.5
ylim,'FSPC1_all_2L',0,50

;; tplot,['FSPC1_all_2K','dist_pp_2K','dist_pp_2K_bin_0.5',$
;;       'FSPC1_all_2X','dist_pp_2X','dist_pp_2X_bin_0.5',$
;;       'FSPC1_all_2W','dist_pp_2W','dist_pp_2W_bin_0.5',$
;;       'FSPC1_all_2L','dist_pp_2L','dist_pp_2L_bin_0.5']
tplot,['FSPC1_all_2K','dist_pp_2K_bin_0.5',$
      'FSPC1_all_2X','dist_pp_2X_bin_0.5',$
      'FSPC1_all_2W','dist_pp_2W_bin_0.5',$
      'FSPC1_all_2L','dist_pp_2L_bin_0.5']


;;--------------------------------------------------
;;Load THEMIS A, D and E data showing the hiss
;;--------------------------------------------------


;thm_load_efi,probe=['a','e'],datatype='vaf'
cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/the_l2_efi_20140108_v01.cdf'
cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/tha_l2_efi_20140108_v01.cdf'


thm_load_fft,probe=['a','e','d']
thm_load_fbk,probe=['a','e','d']


get_data,'tha_fb2',data=fb

options,['*tha_fb*','*the_fb*'],'spec',1
tplot,'the_fb_edc12'
get_data,'the_fb_edc12',data=fb
print,fb.v

;      2689.00      572.000      144.200      36.2000      9.05000      2.26000
store_data,'the_e12dc_hiss',data={x:fb.x,y:reform(fb.y[*,2])}
tplot,'the_e12dc_hiss'



get_data,'the_state_pos',data=thepos
get_data,'the_state_pos',data=thepos

get_data,'rbspa_state_lshell',data=la
get_data,'rbspb_state_lshell',data=lb
get_data,'rbspa_state_mlt',data=ma
get_data,'rbspb_state_mlt',data=mb

la = 0.
lb = 0.
ma = 0.
mb = 0.
tms = time_double('2014-01-08/'+['21:35','21:55','22:15','22:35','22:55','23:15','23:35'])
for i=0,n_elements(tms)-1 do la = [la,tsample('rbspa_state_lshell',tms[i],times=t)]
for i=0,n_elements(tms)-1 do lb = [lb,tsample('rbspb_state_lshell',tms[i],times=t)]
for i=0,n_elements(tms)-1 do ma = [ma,tsample('rbspa_state_mlt',tms[i],times=t)]
for i=0,n_elements(tms)-1 do mb = [mb,tsample('rbspb_state_mlt',tms[i],times=t)]
la = la[1:n_elements(tms)]
lb = lb[1:n_elements(tms)]
ma = ma[1:n_elements(tms)]
mb = mb[1:n_elements(tms)]

mte = [14.68,14.76,14.83,14.91,15.,15.05,15.11]
lse = [9.8,10,10.2,10.4,10.6,10.7,10.8]

lx = 0.
lk = 0.
ll = 0.

mx = 0.
mk = 0.
ml = 0.
for i=0,n_elements(tms)-1 do lx = [lx,tsample('L_Kp2_2x',tms[i],times=t)]
for i=0,n_elements(tms)-1 do lk = [lk,tsample('L_Kp2_2k',tms[i],times=t)]
for i=0,n_elements(tms)-1 do ll = [ll,tsample('L_Kp2_2l',tms[i],times=t)]
for i=0,n_elements(tms)-1 do mx = [mx,tsample('MLT_Kp2_2x',tms[i],times=t)]
for i=0,n_elements(tms)-1 do mk = [mk,tsample('MLT_Kp2_2k',tms[i],times=t)]
for i=0,n_elements(tms)-1 do ml = [ml,tsample('MLT_Kp2_2l',tms[i],times=t)]
mx = mx[1:n_elements(tms)]
mk = mk[1:n_elements(tms)]
ml = ml[1:n_elements(tms)]
lx = lx[1:n_elements(tms)]
lk = lk[1:n_elements(tms)]
ll = ll[1:n_elements(tms)]



;;Load RBSP density

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/RBSP/'
cdf2tplot,path+'rbspa_efw-l3_20140108_v01.cdf'

rbsp_efw_density_fit_from_uh_line,'Vavg','a',newname='rbspa_dens'


;;--------------------------------------------------
;;Load RBSP HOPE and MagEIS data
;;--------------------------------------------------

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/RBSP/HOPE/'
cdf2tplot,path+'rbspa_rel03_ect-mageis-L3_20140108_v7.2.0.cdf'
copy_data,'FEDU','rbspa_mageis_FEDU'

cdf2tplot,path+'rbspa_rel03_ect-hope-PA-L3_20140108_v6.0.0.cdf'
copy_data,'FEDO','rbspa_hope_FEDO'
copy_data,'FODU','rbspa_hope_FODU'

cdf2tplot,path+'rbspa_rel03_ect-hope-MOM-L3_20140108_v6.0.0.cdf'
copy_data,'Dens_e_200','rbspa_hope_dens_e_200'
copy_data,'Tperp_Tpar_e_30','rbspa_hope_Tperp_Tpar_e_30'

options,'rbspa_hope_FEDO','spec',0
ylim,'rbspa_hope_FEDO',1d4,1d6,1
get_data,'rbspa_hope_FEDO',data=d
print,d.v[0,*]
store_data,'rbspa_hope_tmp',data={x:d.x,y:d.y[*,20]}
rbsp_detrend,'rbspa_hope_tmp',60.*20.

tplot,'rbspa_hope_tmp_detrend'



;;Create unidirectional MagEIS flux
vals = fltarr(n_elements(dd.y[*,0,0]),n_elements(dd.y[0,0,*]))
for i=0,n_elements(dd.x)-1 do for j=0,10 do vals[i,j] = total(dd.y[i,*,j],/nan)
store_data,'rbspa_mageis_FEDU_energy',data={x:dd.x,y:vals,v:reform(dd.v1)}
ylim,'rbspa_mageis_FEDU_energy',1d3,1d6,1
tplot,'rbspa_mageis_FEDU_energy'
split_vec,'rbspa_mageis_FEDU_energy'
options,'rbspa_mageis_FEDU_energy','spec',1
ylim,'rbspa_mageis_FEDU_energy',30,200,1
zlim,'rbspa_mageis_FEDU_energy',1d3,1d6,1


rbsp_detrend,'rbspa_mageis_FEDU_energy_*',60.*0.4
rbsp_detrend,'rbspa_mageis_FEDU_energy_*_smoothed',60.*20.

ylim,'rbspa_mageis_FEDU_energy_0_detrend',-4d3,4d3,0
ylim,'rbspa_mageis_FEDU_energy_1_detrend',-4d3,4d3,0
ylim,'rbspa_mageis_FEDU_energy_0',3000,10000,0
ylim,'rbspa_mageis_FEDU_energy_1',1d3,1d5,1


tplot,'rbspa_'+['mageis_FEDU','hope_tmp','hope_FEDO','hope_FODU','hope_dens_e_200','hope_Tperp_Tpar_e_30']


;;--------------------------------------------------
;;load ARTEMIS data (both are at about 18 MLT in solar wind)
;;--------------------------------------------------

;2014   8 21:34:00       5.31       9.11       3.25   7.34  56.36 15:45:27     11.03 D Msphere 


thm_load_esa,probe=['b','c']
thm_load_fgm,probe=['b','c']
;; thm_load_fft,probe=['b','c']
;; thm_load_fbk,probe=['b','c']


get_data,'thb_fgl',data=b
bmag = sqrt(b.y[*,0]^2 + b.y[*,1]^2 + b.y[*,2]^2)
store_data,'thb_bmag',data={x:b.x,y:bmag}
;; tplot,['thb_peef_density','thb_peef_vthermal','thb_peef_ptens','thb_fgl','thb_bmag','FSPC1a_2K_smoothed','kyoto_ae','OMNI_HRO_1min_proton_density','OMNI_HRO_1min_Pressure','wi_dens_hires']

ylim,'thb_peef_density',1,20,1
ylim,'thb_peef_vthermal',1000,3000,1
ylim,'thb_peef_ptens',20,100
ylim,'thb_bmag',0,10

split_vec,'thb_peef_ptens'
zlim,'th?_fff_32_scm3',1d-10,1d-6,1
ylim,'th?_fff_32_scm3',100,1000,1
ylim,'rbsp?_efw_64_spec4',100,1000,1
zlim,'rbsp?_efw_64_spec4',1d-8,1d-5,1
ylim,'rbspa_mageis_FEDU',1,1d4,1
options,'rbspa_mageis_FEDU','spec',1
tplot,'rbspa_mageis_FEDU'
get_data,'rbspa_mageis_FEDU',data=dd
ylim,['rbspa_efw_64_spec4','rbspb_efw_64_spec4'],100,1000,1

tplot,['thb_peef_density','thb_peef_vthermal','thb_peef_ptens_0','thb_bmag','FSPC1a_2K_smoothed','Bfielda_hissint','Bfieldb_hissint','tha_fff_32_scm3','the_fff_32_scm3','thd_fff_32_scm3','rbspa_efw_64_spec4','rbspb_efw_64_spec4']



ylim,'rbspa_mageis_FEDU_energy_0_smoothed_detrend',-10000,10000
ylim,'rbspa_mageis_FEDU_energy_1_smoothed_detrend',-10000,10000
ylim,'rbspa_mageis_FEDU_energy_2_smoothed_detrend',-10000,10000
ylim,'rbspa_mageis_FEDU_energy_3_smoothed_detrend',-10000,10000
ylim,'rbspa_mageis_FEDU_energy_4_smoothed_detrend',-20000,10000
ylim,'rbspa_mageis_FEDU_energy_5_smoothed_detrend',-20000,10000
ylim,'rbspa_mageis_FEDU_energy_6_smoothed_detrend',-20000,10000
ylim,'rbspa_mageis_FEDU_energy_7_smoothed_detrend',-10000,10000
ylim,'rbspa_mageis_FEDU_energy_8_smoothed_detrend',-10000,10000
ylim,'rbspa_mageis_FEDU_energy_9_smoothed_detrend',-10000,10000

tplot,['OMNI_HRO_1min_Pressure','thb_peef_density','FSPC1a_2K_smoothed','Bfielda_hissint','rbspa_efw_64_spec4',$
       'rbspa_mageis_FEDU_energy_0_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_1_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_2_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_3_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_4_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_5_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_6_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_7_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_8_smoothed_detrend',$
       'rbspa_mageis_FEDU_energy_9_smoothed_detrend']


;; ,'rbspa_hope_tmp','rbspa_hope_FEDO','rbspa_hope_FODU','rbspa_hope_dens_e_200','rbspa_hope_Tperp_Tpar_e_30']


tplot,['thc_peef_density','thc_peef_vthermal','thc_peef_ptens','thc_bmag']


;;both Artemis sats see almost exactly the same structure
store_data,'art_dens_comb',data=['thb_peef_density','thc_peef_density']
options,'art_dens_comb','colors',[0,250]
tplot,'art_dens_comb'


;; thm_load_mom_l2.pro
;; thm_load_fgm.pro
;; thm_load_efi.pro

stop

path = '~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/THEMIS/'
cdf2tplot,path+'thb_l2s_esa_20140108180057_20140108225419.cdf'



;; thb_l1s_state_20140108180000_20140108230000.cdf
;; thb_l2s_fbk_20140108180000_20140108225956.cdf
;; thc_l1s_state_20140108180000_20140108230000.cdf
;; thc_l2s_esa_20140108180031_20140108225328.cdf
;; thc_l2s_fgm_20140108180000_20140108225956.cdf






;; ;;MLT and Lshell of [THA,THE,RBSP-A,RBSP-B,i,t,w,k,l,x] at 21:35 UT
;; mltvals = [18.5,14.7,ma,mb,mlts]
;; lshellvals = [4.8,9.8,la,lb,lvals]





;;Looking at the THEMIS survey plots, THA seems to be encountering an
;;extended plasmatrough with structure from 20:30-20:35. The hiss
;;picks up here just after 20:35. Thus, I can't tell if the
;;sudden hiss
;;increase is due to modulation by solar wind pressure pulse, or THE
;;just entering the PS


pp = plasmapause_goldstein_boundary(tms[0],[ma[0],mb[0],mte[0],mx[0],mk[0],ml[0]],[la[0],lb[0],lse[0],lx[0],lk[0],ll[0]],/plot,/ps)
pp = plasmapause_goldstein_boundary(tms[1],[ma[1],mb[1],mte[1],mx[1],mk[1],ml[1]],[la[1],lb[1],lse[1],lx[1],lk[1],ll[1]],/plot,/ps)
pp = plasmapause_goldstein_boundary(tms[2],[ma[2],mb[2],mte[2],mx[2],mk[2],ml[2]],[la[2],lb[2],lse[2],lx[2],lk[2],ll[2]],/plot,/ps)
pp = plasmapause_goldstein_boundary(tms[3],[ma[3],mb[3],mte[3],mx[3],mk[3],ml[3]],[la[3],lb[3],lse[3],lx[3],lk[3],ll[3]],/plot,/ps)
pp = plasmapause_goldstein_boundary(tms[4],[ma[4],mb[4],mte[4],mx[4],mk[4],ml[4]],[la[4],lb[4],lse[4],lx[4],lk[4],ll[4]],/plot,/ps)
pp = plasmapause_goldstein_boundary(tms[5],[ma[5],mb[5],mte[5],mx[5],mk[5],ml[5]],[la[5],lb[5],lse[5],lx[5],lk[5],ll[5]],/plot,/ps)
pp = plasmapause_goldstein_boundary(tms[6],[ma[6],mb[6],mte[6],mx[6],mk[6],ml[6]],[la[6],lb[6],lse[6],lx[6],lk[6],ll[6]],/plot,/ps)


pp = plasmapause_goldstein_boundary('2014-01-08/21:35:00',mltvals,lshellvals,/plot,/ps)
pp = plasmapause_goldstein_boundary('2014-01-08/21:35:00',mltvals,lshellvals,/plot,/ps)
pp = plasmapause_goldstein_boundary('2014-01-08/21:35:00',mltvals,lshellvals,/plot,/ps)
pp = plasmapause_goldstein_boundary('2014-01-08/21:35:00',mltvals,lshellvals,/plot,/ps)



;;--------------------------------------------------
;;Load RBSP FBK data showing hiss
;;--------------------------------------------------

rbsp_load_efw_fbk,probe='a',type='calibrated',/pt
rbsp_split_fbk,'a'
rbsp_load_efw_fbk,probe='b',type='calibrated',/pt
rbsp_split_fbk,'b'


tplot,['rbspa_fbk2_7pk_4','rbspb_fbk2_7pk_4','the_e12dc_hiss','tha_fb2','the_fff_32_edc12','the_fff_32_scm2']

;;--------------------------------------------------
;;Load RBSP data showing hiss
;;--------------------------------------------------

rbsp_load_efw_spec,probe='a',type='calibrated'

trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

get_data,'rbspa_efw_64_spec2',data=bu2
get_data,'rbspa_efw_64_spec3',data=bv2
get_data,'rbspa_efw_64_spec4',data=bw2
bu2.y[*,0:11] = 0.
bv2.y[*,0:11] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfielda_hissint',data={x:bu2.x,y:bt}
tplot,'Bfielda_hissint'





rbsp_load_efw_spec,probe='b',type='calibrated'

trange = timerange()
fcals = rbsp_efw_get_gain_results()
fbinsL = fcals.cal_spec.freq_spec64L
fbinsH = fcals.cal_spec.freq_spec64H
bandw = fbinsH - fbinsL

get_data,'rbspb_efw_64_spec2',data=bu2
get_data,'rbspb_efw_64_spec3',data=bv2
get_data,'rbspb_efw_64_spec4',data=bw2
bu2.y[*,0:7] = 0.
bv2.y[*,0:7] = 0.
bw2.y[*,0:2] = 0.
bu2.y[*,45:63] = 0.
bv2.y[*,45:63] = 0.
bw2.y[*,45:63] = 0.
nelem = n_elements(bu2.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)
store_data,'Bfieldb_hissint',data={x:bu2.x,y:bt}
tplot,'Bfieldb_hissint'




;;Hissint for THE
bandw = scm.v - shift(scm.v,1)
bandw[0] = 0.
get_data,'the_fff_32_scm2',data=scm
scm.y[0:5] = 0.
scm.y[20:31] = 0.

nelem = n_elements(scm.x)
bt = fltarr(nelem)
;Add up amplitude in all 64 bins and multiply each bin by a bandwidth
ball = scm.y^2
;; ball = bu2.y + bv2.y + bw2.y
for j=0L,nelem-1 do bt[j] = sqrt(total(ball[j,*]*bandw))  ;RMS method (Malaspina's method)

store_data,'Bfield_the_hissint',data={x:scm.x,y:bt}
tplot,'Bfield_the_hissint'




;;---------
;;---------
;;---------
;;---------
;;Load THEMIS and RBSP survey data to see if they see a delta-B
thm_load_fgm,probe=['a','e'],datatype='all'

;; rbsp_load_efw_waveform,probe=['a','b'],datatype='esvy',type='calibrated'
;; tplot,['rbspa_efw_esvy','rbspb_efw_esvy']

cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/RBSP/rbspa_efw-l3_20140108_v01.cdf'
copy_data,'efield_inertial_frame_mgse','rbspa_einertial_mgse'
copy_data,'efield_corotation_frame_mgse','rbspa_ecoro_mgse'

cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/RBSP/rbspb_efw-l3_20140108_v01.cdf'
copy_data,'efield_inertial_frame_mgse','rbspb_einertial_mgse'
copy_data,'efield_corotation_frame_mgse','rbspb_ecoro_mgse'



;;--------------------------------------------------
;;load EMFISIS data
;;--------------------------------------------------

cdf_leap_second_init
cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/EMFISIS/rbsp-a_magnetometer_4sec-gsm_emfisis-L3_20140108_v1.3.1.cdf'
copy_data,'Mag','rbspa_Bgsm'
copy_data,'Magnitude','rbspa_Bmagnitude_gsm'
cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/EMFISIS/rbsp-b_magnetometer_4sec-gsm_emfisis-L3_20140108_v1.3.1.cdf'
copy_data,'Mag','rbspb_Bgsm'
copy_data,'Magnitude','rbspb_Bmagnitude_gsm'


cdf2tplot,files='~/Desktop/Research/RBSP_hiss_precip2_coherence_survey/EMFISIS/rbspa_efw-l2_combo_20140108_v03.cdf'






rbsp_efw_dcfield_removal_crib,'b'
tplot,'rbspb_mag_mgse_t96_ace_dif'

;;RBSP-B sees pulse in Efield (Ey mostly)
tplot,['rbspa_ecoro_mgse','rbspa_mag_mgse_t96_ace_dif','rbspa_Bgsm']
tplot,['rbspb_ecoro_mgse','rbspb_mag_mgse_t96_ace_dif','rbspb_Bgsm']

tplot,['tha_fgl','the_fgl']

;;No useful data here
;thm_load_scm,probe=['a','e']


;;--------------------------------------------------
;;Master survey plot of RBSP and THEMIS
;;--------------------------------------------------


split_vec,'tha_fgl'
split_vec,'tha_efs_dot0_gsm'
tplot,['tha_efs_dot0_gsm_x','tha_efs_dot0_gsm_y','tha_efs_dot0_gsm_z','tha_fb2']

split_vec,'the_fgl'
tplot,['the_efs_dot0_gsm','the_e12dc_hiss','the_fff_32_edc12','the_fff_32_scm2','the_fgl_x','the_fgl_y','the_fgl_z']


tplot,['rbspa_efw_64_spec4','rbspa_fbk2_7pk_4','Bfielda_hissint','rbspa_mag_mgse_t96_ace_dif']
tplot,['rbspb_efw_64_spec4','rbspb_fbk2_7pk_4','Bfieldb_hissint','rbspb_mag_mgse_t96_ace_dif']




tplot,['the_efs_dot0_gsm','the_e12dc_hiss','the_fff_32_edc12','the_fff_32_scm2','the_fgl_x','the_fgl_y','the_fgl_z','rbspa_efw_64_spec4','rbspa_fbk2_7pk_4','Bfielda_hissint','rbspa_mag_mgse_t96_ace_dif']

;;Both THE and RBSP-A see the same freq VLF waves, but RBSP-A is
;;definitely in the PS (late morningside) and THE is at L=11 in afternoon sector
;;The THE survey plot indicates that it likely isn't in an
;;extended plume (density is constant)

get_data,'the_fgl',data=bo
magnit = sqrt(bo.y[*,0]^2 + bo.y[*,1]^2 + bo.y[*,2]^2)
fce = 28.*magnit
store_data,'the_fce',data={x:bo.x,y:fce}
store_data,'the_fce_2',data={x:bo.x,y:fce/2.}
store_data,'the_fce_01',data={x:bo.x,y:0.1*fce}
store_data,'the_fci',data={x:bo.x,y:fce/1836.}
store_data,'the_flh',data={x:bo.x,y:sqrt(fce*fce/1836.)}

options,['the_fce','the_fce_2','the_fce_01','the_flh'],'colors',[250,250,250,100]
store_data,'the_fff_32_scm2_comb',data=['the_fff_32_scm2','the_fce','the_fce_2','the_fce_01','the_flh','the_fci']


get_data,'rbspa_emfisis_l3_1sec_gse_Magnitude',data=bo
magnit = bo.y
fce = 28.*magnit
store_data,'rbspa_fce',data={x:bo.x,y:fce}
store_data,'rbspa_fce_2',data={x:bo.x,y:fce/2.}
store_data,'rbspa_fce_01',data={x:bo.x,y:0.1*fce}
store_data,'rbspa_fci',data={x:bo.x,y:fce/1836.}
store_data,'rbspa_flh',data={x:bo.x,y:sqrt(fce*fce/1836.)}

get_data,'rbspb_emfisis_l3_1sec_gse_Magnitude',data=bo
magnit = bo.y
fce = 28.*magnit
store_data,'rbspb_fce',data={x:bo.x,y:fce}
store_data,'rbspb_fce_2',data={x:bo.x,y:fce/2.}
store_data,'rbspb_fce_01',data={x:bo.x,y:0.1*fce}
store_data,'rbspb_fci',data={x:bo.x,y:fce/1836.}
store_data,'rbspb_flh',data={x:bo.x,y:sqrt(fce*fce/1836.)}

options,'*_fce*','thick',2
options,'*_flh*','thick',2
options,'*_fci*','thick',2
options,'*_fce_2','linestyle',2
options,'*_fce_01','linestyle',3
options,'*_flh','linestyle',0

options,'*_fce','color',250
options,'*_fce_2','color',250
options,'*_fce_01','color',250
options,'*_flh','color',200

options,['rbspa_fce','rbspa_fce_2','rbspa_flh'],'colors',[250,200,150,100]
store_data,'rbspa_efw_64_spec4_comb',data=['rbspa_efw_64_spec4','rbspa_fce','rbspa_fce_2','rbspa_flh','rbspa_fci']
store_data,'rbspb_efw_64_spec4_comb',data=['rbspb_efw_64_spec4','rbspb_fce','rbspb_fce_2','rbspb_flh','rbspb_fci']



rbsp_detrend,'rbspa_fbk2_7pk_4',60.*0.5
rbsp_detrend,'rbspa_fbk2_7pk_4_smoothed',60.*8.

rbsp_detrend,'Bfielda_hissint',60.*0.5
rbsp_detrend,'Bfielda_hissint_smoothed',60.*8
;rbsp_detrend,'Bfield_the_hissint',60.*8.

get_data,'the_fgl',data=fgl
bmag = sqrt(fgl.y[*,0]^2 + fgl.y[*,1]^2 + fgl.y[*,2]^2)
store_data,'the_fgl_bmag',data={x:fgl.x,y:bmag}
rbsp_detrend,'the_fgl',60.*10.
rbsp_detrend,'the_fgl_bmag',60.*10.

copy_data,'rbspb_mag_mgse_t96_ace_dif_mag_smoothed','rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v2'
ylim,'rbspb_mag_mgse_t96_ace_dif_mag_smoothed',15,25
ylim,'rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v2',0,140

yv = tsample('rbspb_mag_mgse_t96_ace_dif_mag_smoothed',time_double(['2014-01-08/22:00','2014-01-08/24:00']),times=tms)
store_data,'rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v3',data={x:tms,y:yv}
rbsp_detrend,'rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v3',60.*10.


rbsp_detrend,'rbsp?_emfisis_l3_1sec_gse_Magnitude',60.*10.
store_data,'rbsp_the_mag_comb',data=['rbspa_emfisis_l3_1sec_gse_Magnitude_detrend',$
                                     'rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v3_detrend',$
                                     'the_fgl_bmag_detrend']


options,'rbsp_the_mag_comb','colors',[0,50,250]
ylim,'rbsp_the_mag_comb',-3,2
options,'rbsp_the_mag_comb','ytitle','Black=RBSPa Bmag!CBlue=RBSPb Bmag!CRed=TH-E Bmag!Cdetrend'

rbsp_detrend,'Bfieldb_hissint',60.*0.5
rbsp_detrend,'Bfieldb_hissint_smoothed',60.*10.


split_vec,'the_fgl_detrend'

get_data,'rbspb_mag_mgse_t96_ace_dif',data=amag
amag2 = sqrt(amag.y[*,0]^2 + amag.y[*,1]^2 + amag.y[*,2]^2)
store_data,'rbspb_mag_mgse_t96_ace_dif_mag',data={x:amag.x,y:amag2}
rbsp_detrend,'rbspb_mag_mgse_t96_ace_dif_mag',60.*0.5
rbsp_detrend,'rbspb_mag_mgse_t96_ace_dif_mag_smoothed',60.*10.
;rbsp_detrend,'rbspb_emfisis_l3_1sec_gse_Magnitude',60.*10.

options,'the_fgl_detrend_z','ytitle','TH-E FGL!CDSLz (roughly GSMz)!Cdetrend'

ylim,['rbsp?_efw_64_spec4_comb','the_fff_32_scm2_comb'],10,10000,1
zlim,'the_fff_32_scm2_comb',1d-8,1d-4,1
ylim,'rbspb_mag_mgse_t96_ace_dif_mag',0,150
zlim,'rbspb_efw_64_spec4',1d-8,1d-6,1
ylim,'rbspb_efw_64_spec4',10,10000,1
ylim,'the_fgl_detrend_z',-2,2


tplot_options,'title','from paper_direct_sw_coherence_comparison.pro'
tplot,['rbsp_the_mag_comb',$
       'the_fff_32_scm2_comb','the_fgl_detrend_z',$
       'rbspa_efw_64_spec4_comb','Bfielda_hissint_smoothed','Bfielda_hissint_smoothed_detrend','rbspb_efw_64_spec4_comb','Bfieldb_hissint_smoothed_detrend',$
       'rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v2']




;;---------
;;---------
;;---------
;;---------



;;Extract slices of the power spectra and compare freq spectrum

tplot,['the_fff_32_scm2','rbspa_efw_64_spec4']
get_data,'the_fff_32_scm2',data=dat1
get_data,'rbspa_efw_64_spec4',data=dat2

;; u0 = time_double('2014-01-08/21:30')
;; u1 = time_double('2014-01-08/23:00')
u0 = time_double('2014-01-08/21:30')
u1 = time_double('2014-01-08/22:00')
;; u0 = time_double('2014-01-08/22:10')
;; u1 = time_double('2014-01-08/22:40')
goo1 = where((dat1.x ge u0) and (dat1.x le u1))                         
goo2 = where((dat2.x ge u0) and (dat2.x le u1))                         


title = time_string(u0) + ' to ' + strmid(time_string(u1),11,5)

vals1 = dat1.y[goo1,*]
vals2 = dat2.y[goo2,*]

med1 = fltarr(n_elements(dat1.v))
med2 = fltarr(n_elements(dat2.v))
for i=0,n_elements(dat1.v)-1 do med1[i] = median(reform(vals1[*,i]))
for i=0,n_elements(dat2.v)-1 do med2[i] = median(reform(vals2[*,i]))

!p.multi = [0,2,3]
plot,dat1.v,reform(dat1.y[goo1[0],*]),xrange=[0,600],$
     /ylog,yrange=[1d-8,1d-4],/nodata,title=title
for i=0,n_elements(goo1)-1 do oplot,dat1.v,reform(dat1.y[goo1[i],*])
oplot,dat1.v,med1,thick=2,color=120

plot,dat1.v,reform(dat1.y[goo1[0],*]),xrange=[10,1000],$
     /xlog,/ylog,yrange=[1d-8,1d-4],/nodata
for i=0,n_elements(goo1)-1 do oplot,dat1.v,reform(dat1.y[goo1[i],*])
oplot,dat1.v,med1,thick=2,color=120



plot,dat2.v,reform(dat2.y[goo2[0],*]),xrange=[0,600],$
     /ylog,yrange=[1d-8,1d-4],/nodata
for i=0,n_elements(goo2)-1 do oplot,dat2.v,reform(dat2.y[goo2[i],*]),color=250
oplot,dat2.v,med2,thick=2,color=120


plot,dat2.v,reform(dat2.y[goo2[0],*]),xrange=[10,1000],$
     /xlog,/ylog,yrange=[1d-8,1d-4],/nodata
for i=0,n_elements(goo2)-1 do oplot,dat2.v,reform(dat2.y[goo2[i],*]),color=250
oplot,dat2.v,med2,thick=2,color=120




plot,dat1.v,med1,xrange=[0,600],$
     /ylog,yrange=[1d-8,1d-4],thick=2
oplot,dat2.v,med2,thick=2,color=250
plot,dat1.v,med1,xrange=[10,1000],$
     /xlog,/ylog,yrange=[1d-8,1d-4],thick=2
oplot,dat2.v,med2,thick=2,color=250















;;--------------------------------------------------
;; Load Wind hires density from CDFs
paath = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/wind/'
cdf2tplot,paath+'wi_ems_3dp_20131225000000_20140220235958.cdf'
cdf2tplot,paath+'wi_pms_3dp_20131225000002_20140221000000.cdf'
cdf2tplot,paath+'wi_k0s_swe_20131225000105_20140220235837.cdf'


;; copy_data,'E_DENS','wi_dens_hires'
copy_data,'P_DENS','wi_dens_hires'
copy_data,'V_GSE','wi_swe_V_GSE'


;; remove NaN values

get_data,'wi_dens_hires',data=dd

goo = where(dd.y lt 0.)   
if goo[0] ne -1 then dd.y[goo] = !values.f_nan  
xv = dd.x   
yv = dd.y   
interp_gap,xv,yv   

store_data,'wi_dens_hires',data={x:xv,y:yv}   

;;--------------------------------------------------

rbsp_detrend,'wi_dens_hires',60.*0.4


rbsp_load_emfisis,probe='a',level='l3',coord='gse',cadence='4sec'
split_vec,'rbspa_emfisis_l3_4sec_gse_Mag'

rbsp_efw_dcfield_removal_crib,'a',model='t89'
get_data,'rbspa_mag_gsm_t89_dif',data=bw
bmag = sqrt(bw.y[*,0]^2 + bw.y[*,1]^2 + bw.y[*,2]^2)
store_data,'bmag_diff_rbsp',data={x:bw.x,y:bmag}
split_vec,'rbspa_mag_gsm_t89_dif'


omni_hro_load
wi_mfi_load
;; wi_swe_load
wi_or_load  ;load position data
;; goes_mag_load  (Need to ask Kyle Murphy for GOES12,13 data)



split_vec,'wi_h0_mfi_B3GSE'
get_data,'wi_h0_mfi_B3GSE',data=bw
bmag = sqrt(bw.y[*,0]^2 + bw.y[*,1]^2 + bw.y[*,2]^2)
store_data,'bmag_wind',data={x:bw.x,y:bmag}

split_vec,'wi_h0_mfi_B3GSE'

;;Shift Wind data
get_data,'wi_pre_or_GSE_POS',data=dd
store_data,'wi_pre_or_GSE_POS',data={x:dd.x,y:dd.y/6370.}
split_vec,'wi_swe_V_GSE'

tplot,['wi_pre_or_GSE_POS','wi_swe_V_GSE_x']
stop



xgse = 195.   ;RE upstream
vsw = 350.    ;km/s

dt = (xgse*6370.)/vsw/60.  ;timeshift in minutes
print,dt
dt = 51

get_data,'bmag_wind',data=dd
store_data,'bmag_wind_shift',data={x:dd.x+dt*60.,y:dd.y}

split_vec,'wi_h0_mfi_B3GSE'
get_data,'wi_h0_mfi_B3GSE_z',data=dd
store_data,'wi_h0_mfi_B3GSE_z_shift',data={x:dd.x+dt*60.,y:dd.y}

;; get_data,'wi_swe_Np',data=dd
;; store_data,'wi_swe_NP_shift',data={x:dd.x+dt*60.,y:dd.y}

get_data,'wi_dens_hires_smoothed',data=dd
store_data,'wi_dens_hires_smoothed_shift',data={x:dd.x+dt*60.,y:dd.y}

get_data,'wi_dens_hires',data=dd
store_data,'wi_dens_hires_shift',data={x:dd.x+dt*60.,y:dd.y}

split_vec,'wi_swe_V_GSE'
get_data,'wi_swe_V_GSE_x',data=dd
store_data,'wi_swe_V_GSE_x_shift',data={x:dd.x+dt*60.,y:dd.y}


rbsp_detrend,'rbspa_mag_gsm_t89_dif_z',60.*20
ylim,'rbspa_mag_gsm_t89_dif_z_detrend',-10,10

rbsp_detrend,'rbspa_mag_gsm_t89_dif',60.*20
ylim,'rbspa_mag_gsm_t89_dif_detrend',-10,10

rbsp_detrend,'bmag_diff_rbsp',60.*20.
ylim,'bmag_diff_rbsp_detrend',-10,10

;; tplot,['OMNI_HRO_1min_Pressure','bmag_wind_shift','wi_h0_mfi_B3GSE_z_shift',$
;;        'OMNI_HRO_1min_BZ_GSM',$
;;        'wi_dens_hires_shift',$
;;        'wi_swe_NP_shift',$
;;        'FSPC1a_2'+payloads[0]+'_smoothed','FSPC1a_2'+payloads[1]+'_smoothed',$
;;        'L_Kp2_2?','MLT_Kp2_2?',$
;;        'rbspa_emfisis_l3_4sec_gse_Mag_z','rbspa_mag_gsm_t89_dif_z',$
;;        'bmag_diff_rbsp','wi_swe_Np','wi_swe_Proton_Np_moment',$
;; 'rbspa_mag_gsm_t89_dif_z_detrend',$
;;        'bmag_diff_rbsp_detrend']

store_data,'wind_omni_compare_bz',data=['wi_h0_mfi_B3GSE_z_shift','OMNI_HRO_1min_BZ_GSE']
store_data,'wind_omni_compare_dens',data=['wi_dens_hires_shift','OMNI_HRO_1min_proton_density']
options,'wind_omni_compare','colors',[0,250]

tplot,['OMNI_HRO_1min_Pressure','bmag_wind_shift',$
       'wind_omni_compare_bz',$
       'wi_dens_hires_smoothed_shift',$
;       'wi_swe_NP_shift',$
       'FSPC1a_2'+payloads[0]+'_smoothed','FSPC1a_2'+payloads[1]+'_smoothed',$
       'rbspa_emfisis_l3_4sec_gse_Mag_z_detrend','rbspa_mag_gsm_t89_dif_z_detrend',$
      'FSPC1a_2I_smoothed','FSPC1a_2K_smoothed','FSPC1a_2L_smoothed','FSPC1a_2X_smoothed',$
      'L_Kp2_2'+payloads[0],'L_Kp2_2'+payloads[1],'MLT_Kp2_2'+payloads[0],'MLT_Kp2_2'+payloads[1]]


stop


payloads = strlowcase(payloads)

;;Take FFT of various quantities
;; t0 = '2014-01-07/15:16'
;; t1 = '2014-01-07/18:00'
;; t0 = '2014-01-09/00:00'
;; t1 = '2014-01-09/03:00'
;; t0 = '2014-01-08/20:00'
;; t1 = '2014-01-08/24:00'
t0 = '2014-01-06/20:00'
t1 = '2014-01-13/06:00'
;; t0 = '2014-02-09/00:00'
;; t1 = '2014-02-10/24:00'
;; t0 = '2014-01-08/00:00'
;; t1 = '2014-01-08/15:00'

x = tsample('bmag_wind_shift',time_double([t0,t1]),times=tms)
store_data,'bmag_wind_shift_tmp',data={x:tms,y:x}
;; x = tsample('OMNI_HRO_1min_Pressure',time_double([t0,t1]),times=tms)
;; store_data,'OMNI_HRO_1min_Pressure_tmp',data={x:tms,y:x}
x = tsample('wi_dens_hires_shift',time_double([t0,t1]),times=tms)
store_data,'wi_dens_hires_shift_tmp',data={x:tms,y:x}
x = tsample('wi_swe_V_GSE_x_shift',time_double([t0,t1]),times=tms)
store_data,'wi_swe_V_GSE_x_shift_tmp',data={x:tms,y:x}
x = tsample('FSPC1a_2'+payloads[0],time_double([t0,t1]),times=tms)
store_data,'FSPC1a_2'+payloads[0]+'_tmp',data={x:tms,y:x}
x = tsample('FSPC1a_2'+payloads[1],time_double([t0,t1]),times=tms)
store_data,'FSPC1a_2'+payloads[1]+'_tmp',data={x:tms,y:x}
x = tsample('FSPC1b_2'+payloads[0],time_double([t0,t1]),times=tms)
store_data,'FSPC1b_2'+payloads[0]+'_tmp',data={x:tms,y:x}
x = tsample('FSPC1b_2'+payloads[1],time_double([t0,t1]),times=tms)
store_data,'FSPC1b_2'+payloads[1]+'_tmp',data={x:tms,y:x}
x = tsample('FSPC1c_2'+payloads[0],time_double([t0,t1]),times=tms)
store_data,'FSPC1c_2'+payloads[0]+'_tmp',data={x:tms,y:x}
x = tsample('FSPC1c_2'+payloads[1],time_double([t0,t1]),times=tms)
store_data,'FSPC1c_2'+payloads[1]+'_tmp',data={x:tms,y:x}

x = tsample('rbspa_mag_gsm_t89_dif_z',time_double([t0,t1]),times=tms)
store_data,'rbspa_mag_gsm_t89_dif_z_tmp',data={x:tms,y:x}
;; x = tsample('PeakDet_2'+payloads[0],time_double([t0,t1]),times=tms)
;; store_data,'PeakDet_2'+payloads[0]+'_tmp',data={x:tms,y:x}
;; x = tsample('PeakDet_2'+payloads[1],time_double([t0,t1]),times=tms)
;; store_data,'PeakDet_2'+payloads[1]+'_tmp',data={x:tms,y:x}



get_data,'bmag_wind_shift_tmp',data=d
tinterp = d.x
tinterpol_mxn,'wi_dens_hires_shift_tmp',tinterp,newname='wi_dens_hires_shift_tmp'
tinterpol_mxn,'wi_swe_V_GSE_x_shift_tmp',tinterp,newname='wi_swe_V_GSE_x_shift_tmp'
tinterpol_mxn,'FSPC1a_2'+payloads[0]+'_tmp',tinterp,newname='FSPC1a_2'+payloads[0]+'_tmp'
tinterpol_mxn,'FSPC1a_2'+payloads[1]+'_tmp',tinterp,newname='FSPC1a_2'+payloads[1]+'_tmp'
tinterpol_mxn,'FSPC1b_2'+payloads[0]+'_tmp',tinterp,newname='FSPC1b_2'+payloads[0]+'_tmp'
tinterpol_mxn,'FSPC1b_2'+payloads[1]+'_tmp',tinterp,newname='FSPC1b_2'+payloads[1]+'_tmp'
tinterpol_mxn,'FSPC1c_2'+payloads[0]+'_tmp',tinterp,newname='FSPC1c_2'+payloads[0]+'_tmp'
tinterpol_mxn,'FSPC1c_2'+payloads[1]+'_tmp',tinterp,newname='FSPC1c_2'+payloads[1]+'_tmp'
tinterpol_mxn,'rbspa_mag_gsm_t89_dif_z_tmp',tinterp,newname='rbspa_mag_gsm_t89_dif_z_tmp'
;; tinterpol_mxn,'PeakDet_2'+payloads[0]+'_tmp',tinterp,newname='PeakDet_2'+payloads[0]+'_tmp'
;; tinterpol_mxn,'PeakDet_2'+payloads[1]+'_tmp',tinterp,newname='PeakDet_2'+payloads[1]+'_tmp'


;;Combine multiple quantities into one tplot variable
;; get_data,'bmag_wind_shift_tmp',data=b1


rbsp_detrend,'FSPC1a_2'+payloads,60.*0.2
copy_data,'FSPC1a_2'+payloads[0]+'_smoothed','FSPC1a_2'+payloads[0]+'_smoothed_tmp'
copy_data,'FSPC1a_2'+payloads[1]+'_smoothed','FSPC1a_2'+payloads[1]+'_smoothed_tmp'

var1 = 'wi_dens_hires_shift_tmp'
var2 = 'FSPC1a_2'+payloads[0]+'_smoothed_tmp'
;; var2 = 'PeakDet_2'+payloads[0]+'_tmp'
var3 = 'FSPC1a_2'+payloads[1]+'_smoothed_tmp'
;; var3 = 'PeakDet_2'+payloads[1]+'_tmp'


;;--------------------------------------------------
;;Calculate dynamic pressure as n*v^2
;;--------------------------------------------------
;;From OMNIWeb
;; Flow pressure = (2*10**-6)*Np*Vp**2 nPa (Np in cm**-3, 
;; Vp in km/s, subscript "p" for "proton")


get_data,'wi_swe_V_GSE_x_shift_tmp',data=vv
get_data,'wi_dens_hires_shift_tmp',data=dd
;change velocity to m/s
vsw = vv.y
;change number density to 1/m^3
dens = dd.y
;change to mass density using proton mass
;; pdens = dens*1.67d-27  ;kg/m3


vsw_mean = mean(vsw)
dens_mean = mean(dens)


;;Pressure in nPa (rho*v^2)
press_proxy = 2d-6 * dens * vsw^2
store_data,'press_proxy',data={x:vv.x,y:press_proxy}
;;calculate pressure using averaged Vsw value
press_proxy = 2d-6 * dens * vsw_mean^2 
store_data,'press_proxy_constant_vsw',data={x:vv.x,y:press_proxy}
;;calculate pressure using averaged density value
press_proxy = 2d-6 * dens_mean * vsw^2 
store_data,'press_proxy_constant_dens',data={x:vv.x,y:press_proxy}

store_data,'pressure_compare',$
           data=['press_proxy','press_proxy_constant_dens','press_proxy_constant_vsw']


store_data,'pressure_compare_dec',$
           data=['press_proxy_dec','press_proxy_constant_dens_dec','press_proxy_constant_vsw_dec']

options,'pressure_compare','colors',[0,50,250]
options,'pressure_compare_dec','colors',[0,50,250]

tplot,['OMNI_HRO_1min_Pressure','pressure_compare','pressure_compare_dec','wi_swe_V_GSE_x']




ylim,['SSPC_2'+payloads[0],'SSPC_2E'+payloads[1]],0,100
zlim,['SSPC_2'+payloads[0],'SSPC_2E'+payloads[1]],0,10
;; tplot,['wi_dens_hires_smoothed_shift',$
;;        'FSPC1a_2'+payloads[0]+'_smoothed','FSPC1a_2'+payloads[1]+'_smoothed']
tplot,[var1,var2,var3,'OMNI_HRO_1min_Pressure','pressure_compare','SSPC_2'+payloads[0],'SSPC_2E'+payloads[1],'wind_omni_compare_dens']
tlimit,t0,t1

get_data,var1,data=b1
get_data,var2,data=b2
get_data,var3,data=b3
;; get_data,'FSPC1a_2'+payloads[0]+'_smoothed_tmp',data=b3

store_data,'tmp_comb',data={x:b1.x,y:[[b1.y],[b2.y],[b3.y]]}


extra_psd = {yrange:[-10,80],xrange:[0,3]/1000.}
;extra_psd = {yrange:[-10,80],xrange:[0.1,10]/1000.,xlog:1}
;; plot_wavestuff,'tmp_comb',/psd,/nodelete,extra_psd=extra_psd,vline=[0.001,0.0016,0.0023,0.0029];,/postscript


;; .compile /Users/aaronbreneman/Desktop/code/Aaron/IDL/analysis/plot_wavestuff.pro

stop
plot_wavestuff,'tmp_comb',/psd,/nodelete,extra_psd=extra_psd,/postscript









;;%%%%%%%%%

;; rbsp_detrend,'*PeakDet*',60.*0.2
rbsp_detrend,'*FSPC*',60.*0.2

ylim,256,2000,4000
ylim,258,1000,2500
ylim,260,1000,3000
ylim,262,1500,3500
ylim,264,1500,3000
ylim,266,600,1200

options,'OMNI_HRO_1min_Pressure','colors',250
tplot,['OMNI_HRO_1min_Pressure','bmag_wind_shift',$
       'wind_omni_compare_bz',$
       'wi_dens_hires_smoothed_shift',$
       'rbspa_emfisis_l3_4sec_gse_Mag_z_detrend','rbspa_mag_gsm_t89_dif_z_detrend',$
       'FSPC1a_2I_smoothed',$
       'FSPC1a_2K_smoothed',$
       'FSPC1a_2L_smoothed',$
       'FSPC1a_2W_smoothed',$
       'FSPC1a_2T_smoothed',$
       'FSPC1a_2X_smoothed']



;;%%%%%%%%%


  window_minutes = 120.
  window = 60.*window_minutes
  lag = window/16.
  coherence_time = window*2.5


  ;;band4 (0.1-3 mHz)
  window_minutes = 2*90.
  window = 60.*window_minutes
  lag = window/8.
  coherence_time = window*2.5

  v1 = 'wi_dens_hires_shift'
  v2 = 'fspc_2X_smoothed'
  TT1 = time_double('2014-01-07')
  TT2 = time_double('2014-01-10')
  p1 = 'w'
  p2 = 'X'

  dynamic_cross_spec_tplot,v1,0,v2,0,TT1,TT2,window,lag,coherence_time,$
                           new_name='Precip_hiss'  

  copy_data,'Precip_hiss_coherence','coh_'+p1+p2+'_band4'
  get_data,'coh_'+p1+p2+'_band4',data=coh
  store_data,'coh_'+p1+p2+'_band4',data={x:coh.x,y:coh.y,v:coh.v*1000.,spec:1}
  ;;--------------------

  cormin = 0.4
  get_data,'coh_'+p1+p2+'_band4',data=coh_band4
  goo = where(coh_band4.y lt cormin)
  if goo[0] ne -1 then coh_band4.y[goo] = !values.f_nan
  store_data,'coh_'+p1+p2+'_band4',data=coh_band4

  band4 = [0.1,3]
  ylim,'coh_'+p1+p2+'_band4',band4
  zlim,'coh_'+p1+p2+'_band4',cormin,1,0

  get_data,'coh_'+p1+p2+'_band4',data=coh
  goo = where((coh.v gt band4[0]) and (coh.v le band4[1]))
  totes = fltarr(n_elements(coh.x))
  for i=0L,n_elements(coh.x)-1 do totes[i] = total(coh.y[i,goo],/nan)
  store_data,'totes_band4',data={x:coh.x,y:totes}

  goo = where((coh_band4.v ge band4[0]) and (coh_band4.v le band4[1]),nelem)
  ylim,'totes_band4',0,nelem


  lf = band4[0]/1000.
  hf = band4[1]/1000.
  pl = 1/lf
  ph = 1/hf
  rbsp_detrend,v2,ph
  rbsp_detrend,v2+'_smoothed',pl
  copy_data,v2+'_smoothed_detrend',v2+'_band4'
  tplot,[v2,v2+'_smoothed',v2+'_band4']


  copy_data,'totes_band4','coh_totes_band4_'+pre+p1+p2

  ylim,'coh_wX_band4',0.1,3,1

  ;;tplot,[v1,v2,'coh_wX_band4']
  tplot,[v1,$
         'FSPC1a_2x_smoothed_tmp',$
         'coh_wX_band4',$
         var1,var2,var3,$
         'OMNI_HRO_1min_Pressure','pressure_compare',$
         'SSPC_2'+payloads[0],'SSPC_2'+payloads[1],$
         'wind_omni_compare_dens']

stop
  tplot,['FSPC1a_2x_smoothed_tmp',$
         'coh_wX_band4',$
;         var1,var2,var3,$
;         'OMNI_HRO_1min_Pressure',$
         'pressure_compare',$
         'SSPC_2'+payloads[0],$
         'SSPC_2'+payloads[1],$
         'wind_omni_compare_dens',$
;         'rbsp_the_mag_comb',$
;       'the_fff_32_scm2_comb',$
;         'the_fgl_detrend_z',$
       'rbspa_efw_64_spec4_comb',$
         'Bfielda_hissint_smoothed',$
         'Bfielda_hissint_smoothed_detrend',$
         'rbspb_efw_64_spec4_comb',$
         'Bfieldb_hissint_smoothed_detrend',$
       'rbspb_mag_mgse_t96_ace_dif_mag_smoothed_v2']





end

