#include <hmg.ch>

Function IFNULL(cText)
    IF !Empty(cText)
        cText := String_HB_TO_MySQL(cText)
    ELSE
        Return "NULL"
    END
Return "'" + cText + "'"
