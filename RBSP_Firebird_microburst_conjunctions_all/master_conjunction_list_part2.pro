;Part 2 of the code that produces a master conjunction list b/t FB and RBSP.
;This part reads in the files from Part 1 (e.g. FU?_RBSP?_conjunctions.sav)
;for all the combinations of FU3,FU4 and RBSPa,RBSPb.
;Outputs a "master list" with all the conjunctions. This has the number of
;conjunctions and the payloads involved for each day.
;e.g.
;20151215 a3 b3 ;  2 total conjunctions
;20160114 a4 b4 ;  2 total conjunctions
;20160120 a3 a4 b3 b4 ;  4 total conjunctions
;20160121 a3 a4 b3 b4 ;  5 total conjunctions
;20160122 a4 ;  1 total conjunctions
;20160127 b3 ;  1 total conjunctions

path = '/Users/aaronbreneman/Desktop/code/Aaron/github.umn.edu/RBSP_Firebird_microburst_conjunctions_all/'



probe = 'a'
fb = 'FU3'
hires = 0

if keyword_set(hires) then $
	suffix = '_conjunctions_hr.sav' else $
	suffix = '_conjunctions.sav'


fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,path+fn
tfb0 = t0
tfb1 = t1

datetmp1 = strarr(n_elements(tfb0))
t0tmp1 = strarr(n_elements(tfb0))
t1tmp1 = strarr(n_elements(tfb0))

for i=0,n_elements(tfb0)-1 do begin
	datetmp1[i] = strmid(time_string(tfb0[i]),0,4) + strmid(time_string(tfb0[i]),5,2) + strmid(time_string(tfb0[i]),8,2)
	t0tmp1[i] = strmid(time_string(tfb0[i]),11,8)
	t1tmp1[i] = strmid(time_string(tfb1[i]),11,8)
	;print,datetmp1[i]
endfor

undefine,t0,t1
;--------------
probe = 'a'
fb = 'FU4'

fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,path+fn
tfb0 = t0
tfb1 = t1

datetmp2 = strarr(n_elements(tfb0))
t0tmp2 = strarr(n_elements(tfb0))
t1tmp2 = strarr(n_elements(tfb0))

for i=0,n_elements(tfb0)-1 do begin
	datetmp2[i] = strmid(time_string(tfb0[i]),0,4) + strmid(time_string(tfb0[i]),5,2) + strmid(time_string(tfb0[i]),8,2)
	t0tmp2[i] = strmid(time_string(tfb0[i]),11,8)
	t1tmp2[i] = strmid(time_string(tfb1[i]),11,8)
	;print,datetmp2[i]
endfor

undefine,t0,t1
;--------------

probe = 'b'
fb = 'FU3'

fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,path+fn
tfb0 = t0
tfb1 = t1

datetmp3 = strarr(n_elements(tfb0))
t0tmp3 = strarr(n_elements(tfb0))
t1tmp3 = strarr(n_elements(tfb0))

for i=0,n_elements(tfb0)-1 do begin
	datetmp3[i] = strmid(time_string(tfb0[i]),0,4) + strmid(time_string(tfb0[i]),5,2) + strmid(time_string(tfb0[i]),8,2)
	t0tmp3[i] = strmid(time_string(tfb0[i]),11,8)
	t1tmp3[i] = strmid(time_string(tfb1[i]),11,8)
	;print,datetmp3[i]
endfor

undefine,t0,t1

;--------------

probe = 'b'
fb = 'FU4'

fn = fb+'_'+'RBSP'+strupcase(probe)+suffix
restore,path+fn
tfb0 = t0
tfb1 = t1

datetmp4 = strarr(n_elements(tfb0))
t0tmp4 = strarr(n_elements(tfb0))
t1tmp4 = strarr(n_elements(tfb0))

for i=0,n_elements(tfb0)-1 do begin
	datetmp4[i] = strmid(time_string(tfb0[i]),0,4) + strmid(time_string(tfb0[i]),5,2) + strmid(time_string(tfb0[i]),8,2)
	t0tmp4[i] = strmid(time_string(tfb0[i]),11,8)
	t1tmp4[i] = strmid(time_string(tfb1[i]),11,8)
	;print,datetmp4[i]
endfor

undefine,t0,t1

;----------------------
;Glom all dates together
dates = [datetmp1,datetmp2,datetmp3,datetmp4]
t0 = [t0tmp1,t0tmp2,t0tmp3,t0tmp4]
t1 = [t1tmp1,t1tmp2,t1tmp3,t1tmp4]

d2 = time_double(dates)
b = d2[UNIQ(d2, SORT(d2))]
datesfin = time_string(b,prec=-3,format=2)


;determine which pairs exist for each date
for i=0,n_elements(datesfin)-1 do begin
	goo1 = where(datetmp1 eq datesfin[i])
	goo2 = where(datetmp2 eq datesfin[i])
	goo3 = where(datetmp3 eq datesfin[i])
	goo4 = where(datetmp4 eq datesfin[i])

	str = ' '
	if goo1[0] ne -1 then str += 'a3 '
	if goo2[0] ne -1 then str += 'a4 '
	if goo3[0] ne -1 then str += 'b3 '
	if goo4[0] ne -1 then str += 'b4 '

	if goo1[0] ne -1 then t1 = n_elements(goo1) else t1 = 0.
	if goo2[0] ne -1 then t2 = n_elements(goo2) else t2 = 0.
	if goo3[0] ne -1 then t3 = n_elements(goo3) else t3 = 0.
	if goo4[0] ne -1 then t4 = n_elements(goo4) else t4 = 0.
	;determine number of conjunctions on current day
	nconj = string(t1 + t2 + t3 + t4,format='(I2)')

	print,datesfin[i] + str + '; ' + nconj + ' total conjunctions'
;	print,datesfin[i]
;	print,str
;	print,nconj

;20160121 a3 a4 b3 b4 ;  5 total conjunctions

endfor
;---------------------------------------------------
;Find all unique dates

dates = [datetmp1,datetmp2,datetmp3,datetmp4]
d2 = time_double(dates)
b = d2[UNIQ(d2, SORT(d2))]
datesfin = time_string(b,prec=-3,format=2)

;For each unique date...
for i=0,n_elements(datesfin)-1 do begin

	goo1 = where(datetmp1 eq datesfin[i])

endfor


t0 = [t0tmp1,t0tmp2,t0tmp3,t0tmp4]
t1 = [t1tmp1,t1tmp2,t1tmp3,t1tmp4]


stop
end
