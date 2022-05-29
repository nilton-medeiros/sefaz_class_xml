#include <hmg.ch>


function isTrue(boolean)
	if (valtype(boolean) == "L")
		return boolean
	elseif (ValType(boolean) == "N")
		return (boolean > 0)
	endif
return False
