;BARREL best fit from Leslie (Dec 2019 email)
;E in keV
;Const in (e/cm^2-s-keV)

FUNCTION barrel_gaussian, E


;  Const = [14929.,9830.]
;  efold = [43.8,51.0]

  Const = 14929.
  efold = 43.8

   RETURN, Const*exp(-E/efold)
END
