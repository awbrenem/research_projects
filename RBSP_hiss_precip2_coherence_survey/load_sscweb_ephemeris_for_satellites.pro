;Loads ephemeris data I've grabbed from SSCWeb for a bunch of satellites that can have conjunctions
;with the BARREL balloons.
;Puts all relevant data in a structure and saves to a file for later recall

;Used mostly for overlaying payload positions on dial plots with balloons


pro load_sscweb_ephemeris_for_satellites



path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/ephemeris_allsatellites/'

fn = ['Cluster1_campaign1_ephem.txt',$
'Cluster1_campaign2_ephem.txt',$
'Cluster2_campaign1_ephem.txt',$
'Cluster2_campaign2_ephem.txt',$
'Cluster3_campaign1_ephem.txt',$
'Cluster3_campaign2_ephem.txt',$
'Cluster4_campaign1_ephem.txt',$
'Cluster4_campaign2_ephem.txt',$
'GOES13_campaign1_ephem.txt',$
'GOES13_campaign2_ephem.txt',$
'GOES15_campaign1_ephem.txt',$
'GOES15_campaign2_ephem.txt',$
'RBSPa_campaign1_ephem.txt',$
'RBSPa_campaign2_ephem.txt',$
'RBSPb_campaign1_ephem.txt',$
'RBSPb_campaign2_ephem.txt',$
'THA_campaign1_ephem.txt',$
'THA_campaign2_ephem.txt',$
'THB_campaign1_ephem.txt',$
'THB_campaign2_ephem.txt',$
'THC_campaign1_ephem.txt',$
'THC_campaign2_ephem.txt',$
'THD_campaign1_ephem.txt',$
'THD_campaign2_ephem.txt',$
'THE_campaign1_ephem.txt',$
'THE_campaign2_ephem.txt']



for b=0,n_elements(fn)-1 do begin


openr,lun,path+fn[b],/get_lun
jnk = ''
for i=0,82 do readf,lun,jnk

;vars to load
date = '' & time = ''
geox = '' & geoy = '' & geoz = ''
geolat = '' & geolon = '' & geolt = ''
gsex = '' & gsey = '' & gsez = ''
gselat = '' & gselon = '' & gselt = ''
n_btrace_geo_lat = '' & n_btrace_geo_lon = '' & n_btrace_geo_arclen = ''
s_btrace_geo_lat = '' & s_btrace_geo_lon = '' & s_btrace_geo_arclen = ''
n_btrace_gm_lat = '' & n_btrace_gm_lon = '' & n_btrace_gm_arclen = ''
s_btrace_gm_lat = '' & s_btrace_gm_lon = '' & s_btrace_gm_arclen = ''
radius = '' & dipL = ''
dbowshk = '' & dmpause = ''
dipinvlat = '' & region = ''
n_btraced = '' & s_btraced = ''


dat = ''
while not eof(lun) do begin
    readf,lun,dat
    datarr = strsplit(dat,' ',/extract)

    date = [date,datarr[0]]
    time = [time,datarr[1]]
    geox = [geox,datarr[2]]
    geoy = [geoy,datarr[3]]
    geoz = [geoz,datarr[4]]
    geolat = [geolat,datarr[5]]
    geolon = [geolon,datarr[6]]
    geolt = [geolt,datarr[7]]
    gsex = [gsex,datarr[8]]
    gsey = [gsey,datarr[9]]
    gsez = [gsez,datarr[10]]
    gselat = [gselat,datarr[11]]
    gselon = [gselon,datarr[12]]
    gselt = [gselt,datarr[13]]
    n_btrace_geo_lat = [n_btrace_geo_lat,datarr[14]]
    n_btrace_geo_lon = [n_btrace_geo_lon,datarr[15]]
    n_btrace_geo_arclen = [n_btrace_geo_arclen,datarr[16]]
    s_btrace_geo_lat = [s_btrace_geo_lat,datarr[17]]
    s_btrace_geo_lon = [s_btrace_geo_lon,datarr[18]]
    s_btrace_geo_arclen = [s_btrace_geo_arclen,datarr[19]]

    n_btrace_gm_lat = [n_btrace_gm_lat,datarr[20]]
    n_btrace_gm_lon = [n_btrace_gm_lon,datarr[21]]
    n_btrace_gm_arclen = [n_btrace_gm_arclen,datarr[22]]
    s_btrace_gm_lat = [s_btrace_gm_lat,datarr[23]]
    s_btrace_gm_lon = [s_btrace_gm_lon,datarr[24]]
    s_btrace_gm_arclen = [s_btrace_gm_arclen,datarr[25]]

    radius = [radius,datarr[26]]
    dbowshk = [dbowshk,datarr[27]]
    dmpause = [dmpause,datarr[28]]
    dipL = [dipL,datarr[29]]
    dipinvlat = [dipinvlat,datarr[30]]
    region = [region,datarr[31]]
    n_btraced = [n_btraced,datarr[32]]
    s_btraced = [s_btraced,datarr[33]]

endwhile

close,lun
free_lun,lun

nel = n_elements(date)

date = date[1:nel-1]
time = time[1:nel-1]
geox = geox[1:nel-1] & geoy = geoy[1:nel-1] & geoz = geoz[1:nel-1]
geolat = geolat[1:nel-1] & geolon = geolon[1:nel-1] & geolt = geolt[1:nel-1]
gsex = gsex[1:nel-1] & gsey = gsey[1:nel-1] & gsez = gsez[1:nel-1]
gselat = gselat[1:nel-1] & gselon = gselon[1:nel-1] & gselt = gselt[1:nel-1]
n_btrace_geo_lat = n_btrace_geo_lat[1:nel-1] & n_btrace_geo_lon= n_btrace_geo_lon[1:nel-1] & n_btrace_geo_arclen = n_btrace_geo_arclen[1:nel-1]
s_btrace_geo_lat = s_btrace_geo_lat[1:nel-1] & s_btrace_geo_lon= s_btrace_geo_lon[1:nel-1] & s_btrace_geo_arclen = s_btrace_geo_arclen[1:nel-1]
n_btrace_gm_lat = n_btrace_gm_lat[1:nel-1] & n_btrace_gm_lon = n_btrace_gm_lon[1:nel-1] & n_btrace_gm_arclen = n_btrace_gm_arclen[1:nel-1]
s_btrace_gm_lat = s_btrace_gm_lat[1:nel-1] & s_btrace_gm_lon = s_btrace_gm_lon[1:nel-1] & s_btrace_gm_arclen = s_btrace_gm_arclen[1:nel-1]
radius = radius[1:nel-1]
dbowshk = dbowshk[1:nel-1] & dmpause = dmpause[1:nel-1]
dipL = dipL[1:nel-1] & dipinvlat = dipinvlat[1:nel-1]
region = region[1:nel-1]
;n_btraced = n_btraced[1:nel-1] & s_btraced = s_btraced[1:nel-1]

date2 = '20' + strmid(date,0,2) + '-' + strmid(date,3,2) + '-' + strmid(date,6,2)
datefin = time_double(date2 + '/' + time)
geox = float(geox)
geoy = float(geoy)
geoz = float(geoz)
geolat = float(geolat)
geolon = float(geolon)
geolt = float(geolt)

gsex = float(gsex)
gsey = float(gsey)
gsez = float(gsez)
gselat = float(gselat)
gselon = float(gselon)

hh = float(strmid(gselt,0,2))
mm = float(strmid(gselt,3,2))
ss = float(strmid(gselt,6,2))
gselt = hh + mm/60. + ss/3600.


n_btrace_geo_lat = float(n_btrace_geo_lat)
n_btrace_geo_lon = float(n_btrace_geo_lon)
n_btrace_geo_arclen = float(n_btrace_geo_arclen)
s_btrace_geo_lat = float(s_btrace_geo_lat)
s_btrace_geo_lon = float(s_btrace_geo_lon)
s_btrace_geo_arclen = float(s_btrace_geo_arclen)
n_btrace_gm_lat = float(n_btrace_gm_lat)
n_btrace_gm_lon = float(n_btrace_gm_lon)
n_btrace_gm_arclen = float(n_btrace_gm_arclen)
s_btrace_gm_lat = float(s_btrace_gm_lat)
s_btrace_gm_lon = float(s_btrace_gm_lon)
s_btrace_gm_arclen = float(s_btrace_gm_arclen)
radius = float(radius)
dbowshk = float(dbowshk)
dmpause = float(dmpause)
dipL = float(dipL)
dipinvlat = float(dipinvlat)
;region = float(region)
;n_btraced = float(n_btraced)
;s_btraced = float(s_btraced)


;store_data,'gse',datefin,[[gsex],[gsey],[gsez]]
vals = {datetime:datefin,$
        geocoord:[[geox],[geoy],[geoz]],$
        geolat:geolat,geolon:geolon,geolt:geolt,$
        gsecoord:[[gsex],[gsey],[gsez]],$
        gselat:gselat,gselon:gselon,gselt:gselt,$
        n_btrace_geo_lat:n_btrace_geo_lat,$
        n_btrace_geo_lon:n_btrace_geo_lon,$
        n_btrace_geo_arclen:n_btrace_geo_arclen,$
        s_btrace_geo_lat:s_btrace_geo_lat,$
        s_btrace_geo_lon:s_btrace_geo_lon,$
        s_btrace_geo_arclen:s_btrace_geo_arclen,$
        n_btrace_gm_lat:n_btrace_gm_lat,$
        n_btrace_gm_lon:n_btrace_gm_lon,$
        n_btrace_gm_arclen:n_btrace_gm_arclen,$
        s_btrace_gm_lat:s_btrace_gm_lat,$
        s_btrace_gm_lon:s_btrace_gm_lon,$
        s_btrace_gm_arclen:s_btrace_gm_arclen,$
        radius:radius,$
        dbowshk:dbowshk,dmpause:dmpause,$
        dipL:dipL,dipinvlat:dipinvlat,$
        region:region}

    len = strlen(fn[b])
    pre = strmid(fn[b],0,len-4)
    SAVE, vals, FILENAME = '~/Desktop/'+pre+'.sav'

endfor


end
