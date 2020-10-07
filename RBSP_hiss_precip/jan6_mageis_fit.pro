function jan6_mageis_fit,E
	return,4.7d5*exp(-E/25.8) + 7.7d3*exp(-E/197) ;with E in keV and J in electrons/(cm2 s sr keV) 
end
