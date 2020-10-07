;Make dial plot of the burst 1 availability
rbsp_efw_init

dtheta = 1 & dlshell = 1
lmin = 0 & lmax = 8
tmin = 0 & tmax = 24
grid = return_L_MLT_grid(dtheta,dlshell,lmin,lmax,tmin,tmax)



path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_phaseF/'
restore,path+'burst1_L_MLT_16k_RBSPa_vals'
h2d = h2d[0:7,0:23]
v16a = h2d
restore,path+'burst1_L_MLT_16k_RBSPb_vals'
h2d = h2d[0:7,0:23]
v16b = h2d
restore,path+'burst1_L_MLT_8k_RBSPa_vals'
h2d = h2d[0:7,0:23]
v8a = h2d
restore,path+'burst1_L_MLT_8k_RBSPb_vals'
h2d = h2d[0:7,0:23]
v8b = h2d
restore,path+'burst1_L_MLT_4k_RBSPa_vals'
h2d = h2d[0:7,0:23]
v4a = h2d
restore,path+'burst1_L_MLT_4k_RBSPb_vals'
h2d = h2d[0:7,0:23]
v4b = h2d
restore,path+'burst1_L_MLT_2k_RBSPa_vals'
h2d = h2d[0:7,0:23]
v2a = h2d
restore,path+'burst1_L_MLT_2k_RBSPb_vals'
h2d = h2d[0:7,0:23]
v2b = h2d
restore,path+'burst1_L_MLT_1k_RBSPa_vals'
h2d = h2d[0:7,0:23]
v1a = h2d
restore,path+'burst1_L_MLT_1k_RBSPb_vals'
h2d = h2d[0:7,0:23]
v1b = h2d
restore,path+'burst1_L_MLT_05k_RBSPa_vals'
h2d = h2d[0:7,0:23]
v5a = h2d
restore,path+'burst1_L_MLT_05k_RBSPb_vals'
h2d = h2d[0:7,0:23]
v5b = h2d

;Total up the histograms
vatots = v16a + v8a + v4a + v2a + v1a + v5a
vbtots = v16b + v8b + v4b + v2b + v1b + v5b

vtots = vatots + vbtots
v16t = v16a + v16b
v8t = v8a + v8b
v4t = v4a + v4b
v2t = v2a + v2b
v1t = v1a + v1b
v5t = v5a + v5b


ps = 1
dial_plot,vatots,vbtots,grid,minc_vals=0.,maxc_vals=2000.,minc_cnt=0.,maxc_cnt=2000.,ps=ps
dial_plot,v16a,v16b,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v8a,v8b,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v4a,v4b,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v2a,v2b,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v1a,v1b,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v5a,v5b,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps


ps = 1
dial_plot,vtots,vtots,grid,minc_vals=0.,maxc_vals=2000.,minc_cnt=0.,maxc_cnt=2000.,ps=ps
dial_plot,v16t,v16t,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v8t,v8t,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v4t,v4t,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v2t,v2t,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v1t,v1t,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps
dial_plot,v5t,v5t,grid,minc_vals=5.,maxc_vals=2000.,minc_cnt=5.,maxc_cnt=2000.,ps=ps



;dial_plot,v16a,v16a,grid,minc_vals=0.,maxc_vals=1000.
