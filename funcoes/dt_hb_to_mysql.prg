
function dateTime_hb_to_mysql(d, t)
	local dt

	if Empty(d)
		dt := 'NULL'
	else
		dt := Transform(DToS(d), "@R 9999-99-99")
		if (ValType(t) == 'C') .and. !Empty(t)
			dt += ' ' + t
		endif
		dt := "'" + dt + "'"
	endif

return dt
