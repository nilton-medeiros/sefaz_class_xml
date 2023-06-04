#include <hmg.ch>

function auxEncrypt(string)
    local char, encrypted := ''

    string := TirarAcentos(string)

    for each char in string 
        encrypted += hb_ntos(asc(char)) + '#|@'
    next

    encrypted := hb_ULeft(encrypted, hmg_len(encrypted)-3)

return encrypted
