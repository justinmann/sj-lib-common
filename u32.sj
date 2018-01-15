u32_asString(val : 'u32, base : 10) {
    count := 0
    vresult := nullptr
    --c--
    sjs_array* arr = createarray(1, 256);
    vresult = (void*)arr;
    char *tmp = (char*)arr->data + 128;
    char *tp = (char*)arr->data + 128;
    int i;
    unsigned v = val;
    while (v || tp == tmp)
    {
        i = v % base;
        v /= base; // v/=base uses less CPU clocks than v=v/base does
        if (i < 10)
          *tp++ = i + '0';
        else
          *tp++ = i + 'a' - 10;
    }

    int len = tp - tmp;

    char* sp = (char*)arr->data;
    while (tp > tmp)
        *sp++ = *--tp;

    arr->count = len;
    count = len;
    --c--
    string(count := count, data := array!char(vresult))
}