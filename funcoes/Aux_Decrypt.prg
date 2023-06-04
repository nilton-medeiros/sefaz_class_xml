#include <hmg.ch>

function auxDecrypt(encrypted)
    local aChar, decrypted := ''

    aChar := hb_ATokens(encrypted, '#|@')
    AEval(aChar, {|c| decrypted += Chr(Val(c))})

return decrypted

