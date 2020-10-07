;FIREBIRD/RBSP conjunction plotter from FB conjunction files.

pm_time = 2.5*60.  ;plus and minus times for conjunction collection.

rbsp_efw_init

path = '/Users/aaronbreneman/Desktop/Research/RBSP_Firebird_microburst_conjunctions_all/all_conjunctions/'
;fn = 'FU3_RBSPA_camp14_conjunctions_pre.txt'
;fn = 'FU3_RBSPB_camp14_conjunctions_pre.txt'
;fn = 'FU4_RBSPA_camp14_conjunctions_pre.txt'
;fn = 'FU4_RBSPB_camp14_conjunctions_pre.txt'
fn = 'FU3_RBSPA_camp15_conjunctions_pre.txt'
;fn = 'FU3_RBSPB_camp15_conjunctions_pre.txt'
;fn = 'FU4_RBSPA_camp15_conjunctions_pre.txt'
;fn = 'FU4_RBSPB_camp15_conjunctions_pre.txt'

FU3_RBSPA_camp17_conjunctions_dL10_dMLT10.txt
FU3_RBSPB_camp17_conjunctions_dL10_dMLT10.txt
FU4_RBSPA_camp17_conjunctions_dL10_dMLT10.txt
FU4_RBSPB_camp17_conjunctions_dL10_dMLT10.txt

openr,lun,path+fn,/get_lun
jnk = ''
for i=0,49 do readf,lun,jnk

strvals = ''
strv = ''
while not eof(lun) do begin $
    readf,lun,strvals     & $
    strv = [strv,strvals]

close,lun
free_lun,lun


strv = strv[1:n_elements(strv)-1]

vals = strarr(n_elements(strv),7)
for i=0,n_elements(strv)-1 do vals[i,*] = strsplit(strv[i],' ',/extract)

t0 = time_double(vals[*,0])
t1 = time_double(vals[*,1])
duration = float(vals[*,2])
meanL_FU = float(vals[*,3])
meanL_RB = float(vals[*,4])
meanMLT_FU = float(vals[*,5])
meanMLT_RB = float(vals[*,6])

Ldiff = meanL_RB - meanL_FU
MLTdiff = meanMLT_RB - meanMLT_FU


store_data,'meanL_FU',t0,meanL_FU
store_data,'meanL_RB',t0,meanL_RB
store_data,'meanMLT_FU',t0,meanMLT_FU
store_data,'meanMLT_RB',t0,meanMLT_RB
store_data,'ldiff',t0,Ldiff
store_data,'mltdiff',t0,MLTdiff
store_data,'line',t0,replicate(0.,n_elements(t0))

store_data,'ldiffcomb',data=['line','ldiff']
store_data,'mltdiffcomb',data=['line','mltdiff']
options,['meanL_??','ldiff','mltdiff'],'psym',-2

tplot,['ldiffcomb','mltdiffcomb']



;Print times formatted for Tohban from FIREBIRD file Mike Shumko sends me
print,'TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL'
for i=0,n_elements(Ldiff)-1 do $
print,"[time_double(['" + time_string(t0[i]-pm_time) + "', '" + time_string(t1[i]+pm_time) + $
    "']),16384],$"+ ' ',meanMLT_RB[i],meanL_RB[i],MLTdiff[i],Ldiff[i]


;FU3-RBSPa
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL
[time_double(['2018-04-19/00:51:30', '2018-04-19/00:57:30']),16384],$       8.98300      3.15849     0.166862    -0.519922
[time_double(['2018-04-19/18:13:30', '2018-04-19/18:21:30']),16384],$       7.91288      3.89882    -0.441901    -0.101515
[time_double(['2018-04-20/03:45:30', '2018-04-20/03:51:30']),16384],$       8.91467      3.02515    -0.583685    -0.388717
[time_double(['2018-04-20/21:10:30', '2018-04-20/21:17:30']),16384],$       8.11527      3.93768   -0.0101109    0.0582633
[time_double(['2018-04-22/00:05:30', '2018-04-22/00:12:30']),16384],$       8.07274      3.91946    -0.565399   -0.0218198
[time_double(['2018-04-23/20:24:30', '2018-04-23/20:31:30']),16384],$       7.43989      4.53006    -0.658023     0.464532
[time_double(['2018-04-24/23:21:30', '2018-04-24/23:27:30']),16384],$       7.43327      4.52545    -0.730885    -0.985122
[time_double(['2018-04-28/17:30:30', '2018-04-28/17:36:30']),16384],$       8.45938      3.07735    -0.436086    -0.459601
[time_double(['2018-05-01/01:13:30', '2018-05-01/01:19:30']),16384],$      0.891258      3.04026     0.818012    -0.507313
[time_double(['2018-05-02/19:40:30', '2018-05-02/19:47:30']),16384],$       7.85311      3.72249    -0.664723     0.119178
[time_double(['2018-05-03/22:36:30', '2018-05-03/22:43:30']),16384],$       7.95460      3.70787    -0.633408   -0.0528326
[time_double(['2018-05-08/21:33:30', '2018-05-08/21:40:30']),16384],$       1.44795      3.74309     0.574963    -0.437614
[time_double(['2018-05-10/00:29:30', '2018-05-10/00:35:30']),16384],$       1.50046      3.87944     0.825666    -0.158122
[time_double(['2018-05-11/20:48:30', '2018-05-11/20:54:30']),16384],$      0.554068      3.01439    -0.101904    -0.603636
[time_double(['2018-05-12/23:43:30', '2018-05-12/23:50:30']),16384],$      0.694559      3.19345    0.0532163    -0.190519
[time_double(['2018-05-14/02:39:30', '2018-05-14/02:45:30']),16384],$      0.748893      3.35449     -23.1483    -0.772094
[time_double(['2018-05-15/21:07:30', '2018-05-15/21:13:30']),16384],$       7.75717      3.47526    -0.792692    -0.529225
[time_double(['2018-05-17/20:50:30', '2018-05-17/20:56:30']),16384],$       1.82153      4.58116     0.862138     0.230081
[time_double(['2018-05-18/23:45:30', '2018-05-18/23:51:30']),16384],$       1.82534      4.63078     0.694665     0.155027
[time_double(['2018-05-19/17:09:30', '2018-05-19/17:15:30']),16384],$      0.979692      3.83743     0.935404    -0.484252
[time_double(['2018-05-20/20:04:30', '2018-05-20/20:11:30']),16384],$       1.16142      3.96050     0.471802     0.193586
[time_double(['2018-05-21/22:59:30', '2018-05-21/23:06:30']),16384],$       1.22341      4.04925     0.247046     0.351189
[time_double(['2018-05-22/16:24:30', '2018-05-22/16:30:30']),16384],$     0.0338614      3.09368     -23.6460    -0.215115
[time_double(['2018-05-23/01:55:30', '2018-05-23/02:01:30']),16384],$       1.23332      4.15151     0.825283     0.105775
[time_double(['2018-05-23/19:18:30', '2018-05-23/19:25:30']),16384],$      0.273539      3.21215    -0.239072    -0.381481
[time_double(['2018-05-24/22:13:30', '2018-05-24/22:20:30']),16384],$      0.434756      3.35173    -0.489402    -0.100896
[time_double(['2018-05-24/23:47:30', '2018-05-24/23:53:30']),16384],$       2.44778      5.65629     0.993173     0.322146
[time_double(['2018-05-26/01:08:30', '2018-05-26/01:15:30']),16384],$      0.485430      3.47496    -0.224076    -0.384198
[time_double(['2018-05-26/20:06:30', '2018-05-26/20:12:30']),16384],$       2.01828      5.30127     0.991708     0.496782

;FU3-RBSPb
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL
[time_double(['2018-04-18/18:29:30', '2018-04-18/18:35:30']),16384],$       7.99589      3.20597    -0.430459    -0.343232
[time_double(['2018-04-19/21:25:30', '2018-04-19/21:32:30']),16384],$       7.54087      3.79170    -0.688809     0.208137
[time_double(['2018-04-21/21:09:30', '2018-04-21/21:16:30']),16384],$      0.997994      3.36792     0.682692    -0.126317
[time_double(['2018-04-22/22:14:30', '2018-04-22/22:20:30']),16384],$       8.41037      3.00534    -0.170412   -0.0109825
[time_double(['2018-04-23/00:05:30', '2018-04-23/00:11:30']),16384],$      0.432433      3.00928     0.261264    -0.363016
[time_double(['2018-04-24/21:58:30', '2018-04-24/22:04:30']),16384],$       1.57456      4.07762     0.931873  -0.00287104
[time_double(['2018-04-29/19:07:30', '2018-04-29/19:13:30']),16384],$      0.401679      3.09976     0.281214    -0.398260
[time_double(['2018-04-30/20:11:30', '2018-04-30/20:18:30']),16384],$       7.81988      3.21321    -0.618112    -0.366932
[time_double(['2018-05-02/19:55:30', '2018-05-02/20:02:30']),16384],$       1.09353      3.85726     0.616249    -0.178557
[time_double(['2018-05-03/22:51:30', '2018-05-03/22:57:30']),16384],$      0.683395      3.49263    0.0449710   -0.0763025
[time_double(['2018-05-05/01:47:30', '2018-05-05/01:54:30']),16384],$      0.119503      3.17225     -23.7410    -0.164672
[time_double(['2018-05-05/20:44:30', '2018-05-05/20:50:30']),16384],$       1.55536      4.51744     0.727683   -0.0707455
[time_double(['2018-05-06/23:39:30', '2018-05-06/23:46:30']),16384],$       1.21088      4.19072     0.352196   -0.0931392
[time_double(['2018-05-08/02:36:30', '2018-05-08/02:42:30']),16384],$      0.781865      3.90241     -23.0273    -0.303232
[time_double(['2018-05-08/21:33:30', '2018-05-08/21:39:30']),16384],$       1.89664      5.08726     0.879310     0.416084
[time_double(['2018-05-10/00:28:30', '2018-05-10/00:35:30']),16384],$       1.58496      4.80887     0.734407     0.167271
[time_double(['2018-05-10/17:53:30', '2018-05-10/18:00:30']),16384],$      0.530243      3.64907     -11.4311     0.237136
[time_double(['2018-05-11/20:48:30', '2018-05-11/20:54:30']),16384],$      0.102696      3.20464    -0.553276    -0.413386
[time_double(['2018-05-13/01:17:30', '2018-05-13/01:23:30']),16384],$       1.85257      5.32244     0.913321    -0.616751
[time_double(['2018-05-13/18:41:30', '2018-05-13/18:48:30']),16384],$       1.05769      4.34447     0.666427     0.103753
[time_double(['2018-05-14/12:07:30', '2018-05-14/12:13:30']),16384],$       23.5003      3.06146     0.930552    -0.282728
[time_double(['2018-05-14/21:36:30', '2018-05-14/21:43:30']),16384],$      0.740696      3.95348    -0.200429    -0.126754
[time_double(['2018-05-16/00:32:30', '2018-05-16/00:39:30']),16384],$      0.305347      3.60568    -0.293496    0.0459929
[time_double(['2018-05-16/19:30:30', '2018-05-16/19:36:30']),16384],$       1.45437      4.95202     0.718529     0.274907
[time_double(['2018-05-17/03:29:30', '2018-05-17/03:36:30']),16384],$       23.7075      3.29980     0.256798    -0.182685
[time_double(['2018-05-17/22:25:30', '2018-05-17/22:31:30']),16384],$       1.16536      4.60251   -0.0270278    0.0579014
[time_double(['2018-05-18/15:50:30', '2018-05-18/15:57:30']),16384],$       23.8441      3.40821     0.356089    0.0873282
[time_double(['2018-05-19/01:21:30', '2018-05-19/01:28:30']),16384],$      0.808335      4.30470     0.322692     0.482819
[time_double(['2018-05-19/09:46:30', '2018-05-19/09:52:30']),16384],$       23.2594      3.03147     0.809839    -0.745142
[time_double(['2018-05-19/20:18:30', '2018-05-19/20:25:30']),16384],$       1.75299      5.45491     0.669120    0.0896678
[time_double(['2018-05-20/23:14:30', '2018-05-20/23:20:30']),16384],$       1.48075      5.16027     0.241073     0.595865
[time_double(['2018-05-21/16:38:30', '2018-05-21/16:45:30']),16384],$      0.455153      4.14369     -23.4083    0.0963273
[time_double(['2018-05-22/02:10:30', '2018-05-22/02:16:30']),16384],$       1.14436      4.89692     0.715111     0.240865
[time_double(['2018-05-22/19:33:30', '2018-05-22/19:40:30']),16384],$      0.173411      3.71213    -0.470082    -0.209889
[time_double(['2018-05-22/21:07:30', '2018-05-22/21:13:30']),16384],$       1.98347      5.85605     0.578040   -0.0636668
[time_double(['2018-05-24/00:02:30', '2018-05-24/00:09:30']),16384],$       1.70922      5.60727     0.301059     0.126796
[time_double(['2018-05-24/17:26:30', '2018-05-24/17:33:30']),16384],$      0.900919      4.78868     0.614871    -0.272137
[time_double(['2018-05-25/20:22:30', '2018-05-25/20:28:30']),16384],$      0.682268      4.41500    -0.245524     0.236619
[time_double(['2018-05-25/21:56:30', '2018-05-25/22:02:30']),16384],$       2.18202      6.16798     0.654681     0.495461
[time_double(['2018-05-26/13:47:30', '2018-05-26/13:53:30']),16384],$       23.0935      3.12685    0.0654678    -0.302259
[time_double(['2018-05-26/23:17:30', '2018-05-26/23:24:30']),16384],$      0.331644      4.04071    -0.715798     0.314244

;FU4-RBSPa
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL
[time_double(['2018-04-19/00:35:30', '2018-04-19/00:42:30']),16384],$       8.35279      3.71241    -0.406563    0.0142050
[time_double(['2018-04-19/17:59:30', '2018-04-19/18:05:30']),16384],$       7.52852      4.28071    -0.698648    -0.298368
[time_double(['2018-04-20/20:55:30', '2018-04-20/21:02:30']),16384],$       7.70580      4.36030    -0.208626    -0.119497
[time_double(['2018-04-21/23:50:30', '2018-04-21/23:57:30']),16384],$       7.64752      4.36435    -0.813488    -0.117527
[time_double(['2018-04-23/20:09:30', '2018-04-23/20:16:30']),16384],$       7.12019      4.86898    -0.749658    0.0960655
[time_double(['2018-04-24/15:04:30', '2018-04-24/15:11:30']),16384],$       8.51281      3.03489    -0.835662    -0.453933
[time_double(['2018-04-26/22:47:30', '2018-04-26/22:54:30']),16384],$       1.13988      3.06698     0.607892    -0.578200
[time_double(['2018-04-28/17:15:30', '2018-04-28/17:21:30']),16384],$       7.90067      3.54010    -0.874236    -0.628115
[time_double(['2018-04-29/20:11:30', '2018-04-29/20:18:30']),16384],$       8.21268      3.50786    -0.120914    -0.294399
[time_double(['2018-04-30/23:06:30', '2018-04-30/23:13:30']),16384],$       8.26489      3.49929    -0.457805    0.0549414
[time_double(['2018-05-02/19:26:30', '2018-05-02/19:32:30']),16384],$       7.43348      4.14390    -0.700802    -0.598791
[time_double(['2018-05-03/22:22:30', '2018-05-03/22:28:30']),16384],$       7.50786      4.16698    -0.694417    -0.823014
[time_double(['2018-05-05/22:04:30', '2018-05-05/22:10:30']),16384],$       1.74096      3.94716     0.921097   -0.0415370
[time_double(['2018-05-07/18:23:30', '2018-05-07/18:30:30']),16384],$      0.768537      3.10191     0.661462    -0.548370
[time_double(['2018-05-08/21:18:30', '2018-05-08/21:25:30']),16384],$      0.945106      3.25088     0.304521    -0.271124
[time_double(['2018-05-10/00:13:30', '2018-05-10/00:20:30']),16384],$       1.03068      3.40153     0.395624    -0.346505
[time_double(['2018-05-11/18:41:30', '2018-05-11/18:47:30']),16384],$       7.87336      3.31068    -0.900902    -0.583082
[time_double(['2018-05-12/21:37:30', '2018-05-12/21:43:30']),16384],$       8.10873      3.26843    -0.577764    -0.295740
[time_double(['2018-05-14/21:20:30', '2018-05-14/21:26:30']),16384],$       2.06317      4.72811     0.969563    0.0110059
[time_double(['2018-05-16/00:15:30', '2018-05-16/00:21:30']),16384],$       2.04758      4.77445     0.885616    -0.313781
[time_double(['2018-05-17/20:34:30', '2018-05-17/20:41:30']),16384],$       1.45109      4.14139     0.630416     0.116405
[time_double(['2018-05-18/23:29:30', '2018-05-18/23:36:30']),16384],$       1.48623      4.22318     0.466397     0.174795
[time_double(['2018-05-19/16:54:30', '2018-05-19/17:00:30']),16384],$      0.447719      3.31973     -23.3866    -0.214473
[time_double(['2018-05-20/19:48:30', '2018-05-20/19:55:30']),16384],$      0.648381      3.43058  -0.00456530    -0.393635
[time_double(['2018-05-21/22:43:30', '2018-05-21/22:50:30']),16384],$      0.765325      3.55758    -0.224239    -0.153518
[time_double(['2018-05-23/01:39:30', '2018-05-23/01:46:30']),16384],$      0.820765      3.70218     0.451772     0.133893
[time_double(['2018-05-24/23:31:30', '2018-05-24/23:37:30']),16384],$       2.21213      5.38020     0.747877     0.142300
[time_double(['2018-05-26/19:50:30', '2018-05-26/19:56:30']),16384],$       1.70886      4.92073     0.748966     0.143447

;FU4-RBSPb
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL
[time_double(['2018-04-18/18:14:30', '2018-04-18/18:20:30']),16384],$       7.44992      3.66642    -0.839900    -0.432785
[time_double(['2018-04-19/21:11:30', '2018-04-19/21:17:30']),16384],$       7.11207      4.21077    -0.770829    -0.347430
[time_double(['2018-04-22/21:59:30', '2018-04-22/22:06:30']),16384],$       7.76613      3.52232    -0.506566    -0.310278
[time_double(['2018-04-24/21:42:30', '2018-04-24/21:49:30']),16384],$       1.16219      3.63160     0.560676    -0.393720
[time_double(['2018-04-26/00:38:30', '2018-04-26/00:45:30']),16384],$      0.674164      3.30338     0.483528    -0.340212
[time_double(['2018-04-27/03:35:30', '2018-04-27/03:41:30']),16384],$       23.9781      3.02021     0.882996    -0.924422
[time_double(['2018-04-27/22:31:30', '2018-04-27/22:37:30']),16384],$       1.65946      4.31168     0.740145    -0.443851
[time_double(['2018-04-28/15:56:30', '2018-04-28/16:03:30']),16384],$      0.233775      3.03859     -23.0817    -0.411747
[time_double(['2018-04-30/19:57:30', '2018-04-30/20:03:30']),16384],$       7.26318      3.69865    -0.787774    -0.985340
[time_double(['2018-04-30/23:20:30', '2018-04-30/23:26:30']),16384],$       2.01884      4.90877     0.987571    -0.188215
[time_double(['2018-05-02/19:40:30', '2018-05-02/19:47:30']),16384],$      0.639646      3.39523     0.365220   -0.0832860
[time_double(['2018-05-03/22:36:30', '2018-05-03/22:42:30']),16384],$      0.131492      3.01126    -0.321155   -0.0715282
[time_double(['2018-05-05/20:28:30', '2018-05-05/20:36:30']),16384],$       1.22027      4.11624     0.615332     0.131809
[time_double(['2018-05-06/23:24:30', '2018-05-06/23:31:30']),16384],$      0.837595      3.76592     0.193061     0.206885
[time_double(['2018-05-08/02:20:30', '2018-05-08/02:27:30']),16384],$      0.305375      3.44284     -23.5393    -0.406962
[time_double(['2018-05-08/21:17:30', '2018-05-08/21:24:30']),16384],$       1.62277      4.73979     0.712095     0.316803
[time_double(['2018-05-09/05:17:30', '2018-05-09/05:23:30']),16384],$       23.5821      3.07701     0.785635    -0.394131
[time_double(['2018-05-10/00:13:30', '2018-05-10/00:19:30']),16384],$       1.29140      4.43020     0.507971     0.280130
[time_double(['2018-05-10/17:37:30', '2018-05-10/17:44:30']),16384],$       23.9590      3.12375      12.0305    -0.432516
[time_double(['2018-05-11/22:06:30', '2018-05-11/22:12:30']),16384],$       1.92054      5.26335     0.718024     0.270838
[time_double(['2018-05-13/01:02:30', '2018-05-13/01:08:30']),16384],$       1.61812      5.01566     0.916505     0.535676
[time_double(['2018-05-13/18:26:30', '2018-05-13/18:33:30']),16384],$      0.677178      3.91323     0.506693     0.378236
[time_double(['2018-05-14/21:21:30', '2018-05-14/21:28:30']),16384],$      0.309447      3.49926    -0.385901    0.0999348
[time_double(['2018-05-14/22:55:30', '2018-05-14/23:01:30']),16384],$       2.15724      5.69398     0.869368     0.655365
[time_double(['2018-05-16/00:17:30', '2018-05-16/00:23:30']),16384],$       23.7602      3.11309      23.2249    -0.102586
[time_double(['2018-05-16/19:14:30', '2018-05-16/19:21:30']),16384],$       1.14275      4.57385     0.551122     0.245934
[time_double(['2018-05-17/12:39:30', '2018-05-17/12:45:30']),16384],$       23.6718      3.30571     0.936184    -0.849136
[time_double(['2018-05-17/22:09:30', '2018-05-17/22:16:30']),16384],$      0.836309      4.19595    -0.224570    0.0312710
[time_double(['2018-05-19/01:05:30', '2018-05-19/01:12:30']),16384],$      0.417045      3.85739    -0.154020    0.0836773
[time_double(['2018-05-19/20:03:30', '2018-05-19/20:09:30']),16384],$       1.49652      5.14148     0.588445     0.463875
[time_double(['2018-05-20/04:02:30', '2018-05-20/04:09:30']),16384],$       23.8636      3.55061     0.515171    -0.132969
[time_double(['2018-05-20/22:58:30', '2018-05-20/23:04:30']),16384],$       1.20775      4.80760   -0.0529072     0.218164
[time_double(['2018-05-21/16:22:30', '2018-05-21/16:29:30']),16384],$       11.9918      3.65228     -11.8011    -0.433471
[time_double(['2018-05-22/01:54:30', '2018-05-22/02:01:30']),16384],$      0.854961      4.52201     0.460283     0.464011
[time_double(['2018-05-22/10:18:30', '2018-05-22/10:24:30']),16384],$       23.4129      3.25909     0.953487    -0.148003
[time_double(['2018-05-22/19:18:30', '2018-05-22/19:24:30']),16384],$       23.6450      3.20611      23.1553    -0.322552
[time_double(['2018-05-22/20:51:30', '2018-05-22/20:57:30']),16384],$       1.75686      5.59731     0.391171    -0.387332
[time_double(['2018-05-23/23:46:30', '2018-05-23/23:53:30']),16384],$       1.47692      5.32005    0.0457121   -0.0612903
[time_double(['2018-05-24/17:11:30', '2018-05-24/17:18:30']),16384],$      0.568663      4.39394     -11.4725     0.443946
[time_double(['2018-05-25/02:43:30', '2018-05-25/02:49:30']),16384],$       1.14960      5.08382     0.877508     0.138090
[time_double(['2018-05-25/10:37:30', '2018-05-25/10:44:30']),16384],$       23.0874      3.08668     0.599880    -0.312425
[time_double(['2018-05-25/20:06:30', '2018-05-25/20:13:30']),16384],$      0.299128      3.97431    -0.465042     0.195468
[time_double(['2018-05-25/21:40:30', '2018-05-25/21:46:30']),16384],$       1.97970      5.97387     0.493040     0.347821
[time_double(['2018-05-26/04:36:30', '2018-05-26/04:42:30']),16384],$       22.9369      3.00694     0.981138    -0.479413
[time_double(['2018-05-26/23:02:30', '2018-05-26/23:08:30']),16384],$       23.9041      3.57904      23.0007     0.292287
;---------------------------------
;Choose conjunctions manually
ctime,/exact,vv
print,time_string(vv)
;---------------------------------
;Choose conjunctions automatically
ldiffmax = 0.5

get_data,'ldiff',t,d
labs = abs(d)
goo = where(labs le ldiffmax)
vv = t[goo]



mlt = fltarr(n_elements(vv))
lshell = fltarr(n_elements(vv))
dmlt = fltarr(n_elements(vv))
dl = fltarr(n_elements(vv))

for i=0,n_elements(vv)-1 do mlt[i] = tsample('meanMLT_RB',vv[i])
for i=0,n_elements(vv)-1 do lshell[i] = tsample('meanL_RB',vv[i])
for i=0,n_elements(vv)-1 do dmlt[i] = tsample('mltdiff',vv[i])
for i=0,n_elements(vv)-1 do dl[i] = tsample('ldiff',vv[i])
print,'TIME                         MLT         Lshell     deltaMLT     deltaL'
for i=0,n_elements(vv)-1 do print,time_string(vv[i])+ ' ',mlt[i],lshell[i],dmlt[i],dl[i]


print,'TIME START               TIME END                MLT         Lshell     deltaMLT     deltaL'
;for i=0,n_elements(vv)-1 do print,$
;    time_string(vv[i]-pm_time)+' - '+time_string(vv[i]+pm_time)+ ' ',mlt[i],lshell[i],dmlt[i],dl[i]

;Print times formatted for Tohban
print,'TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL'
for i=0,n_elements(vv)-1 do $
print,"[time_double(['" + time_string(vv[i]-pm_time) + "', '" + time_string(vv[i]+pm_time) + $
    "']),16384],$"+ ' ',mlt[i],lshell[i],dmlt[i],dl[i]




;FU3/RBSPa
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL
[time_double(['2018-04-19/18:13:30', '2018-04-19/18:18:30']),16384],$       7.91288      3.89882    -0.441901    -0.101515
[time_double(['2018-04-20/03:45:30', '2018-04-20/03:50:30']),16384],$       8.91467      3.02515    -0.583685    -0.388717
[time_double(['2018-04-20/21:10:30', '2018-04-20/21:15:30']),16384],$       8.11527      3.93768   -0.0101109    0.0582633
[time_double(['2018-04-22/00:05:30', '2018-04-22/00:10:30']),16384],$       8.07274      3.91946    -0.565399   -0.0218198
[time_double(['2018-04-23/20:24:30', '2018-04-23/20:29:30']),16384],$       7.43989      4.53006    -0.658023     0.464532
[time_double(['2018-04-28/17:30:30', '2018-04-28/17:35:30']),16384],$       8.45938      3.07735    -0.436086    -0.459601
[time_double(['2018-05-02/19:40:30', '2018-05-02/19:45:30']),16384],$       7.85311      3.72249    -0.664723     0.119178
[time_double(['2018-05-03/22:36:30', '2018-05-03/22:41:30']),16384],$       7.95460      3.70787    -0.633408   -0.0528326
[time_double(['2018-05-08/21:33:30', '2018-05-08/21:38:30']),16384],$       1.44795      3.74309     0.574963    -0.437614
[time_double(['2018-05-10/00:29:30', '2018-05-10/00:34:30']),16384],$       1.50046      3.87944     0.825666    -0.158122
[time_double(['2018-05-12/23:43:30', '2018-05-12/23:48:30']),16384],$      0.694559      3.19345    0.0532163    -0.190519
[time_double(['2018-05-17/20:50:30', '2018-05-17/20:55:30']),16384],$       1.82153      4.58116     0.862138     0.230081
[time_double(['2018-05-18/23:45:30', '2018-05-18/23:50:30']),16384],$       1.82534      4.63078     0.694665     0.155027
[time_double(['2018-05-19/17:09:30', '2018-05-19/17:14:30']),16384],$      0.979692      3.83743     0.935404    -0.484252
[time_double(['2018-05-20/20:04:30', '2018-05-20/20:09:30']),16384],$       1.16142      3.96050     0.471802     0.193586
[time_double(['2018-05-21/22:59:30', '2018-05-21/23:04:30']),16384],$       1.22341      4.04925     0.247046     0.351189
[time_double(['2018-05-22/16:24:30', '2018-05-22/16:29:30']),16384],$     0.0338614      3.09368     -23.6460    -0.215115
[time_double(['2018-05-23/01:55:30', '2018-05-23/02:00:30']),16384],$       1.23332      4.15151     0.825283     0.105775
[time_double(['2018-05-23/19:18:30', '2018-05-23/19:23:30']),16384],$      0.273539      3.21215    -0.239072    -0.381481
[time_double(['2018-05-24/22:13:30', '2018-05-24/22:18:30']),16384],$      0.434756      3.35173    -0.489402    -0.100896
[time_double(['2018-05-24/23:47:30', '2018-05-24/23:52:30']),16384],$       2.44778      5.65629     0.993173     0.322146
[time_double(['2018-05-26/01:08:30', '2018-05-26/01:13:30']),16384],$      0.485430      3.47496    -0.224076    -0.384198
[time_double(['2018-05-26/20:06:30', '2018-05-26/20:11:30']),16384],$       2.01828      5.30127     0.991708     0.496782


;FU4/RBSPa
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL[time_double(['2018-03-11/05:26:30', '2018-03-11/05:31:30']),16384],$       8.93988      3.99640    -0.672409   -0.0912011


;FU3/RBSPb
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL[time_double(['2018-03-11/05:26:30', '2018-03-11/05:31:30']),16384],$       8.93988      3.99640    -0.672409   -0.0912011


;FU4/RBSPb
TIME START                           TIME END                                MLT         Lshell     deltaMLT     deltaL[time_double(['2018-03-11/05:26:30', '2018-03-11/05:31:30']),16384],$       8.93988      3.99640    -0.672409   -0.0912011

end