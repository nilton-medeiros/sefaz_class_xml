#include <hmg.ch>

Procedure TextBox_OnLostFocus(cFormName, cCltrName, cFormat)
    LOCAL cNumero

    SetProperty(cFormName, cCltrName, "BackColor", WHITE)
    IF ValType(cFormat) == "C"
        cNumero := onlyNumbers(GetProperty(cFormName, cCltrName, "Value"))
        IF ! Empty(cNumero) .AND. LEN(cNumero) == LEN(onlyNumbers(cFormat))
            SetProperty(cFormName, cCltrName, "Value", Transform(cNumero, cFormat))
        ENDIF
    ENDIF

Return
