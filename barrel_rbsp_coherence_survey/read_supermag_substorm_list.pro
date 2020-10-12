function read_supermag_substorm_list

path = '/Users/aaronbreneman/Desktop/Research/RBSP_hiss_precip2_coherence_survey/data/substorm_list/'
fn = '20180917-19-24-substorms.txt'

openr,lun,path+fn,/get_lun
jnk = ''    
for i=0,67 do readf,lun,jnk 
yy = ''
mm = '' 
dd = '' 
hr = ''
mn = ''
mlat = ''
mlt = ''

while not eof(lun) do begin ;$
    readf,lun,jnk  ;& $
    vals = strsplit(jnk,string(9B),/extract)  ;& $
    yy = [yy,vals[0]]  ;& $
    mm = [mm,vals[1]]  ;& $
    dd = [dd,vals[2]]  ;& $
    hr = [hr,vals[3]]  ;& $
    mn = [mn,vals[4]]  ;& $
    mlat = [mlat,vals[5]]  ;& $
    mlt = [mlt,vals[6]]
endwhile

close,lun 
free_lun,lun 
  

nelem = n_elements(yy)
yy = yy[1:nelem-1]
mm = mm[1:nelem-1]
dd = dd[1:nelem-1]
hr = hr[1:nelem-1]
mn = mn[1:nelem-1]
mlat = mlat[1:nelem-1]
mlt = mlt[1:nelem-1]

times = yy + '-' + mm + '-' + dd + '/' + hr + ':' + mn + ':' + '00'

return,{times:times,mlat:mlat,mlt:mlt}


end
