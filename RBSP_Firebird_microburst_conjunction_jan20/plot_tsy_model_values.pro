rbsp_efw_init

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/TSY_files/'
fn = 'fb4_t04s_tshift=0.0sec_lshell_MLT_hires.tplot'

tplot_restore,filenames=path + fn

fn = 'fb4_t01_tshift=0.0sec_lshell_MLT_hires.tplot'
tplot_restore,filenames=path + fn


path2 = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/datafiles/'
fn = 'rbspa_fb4_ts04_lshell.tplot'
tplot_restore,filenames=path2 + fn

fn = 'rbspa_jan20_ts04_mag.tplot'
tplot_restore,filenames=path2 + fn


fn = 'rbspa_tsy01_mapping_20160120.tplot'
tplot_restore,filenames=path + fn


;Load EMFISIS L3 data
path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunction_jan20/EMFISIS/'
fn = 'rbsp-a_magnetometer_4sec-gse_emfisis-L3_20160120_v1.3.2.cdf'
cdf2tplot,path+fn


;Compare magnetic field vectors (model and data)
tplot,['Mag','B_t04s_gse']
tinterpol_mxn,'Mag','B_t04s_gse',newname='Mag'
tinterpol_mxn,'Magnitude','B_t04s_gse',newname='Magnitude'
get_data,'Mag',te,be
get_data,'B_t04s_gse',tm,bm
get_data,'Magnitude',ttmp,bmage
bmagm = sqrt(bm[*,0]^2 + bm[*,1]^2 + bm[*,2]^2)

dotp = be[*,0]*bm[*,0]+be[*,1]*bm[*,1]+be[*,2]*bm[*,2]

ang = acos(dotp/bmage/bmagm)/!dtor

store_data,'angle',tm,ang
options,'angle','ytitle','Angle b/t Bw model!Cand Bw EMFISIS'

tplot,['Mag','B_t04s_gse','angle']



1 FB4!CL-shell-t04s
5 FB4!CL-shell-t01



 2 FB4!Cnorth-foot-MLT!Ct04s
 3 FB4!Csouth-foot-MLT!Ct04s
 4 FB4!Cequatorial-foot-MLT!Ct04s
 6 FB4!Cnorth-foot-MLT!Ct01
 7 FB4!Csouth-foot-MLT!Ct01
 8 FB4!Cequatorial-foot-MLT!Ct01
 9 RBSPa!CL-shell-t04
10 RBSPa!Cequatorial-foot-MLT!Ct04
13 B_t04s_gse
 14 B_t04s_gse_omni
 15 bmag_t04s


tinterpol_mxn,'RBSPa!CL-shell-t04','FB4!CL-shell-t04s',newname='RBSPa!CL-shell-t04'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct04','FB4!Cequatorial-foot-MLT!Ct04s',newname='RBSPa!Cequatorial-foot-MLT!Ct04'

tinterpol_mxn,'RBSPa!CL-shell-t01','FB4!CL-shell-t01',newname='RBSPa!CL-shell-t01'
tinterpol_mxn,'RBSPa!Cequatorial-foot-MLT!Ct01','FB4!Cequatorial-foot-MLT!Ct01',newname='RBSPa!Cequatorial-foot-MLT!Ct01'



 dif_data,'RBSPa!CL-shell-t04','FB4!CL-shell-t04s',newname='dl04'
 dif_data,'RBSPa!CL-shell-t01','FB4!CL-shell-t01',newname='dl01'
 dif_data,'RBSPa!Cequatorial-foot-MLT!Ct04','FB4!Cequatorial-foot-MLT!Ct04s',newname='dmlt04'
 dif_data,'RBSPa!Cequatorial-foot-MLT!Ct01','FB4!Cequatorial-foot-MLT!Ct01',newname='dmlt01'


 options,['RBSPa!CL-shell-t04','FB4!CL-shell-t04s','dl04',$
 'RBSPa!Cequatorial-foot-MLT!Ct04','FB4!Cequatorial-foot-MLT!Ct04s','dmlt04'],'psym',-4
 options,['RBSPa!CL-shell-t01','FB4!CL-shell-t01','dl01',$
 'RBSPa!Cequatorial-foot-MLT!Ct01','FB4!Cequatorial-foot-MLT!Ct01','dmlt01'],'psym',-4
tlimit,'2016-01-20/19:43:20','2016-01-20/19:44:40'
options,['dmlt04','dl04','dmlt01','dl01'],'constant',0

store_data,'dlcomb',data=['dl04','dl01']
options,'dlcomb','colors',[0,250]
store_data,'dmltcomb',data=['dmlt04','dmlt01']
options,'dmltcomb','colors',[0,250]


tplot_options,'title','from plot_tsy_model_values.pro'

tplot,['RBSPa!CL-shell-t04','FB4!CL-shell-t04s','dlcomb']
ylim,'dmltcomb',-0.14,0.14
tplot,['RBSPa!Cequatorial-foot-MLT!Ct04','FB4!Cequatorial-foot-MLT!Ct04s','dmltcomb']



tplot,['FB4!CL-shell-t04s','dlcomb','dmltcomb']
