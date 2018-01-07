f32_pi : 3.14159265358979323846f

f32_sqrt(v : 'f32)'f32 {
    result := 0.0f
    --c--
    result = sqrtf(v);
    --c--
    result
}

f32_cos(v : 'f32)'f32 {
    result := 0.0f
    --c--
    result = cosf(v);
    --c--
    result
}

f32_sin(v : 'f32)'f32 {
    result := 0.0f
    --c--
    result = sinf(v);
    --c--
    result
}

f32_tan(v : 'f32)'f32 {
    result := 0.0f
    --c--
    result = tanf(v);
    --c--
    result
}

f32_atan2(y : 'f32, x : 'f32)'f32 {
    result := 0.0f
    --c--
    result = atan2f(y, x);
    --c--
    result
}

f32_max(a : 'f32, b : 'f32)'f32 {
    if a < b { b } else { a }
}

f32_min(a : 'f32, b : 'f32)'f32 {
    if a < b { a } else { b }
}

f32_random()'f32 {
    x := 0.0f
    --c--
    x = (float)rand() / (float)RAND_MAX;
    --c--
    x
}

f32_ceil(v : 'f32)'f32 {
    x := 0.0f
    --c--
    x = ceilf(v);
    --c--
    x
}

f32_floor(v : 'f32)'f32 {
    x := 0.0f
    --c--
    x = floorf(v);
    --c--
    x
}

f32_pow(x : 'f32, y : 'f32) {
    --c--
    #return(f32, powf(x, y));
    --c--
}

f32_abs(v : 'f32)'f32 {
    --c--
    #return(f32, fabsf(v))
    --c--
}

f32_exp(v : 'f32)'f32 {
    --c--
    #return(f32, expf(v))
    --c--
}

f32_asString(val : 'f32) {
    count := 0
    data := nullptr
    --c--
    data = (int*)malloc(sizeof(int) + sizeof(char) * 256) + 1;
    int* refcount = (int*)data - 1;
    *refcount = 1;
    snprintf((char*)data, 256, "%f", val);
    count = (int)strlen((char*)data);
    --c--
    string(count := count, data := array!char(dataSize := count, count := count, data := data))
}

string_asF32(text : 'string) {
    x := 0.0f
    --c--
    char* e;
    float v = strtof((char*)text->data.data, &e);
    
    if (*e != '\0') {
        x = 0.0f;
    }
    else {
        x = v;
    }
    --c--
    x
}

f32_hash(val : 'f32)'u32 {
    result := 0u
    --c--
    int32_t* p = (int32_t*)&val;
    result = *p;
    --c--
    result
}

f32_compare(l : 'f32, r : 'f32) {
    if l == r {
        0
    } else if l < r {
        -1
    } else {
        1
    }
}