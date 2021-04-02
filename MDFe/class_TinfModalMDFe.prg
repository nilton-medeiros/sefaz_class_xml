#include <hmg.ch>
#include "hbclass.ch"


class TinfModalMDFe
   data documentation READONLY
   data value READONLY
   data rodo
   method new() constructor
end class

method new() class TinfModalMDFe
   ::documentation := "infModal | Informações do modal"+CRLF+"XML do modal: XML específico do modal (rodoviário, aéreo, ferroviário, aquaviário)."
   ::value := "TinfModalMDFe"
   ::rodo := TrodoMDFe():new()
return self
