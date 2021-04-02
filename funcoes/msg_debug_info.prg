
procedure msgDebugInfo(inMsg)
	local ouMsg := {'Chamado de: ', ProcName(1) + '(' + hb_NToS(ProcLine(1)) + ') -->', hb_eol()}
	local msg
	if (ValType(inMsg) == 'A')
		for each msg in inMsg
			AAdd(ouMsg, msg)
		next
	else
		AAdd(ouMsg, inMsg)
	endif
	MsgInfo(ouMsg, 'DEBUG INFO')
return
