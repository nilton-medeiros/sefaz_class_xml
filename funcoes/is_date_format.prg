#include <hmg.ch>

function isDateFormat(d, t)
	local i := 0, len := iif(t == "D", 10, 19)
	local c, f, format := iif(t == "D", "9999-99-99", "9999-99-99T99:99:99")
	if ! ValType(d) == "C" .or. ! (HMG_LEN(d) == len)
		return False
	endif
	for each c in d
		i++
		f := hb_uSubStr(format, i, 1)
		if (f == "9")
			f := "0123456789"
		endif
		if ! (c $ f)
			return False
		endif
	next
return True
