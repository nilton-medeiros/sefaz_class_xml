#include <hmg.ch>

Procedure TextBox_OnGoTFocus(cFormName, cCltrName)
    SetProperty(cFormName, cCltrName, "BackColor", {190,215,250})
Return
