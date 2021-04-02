#include <hmg.ch>
#include "hbclass.ch"

class TinfMDFeSupl
   data documentation  READONLY
   data name  READONLY
   data value READONLY
   data qrCodMDFe
   method new() constructor
end class

method new() class TinfMDFeSupl
   ::documentation := "Informações suplementares do MDF-e"
   ::name := "infMDFeSupl"
   ::value := "TinfMDFeSupl"
   ::qrCodMDFe := Telement():new({'name' => "qrCodMDFe", 'documentation' => 'Texto com o QR-Code para consulta do MDF-e', 'minLength' => 50, 'maxLength' => 1000})
return self