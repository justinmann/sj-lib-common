string_escapeHtml(s : 'string) {
    count := 0
    vresult := nullptr
    --c--
    const unsigned char calcFinalSize[] =
    {
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   6,   1,   1,   1,   5,   6,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   4,   1,   4,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,
        1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1,   1
    };

    sjs_array* arr = (sjs_array*)s->data.v;
    char* dataIn = (char*)arr->data;
    int sizeIn = arr->count;

    char* dataInCurrent = dataIn;
    char* dataInEnd = dataIn + sizeIn;
    int outSize = 0;
    while (dataInCurrent < dataInEnd) {
        outSize += calcFinalSize[static_cast<uint8_t>(*dataInCurrent)];
        dataInCurrent++;
    }

    sjs_array* arrOut = createarray(1, outSize);
    char* dataOut = arrOut->data;
    vresult = (void*)arrOut;
    arrOut->count = outSize;
    count = outSize;

    dataInCurrent = dataIn;
    while (dataInCurrent < dataInEnd)
    {
        switch (*dataInCurrent) {
        case '&':
            memcpy(dataOut, "&amp;", sizeof("&amp;") - 1);
            dataOut += sizeof("&amp;") - 1;
            break;
        case '\'':
            memcpy(dataOut, "&apos;", sizeof("&apos;") - 1);
            dataOut += sizeof("&apos;") - 1;
            break;
        case '\"':
            memcpy(dataOut, "&quote;", sizeof("&quote;") - 1);
            dataOut += sizeof("&quote;") - 1;
            break;
        case '>':
            memcpy(dataOut, "&gt;", sizeof("&gt;") - 1);
            dataOut += sizeof("&gt;") - 1;
            break;
        case '<':
            memcpy(dataOut, "&lt;", sizeof("&lt;") - 1);
            dataOut += sizeof("&lt;") - 1;
            break;
        default:
            *dataOut++ = *dataInCurrent;
        }
        dataInCurrent++;
    }
    --c--
    string(count := count, data := array!char(vresult))
}