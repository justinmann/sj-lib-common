f64_asString(val : 'f64) {
    v := nullptr
    count := 0
    --c--
    sjs_array* arr = createarray(256);
    snprintf(arr->data, 256, "%lf", val);
    arr->count = (int)strlen(arr->data);
    count = arr->count;
    v = arr;
    --c--
    string(count : count, data := array!char(v))
}

string_asF64(text : 'string) {
    x := 0.0
    --c--
    char* e;
    double v = strtod(string_char(text), &e);
    
    if (*e != '\0') {
        x = 0.0f;
    }
    else {
        x = v;
    }
    --c--
    x
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