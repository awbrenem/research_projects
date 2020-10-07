path = '~/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'

rbsp_efw_init

fn = 'FB4_T04s_equ_L_MLT.dat'
restore,path+fn
fn = 'RBSPa_T04s_equ_L_MLT.dat'
restore,path+fn







restore,'FB4_T04s_equ_L_MLT.dat'
store_data,'fb-l',data={x:fb_times,y:fb_l}
store_data,'fb-mlt',data={x:fb_times,y:fb_mlt}








;; fn = 'RBSPb_T04s_equ_L_MLT.dat'
;; restore,path+fn


 
store_data,'fb4l',fb_times,fb_l
store_data,'fb4mlt',fb_times,fb_mlt

store_data,'rbal',rba_times,rba_l
store_data,'rbamlt',rba_times,rba_mlt

ylim,['rbal','fb4l'],0,7
ylim,['rbamlt','fb4mlt'],0,25


tplot,['fb4l','rbal','fb4mlt','rbamlt']

dif_data,'fb4l','rbal',newname='ldiff'
dif_data,'fb4mlt','rbamlt',newname='mltdiff'

zerolinefb = replicate(0.,n_elements(fb_times))
zerolinerba = replicate(0.,n_elements(rba_times))
store_data,'zerolinefb',fb_times,zerolinefb

store_data,'ldiffcomb',data=['ldiff','zerolinefb']
store_data,'mltdiffcomb',data=['mltdiff','zerolinefb']


ylim,['ldiffcomb','ldiff'],-6,6
ylim,['mltdiffcomb','mltdiff'],-5,5
tplot,['ldiffcomb','mltdiffcomb']

