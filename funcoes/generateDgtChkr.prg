
function generateDigitChecker(key43)
   local i, peso := 2, soma := 0, resto, digitoVerificador

   // 35 1212 61611877000103 57 000 000000063 1 00000063 0
   for i := hmg_len(key43) to 1 step -1
      soma += (peso * Val(hb_uSubStr(key43, i, 1)))
      if ++peso > 9
         peso := 2
      endif
   next

   resto := soma % 11
   IF resto <= 1
      digitoVerificador := 0
   ELSE
      digitoVerificador := 11 - resto
      digitoVerificador := int(digitoVerificador)
   END

Return hb_ntos(digitoVerificador)
