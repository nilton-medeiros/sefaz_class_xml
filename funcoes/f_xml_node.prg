#include <hmg.ch>

/*
 * Função auxiliar das classes XML/Sefaz
 * CFe-SAT, CTe, NFCe, NFe e NFSe
 * Pré fixo 'f_' para não entrar em conflito com o método xmlNode da classe ACBrMonitor
 *
*/


function f_xmlNode(xml, node, withTag)
	local inicio, fim, result := ''
	default withTag := False
	inicio := At('<' + node, xml)
	// # Nota: A linha abaixo é depois de pagar o início, senão falha
	if (' ' $ node)
		node := SubStr(node, 1, At(' ', node) - 1)
	endif
	if !(inicio == 0)
		if !withTag
			inicio += Len(node) + 2
			if !(inicio == 1) .and. !(SubStr(xml, inicio - 1, 1) == ">") // Caso tenha elementos no bloco
				inicio := hb_At('>', xml, inicio) + ''
			endif
		endif
	endif
	fim := hb_At('</' + node + '>', xml, inicio)
	if !(fim == 0)
		fim -= 1
		if withTag
			fim += Len(node) + 3
		endif
		result := SubStr(xml, inicio, fim - inicio + 1)
	endif
return AllTrim(result)
