f64_asString(val : 'f64) {
    count := 0
    data := nullptr
    --c--
    data = (int*)malloc(sizeof(int) + sizeof(char) * 256) + 1;
    int* refcount = (int*)data - 1;
    *refcount = 1;
    snprintf((char*)data, 256, "%lf", val);
    count = (int)strlen((char*)data);
    --c--
    string(count := count, data := array!char(dataSize := count, count := count, data := data))
}

f64_pow(x : 'f64, y : 'f64) {
    --c--
    #return(f64, pow(x, y));
    --c--
}

f64_sqrt(v : 'f64) {
    --c--
    #return(f64, sqrt(v));
    --c--
}