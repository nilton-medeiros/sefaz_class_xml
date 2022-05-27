Function first_string(cString)
     LOCAL pos AS NUMERIC

    IF !Empty( cString )
        cString := LTrim(cString)
        pos := HB_UAT(' ', cString )
        IF ( pos == 0 )
          pos := HMG_LEN( AllTrim(cString) )
        ENDIF
        cString := HB_ULEFT( cString, pos )
    ENDIF
Return AllTrim(cString)