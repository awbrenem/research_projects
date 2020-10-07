;Make a geographic plot of BARREL balloon trajectories.
;This is my attempt to relate overall precipitation amount vs
;Geographic coord to see if precip increases over areas of weaker
;surface magnetic field.


rbsp_efw_init
tplot_options,'title','plot_barrel_geo_lat_lon.pro'

tplot_options,'xmargin',[20.,16.]
tplot_options,'ymargin',[3,9]
tplot_options,'xticklen',0.08
tplot_options,'yticklen',0.02
tplot_options,'xthick',2
tplot_options,'ythick',2
tplot_options,'labflag',-1




timespan,'2014-01-01',45,/days

bal = ['W','I','L','X','T','A','B','C','D','M','O','Q','P','E','F','N','Y']

for i=0,n_elements(bal)-1 do load_barrel_lc,'2'+bal[i],type='ephm'


store_data,'lon_comb',data='lon_2'+bal
store_data,'lat_comb',data='lat_2'+bal
store_data,'l_comb',data='L_Kp2_2'+bal
;store_data,'lon_comb',data='lon_'+['2W','2I','2L','2X','2T','2A','2B','2C','2D','2M','2O','2Q','2P','2E','2F','2N','2Y']
;store_data,'lat_comb',data='lat_'+['2W','2I','2L','2X','2T','2A','2B','2C','2D','2M','2O','2Q','2P','2E','2F','2N','2Y']
ylim,'lon_comb',-180,180
ylim,'lat_comb',-90,90
ylim,'l_comb',0,20
tplot,['lon_comb','lat_comb','l_comb']
;tplot,['lon_2A','lat_2A','L_Kp2_2A']



;------------------------------------------------------------
;Make geographic plot of all payload trajectories
;------------------------------------------------------------

get_data,'lon_2W',t,lon
get_data,'lat_2W',t,lat
plot,lon,lat,xrange=[-180,180],yrange=[-90,90],psym=2,ystyle=1,xstyle=1
for i=1,n_elements(bal-1) do begin $
    get_data,'lon_2'+bal[i],t,lon  & $
    get_data,'lat_2'+bal[i],t,lat  & $
    oplot,lon,lat,psym=2




;-------------------------------------------------------------
;Plot single payload track with markers at each day boundary.
;-------------------------------------------------------------


pld = '2P'

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/folder_singlepayload/'
fn = 'barrel_'+pld+'_fspc_fullmission.tplot' & tplot_restore,filenames=path + fn
rbsp_detrend,'fspc_'+pld,5.*60.


get_data,'lon_'+pld,t,lon
get_data,'lat_'+pld,t,lat
plot,lon,lat,xrange=[-180,180],yrange=[-90,90],psym=2,ystyle=1,xstyle=1,title='plot_barrel_geo_lat_lon.pro'

daystarts = time_double('2014-01-01') + indgen(45)*86400.
for i=0,n_elements(daystarts)-1 do begin $
    goo = where(t ge daystarts[i]) & $
    if (t[goo[0]]-daystarts[i] le 1000.) then oplot,[lon[goo[0]],lon[goo[0]]],[lat[goo[0]],lat[goo[0]]],psym=2,color=250 & $
    xyouts,[lon[goo[0]],lon[goo[0]]],[lat[goo[0]]+2,lat[goo[0]]+2],strmid(time_string(daystarts[i]),8,2)

tplot,'fspc_'+pld+'_smoothed'
