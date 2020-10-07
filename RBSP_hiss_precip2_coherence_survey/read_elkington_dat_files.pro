;Read Elkington simulation output files.

tplot_options,'title','read_elkington_dat_files.pro'


path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/Analysis_major_events_campaign2/Jan8/Elkington_simulations/SatDat/'
fn = 'mhdout-LFMRCM-20140108_BARREL.BARREL-2K.dat' & prefix = '2K_'

;fn = 'mhdout-LFMRCM-20140108_BARREL.BARREL-2L.dat' & prefix = '2L_'
;fn = 'mhdout-LFMRCM-20140108_BARREL.BARREL-2X.dat' & prefix = '2X_'



openr,lun,path+fn,/get_lun
jnk = ''
readf,lun,jnk
variables = ''
readf,lun,variables

yr = ''
mn = ''
dy = ''
times = ''
xy = [[0.],[0.]]
efield = [[0.],[0.],[0.]]
bfield = efield
velocity = efield
dens = 0.
energy_density = 0.

while not eof(lun) do begin
  readf,lun,jnk
  vals = strsplit(jnk,' ',/extract)
  yr = [yr,strmid(vals[0],0,4)]
  mn = [mn,strmid(vals[0],5,2)]
  dy = [dy,strmid(vals[0],8,2)]
  times = [times,vals[1]]

  xy2 = [[vals[2]],[vals[3]]]
  xy = [xy,xy2]

  efield2 = [[vals[4]],[vals[5]],[vals[6]]]
  efield = [efield,efield2]
  bfield2 = [[vals[7]],[vals[8]],[vals[9]]]
  bfield = [bfield,bfield2]

  velocity2 = [[vals[10]],[vals[11]],[vals[12]]]
  velocity = [velocity,velocity2]

  dens = [dens,vals[13]]
  energy_density = [energy_density,vals[14]]

endwhile

close,lun & free_lun,lun

n = n_elements(yr)-1
yr = yr[1:n]
mn = mn[1:n]
dy = dy[1:n]
times = times[1:n]
dens = dens[1:n]
energy_density = energy_density[1:n]

xy = xy[1:n,*]
efield = efield[1:n,*]
bfield = bfield[1:n,*]
velocity = velocity[1:n,*]

tt = yr + '-' + mn + '-' + dy + '/' + times
tt = time_double(tt)


bmag = sqrt(bfield[*,0]^2 + bfield[*,1]^2 + bfield[*,2]^2)
store_data,prefix+'bmag',tt,bmag

store_data,prefix+'position',tt,xy
store_data,prefix+'velocity',tt,velocity
store_data,prefix+'efield',tt,efield
store_data,prefix+'bfield',tt,bfield
store_data,prefix+'density',tt,dens
store_data,prefix+'energy_density',tt,energy_density

rbsp_detrend,prefix+'?field',60.*5.
rbsp_detrend,prefix+'?field_smoothed',60.*80.
rbsp_detrend,prefix+'density',60.*5.
rbsp_detrend,prefix+'density_smoothed',60.*80.
rbsp_detrend,prefix+'bmag',60.*5.
rbsp_detrend,prefix+'bmag_smoothed',60.*80.

omni_hro_load
load_barrel_lc,['2X','2K','2L'],type='rcnt'

rbsp_detrend,'PeakDet_2?',60.*5.
rbsp_detrend,'PeakDet_2?_smoothed',60.*80.

tplot,['PeakDet_2X_smoothed_detrend',prefix+'density_smoothed_detrend','OMNI_HRO_1min_Pressure']
tplot,['PeakDet_2K_smoothed',prefix+'bmag_smoothed',prefix+'density_smoothed_detrend','OMNI_HRO_1min_Pressure']

tplot,['PeakDet_2?_smoothed',prefix+'bmag_smoothed',prefix+'density_smoothed_detrend','OMNI_HRO_1min_Pressure']

stop





end
