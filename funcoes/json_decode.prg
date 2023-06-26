function jsonDecode(text)
    local bytes, jsonHash

    text := Lower(text)
    bytes := hb_jsonDecode(text, @jsonHash)

    if (bytes == 0)
        jsonHash := {}
    endif

return jsonHash
