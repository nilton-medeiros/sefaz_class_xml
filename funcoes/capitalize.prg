#include <hmg.ch>

Function Capitalize( cString )
    Local nPos

    cString := AllTrim(cString)
    cString := HMG_UPPER( HB_ULEFT(cString,1) ) + HMG_LOWER(HB_USUBSTR( cString, 2 ))
    cString := HB_UTF8STRTRAN( cString, " ", Chr(176) )
    nPos    := AT( Chr(176), cString )

    WHILE nPos > 0
          cString := HB_ULEFT( cString, nPos-1 ) + " " + HMG_UPPER( HB_USUBSTR( cString, nPos+1 , 1 ) ) + HB_USUBSTR( cString, nPos+2 )
          nPos := AT( Chr(176), cString )
    ENDDO

Return cString
