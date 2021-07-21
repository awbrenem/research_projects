;Load the output file from create_master_conjunction_list_part3.pro. This file contains all of the 
;FIREBIRD/RBSP conjunctions as well as info on wave amplitudes during them. 

;For plotting values see plot_master_conjunction_list_part3.pro

;Note that there are many conjunctions where there's no FIREBIRD burst data during the 
;conjunction. These end up with "tmin" times (times of closest approach) of 0000-00-00/00:00. 
;I'm not including these in the tplot files at the end. 
;However, they are included in the non-tplot data arrays




path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/research_projects/RBSP_Firebird_microburst_conjunctions_all/RBSP_FB_final_conjunction_lists/'
fb = '3' ;FIREBIRD 3 or 4
rb = 'a' ;RBSP a or b
file = 'RBSP'+rb+'_FU'+fb+'_conjunction_values.txt'


ft= [7,7,7,4,4,4,4,4,4,4,4,4,4,4,4,7,4,4,4,4,4,4,7,7,7,7,7,7,7,7,4,4,4,4,7,7,7,7,7,7,7,7,4,4,4,4,4,4,4,4,7,7,7,7,7,7,7,7,7,7,7,7,7,7]
fns = ['FIELD01','FIELD02','FIELD03','FIELD04','FIELD05','FIELD06','FIELD07','FIELD08','FIELD09','FIELD10','FIELD11','FIELD12','FIELD13','FIELD14','FIELD15','FIELD16','FIELD17','FIELD18','FIELD19','FIELD20','FIELD21','FIELD22','FIELD23','FIELD24','FIELD25','FIELD26','FIELD27','FIELD28','FIELD29','FIELD30','FIELD31','FIELD32','FIELD33','FIELD34','FIELD35','FIELD36','FIELD37','FIELD38','FIELD39','FIELD40','FIELD41','FIELD42','FIELD43','FIELD44','FIELD45','FIELD46','FIELD47','FIELD48','FIELD49','FIELD50','FIELD51','FIELD52','FIELD53','FIELD54','FIELD55','FIELD56','FIELD57','FIELD58','FIELD59','FIELD60','FIELD61','FIELD62','FIELD63','FIELD64']
floc = [0,20,40,64,73,81,90,98,108,118,128,139,155,167,176,184,192,200,217,237,257,277,314,334,353,374,401,421,440,461,478,498,518,538,575,595,614,635,662,682,701,722,730,738,746,754,762,769,777,785,794,802,810,818,826,834,842,850,858,866,874,882,890,898]
fg = indgen(64)

template = {version:1.,$
       datastart:49L,$
       delimiter:32B,$
       missingvalue:!values.f_nan,$
       commentsymbol:'',$
       fieldcount:64,$
       fieldtypes:ft,$
       fieldnames:fns,$
       fieldlocations:floc,$
       fieldgroups:fg}



vals = read_ascii(path+file,template=template)


t0 = vals.FIELD01
t1 = vals.FIELD02


;There are a few conjunctions with zero length. Get rid of these

;Find average conjunction duration
tdiff_each_conj = time_double(t1) - time_double(t0)

goo = where(tdiff_each_conj eq 0.)
;IDL> help,goo
;GOO  LONG      = Array[6]
;These conjunctions that have zero time length (almost all of them)
good = where(tdiff_each_conj ne 0.)




t0 = t0[good]
t1 = t1[good]
tmin = vals.FIELD03[good]

goonan = where(tmin ne '0000-00-00/00:00:00')
tmin2 = time_double(tmin[goonan])


;Flag tplot variable showing all the conjunctions.
flag = replicate(1.,n_elements(goonan))
store_data,'allconjunctions',time_double(t0[goonan]),flag
ylim,'allconjunctions',0,2
options,'allconjunctions','psym',4
options,'allconjunctions','panel_size',0.5

;Flag tplot variable showing only conjunctions with hires FB data
goohr = where(finite(vals.FIELD13[good[goonan]]) ne 0.)
flag = replicate(1.,n_elements(goohr))
store_data,'allconjunctions_hr',time_double(t0[goohr]),flag
ylim,'allconjunctions_hr',0,2
options,'allconjunctions_hr','psym',4
options,'allconjunctions_hr','panel_size',0.5


store_data,'Lrb',tmin2,float(vals.FIELD04[good[goonan]])
store_data,'Lfb',tmin2,float(vals.FIELD05[good[goonan]])
store_data,'MLTrb',tmin2,float(vals.FIELD06[good[goonan]])
store_data,'MLTfb',tmin2,float(vals.FIELD07[good[goonan]])
store_data,'distmin',tmin2,float(vals.FIELD08[good[goonan]]) & ylim,'distmin',0,2
store_data,'dLmin',tmin2,float(vals.FIELD09[good[goonan]]) & ylim,'dLmin',0,2
store_data,'dMLTmin',tmin2,float(vals.FIELD10[good[goonan]]) & ylim,'dMLTmin',0,2

;counts (survey)
store_data,'col',tmin2,float(vals.FIELD11[good[goonan]])
store_data,'sur',tmin2,float(vals.FIELD12[good[goonan]])
;flux (HIRES)
store_data,'colHR',tmin2,float(vals.FIELD13[good[goonan]])
store_data,'surHR',tmin2,float(vals.FIELD14[good[goonan]])

store_data,'FBb',tmin2,float(vals.FIELD15[good[goonan]])
store_data,'emfb',tmin2,float(vals.FIELD16[good[goonan]])
store_data,'b1b',tmin2,float(vals.FIELD17[good[goonan]])
store_data,'b2b',tmin2,float(vals.FIELD18[good[goonan]])



store_data,'SpecETot_lf',tmin2,float(vals.FIELD19[good[goonan]])
store_data,'SpecEMax_lf',tmin2,float(vals.FIELD20[good[goonan]]) & ylim,'SpecEMax_lf',1d-5,100,1
store_data,'SpecEAvg_lf',tmin2,float(vals.FIELD21[good[goonan]]) & ylim,'SpecEAvg_lf',1d-5,100,1
store_data,'SpecEMed_lf',tmin2,float(vals.FIELD22[good[goonan]]) & ylim,'SpecEMed_lf',1d-5,100,1

store_data,'SpecETot_lb',tmin2,float(vals.FIELD23[good[goonan]])
store_data,'SpecEMax_lb',tmin2,float(vals.FIELD24[good[goonan]]) & ylim,'SpecEMax_lb',1d-5,100,1
store_data,'SpecEAvg_lb',tmin2,float(vals.FIELD25[good[goonan]]) & ylim,'SpecEMax_lb',1d-5,100,1
store_data,'SpecEMed_lb',tmin2,float(vals.FIELD26[good[goonan]]) & ylim,'SpecEMax_lb',1d-5,100,1


store_data,'SpecETot_ub',tmin2,float(vals.FIELD27[good[goonan]])
store_data,'SpecEMax_ub',tmin2,float(vals.FIELD28[good[goonan]]) & ylim,'SpecEMax_ub',1d-5,100,1
store_data,'SpecEAvg_ub',tmin2,float(vals.FIELD29[good[goonan]]) & ylim,'SpecEMax_ub',1d-5,100,1
store_data,'SpecEMed_ub',tmin2,float(vals.FIELD30[good[goonan]]) & ylim,'SpecEMax_ub',1d-5,100,1

store_data,'SpecBTot_lf',tmin2,float(vals.FIELD31[good[goonan]])
store_data,'SpecBMax_lf',tmin2,float(vals.FIELD32[good[goonan]]) & ylim,'SpecBMax_lf',1d-6,1,1
store_data,'SpecBAvg_lf',tmin2,float(vals.FIELD33[good[goonan]]) & ylim,'SpecBAvg_lf',1d-7,1d-4,1
store_data,'SpecBMed_lf',tmin2,float(vals.FIELD34[good[goonan]]) & ylim,'SpecBMed_lf',1d-7,1d-4,1

store_data,'SpecBTot_lb',tmin2,float(vals.FIELD35[good[goonan]])
store_data,'SpecBMax_lb',tmin2,float(vals.FIELD36[good[goonan]]) & ylim,'SpecBMax_lb',1d-6,1,1
store_data,'SpecBAvg_lb',tmin2,float(vals.FIELD37[good[goonan]]) & ylim,'SpecBAvg_lb',1d-7,1d-4,1
store_data,'SpecBMed_lb',tmin2,float(vals.FIELD38[good[goonan]]) & ylim,'SpecBMed_lb',1d-7,1d-4,1

store_data,'SpecBTot_ub',tmin2,float(vals.FIELD39[good[goonan]])
store_data,'SpecBMax_ub',tmin2,float(vals.FIELD40[good[goonan]]) & ylim,'SpecBMax_ub',1d-6,1,1
store_data,'SpecBAvg_ub',tmin2,float(vals.FIELD41[good[goonan]]) & ylim,'SpecBAvg_ub',1d-7,1d-4,1
store_data,'SpecBMed_ub',tmin2,float(vals.FIELD42[good[goonan]]) & ylim,'SpecBMed_ub',1d-7,1d-4,1

store_data,'fb7E3',tmin2,float(vals.FIELD43[good[goonan]])
store_data,'fb7E4',tmin2,float(vals.FIELD44[good[goonan]])
store_data,'fb7E5',tmin2,float(vals.FIELD45[good[goonan]])
store_data,'fb7E6',tmin2,float(vals.FIELD46[good[goonan]])

store_data,'fb7B3',tmin2,float(vals.FIELD47[good[goonan]])
store_data,'fb7B4',tmin2,float(vals.FIELD48[good[goonan]])
store_data,'fb7B5',tmin2,float(vals.FIELD49[good[goonan]])
store_data,'fb7B6',tmin2,float(vals.FIELD50[good[goonan]])

store_data,'fb13E6',tmin2,float(vals.FIELD51[good[goonan]])
store_data,'fb13E7',tmin2,float(vals.FIELD52[good[goonan]])
store_data,'fb13E8',tmin2,float(vals.FIELD53[good[goonan]])
store_data,'fb13E9',tmin2,float(vals.FIELD54[good[goonan]])
store_data,'fb13E10',tmin2,float(vals.FIELD55[good[goonan]])
store_data,'fb13E11',tmin2,float(vals.FIELD56[good[goonan]])
store_data,'fb13E12',tmin2,float(vals.FIELD57[good[goonan]])

store_data,'fb13B6',tmin2,float(vals.FIELD58[good[goonan]])
store_data,'fb13B7',tmin2,float(vals.FIELD59[good[goonan]])
store_data,'fb13B8',tmin2,float(vals.FIELD60[good[goonan]])
store_data,'fb13B9',tmin2,float(vals.FIELD61[good[goonan]])
store_data,'fb13B10',tmin2,float(vals.FIELD62[good[goonan]])
store_data,'fb13B11',tmin2,float(vals.FIELD63[good[goonan]])
store_data,'fb13B12',tmin2,float(vals.FIELD64[good[goonan]])


options,'fb13E6','ytitle','FBK Ew(mV/m)!C50-100Hz'
options,'fb13E7','ytitle','FBK Ew(mV/m)!C100-200Hz'
options,'fb13E8','ytitle','FBK Ew(mV/m)!C200-400Hz'
options,'fb13E9','ytitle','FBK Ew(mV/m)!C400-800Hz'
options,'fb13E10','ytitle','FBK Ew(mV/m)!C800-1600Hz'
options,'fb13E11','ytitle','FBK Ew(mV/m)!C1600-3200Hz'
options,'fb13E12','ytitle','FBK Ew(mV/m)!C3200-6500Hz'

options,'fb13B6','ytitle','FBK Bw(pT)!C50-100Hz'
options,'fb13B7','ytitle','FBK Bw(pT)!C100-200Hz'
options,'fb13B8','ytitle','FBK Bw(pT)!C200-400Hz'
options,'fb13B9','ytitle','FBK Bw(pT)!C400-800Hz'
options,'fb13B10','ytitle','FBK Bw(pT)!C800-1600Hz'
options,'fb13B11','ytitle','FBK Bw(pT)!C1600-3200Hz'
options,'fb13B12','ytitle','FBK Bw(pT)!C3200-6500Hz'

options,'fb7E3','ytitle','FBK Ew(mV/m)!C50-100Hz'
options,'fb7E4','ytitle','FBK Ew(mV/m)!C200-400Hz'
options,'fb7E5','ytitle','FBK Ew(mV/m)!C800-1600Hz'
options,'fb7E6','ytitle','FBK Ew(mV/m)!C3200-6500Hz'

options,'fb7B3','ytitle','FBK Bw(pT)!C50-100Hz'
options,'fb7B4','ytitle','FBK Bw(pT)!C200-400Hz'
options,'fb7B5','ytitle','FBK Bw(pT)!C800-1600Hz'
options,'fb7B6','ytitle','FBK Bw(pT)!C3200-6500Hz'


options,'SpecBTot_lf','ytitle','Spec!CIntegrated pT^2/Hz!C10Hz<f<0.1fce'
options,'SpecBTot_lb','ytitle','Spec!CIntegrated pT^2/Hz!Clower band chorus'
options,'SpecBTot_ub','ytitle','Spec!CIntegrated pT^2/Hz!Cupper band chorus'
options,'SpecBMax_lf','ytitle','Spec!CMax pT^2/Hz!C10Hz<f<0.1fce'
options,'SpecBMax_lb','ytitle','Spec!CMax pT^2/Hz!Clower band chorus'
options,'SpecBMax_ub','ytitle','Spec!CMax pT^2/Hz!Cupper band chorus'
options,'SpecBAvg_lf','ytitle','Spec!CAvg pT^2/Hz!C10Hz<f<0.1fce'
options,'SpecBAvg_lb','ytitle','Spec!CAvg pT^2/Hz!Clower band chorus'
options,'SpecBAvg_ub','ytitle','Spec!CAvg pT^2/Hz!Cupper band chorus'

;All conjunctions, except the 0000-00-00/00:00 ones





;-----------------------------------------------------------
;Now add in the output from Mike Shumko's microburst detection program. 
;I'm adding this after the fact b/c this is the sort of program that probably will 
;be rerun a bunch of times and I don't want to recreate the entire master list every time 
;-----------------------------------------------------------



microbursts = load_firebird_microburst_list(fb)
tmb = time_double(microbursts.time)
tconj = time_double(tmin2)

mb_number = replicate(!values.f_nan,n_elements(tmin2))
mb_chavg = replicate(!values.f_nan,n_elements(tmin2),6)
mb_chmax = replicate(!values.f_nan,n_elements(tmin2),6)
mb_chmin = replicate(!values.f_nan,n_elements(tmin2),6)
mb_chmed = replicate(!values.f_nan,n_elements(tmin2),6)
mb_totaltime = replicate(!values.f_nan,n_elements(tmin2),6)  ;Time separating first and last detected microburst. Used to find avg flux
;mb_ratio = replicate(!values.f_nan,n_elements(tmin2)) ;ratio of amplitudes for ch1 and ch6 (poor man's spectral shape)


;Extract the detected microbursts with +/- some time range about the closest approach for each conjunction
for i=0,n_elements(tmin2)-1 do begin $
       goomb = where((tmb gt tconj[i]-60*5.) and (tmb lt tconj[i]+60*5.)) & $
       if goomb[0] ne -1 then begin 
              mb_number[i] = n_elements(goomb)
              mb_chmax[i,0] = max(microbursts.flux_ch1[goomb],/nan)
              mb_chmin[i,0] = min(microbursts.flux_ch1[goomb],/nan)
              mb_chavg[i,0] = mean(microbursts.flux_ch1[goomb],/nan)
              mb_chmed[i,0] = median(microbursts.flux_ch1[goomb])

              mb_chmax[i,1] = max(microbursts.flux_ch2[goomb],/nan)
              mb_chmin[i,1] = min(microbursts.flux_ch2[goomb],/nan)
              mb_chavg[i,1] = mean(microbursts.flux_ch2[goomb],/nan)
              mb_chmed[i,1] = median(microbursts.flux_ch2[goomb])

              mb_chmax[i,2] = max(microbursts.flux_ch3[goomb],/nan)
              mb_chmin[i,2] = min(microbursts.flux_ch3[goomb],/nan)
              mb_chavg[i,2] = mean(microbursts.flux_ch3[goomb],/nan)
              mb_chmed[i,2] = median(microbursts.flux_ch3[goomb])

              mb_chmax[i,3] = max(microbursts.flux_ch4[goomb],/nan)
              mb_chmin[i,3] = min(microbursts.flux_ch4[goomb],/nan)
              mb_chavg[i,3] = mean(microbursts.flux_ch4[goomb],/nan)
              mb_chmed[i,3] = median(microbursts.flux_ch4[goomb])

              mb_chmax[i,4] = max(microbursts.flux_ch5[goomb],/nan)
              mb_chmin[i,4] = min(microbursts.flux_ch5[goomb],/nan)
              mb_chavg[i,4] = mean(microbursts.flux_ch5[goomb],/nan)
              mb_chmed[i,4] = median(microbursts.flux_ch5[goomb])

              mb_chmax[i,5] = max(microbursts.flux_ch6[goomb],/nan)
              mb_chmin[i,5] = min(microbursts.flux_ch6[goomb],/nan)
              mb_chavg[i,5] = mean(microbursts.flux_ch6[goomb],/nan)
              mb_chmed[i,5] = median(microbursts.flux_ch6[goomb])
              if n_elements(goomb) gt 1 then mb_totaltime[i] = tmb[max(goomb)] - tmb[goomb[0]] else mb_totaltime[i] = 0.

              print,'i=',i,' ',time_string(tmin2[i]),' # = ',strtrim(floor(mb_number[i]),2),' ',mb_chmax[i,0],' ',mb_chmin[i,0],' ',mb_chavg[i,0],' ',mb_chmed[i,0]

       endif
endfor


store_data,'mb_number',tmin2,mb_number
store_data,'mb_totaltime',tmin2,mb_totaltime
store_data,'mb_chavg',tmin2,mb_chavg
store_data,'mb_chmed',tmin2,mb_chmed
store_data,'mb_chmax',tmin2,mb_chmax
store_data,'mb_chmin',tmin2,mb_chmin

options,'mb_number','ytitle','#uB during conjunction'
options,'mb_totaltime','ytitle','delta-t b/t first and last!Cdetected uB for each conjunction'
options,'mb_chavg','ytitle','average uB flux!Cduring each conjunction'
options,'mb_chmed','ytitle','median uB flux!Cduring each conjunction'
options,'mb_chmin','ytitle','min uB flux!Cduring each conjunction'
options,'mb_chmax','ytitle','max uB flux!Cduring each conjunction'



Lrb=vals.FIELD04[good]
Lfb=vals.FIELD05[good]
MLTrb=vals.FIELD06[good]
MLTfb=vals.FIELD07[good]
distmin=vals.FIELD08[good]
dLmin=vals.FIELD09[good]
dMLTmin=vals.FIELD10[good]

col=vals.FIELD11[good]
sur=vals.FIELD12[good]
colHR=vals.FIELD13[good]
surHR=vals.FIELD14[good]

FBb=vals.FIELD15[good]
emfb=vals.FIELD16[good]
b1b=vals.FIELD17[good]
b2b=vals.FIELD18[good]

SpecETot_lf=vals.FIELD19[good]
SpecEMax_lf=vals.FIELD20[good]
SpecEAvg_lf=vals.FIELD21[good]
SpecEMed_lf=vals.FIELD22[good]

SpecETot_lb=vals.FIELD23[good]
SpecEMax_lb=vals.FIELD24[good]
SpecEAvg_lb=vals.FIELD25[good]
SpecEMed_lb=vals.FIELD26[good]

SpecETot_ub=vals.FIELD27[good]
SpecEMax_ub=vals.FIELD28[good]
SpecEAvg_ub=vals.FIELD29[good]
SpecEMed_ub=vals.FIELD30[good]

SpecBTot_lf=vals.FIELD31[good]
SpecBMax_lf=vals.FIELD32[good]
SpecBAvg_lf=vals.FIELD33[good]
SpecBMed_lf=vals.FIELD34[good]

SpecBTot_lb=vals.FIELD35[good]
SpecBMax_lb=vals.FIELD36[good]
SpecBAvg_lb=vals.FIELD37[good]
SpecBMed_lb=vals.FIELD38[good]

SpecBTot_ub=vals.FIELD39[good]
SpecBMax_ub=vals.FIELD40[good]
SpecBAvg_ub=vals.FIELD41[good]
SpecBMed_ub=vals.FIELD42[good]

fb7E3=vals.FIELD43[good]
fb7E4=vals.FIELD44[good]
fb7E5=vals.FIELD45[good]
fb7E6=vals.FIELD46[good]

fb7B3=vals.FIELD47[good]
fb7B4=vals.FIELD48[good]
fb7B5=vals.FIELD49[good]
fb7B6=vals.FIELD50[good]

fb13E6=vals.FIELD51[good]
fb13E7=vals.FIELD52[good]
fb13E8=vals.FIELD53[good]
fb13E9=vals.FIELD54[good]
fb13E10=vals.FIELD55[good]
fb13E11=vals.FIELD56[good]
fb13E12=vals.FIELD57[good]

fb13B6=vals.FIELD58[good]
fb13B7=vals.FIELD59[good]
fb13B8=vals.FIELD60[good]
fb13B9=vals.FIELD61[good]
fb13B10=vals.FIELD62[good]
fb13B11=vals.FIELD63[good]
fb13B12=vals.FIELD64[good]





end
