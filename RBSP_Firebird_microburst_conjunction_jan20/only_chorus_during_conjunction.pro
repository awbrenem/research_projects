;Shows that the only waves that exist during the conjunction at
;19:44UT are chorus waves. Therefore they are the only ones that can be
;causing the microbursts.


fileroot = '~/Desktop/Research/RBSP_FIREBIRD_microburst_conjunction_jan20/IDL/'
tplot_restore,filenames=fileroot+'aaron_fb4_rbspa.tplot'


date = '2016-01-20'
timespan,date

rbsp_load_efw_fbk,probe='a',type='calibrated'
rbsp_load_efw_spec,probe='a',type='calibrated'


path ='~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EFW/'
cdf2tplot,path+'rbspa_efw-l2_esvy_despun_20160120_v02.cdf'
tplot,'efield_mgse'

rbsp_split_fbk,'a'


;timespan,'2016-01-20/19:00',60,/minutes
timespan,'2016-01-20/19:43',2,/minutes

ylim,['rbspa_efw_64_spec0','rbspa_efw_64_spec4'],20,8000,1


ylim,'*fbk1_7pk*',0,5
tplot,['hr0_0',$  ;'rbspa_fbk1_7pk_6',$
'rbspa_fbk1_7pk_5',$
'rbspa_fbk1_7pk_4',$
'rbspa_fbk1_7pk_3',$
'rbspa_fbk1_7pk_2',$
'rbspa_fbk1_7pk_1',$
'rbspa_fbk1_7pk_0',$
;'efield_mgse',$
'rbspa_efw_64_spec0']

timebar,'2016-01-20/19:44:00'


ylim,'*fbk2_7pk*',0,200

tplot,['hr0_0',$ ;'rbspa_fbk2_7pk_6',$
'rbspa_fbk2_7pk_5',$
'rbspa_fbk2_7pk_4',$
'rbspa_fbk2_7pk_3',$
'rbspa_fbk2_7pk_2',$
'rbspa_fbk2_7pk_1',$
'rbspa_fbk2_7pk_0',$
;'efield_mgse',$
'rbspa_efw_64_spec4']

timebar,'2016-01-20/19:44:00'





;-------------------------------------------------
;Create binary variables for correlation analysis
;-------------------------------------------------

;combine all FB4 quantities for better signal-noise
get_data,'hr0_0',tt,h0
get_data,'hr0_1',tt,h1
get_data,'hr0_2',tt,h2
get_data,'hr0_3',tt,h3
get_data,'hr0_4',tt,h4
get_data,'hr0_5',tt,h5

store_data,'hr0_T',tt,h0+h1+h2+h3+h4+h5
tplot,'hr0_T'

tinterpol_mxn,'hr0_T','rbspa_fbk2_7pk_5',newname='hr0_T'


rbsp_detrend,'hr0_T',2.

get_data,'hr0_T_detrend',tt,uu

goo = where(uu ge 50.)
new = replicate(0.,n_elements(uu))
new[goo] = 1.
store_data,'hr0_T_bin',tt,new
ylim,'hr0_T_bin',0,2
tplot,['hr0_T','hr0_T_detrend','hr0_T_bin']




rbsp_detrend,'rbspa_fbk2_7pk_5',2.

get_data,'rbspa_fbk2_7pk_5_detrend',tt,uu

goo = where(uu ge 50.)
new = replicate(0.,n_elements(uu))
new[goo] = 1.
store_data,'rbspa_fbk2_7pk_5_T_bin',tt,new
ylim,'rbspa_fbk2_7pk_5_T_bin',0,2
tplot,['hr0_T','hr0_T_detrend','hr0_T_bin','rbspa_fbk2_7pk_5_T_bin']

stop


















;FFT the FB and FBK counts to see similarities.
.compile /Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/signal-analysis/plot_wavestuff.pro

;rbsp_detrend,'hr0_0',20.
;rbsp_detrend,'rbspa_fbk2_7pk_5',20.
;tplot,'hr0_0_detrend'

t0 = time_double('2016-01-20/19:43')
t1 = time_double('2016-01-20/19:45')
;t0 = time_double('2016-01-20/19:43:55')
;t1 = time_double('2016-01-20/19:44:10')


v = tsample('rbspa_fbk2_7pk_5_T_bin',[t0,t1],times=tms)
store_data,'fbk',tms,v

;tinterpol_mxn,'hr0_0_detrend','fbk',newname='hr0_0t'
v = tsample('hr0_T_bin',[t0,t1],times=tms)
store_data,'hr0',tms,v


get_data,'fbk',tms,fbkk
get_data,'hr0',tms,hr00

store_data,'comb',tms,[[fbkk],[hr00]]



plot_wavestuff,'comb',/psd,extra_psd={yrange:[-30,0],ylog:0,xlog:0,xrange:[0.1,4]};,/postscript




tplot,['hr0','fbk']
store_data,['wvhr0','wvfbk'],/delete
store_data,'*wavelet*',/delete
plot_wavestuff,'comb',/psd,extra_psd={yrange:[20,50],ylog:0,xlog:0,xrange:[0.1,6]},$
/wavelet,/samescale,dscale=0.1,/nodelete
copy_data,'waveletx','wvhr0'
copy_data,'wavelety','wvfbk'


ylim,['wvhr0','wvfbk'],0,4,0
zlim,['wvhr0','wvfbk'],2d-4,1.8d4,1
tplot,['wvhr0','wvfbk']



plot_wavestuff,'comb',/psd,extra_psd={yrange:[20,50],ylog:0,xlog:1,xrange:[0.1,6]},/postscript
