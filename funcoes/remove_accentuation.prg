
/*
 * Função auxiliar das classes XML/Sefaz
 * CFe-SAT, CTe, NFCe, NFe e NFSe
 *
*/

function removeAccentuation(text)

	if Empty(text)
		return ''
	endif

	text := HB_UTF8STRTRAN(text, "Ã", "A")
	text := HB_UTF8STRTRAN(text, "Á", "A")
	text := HB_UTF8STRTRAN(text, "À", "A")
	text := HB_UTF8STRTRAN(text, "Â", "A")
	text := HB_UTF8STRTRAN(text, "ã", "a")
	text := HB_UTF8STRTRAN(text, "á", "a")
	text := HB_UTF8STRTRAN(text, "à", "a")
	text := HB_UTF8STRTRAN(text, "â", "a")
	text := HB_UTF8STRTRAN(text, "Ä", "A")
	text := HB_UTF8STRTRAN(text, "ä", "a")
	text := HB_UTF8STRTRAN(text, "É", "E")
	text := HB_UTF8STRTRAN(text, "È", "E")
	text := HB_UTF8STRTRAN(text, "Ê", "E")
	text := HB_UTF8STRTRAN(text, "é", "e")
	text := HB_UTF8STRTRAN(text, "è", "e")
	text := HB_UTF8STRTRAN(text, "ê", "e")
	text := HB_UTF8STRTRAN(text, "Ë", "E")
	text := HB_UTF8STRTRAN(text, "ë", "e")
	text := HB_UTF8STRTRAN(text, "Í", "I")
	text := HB_UTF8STRTRAN(text, "Ì", "I")
	text := HB_UTF8STRTRAN(text, "Î", "I")
	text := HB_UTF8STRTRAN(text, "í", "i")
	text := HB_UTF8STRTRAN(text, "ì", "i")
	text := HB_UTF8STRTRAN(text, "î", "i")
	text := HB_UTF8STRTRAN(text, "Ï", "I")
	text := HB_UTF8STRTRAN(text, "ï", "I")
	text := HB_UTF8STRTRAN(text, "Õ", "O")
	text := HB_UTF8STRTRAN(text, "Ó", "O")
	text := HB_UTF8STRTRAN(text, "Ò", "O")
	text := HB_UTF8STRTRAN(text, "Ô", "O")
	text := HB_UTF8STRTRAN(text, "Ö", "O")
	text := HB_UTF8STRTRAN(text, "õ", "o")
	text := HB_UTF8STRTRAN(text, "ó", "o")
	text := HB_UTF8STRTRAN(text, "ò", "o")
	text := HB_UTF8STRTRAN(text, "ô", "o")
	text := HB_UTF8STRTRAN(text, "ö", "o")
	text := HB_UTF8STRTRAN(text, "Ú", "U")
	text := HB_UTF8STRTRAN(text, "Ù", "U")
	text := HB_UTF8STRTRAN(text, "Û", "U")
	text := HB_UTF8STRTRAN(text, "ú", "u")
	text := HB_UTF8STRTRAN(text, "ù", "u")
	text := HB_UTF8STRTRAN(text, "û", "u")
	text := HB_UTF8STRTRAN(text, "Ü", "U")
	text := HB_UTF8STRTRAN(text, "ü", "u")
	text := HB_UTF8STRTRAN(text, "Ý", "Y")
	text := HB_UTF8STRTRAN(text, "ý", "y")
	text := HB_UTF8STRTRAN(text, "ÿ", "y")
	text := HB_UTF8STRTRAN(text, "Ç", "C")
	text := HB_UTF8STRTRAN(text, "ç", "c")
	text := HB_UTF8STRTRAN(text, "º", "o.")
	text := HB_UTF8STRTRAN(text, "", "A")
	text := HB_UTF8STRTRAN(text, "", "a")
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(173), "i" ) // i acentuado minusculo
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(135), "C" ) // c cedilha maiusculo
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(141), "I" ) // i acentuado maiusculo
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(163), "a" ) // a acentuado minusculo
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(167), "c" ) // c acentuado minusculo
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(161), "a" ) // a acentuado minusculo
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(131), "A" ) // a acentuado maiusculo
	text := HB_UTF8STRTRAN( text, Chr(194) + Chr(186), "o." ) // numero simbolo
	// so pra corrigir no MySql
	text := HB_UTF8STRTRAN( text, "+" + Chr(129), "A" )
	text := HB_UTF8STRTRAN( text, "+" + Chr(137), "E" )
	text := HB_UTF8STRTRAN( text, "+" + Chr(131), "A" )
	text := HB_UTF8STRTRAN( text, "+" + Chr(135), "C" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(167), "c" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(163), "a" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(173), "i" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(131), "A" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(161), "a" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(141), "I" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(135), "C" )
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(156), "a" )
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(159), "A" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(129), "A" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(137), "E" )
	text := HB_UTF8STRTRAN( text, Chr(195) + "?", "C" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(149), "O" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(154), "U" )
	text := HB_UTF8STRTRAN( text, "+" + Chr(170), "o" )
	text := HB_UTF8STRTRAN( text, "?" + Chr(128), "A" )
	text := HB_UTF8STRTRAN( text, Chr(195) + Chr(166), "e" )
	text := HB_UTF8STRTRAN( text, Chr(135) + Chr(227), "ca" )
	text := HB_UTF8STRTRAN( text, "n" + Chr(227), "na" )
	text := HB_UTF8STRTRAN( text, Chr(162), "o" )

return text
