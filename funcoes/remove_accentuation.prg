
/*
 * Função auxiliar das classes XML/Sefaz
 * CFe-SAT, CTe, NFCe, NFe e NFSe
 *
*/

function removeAccentuation(text)
	if Empty(text)
		return ''
	endif
	text := hb_utf8StrTran(text, "Ã", "A")
	text := hb_utf8StrTran(text, "Á", "A")
	text := hb_utf8StrTran(text, "À", "A")
	text := hb_utf8StrTran(text, "Â", "A")
	text := hb_utf8StrTran(text, "ã", "a")
	text := hb_utf8StrTran(text, "á", "a")
	text := hb_utf8StrTran(text, "à", "a")
	text := hb_utf8StrTran(text, "â", "a")
	text := hb_utf8StrTran(text, "Ä", "A")
	text := hb_utf8StrTran(text, "ä", "a")
	text := hb_utf8StrTran(text, "É", "A")
	text := hb_utf8StrTran(text, "È", "E")
	text := hb_utf8StrTran(text, "Ê", "E")
	text := hb_utf8StrTran(text, "é", "E")
	text := hb_utf8StrTran(text, "è", "e")
	text := hb_utf8StrTran(text, "ê", "e")
	text := hb_utf8StrTran(text, "Ë", "E")
	text := hb_utf8StrTran(text, "ë", "e")
	text := hb_utf8StrTran(text, "Í", "I")
	text := hb_utf8StrTran(text, "Ì", "I")
	text := hb_utf8StrTran(text, "Î", "I")
	text := hb_utf8StrTran(text, "í", "i")
	text := hb_utf8StrTran(text, "ì", "i")
	text := hb_utf8StrTran(text, "î", "i")
	text := hb_utf8StrTran(text, "Ï", "I")
	text := hb_utf8StrTran(text, "ï", "i")
	text := hb_utf8StrTran(text, "Õ", "o")
	text := hb_utf8StrTran(text, "Ó", "o")
	text := hb_utf8StrTran(text, "Ò", "o")
	text := hb_utf8StrTran(text, "Ô", "o")
	text := hb_utf8StrTran(text, "õ", "o")
	text := hb_utf8StrTran(text, "ó", "o")
	text := hb_utf8StrTran(text, "ò", "o")
	text := hb_utf8StrTran(text, "ô", "o")
	text := hb_utf8StrTran(text, "Ö", "O")
	text := hb_utf8StrTran(text, "ö", "o")
	text := hb_utf8StrTran(text, "Ú", "U")
	text := hb_utf8StrTran(text, "Ù", "U")
	text := hb_utf8StrTran(text, "Û", "U")
	text := hb_utf8StrTran(text, "ú", "U")
	text := hb_utf8StrTran(text, "ù", "U")
	text := hb_utf8StrTran(text, "û", "U")
	text := hb_utf8StrTran(text, "Ü", "U")
	text := hb_utf8StrTran(text, "ü", "u")
	text := hb_utf8StrTran(text, "Ý", "Y")
	text := hb_utf8StrTran(text, "ý", "y")
	text := hb_utf8StrTran(text, "ÿ", "y")
	text := hb_utf8StrTran(text, "Ç", "C")
	text := hb_utf8StrTran(text, "ç", "c")
	text := hb_utf8StrTran(text, "º", "o.")
	text := hb_utf8StrTran(text, "", "A")
	text := hb_utf8StrTran(text, "", "a")
	text := hb_utf8StrTran( text, Chr(195) + Chr(173), "i" ) // i acentuado minusculo
	text := hb_utf8StrTran( text, Chr(195) + Chr(135), "C" ) // c cedilha maiusculo
	text := hb_utf8StrTran( text, Chr(195) + Chr(141), "I" ) // i acentuado maiusculo
	text := hb_utf8StrTran( text, Chr(195) + Chr(163), "a" ) // a acentuado minusculo
	text := hb_utf8StrTran( text, Chr(195) + Chr(167), "c" ) // c acentuado minusculo
	text := hb_utf8StrTran( text, Chr(195) + Chr(161), "a" ) // a acentuado minusculo
	text := hb_utf8StrTran( text, Chr(195) + Chr(131), "A" ) // a acentuado maiusculo
	text := hb_utf8StrTran( text, Chr(194) + Chr(186), "o." ) // numero simbolo
	// so pra corrigir no MySql
	text := hb_utf8StrTran( text, "+" + Chr(129), "A" )
	text := hb_utf8StrTran( text, "+" + Chr(137), "E" )
	text := hb_utf8StrTran( text, "+" + Chr(131), "A" )
	text := hb_utf8StrTran( text, "+" + Chr(135), "C" )
	text := hb_utf8StrTran( text, "?" + Chr(167), "c" )
	text := hb_utf8StrTran( text, "?" + Chr(163), "a" )
	text := hb_utf8StrTran( text, "?" + Chr(173), "i" )
	text := hb_utf8StrTran( text, "?" + Chr(131), "A" )
	text := hb_utf8StrTran( text, "?" + Chr(161), "a" )
	text := hb_utf8StrTran( text, "?" + Chr(141), "I" )
	text := hb_utf8StrTran( text, "?" + Chr(135), "C" )
	text := hb_utf8StrTran( text, Chr(195) + Chr(156), "a" )
	text := hb_utf8StrTran( text, Chr(195) + Chr(159), "A" )
	text := hb_utf8StrTran( text, "?" + Chr(129), "A" )
	text := hb_utf8StrTran( text, "?" + Chr(137), "E" )
	text := hb_utf8StrTran( text, Chr(195) + "?", "C" )
	text := hb_utf8StrTran( text, "?" + Chr(149), "O" )
	text := hb_utf8StrTran( text, "?" + Chr(154), "U" )
	text := hb_utf8StrTran( text, "+" + Chr(170), "o" )
	text := hb_utf8StrTran( text, "?" + Chr(128), "A" )
	text := hb_utf8StrTran( text, Chr(195) + Chr(166), "e" )
	text := hb_utf8StrTran( text, Chr(135) + Chr(227), "ca" )
	text := hb_utf8StrTran( text, "n" + Chr(227), "na" )
	text := hb_utf8StrTran( text, Chr(162), "o" )
return text
