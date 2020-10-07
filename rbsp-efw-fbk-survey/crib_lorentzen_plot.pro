;Plot data by Lshell vs MLT like in Lorentzen, 2001 paper

rbsp_efw_init

perocc = info.percentoccurrence_bin.percent_peaks
cnts = info.percentoccurrence_bin.counts
mlts = info.grid.grid_theta_center
lshells = info.grid.grid_lshell_center

ilat = acos(sqrt(1/lshells))/!dtor  ;invariant latitude



n = 8.		;keep at 8 for good colorbar labeling (doesn't seem to like more than 8 labels)
maxv = 50.	;max %occ value

colors = 255*indgen(n)/max(n-1)
colors[n-1] = 250.
levels = maxv*indgen(n)/(n-1)
levels2 = maxv*indgen(n-1)/(n-2)  ;for ticknames
ticknames = strtrim(string(levels2,format='(i3)'),2)


maxc = 1000d	;max count value
levelsc = maxc*indgen(n)/(n-1)
levelsc2 = maxc*indgen(n-1)/(n-2)
ticknamesc = strtrim(string(levelsc2,format='(i4)'),2)



!p.multi = [0,0,2]
contour,100.*transpose(perocc),mlts,ilat,/cell_fill,c_colors=colors,levels=levels,$
	ytitle='ilat',xtitle='MLT',yrange=[50,80],position=[0.10,0.55,0.95,0.80],title='%occ - ILAT vs MLT'
contour,transpose(cnts),mlts,ilat,/cell_fill,c_colors=colors,levels=levelsc,$
	ytitle='ilat',xtitle='MLT',yrange=[50,80],position=[0.10,0.07,0.95,0.32],title='counts - ILAT vs MLT'

colorbar,POSITION=[0.10, 0.93, 0.95, 0.95],c_colors=colors,levels=levels,ticknames=ticknames
colorbar,POSITION=[0.10, 0.44, 0.95, 0.46],c_colors=colors,levels=levelsc,ticknames=ticknamesc





!p.multi = [0,0,2]
contour,100.*transpose(perocc),mlts,lshells,/cell_fill,c_colors=colors,levels=levels,$
	ytitle='lshell',xtitle='MLT',yrange=[2.5,7],position=[0.10,0.55,0.95,0.80],title='%occ - LSHELL vs MLT'
contour,transpose(cnts),mlts,lshells,/cell_fill,c_colors=colors,levels=levelsc,$
	ytitle='lshell',xtitle='MLT',yrange=[2.5,7],position=[0.10,0.07,0.95,0.32],title='counts - LSHELL vs MLT'

colorbar,POSITION=[0.10, 0.93, 0.95, 0.95],c_colors=colors,levels=levels,ticknames=ticknames
colorbar,POSITION=[0.10, 0.44, 0.95, 0.46],c_colors=colors,levels=levelsc,ticknames=ticknamesc





