;Determine E/cB ratio of waves observed on THEMIS A to determine wave mode.


get_data,'SSPC_2X',data=d
goode = where(d.v ge 30.)

tots = fltarr(5360)
for i=0,5359 do tots[i] = total(d.y[i,goode])
store_data,'sspc_gt30',d.x,tots


timespan,'2014-01-11'

tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1



t0tmp = time_double('2014-01-11/00:00')
t1tmp = time_double('2014-01-12/24:00')
plot_omni_quantities,t0avg=t0tmp,t1avg=t1tmp

omni_hro_load
rbsp_detrend,'OMNI_HRO_1min_proton_density',60.*2.
rbsp_detrend,'OMNI_HRO_1min_proton_density_smoothed',60.*80.



load_barrel_lc,['2X','2L','2K','2W','2T','2I'],type='rcnt'
rbsp_detrend,'PeakDet_2?',5.*60.
rbsp_detrend,'PeakDet_2?_smoothed',60.*80.



;-----------------------------------------------
;LOAD THEMIS DATA
;-----------------------------------------------

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'

;For some reason the TDAS routines aren't loading the THEMIS FGM data properly.
;So, I've exported the data from Autoplot and am loading it here.


;Load the B-vector data (GSE coord)
;tplot_save,['tha_bvec11','tha_bmag'],filename=path+'jan11_tha_b'
tplot_restore,filenames=path+'jan11_tha_b.tplot'


;--------------------------------------------
;Load the E-vector data

;tplot_save,['tha_evec11','tha_fce','tha_fce_10','tha_fce_2','tha_fci','tha_fci_Hep','tha_fci_Op','tha_flh'],filename=path+'jan11_tha_e'
tplot_restore,filenames=path+'jan11_tha_e.tplot'



get_data,'tha_bmag',data=d

;;Check out how flh varies in the low and high density limits.
fci = 28.*d.y/1836.
fce = 28.*d.y
ntmp = 1.
fpe = 8980.*sqrt(ntmp)
fpi = replicate(fpe/sqrt(43.),n_elements(d.x))  ;Hz  (estimate from n=2 cm-3)
flhr = sqrt(abs(fce)*fci)							 						 ;Lower Hybrid Res freq (Hz) --> high dens limit - no plasma freq terms (Gurnett 4.4.51)
flhr2 = sqrt(fpi*fpi*fce*fci)/sqrt(fce*fci+(fpi^2))   ;Lower Hybrid Res freq (Hz)
fci = fce/(1836.)                              ;ion cyclotron freq (Hz)

store_data,'tha_fci',d.x,fci
store_data,'tha_flh',d.x,flhr
store_data,'tha_flh2',d.x,flhr2
store_data,'tha_fce',d.x,fce
store_data,'tha_fce_2',d.x,fce/2.
store_data,'tha_fce_10',d.x,fce/10.

store_data,'flh_comp',data=['tha_flh','tha_flh2'] & options,'flh_comp','colors',[0,250]
tplot,'flh_comp'






rbsp_detrend,'tha_bvec11',60.*2.
rbsp_detrend,'tha_bvec11_smoothed',60.*60.
split_vec,'tha_bvec11_smoothed_detrend'
ylim,'tha_bvec11_smoothed_detrend_?',-6,6
tplot,['tha_bvec11_smoothed','tha_bvec11_smoothed_detrend_?']


get_data,'tha_fce',data=fce
get_data,'tha_fce_10',data=fce_10
get_data,'tha_fce_2',data=fce_2
get_data,'tha_fci',data=fci
get_data,'tha_flh',data=flh
dat = [[fce.y],[fce_10.y],[fce_2.y],[fci.y],[flh.y]]
store_data,'fces',fce.x,dat




;---------------------------------------------------------
;Load FBK response curves using Chris Cully's code
;---------------------------------------------------------

;Here is how you would plot the filter bank response for the "160 Hz" band:
;This should compile and run on any SPEDAS install.
;For any other filter bank levels, just change the "level=4" line.
;At higher frequencies, you'd want to also include the filter and antenna response:
;But below about 1 kHz, there's no need for that.


;levels
;2 = 670 Hz
;4 = 160 Hz
;6 = 40 Hz
;8 = 9 Hz

f=dindgen(4096)                    ; Frequencies to plot
level=6                            ; This is the level of filter bank you're looking at ("160 Hz" is level=4)
level2=4                            ; This is the level of filter bank you're looking at ("160 Hz" is level=4)
a=thm_dfb_dig_filter_resp(1,1)     ; (This is just to auto-compile the function DFB_transfer used below)
dfb_resp=(abs(DFB_transfer(f/4096,level))-abs(DFB_transfer(f/4096,level+1)))^2    ; Filter bank response
dfb_resp2=(abs(DFB_transfer(f/4096,level2))-abs(DFB_transfer(f/4096,level2+1)))^2    ; Filter bank response

plot,f,dfb_resp,/xlog,/ylog,xrange=[0.1,10e3],yrange=[1e-9,1],xtitle='Frequency [Hz]',ytitle='Normalized power [unitless]'
oplot,f,dfb_resp2,color=250


;See what amplitude ratio would be at various freqs for a monochromatic signal
;Actual amplitude ratio is ~3-4

goo = where(f ge 40.) & print,sqrt(dfb_resp[goo[0]])/sqrt(dfb_resp2[goo[0]])
;       8.5956171
goo = where(f ge 50.) & print,sqrt(dfb_resp[goo[0]])/sqrt(dfb_resp2[goo[0]])
;       3.9023965
goo = where(f ge 55.) & print,sqrt(dfb_resp[goo[0]])/sqrt(dfb_resp2[goo[0]])
;       2.4894708
goo = where(f ge 60.) & print,sqrt(dfb_resp[goo[0]])/sqrt(dfb_resp2[goo[0]])
;       1.5415291

;For a monochromatic signal the observed amp ratio of 3-4 would put the freq at
;about 50-55 Hz




;thm_comp_efi_response, 'SPB', f, SPB_resp,rsheath=5d6,/complex_response             ; Antenna response
;filter_resp=SPB_resp*bessel_filter_resp(f,4096,4)*thm_adc_resp('E34DC',f)           ; Other filters
;plot,f,filter_resp
;plot,f,filter_resp,/xlog,/ylog,xrange=[0.1,10e3],yrange=[1e-9,10],xtitle='Frequency [Hz]',ytitle='Normalized power [unitless]'


;------------------------------------------------------------------------










thm_load_fbk,probe='a'

split_vec,'tha_fb_scm1'
get_data,'tha_fb_scm1_0',data=d & store_data,'tha_fb_scm1_0nT',d.x,d.y & options,'tha_fb_scm1_0nT','ytitle','THA FBK [nT]!Cscm1 2689Hz'
get_data,'tha_fb_scm1_1',data=d & store_data,'tha_fb_scm1_1nT',d.x,d.y & options,'tha_fb_scm1_1nT','ytitle','THA FBK [nT]!Cscm1 670Hz'
get_data,'tha_fb_scm1_2',data=d & store_data,'tha_fb_scm1_2nT',d.x,d.y & options,'tha_fb_scm1_2nT','ytitle','THA FBK [nT]!Cscm1 160Hz'
get_data,'tha_fb_scm1_3',data=d & store_data,'tha_fb_scm1_3nT',d.x,d.y & options,'tha_fb_scm1_3nT','ytitle','THA FBK [nT]!Cscm1 40Hz'
get_data,'tha_fb_scm1_4',data=d & store_data,'tha_fb_scm1_4nT',d.x,d.y & options,'tha_fb_scm1_4nT','ytitle','THA FBK [nT]!Cscm1 9Hz'
get_data,'tha_fb_scm1_5',data=d & store_data,'tha_fb_scm1_5nT',d.x,d.y & options,'tha_fb_scm1_5nT','ytitle','THA FBK [nT]!Cscm1 2Hz'

split_vec,'tha_fb_edc12'
get_data,'tha_fb_edc12_0',data=d & store_data,'tha_fb_edc12_0V_m',d.x,d.y/1000. & options,'tha_fb_edc12_0V_m','ytitle','THA FBK [V/m]!Cedc12 2689Hz'
get_data,'tha_fb_edc12_1',data=d & store_data,'tha_fb_edc12_1V_m',d.x,d.y/1000. & options,'tha_fb_edc12_1V_m','ytitle','THA FBK [V/m]!Cedc12 670Hz'
get_data,'tha_fb_edc12_2',data=d & store_data,'tha_fb_edc12_2V_m',d.x,d.y/1000. & options,'tha_fb_edc12_2V_m','ytitle','THA FBK [V/m]!Cedc12 160Hz'
get_data,'tha_fb_edc12_3',data=d & store_data,'tha_fb_edc12_3V_m',d.x,d.y/1000. & options,'tha_fb_edc12_3V_m','ytitle','THA FBK [V/m]!Cedc12 40Hz'
get_data,'tha_fb_edc12_4',data=d & store_data,'tha_fb_edc12_4V_m',d.x,d.y/1000. & options,'tha_fb_edc12_4V_m','ytitle','THA FBK [V/m]!Cedc12 9Hz'
get_data,'tha_fb_edc12_5',data=d & store_data,'tha_fb_edc12_5V_m',d.x,d.y/1000. & options,'tha_fb_edc12_5V_m','ytitle','THA FBK [V/m]!Cedc12 2Hz'



;-----------------------------
;Find E/B for each FBK bin
;For FBK ratios E/B, we don't have to worry about bin width since it'll divide out.

div_data,'tha_fb_edc12_0V_m','tha_fb_scm1_0nT',newname='E_B0'
div_data,'tha_fb_edc12_1V_m','tha_fb_scm1_1nT',newname='E_B1'
div_data,'tha_fb_edc12_2V_m','tha_fb_scm1_2nT',newname='E_B2'
div_data,'tha_fb_edc12_3V_m','tha_fb_scm1_3nT',newname='E_B3'
div_data,'tha_fb_edc12_4V_m','tha_fb_scm1_4nT',newname='E_B4'
div_data,'tha_fb_edc12_5V_m','tha_fb_scm1_5nT',newname='E_B5'

;Create cB/E ratios for better comparison with most works
get_data,'tha_fb_edc12_0V_m',data=ev & get_data,'tha_fb_scm1_0nT',data=bv
store_data,'cB_E0',ev.x,3d8/1d9/(ev.y/bv.y) & options,'cB_E0','ytitle','cB/E 2689 Hz FBK'
get_data,'tha_fb_edc12_1V_m',data=ev & get_data,'tha_fb_scm1_1nT',data=bv
store_data,'cB_E1',ev.x,3d8/1d9/(ev.y/bv.y) & options,'cB_E1','ytitle','cB/E 670 Hz FBK'
get_data,'tha_fb_edc12_2V_m',data=ev & get_data,'tha_fb_scm1_2nT',data=bv
store_data,'cB_E2',ev.x,3d8/1d9/(ev.y/bv.y) & options,'cB_E2','ytitle','cB/E 160 Hz FBK'
get_data,'tha_fb_edc12_3V_m',data=ev & get_data,'tha_fb_scm1_3nT',data=bv
store_data,'cB_E3',ev.x,3d8/1d9/(ev.y/bv.y) & options,'cB_E3','ytitle','cB/E 40 Hz FBK'
get_data,'tha_fb_edc12_4V_m',data=ev & get_data,'tha_fb_scm1_4nT',data=bv
store_data,'cB_E4',ev.x,3d8/1d9/(ev.y/bv.y) & options,'cB_E4','ytitle','cB/E 9 Hz FBK'


E_B = 0.002  ;(V/m/nT)
cB_E = 3d8/1d9/E_B

;--------------------------------------------
;The weird E/B ratio cap in 160 Hz channel is not a floating point accuracy issue
get_data,'tha_fb_edc12_2V_m',data=d1
get_data,'tha_fb_scm1_2nT',data=d2
store_data,'E_B2_tst',d1.x,double(d1.y)/double(d2.y)
store_data,'Etst',data=['E_B2','E_B2_tst'] & options,'Etst','colors',[0,250]
tplot,'Etst'
;--------------------------------------------



options,'E_B0','ytitle','E/B 2689Hz'
options,'E_B1','ytitle','E/B 670Hz'
options,'E_B2','ytitle','E/B 160Hz'
options,'E_B3','ytitle','E/B 40Hz'
options,'E_B4','ytitle','E/B 9Hz'
options,'E_B5','ytitle','E/B 2Hz'

ylim,'E_B?',0.001,.02,1
tplot,['tha_fci','tha_fb_edc12_3V_m','tha_fb_scm1_3nT','E_B?']

tplot,['tha_fci','tha_fb_edc12_1V_m','tha_fb_edc12_2V_m','tha_fb_edc12_3V_m','tha_fb_scm1_1nT','tha_fb_scm1_2nT','tha_fb_scm1_3nT','E_B?']



;The 160 Hz channel may be showing two separate populations from ~21-24 UT.
;Filter data by the 160 Hz E/B ratio and plot to visualize.
get_data,'E_B2',data=dd

;Define low ("bad") and high ("good") amplitude values
goodv = where(dd.y lt 0.005)
badv = where(dd.y ge 0.005)   ;large amp population


get_data,'cB_E1',data=dd
dd.y[badv] = !values.f_nan     ;remove small amp population
store_data,'cB_E1_good',dd.x,dd.y & options,'cB_E1_good','ytitle','cB/E 670 Hz!C(good data only)'
store_data,'cB_E1_comb',data=['cB_E1','cB_E1_good'] & options,'cB_E1_comb','colors',[0,50]
get_data,'cB_E1',data=dd
dd.y[goodv] = !values.f_nan     ;remove large amp population
store_data,'cB_E1_bad',dd.x,dd.y & options,'cB_E1_bad','colors',250
options,'cB_E1_bad','ytitle','cB/E 670Hz!C(bad values)'

get_data,'cB_E2',data=dd
dd.y[badv] = !values.f_nan     ;remove small amp population
store_data,'cB_E2_good',dd.x,dd.y & options,'cB_E2_good','ytitle','cB/E 160 Hz!C(good data only)'
store_data,'cB_E2_comb',data=['cB_E2','cB_E2_good'] & options,'cB_E2_comb','colors',[0,50]
get_data,'cB_E2',data=dd
dd.y[goodv] = !values.f_nan     ;remove large amp population
store_data,'cB_E2_bad',dd.x,dd.y & options,'cB_E2_bad','colors',250
options,'cB_E2_bad','ytitle','cB/E 160Hz!C(bad values)'

get_data,'cB_E3',data=dd
dd.y[badv] = !values.f_nan     ;remove small amp population
store_data,'cB_E3_good',dd.x,dd.y & options,'cB_E3_good','ytitle','cB/E 40 Hz!C(good data only)'
store_data,'cB_E3_comb',data=['cB_E3','cB_E3_good'] & options,'cB_E3_comb','colors',[0,50]
get_data,'cB_E3',data=dd
dd.y[goodv] = !values.f_nan     ;remove large amp population
store_data,'cB_E3_bad',dd.x,dd.y & options,'cB_E3_bad','colors',250
options,'cB_E3_bad','ytitle','cB/E 40Hz!C(bad values)'



get_data,'E_B1',data=dd
dd.y[badv] = !values.f_nan     ;remove small amp population
store_data,'E_B1_good',dd.x,dd.y & options,'E_B1_good','ytitle','E/B 670 Hz!C(good data only)'
store_data,'E_B1_comb',data=['E_B1','E_B1_good'] & options,'E_B1_comb','colors',[0,50]
get_data,'E_B1',data=dd
dd.y[goodv] = !values.f_nan     ;remove large amp population
store_data,'E_B1_bad',dd.x,dd.y & options,'E_B1_bad','colors',250
options,'E_B1_bad','ytitle','E/B 670Hz!C(bad values)'

get_data,'E_B2',data=dd
dd.y[badv] = !values.f_nan     ;remove small amp population
store_data,'E_B2_good',dd.x,dd.y & options,'E_B2_good','ytitle','E/B 160 Hz!C(good data only)'
store_data,'E_B2_comb',data=['E_B2','E_B2_good'] & options,'E_B2_comb','colors',[0,50]
get_data,'E_B2',data=dd
dd.y[goodv] = !values.f_nan     ;remove large amp population
store_data,'E_B2_bad',dd.x,dd.y & options,'E_B2_bad','colors',250
options,'E_B2_bad','ytitle','E/B 160Hz!C(bad values)'

get_data,'E_B3',data=dd
dd.y[badv] = !values.f_nan     ;remove small amp population
store_data,'E_B3_good',dd.x,dd.y & options,'E_B3_good','ytitle','E/B 40 Hz!C(good data only)'
store_data,'E_B3_comb',data=['E_B3','E_B3_good'] & options,'E_B3_comb','colors',[0,50]
get_data,'E_B3',data=dd
dd.y[goodv] = !values.f_nan     ;remove large amp population
store_data,'E_B3_bad',dd.x,dd.y & options,'E_B3_bad','colors',250
options,'E_B3_bad','ytitle','E/B 40Hz!C(bad values)'

get_data,'tha_fb_edc12_1V_m',data=dd,dlim=dlim,lim=lim
dd.y[badv] = !values.f_nan
store_data,'tha_fb_edc12_1V_m_good',dd.x,dd.y,dlim=dlim,lim=lim
store_data,'tha_fb_edc12_1V_m_comb',data=['tha_fb_edc12_1V_m','tha_fb_edc12_1V_m_good'] & options,'tha_fb_edc12_1V_m_comb','colors',[0,50]
get_data,'tha_fb_edc12_1V_m',data=dd
dd.y[goodv] = !values.f_nan     ;remove small amp population
store_data,'tha_fb_edc12_1V_m_bad',dd.x,dd.y,dlim=dlim,lim=lim & options,'tha_fb_edc12_1V_m_bad','colors',250

get_data,'tha_fb_edc12_2V_m',data=dd,dlim=dlim,lim=lim
dd.y[badv] = !values.f_nan
store_data,'tha_fb_edc12_2V_m_good',dd.x,dd.y,dlim=dlim,lim=lim
store_data,'tha_fb_edc12_2V_m_comb',data=['tha_fb_edc12_2V_m','tha_fb_edc12_2V_m_good'] & options,'tha_fb_edc12_2V_m_comb','colors',[0,50]
get_data,'tha_fb_edc12_2V_m',data=dd
dd.y[goodv] = !values.f_nan     ;remove small amp population
store_data,'tha_fb_edc12_2V_m_bad',dd.x,dd.y,dlim=dlim,lim=lim & options,'tha_fb_edc12_2V_m_bad','colors',250

get_data,'tha_fb_edc12_3V_m',data=dd,dlim=dlim,lim=lim
dd.y[badv] = !values.f_nan
store_data,'tha_fb_edc12_3V_m_good',dd.x,dd.y,dlim=dlim,lim=lim
store_data,'tha_fb_edc12_3V_m_comb',data=['tha_fb_edc12_3V_m','tha_fb_edc12_3V_m_good'] & options,'tha_fb_edc12_3V_m_comb','colors',[0,50]
get_data,'tha_fb_edc12_3V_m',data=dd
dd.y[goodv] = !values.f_nan     ;remove small amp population
store_data,'tha_fb_edc12_3V_m_bad',dd.x,dd.y,dlim=dlim,lim=lim & options,'tha_fb_edc12_3V_m_bad','colors',250

get_data,'tha_fb_scm1_1nT',data=dd,dlim=dlim,lim=lim
dd.y[badv] = !values.f_nan
store_data,'tha_fb_scm1_1nT_good',dd.x,dd.y,dlim=dlim,lim=lim
store_data,'tha_fb_scm1_1nT_comb',data=['tha_fb_scm1_1nT','tha_fb_scm1_1nT_good'] & options,'tha_fb_scm1_1nT_comb','colors',[0,50]
get_data,'tha_fb_scm1_1nT',data=dd
dd.y[goodv] = !values.f_nan     ;remove small amp population
store_data,'tha_fb_scm1_1nT_bad',dd.x,dd.y,dlim=dlim,lim=lim & options,'tha_fb_scm1_1nT_bad','colors',250

get_data,'tha_fb_scm1_3nT',data=dd,dlim=dlim,lim=lim
dd.y[badv] = !values.f_nan
store_data,'tha_fb_scm1_3nT_good',dd.x,dd.y,dlim=dlim,lim=lim
store_data,'tha_fb_scm1_3nT_comb',data=['tha_fb_scm1_3nT','tha_fb_scm1_3nT_good'] & options,'tha_fb_scm1_3nT_comb','colors',[0,50]
get_data,'tha_fb_scm1_3nT',data=dd
dd.y[goodv] = !values.f_nan     ;remove small amp population
store_data,'tha_fb_scm1_3nT_bad',dd.x,dd.y,dlim=dlim,lim=lim & options,'tha_fb_scm1_3nT_bad','colors',250

get_data,'tha_fb_scm1_2nT',data=dd,dlim=dlim,lim=lim
dd.y[badv] = !values.f_nan
store_data,'tha_fb_scm1_2nT_good',dd.x,dd.y,dlim=dlim,lim=lim
store_data,'tha_fb_scm1_2nT_comb',data=['tha_fb_scm1_2nT','tha_fb_scm1_2nT_good'] & options,'tha_fb_scm1_2nT_comb','colors',[0,50]
get_data,'tha_fb_scm1_2nT',data=dd
dd.y[goodv] = !values.f_nan     ;remove small amp population
store_data,'tha_fb_scm1_2nT_bad',dd.x,dd.y,dlim=dlim,lim=lim & options,'tha_fb_scm1_2nT_bad','colors',250


ylim,'E_B2_comb',1d-3,1d-2,0
tplot,['E_B3_comb','E_B2_comb','tha_fb_edc12_3V_m_comb','tha_fb_scm1_3nT_comb','tha_fb_edc12_2V_m_comb','tha_fb_scm1_2nT_comb']
;Not two populations...just seems that the FBK doesn't work well when the
;Ew values are below some threshold.
;This minimum seems to change over time and may be related to plasma conditions?
;Anyways, filtering out the higher E/B ratios in the 160 Hz channel
;leaves the larger amplitude waves.

;OK, so let's see what FBK signals look like without this spurious population
ylim,'tha_fb_edc12_?V_m_good',0,4d-5,0
ylim,'tha_fb_scm1_?nT_good',0,0.025,0
tplot,['E_B3_good','E_B2_good','tha_fb_edc12_1V_m_good','tha_fb_edc12_2V_m_good','tha_fb_edc12_3V_m_good','tha_fb_scm1_1nT_good','tha_fb_scm1_2nT_good','tha_fb_scm1_3nT_good']



get_data,'tha_fb_edc12_1V_m_good',data=ddd,dlim=dlim,lim=lim
store_data,'tha_fb_edc12_1mV_m_good',ddd.x,1000*ddd.y,dlim=dlim,lim=lim & options,'tha_fb_edc12_1mV_m_good','ytitle','THA FBK [mV/m]!Cedc12 670Hz' & ylim,'tha_fb_edc12_1mV_m_good',0,0,0
get_data,'tha_fb_edc12_2V_m_good',data=ddd,dlim=dlim,lim=lim
store_data,'tha_fb_edc12_2mV_m_good',ddd.x,1000*ddd.y,dlim=dlim,lim=lim & options,'tha_fb_edc12_2mV_m_good','ytitle','THA FBK [mV/m]!Cedc12 160Hz' & ylim,'tha_fb_edc12_2mV_m_good',0,0,0
get_data,'tha_fb_edc12_3V_m_good',data=ddd,dlim=dlim,lim=lim
store_data,'tha_fb_edc12_3mV_m_good',ddd.x,1000*ddd.y,dlim=dlim,lim=lim & options,'tha_fb_edc12_3mV_m_good','ytitle','THA FBK [mV/m]!Cedc12 40Hz' & ylim,'tha_fb_edc12_3mV_m_good',0,0,0

get_data,'tha_fb_scm1_1nT_good',data=ddd,dlim=dlim,lim=lim
store_data,'tha_fb_scm1_1pT_good',ddd.x,1000*ddd.y,dlim=dlim,lim=lim & options,'tha_fb_scm1_1pT_good','ytitle','THA FBK [pT]!Cscm1 670Hz' & ylim,'tha_fb_scm1_1pT_good',0,0,0
get_data,'tha_fb_scm1_2nT_good',data=ddd,dlim=dlim,lim=lim
store_data,'tha_fb_scm1_2pT_good',ddd.x,1000*ddd.y,dlim=dlim,lim=lim & options,'tha_fb_scm1_2pT_good','ytitle','THA FBK [pT]!Cscm1 160Hz' & ylim,'tha_fb_scm1_2pT_good',0,0,0
get_data,'tha_fb_scm1_3nT_good',data=ddd,dlim=dlim,lim=lim
store_data,'tha_fb_scm1_3pT_good',ddd.x,1000*ddd.y,dlim=dlim,lim=lim & options,'tha_fb_scm1_3pT_good','ytitle','THA FBK [pT]!Cscm1 40Hz' & ylim,'tha_fb_scm1_3pT_good',0,0,0



store_data,'Ecomb_good',data=['tha_fb_edc12_1mV_m_good','tha_fb_edc12_2mV_m_good','tha_fb_edc12_3mV_m_good'] & options,'Ecomb_good','colors',[250,0,50]
options,'Ecomb_good','ytitle','THA FBK [mV/m]!Cedc12!CBlue=40Hz!CBlack=160Hz!C(good data only)'
store_data,'Bcomb_good',data=['tha_fb_scm1_1pT_good','tha_fb_scm1_2pT_good','tha_fb_scm1_3pT_good'] & options,'Bcomb_good','colors',[250,0,50]
options,'Bcomb_good','ytitle','THA FBK [pT]!Cscm1!CBlue=40Hz!CBlack=160Hz!C(good data only)'

store_data,'Ecomb_bad',data=['tha_fb_edc12_1mV_m_bad','tha_fb_edc12_2mV_m_bad','tha_fb_edc12_3mV_m_bad'] ;& options,'Ecomb_bad','colors',[0,50]
options,'Ecomb_bad','ytitle','THA FBK [mV/m]!Cedc12!CBlue=40Hz!CBlack=160Hz!C(bad data only)'
store_data,'Bcomb_bad',data=['tha_fb_scm1_1pT_bad','tha_fb_scm1_2pT_bad','tha_fb_scm1_3pT_bad'] ;& options,'Bcomb_bad','colors',[0,50]
options,'Bcomb_bad','ytitle','THA FBK [pT]!Cscm1!CBlue=40Hz!CBlack=160Hz!C(bad data only)'

options,'E_B2_good','colors',0
options,['E_B1_good','E_B3_good','E_B2_good'],'psym',4
options,['cB_E1_good','cB_E2_good','cB_E3_good'],'psym',4
ylim,['E_B1_good','E_B2_good','E_B3_good'],0,0.006,0
options,['E_B1_good','E_B2_good','E_B3_good'],'panel_size',0.5



;tplot,['E_B1_good','E_B2_good','E_B3_good','Ecomb_good','Bcomb_good']
tplot,['OMNI_HRO_1min_proton_density_smoothed_detrend','PeakDet_2X_smoothed_detrend','cB_E1_good','cB_E2_good','cB_E3_good','Ecomb_good','Bcomb_good']
tplot,['E_B3_bad','E_B2_bad','Ecomb_bad','Bcomb_bad']


store_data,'E2_good_bad_comb',data=['tha_fb_edc12_2V_m_good','tha_fb_edc12_2V_m_bad']; & options,'E2_good_bad_comb','colors',[50,0]
store_data,'E3_good_bad_comb',data=['tha_fb_edc12_3V_m_good','tha_fb_edc12_3V_m_bad']; & options,'E3_good_bad_comb','colors',[50,0]
store_data,'B2_good_bad_comb',data=['tha_fb_scm1_2nT_good','tha_fb_scm1_2nT_bad']; & options,'B2_good_bad_comb','colors',[50,0]
store_data,'B3_good_bad_comb',data=['tha_fb_scm1_3nT_good','tha_fb_scm1_3nT_bad']; & options,'B3_good_bad_comb','colors',[50,0]
tplot,'??_good_bad_comb'



tplot,['tha_fb_scm1_3nT','E_B3_good','E_B3_bad','tha_fb_scm1_3nT_good','tha_fb_scm1_3nT_bad']

;The E/B ratio is remarkably stable at 0.003-0.004




;-------------------------------------------------------------
;Reasons I think the 160 Hz signal is just a response to a 40 Hz wave


;Peaks in the 160 Hz channel almost always correspond to the peaks in the
;40 Hz channel, but the 40 Hz channel signal is larger. The only peaks that
;show up in the 670 Hz channel correspond to peaks in 40 Hz.

;The 160 Hz Ew values tend to go to zero after peaks whereas the 40 Hz values
;are always at an elevated level.

;E/B in 40 Hz channel is very consistent (~0.002), whereas E/B for 160 Hz
;fluctuates b/t two values: 0.003 for the peaks and 0.007 for the
;smaller amplitudes. E/B for 670 Hz is always about 0.003.
;Seems that the 0.007 values are caused by the Ew values being artificially
;limited in the FBK data.
;NOTE: Amps in the 160 Hz channel for the "noise" that corresponds to the
;E/B=0.007 values. E ~ 1.5d-5 V/m (.015 mV/m); Bw~0.00002nT (0.02 pT)
;I think the ~0.002 values are the actual values of the observed waves (at least
;near 40 Hz).

;Waves after ~23 UT get larger but maintain the same E/B value in 40 Hz bin.






;------------------------------------------------
;Comparison of observed THEMIS-A FBK waves with whistler mode.
;Calculate cB/E for whistler mode
;c in m/s
;B in Tesla
;E in V/m
;------------------------------------------------

;Observed cB/E values at 22 UT for FBK data
;40 Hz = 170-210
;160 Hz = 80-120
;670 Hz = ~50-130 (not much data)


;Let's use the whistler dispersion relation to estimate what cB/E should be
;for FA whistler waves at various freqs.
;cB/E = n ;for FA waves
;B in Tesla, c in m/s, E in V/m

;density values range from about 1-5 cm-3
;Bo value is 74 nT at 22 UT
path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan11/'
tplot_restore,filename=path+'tha_bmag11.tplot'


cpd = cold_plasma_dispersion(epol=1.6,freq=40.,dens=1.,Bo=74.)
print,cpd.n

;= 31 (for density=1, 40 Hz)
;= 70 (for density=5, 40 Hz)
;= 22 (for density=1, 80 Hz)
;= 50 (for density=5, 80 Hz)
;= 16 (for density=1, 160 Hz)
;= 36 (for density=5, 160 Hz)
;Note the above values don't change much with increasing wave normal angle


;Predicted whistler cB/E range are all lower than the observed cB/E values in
;40 Hz bin, suggesting that observed wave has a stronger magnetic component.
;Taking the range of cB/E values from 170-210 in the
;40 Hz FBK bin, observed is larger than predicted by
;   5.5-6.8x   (for density=1, 40 Hz)
;   2.4-3.0x  (for density=5, 40 Hz)
;   7.7-9.5x   (for density=1, 80 Hz)
;   3.4-4.2x  (for density=5, 80 Hz)
;   10.6-13.1x (for density=1, 160 Hz)
;   4.7-5.8x   (for density=5, 160 Hz)
;So FA whistler waves at 40 Hz should have a cB/E at least 2.4x higher than observed,




;------------------------------------------------
;Comparison of observed THEMIS-A FBK waves with magnetosonic mode.
;------------------------------------------------

;Near 20 UT. THA is at about L=5-6 here. It doesn't really see any
;waves but the E/B ratio is about the same as 22 UT, suggesting that it's seeing
;the same thing the entire time. May be useful for a
;more direct comparison to Boardsen16 values since he has statistics for this region.




;------------------------------------------------------
;Find E/B values of Magnetosonic waves from Boardsen16
;--Note that his values only go out to 5-6 RE, and we're at ~8-9 RE here.

;Magnetic latitude of THEMIS A ranges from -5 (22 UT) to -7 (23:30 UT)
;Fcp (proton cyclotron freq, aka fci) ranges from 0.96 to 1.1 Hz
;So, if we assume a freq of ~40 Hz, f/fcp = 36 - 42

;--> plausible range of log10[(V/m)^2/Hz] values from Boardsen16 are -9 to -10 dB
;or, 1d-9 to 1d-10 (V/m)^2/Hz

;--> plausible range of log10[(nT^2/Hz)] values from Boardsen16 are -5 to -6 dB
;or, 1d-5 to 1d-6 nT^2/Hz


;;;;;--> plausible range of log10[(nT^2/Hz)] values from Boardsen16 are -5.5 to -6.2
;;;;;or, 3.16d-6 to 6.31d-7  nT^2/Hz


;Calculate max and min likely E/B ratios.
E_Bmax_Boardsen = sqrt(1d-9/1d-6)
E_Bmin_Boardsen = sqrt(1d-10/1d-5)

cB_E = 3d8/1d9/E_Bmax_Boardsen
print,cB_E
;       9.5
cB_E = 3d8/1d9/E_Bmin_Boardsen
print,cB_E
;       95

;This range of cB/E is pretty broad and encompasses the predicted whistler range (~30-70),
;and goes above it, but is below the observed range for 40 Hz FBK waves of 170-210.




























thm_load_fft,probe='e'
ylim,['the_fff_32_edc12','the_fff_32_edc34','the_fff_32_scm2','the_fff_32_scm3'],30,1000,1


thm_load_fft,probe='d'
ylim,['thd_fff_32_edc12','thd_fff_32_edc34','thd_fff_32_scm2','thd_fff_32_scm3'],30,1000,1


;Determine if the THD waves near end of day are magnetosonic. They
;look very similar to the THA waves during time of the conjunction.

get_data,'thd_fff_32_edc12',data=es,dlim=dlim  ;(V/m)^2/Hz
get_data,'thd_fff_32_scm2',data=bs   ;nT^2/Hz

store_data,'e_b_rat',es.x,es.y/bs.y,es.v,dlim=dlim
tplot,['e_b_rat','thd_fff_32_edc12','thd_fff_32_scm2']
options,'e_b_rat','ztitle','E/B'
options,'e_b_rat','ytitle','E/B'
ylim,'e_b_rat',10,300,1

;From Boardsen16, Fig 10, 11
alog10(nT^2/Hz)=-6.        --> 1d-6 ;nT^2/Hz
alog10((V/m)^2/Hz) = -10   --> 1d-10  ;(V/m)^2/Hz

;From THD spectra
Ew --> 2d-11   ;(V/m)^2/Hz
Bw --> 5d-6    ;nT^2/Hz

;Typical E2/B2 ratio from THD is 1d-5
;From Boardsen paper typical ratio is ~1d-4.
;GOOD EVIDENCE THAT THESE ARE MAGNETOSONIC WAVES ON THD. THIS MEANS
;THIS IS FURTHER PROOF THAT THE WAVES WE'RE SEEING IN THE FBK ON THA
;ARE MAGNETOSONIC.

;From Chaston15 (KAWs) Fig3 at 40 Hz I'm finding a E2/B2 ratio of
;0.02, which is too high for what we observe.









;------------------------------
;Look for EMIC waves
split_vec,'tha_evec11'
rbsp_spec,'tha_evec11_x',npts=64/2.,n_ave=2.
rbsp_spec,'tha_evec11_y',npts=64/2.,n_ave=2.
rbsp_spec,'tha_evec11_z',npts=64/2.,n_ave=2.
ylim,'tha_evec11_?_SPEC',0,0.2
zlim,'tha_evec11_x_SPEC',1d-3,1d1,1

split_vec,'tha_bvec11'
rbsp_spec,'tha_bvec11_x',npts=64/2.,n_ave=2.
rbsp_spec,'tha_bvec11_y',npts=64/2.,n_ave=2.
rbsp_spec,'tha_bvec11_z',npts=64/2.,n_ave=2.
ylim,'tha_bvec11_?_SPEC',0,0.2
zlim,'tha_bvec11_?_SPEC',1d-3,1d1,1
;zlim,'tha_bvec11_?_SPEC',1d-8,1d0,1

store_data,'Exspec',data=['tha_evec11_x_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Eyspec',data=['tha_evec11_y_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Ezspec',data=['tha_evec11_z_SPEC','tha_fci_Hep','tha_fci_Op']
ylim,'E?spec',0,0.5


store_data,'Bxspec',data=['tha_bvec11_x_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Byspec',data=['tha_bvec11_y_SPEC','tha_fci_Hep','tha_fci_Op']
store_data,'Bzspec',data=['tha_bvec11_z_SPEC','tha_fci_Hep','tha_fci_Op']
ylim,'B?spec',0,0.5


;THEMIS A may show some EMIC waves...mostly after 23 UT
tplot,['tha_bvec11','B?spec']
tplot,['tha_evec11','E?spec']
