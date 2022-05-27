#include <hmg.ch>

procedure sysWait(wait)
	local time := Seconds()
	default wait := 2
	do while (Seconds() - time) < wait
		Inkey(1)
	enddo
return
