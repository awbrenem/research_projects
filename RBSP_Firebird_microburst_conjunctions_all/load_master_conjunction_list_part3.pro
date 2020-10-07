;Load the output file from create_master_conjunction_list_part3.pro. This file contains all of the 
;FIREBIRD/RBSP conjunctions as well as info on wave amplitudes during them. 

;For plotting values see plot_master_conjunction_list_part3.pro

;Note that there are many conjuncdtions where there's no FIREBIRD burst data during the 
;conjunction. These end up with "tmin" times (times of closest approach) of 0000-00-00/00:00. 
;I'm not including these in the tplot files at the end. 
;However, they are included in the non-tplot data arrays




path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_Colpitts_Chen/RBSP_FB_final_conjunction_lists/'
file = 'RBSPa_FU3_conjunction_values.txt'


ft = [7,7,7,4,4,4,4,4,4,4,4,4,3,3,3,4,4,4,4,4,7,7,7,4,7,7,7,4,4,4,4,4,7,7,7,4,7,7,7,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
fns = ['FIELD01','FIELD02','FIELD03','FIELD04','FIELD05','FIELD06','FIELD07','FIELD08','FIELD09','FIELD10','FIELD11','FIELD12','FIELD13','FIELD14','FIELD15','FIELD16','FIELD17','FIELD18','FIELD19','FIELD20','FIELD21','FIELD22','FIELD23','FIELD24','FIELD25','FIELD26','FIELD27','FIELD28','FIELD29','FIELD30','FIELD31','FIELD32','FIELD33','FIELD34','FIELD35','FIELD36','FIELD37','FIELD38','FIELD39','FIELD40','FIELD41','FIELD42','FIELD43','FIELD44','FIELD45','FIELD46','FIELD47','FIELD48','FIELD49','FIELD50','FIELD51','FIELD52','FIELD53','FIELD54','FIELD55','FIELD56','FIELD57']
floc = [0, 20, 40, 64, 73, 81, 90, 98,108,118,128,143,150,158,164,176,187,202,217,236,252,266,282,296,312,326,342,356,367,382,397,416,432,446,462,476,492,506,522,530,536,542,547,553,559,566,572,578,584,590,596,602,608,614,620,626,632]
fg = indgen(57)

template = {version:1.,$
       datastart:43L,$
       delimiter:32B,$
       missingvalue:!values.f_nan,$
       commentsymbol:'',$
       fieldcount:57,$
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
;GOO             LONG      = Array[6]
;These conjunctions that have zero time length (almost all of them)
good = where(tdiff_each_conj ne 0.)




t0 = t0[good]
t1 = t1[good]
tmin = vals.FIELD03[good]

goonan = where(tmin ne '0000-00-00/00:00')
tmin2 = time_double(tmin[goonan])


;Flag tplot variable showing all the conjunctions.
flag = replicate(1.,n_elements(goonan))
store_data,'allconjunctions',time_double(t0[goonan]),flag
ylim,'allconjunctions',0,2
options,'allconjunctions','psym',4
options,'allconjunctions','panel_size',0.5


store_data,'Lrb',tmin2,vals.FIELD04[good[goonan]]
store_data,'Lfb',tmin2,vals.FIELD05[good[goonan]]
store_data,'MLTrb',tmin2,vals.FIELD06[good[goonan]]
store_data,'MLTfb',tmin2,vals.FIELD07[good[goonan]]
store_data,'distmin',tmin2,vals.FIELD08[good[goonan]] & ylim,'distmin',0,2
store_data,'dLmin',tmin2,vals.FIELD09[good[goonan]] & ylim,'dLmin',0,2
store_data,'dMLTmin',tmin2,vals.FIELD10[good[goonan]] & ylim,'dMLTmin',0,2

store_data,'col',tmin2,vals.FIELD11[good[goonan]]
store_data,'sur',tmin2,vals.FIELD12[good[goonan]]
store_data,'emfb',tmin2,vals.FIELD13[good[goonan]]
store_data,'b1b',tmin2,vals.FIELD14[good[goonan]]
store_data,'b2b',tmin2,vals.FIELD15[good[goonan]]

store_data,'SpecETot_lf',tmin2,vals.FIELD16[good[goonan]]
store_data,'SpecEMax_lf',tmin2,vals.FIELD17[good[goonan]] & ylim,'SpecEMax_lf',1d-5,100,1
store_data,'SpecEAvg_lf',tmin2,vals.FIELD18[good[goonan]] & ylim,'SpecEAvg_lf',1d-5,100,1
store_data,'SpecEMed_lf',tmin2,vals.FIELD19[good[goonan]] & ylim,'SpecEMed_lf',1d-5,100,1

store_data,'SpecETot_lb',tmin2,vals.FIELD20[good[goonan]]
store_data,'SpecEMax_lb',tmin2,vals.FIELD21[good[goonan]] & ylim,'SpecEMax_lb',1d-5,100,1
store_data,'SpecEAvg_lb',tmin2,vals.FIELD22[good[goonan]] & ylim,'SpecEMax_lb',1d-5,100,1
store_data,'SpecEMed_lb',tmin2,vals.FIELD23[good[goonan]] & ylim,'SpecEMax_lb',1d-5,100,1

store_data,'SpecETot_ub',tmin2,vals.FIELD24[good[goonan]]
store_data,'SpecEMax_ub',tmin2,vals.FIELD25[good[goonan]] & ylim,'SpecEMax_ub',1d-5,100,1
store_data,'SpecEAvg_ub',tmin2,vals.FIELD26[good[goonan]] & ylim,'SpecEMax_ub',1d-5,100,1
store_data,'SpecEMed_ub',tmin2,vals.FIELD27[good[goonan]] & ylim,'SpecEMax_ub',1d-5,100,1

store_data,'SpecBTot_lf',tmin2,vals.FIELD28[good[goonan]]
store_data,'SpecBMax_lf',tmin2,vals.FIELD29[good[goonan]] & ylim,'SpecBMax_lf',1d-6,1,1
store_data,'SpecBAvg_lf',tmin2,vals.FIELD30[good[goonan]] & ylim,'SpecBAvg_lf',1d-7,1d-4,1
store_data,'SpecBMed_lf',tmin2,vals.FIELD31[good[goonan]] & ylim,'SpecBMed_lf',1d-7,1d-4,1

store_data,'SpecBTot_lb',tmin2,vals.FIELD32[good[goonan]]
store_data,'SpecBMax_lb',tmin2,vals.FIELD33[good[goonan]] & ylim,'SpecBMax_lb',1d-6,1,1
store_data,'SpecBAvg_lb',tmin2,vals.FIELD34[good[goonan]] & ylim,'SpecBAvg_lb',1d-7,1d-4,1
store_data,'SpecBMed_lb',tmin2,vals.FIELD35[good[goonan]] & ylim,'SpecBMed_lb',1d-7,1d-4,1

store_data,'SpecBTot_ub',tmin2,vals.FIELD36[good[goonan]]
store_data,'SpecBMax_ub',tmin2,vals.FIELD37[good[goonan]] & ylim,'SpecBMax_ub',1d-6,1,1
store_data,'SpecBAvg_ub',tmin2,vals.FIELD38[good[goonan]] & ylim,'SpecBAvg_ub',1d-7,1d-4,1
store_data,'SpecBMed_ub',tmin2,vals.FIELD39[good[goonan]] & ylim,'SpecBMed_ub',1d-7,1d-4,1

store_data,'fb7E4',tmin2,vals.FIELD40[good[goonan]]
store_data,'fb7E5',tmin2,vals.FIELD41[good[goonan]]
store_data,'fb7E6',tmin2,vals.FIELD42[good[goonan]]

store_data,'fb7B4',tmin2,vals.FIELD43[good[goonan]]
store_data,'fb7B5',tmin2,vals.FIELD44[good[goonan]]
store_data,'fb7B6',tmin2,vals.FIELD45[good[goonan]]

store_data,'fb13E7',tmin2,vals.FIELD46[good[goonan]]
store_data,'fb13E8',tmin2,vals.FIELD47[good[goonan]]
store_data,'fb13E9',tmin2,vals.FIELD48[good[goonan]]
store_data,'fb13E10',tmin2,vals.FIELD49[good[goonan]]
store_data,'fb13E11',tmin2,vals.FIELD50[good[goonan]]
store_data,'fb13E12',tmin2,vals.FIELD51[good[goonan]]

store_data,'fb13B7',tmin2,vals.FIELD52[good[goonan]]
store_data,'fb13B8',tmin2,vals.FIELD53[good[goonan]]
store_data,'fb13B9',tmin2,vals.FIELD54[good[goonan]]
store_data,'fb13B10',tmin2,vals.FIELD55[good[goonan]]
store_data,'fb13B11',tmin2,vals.FIELD56[good[goonan]]
store_data,'fb13B12',tmin2,vals.FIELD57[good[goonan]]


options,'fb13E7','ytitle','FBK Ew(mV/m)!C100-200Hz'
options,'fb13E8','ytitle','FBK Ew(mV/m)!C200-400Hz'
options,'fb13E9','ytitle','FBK Ew(mV/m)!C400-800Hz'
options,'fb13E10','ytitle','FBK Ew(mV/m)!C800-1600Hz'
options,'fb13E11','ytitle','FBK Ew(mV/m)!C1600-3200Hz'
options,'fb13E12','ytitle','FBK Ew(mV/m)!C3200-6500Hz'
options,'fb13B7','ytitle','FBK Bw(pT)!C100-200Hz'
options,'fb13B8','ytitle','FBK Bw(pT)!C200-400Hz'
options,'fb13B9','ytitle','FBK Bw(pT)!C400-800Hz'
options,'fb13B10','ytitle','FBK Bw(pT)!C800-1600Hz'
options,'fb13B11','ytitle','FBK Bw(pT)!C1600-3200Hz'
options,'fb13B12','ytitle','FBK Bw(pT)!C3200-6500Hz'

options,'fb7E4','ytitle','FBK Ew(mV/m)!C200-400Hz'
options,'fb7E5','ytitle','FBK Ew(mV/m)!C800-1600Hz'
options,'fb7E6','ytitle','FBK Ew(mV/m)!C3200-6500Hz'
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

;All conjunctions, event the 0000-00-00/00:00 ones



Lrb=vals.FIELD04[good]
Lfb=vals.FIELD05[good]
MLTrb=vals.FIELD06[good]
MLTfb=vals.FIELD07[good]
distmin=vals.FIELD08[good]
dLmin=vals.FIELD09[good]
dMLTmin=vals.FIELD10[good]

col=vals.FIELD11[good]
sur=vals.FIELD12[good]
emfb=vals.FIELD13[good]
b1b=vals.FIELD14[good]
b2b=vals.FIELD15[good]

SpecETot_lf=vals.FIELD16[good]
SpecEMax_lf=vals.FIELD17[good]
SpecEAvg_lf=vals.FIELD18[good]
SpecEMed_lf=vals.FIELD19[good]

SpecETot_lb=vals.FIELD20[good]
SpecEMax_lb=vals.FIELD21[good]
SpecEAvg_lb=vals.FIELD22[good]
SpecEMed_lb=vals.FIELD23[good]

SpecETot_ub=vals.FIELD24[good]
SpecEMax_ub=vals.FIELD25[good]
SpecEAvg_ub=vals.FIELD26[good]
SpecEMed_ub=vals.FIELD27[good]

SpecBTot_lf=vals.FIELD28[good]
SpecBMax_lf=vals.FIELD29[good]
SpecBAvg_lf=vals.FIELD30[good]
SpecBMed_lf=vals.FIELD31[good]

SpecBTot_lb=vals.FIELD32[good]
SpecBMax_lb=vals.FIELD33[good]
SpecBAvg_lb=vals.FIELD34[good]
SpecBMed_lb=vals.FIELD35[good]

SpecBTot_ub=vals.FIELD36[good]
SpecBMax_ub=vals.FIELD37[good]
SpecBAvg_ub=vals.FIELD38[good]
SpecBMed_ub=vals.FIELD39[good]

fb7E4=vals.FIELD40[good]
fb7E5=vals.FIELD41[good]
fb7E6=vals.FIELD42[good]

fb7B4=vals.FIELD43[good]
fb7B5=vals.FIELD44[good]
fb7B6=vals.FIELD45[good]

fb13E7=vals.FIELD46[good]
fb13E8=vals.FIELD47[good]
fb13E9=vals.FIELD48[good]
fb13E10=vals.FIELD49[good]
fb13E11=vals.FIELD50[good]
fb13E12=vals.FIELD51[good]

fb13B7=vals.FIELD52[good]
fb13B8=vals.FIELD53[good]
fb13B9=vals.FIELD54[good]
fb13B10=vals.FIELD55[good]
fb13B11=vals.FIELD56[good]
fb13B12=vals.FIELD57[good]





end
