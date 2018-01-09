--cdefine--
char* string_char(sjs_string* str);
--cdefine--

--cfunction--
char* string_char(sjs_string* str) {
    #functionStack(string, nullterminate)(str);
    return ((sjs_array*)str->data.v)->data;
}
--cfunction--

string(
    offset := 0
    count := 0
    data := array!char()
    _isNullTerminated := false

    add(item : 'string) {
        if item.count == 0 {
            optionalCopy parent       
        } else {
            // If there is room to add the string and this string is at the end of the array
            // then it is safe to re-use existing array
            if offset + count + item.count < data.totalCount && offset + count == data.count {
                newCount := count

                for i : 0 to item.count {
                    data.initAt(newCount, item.getAt(i))
                    newCount++      
                }

                string(offset : offset, count : newCount, data : data)
            } else {
                newData : data.clone(offset, count, ((count + item.count - 1) / 256 + 1) * 256)

                newCount := newData.count
                for i : 0 to item.count {
                    newData.initAt(newCount, item.getAt(i))
                    newCount++      
                }

                string(offset : 0, count : newCount, data : newData)                
            }
        }
    }

    substr(o : 'i32, c : 'i32) {
        if offset + o + c > data.count {
            halt("out of bounds")
        }

        string(
            offset : offset + o
            count : c
            data : data
        )
    }

    asString() {
        optionalCopy parent
    }

    getAt(index : 'i32)'char {
        data.getAt(offset + index)
    }

    setAt(index : 'i32, item : 'char)'void {
        data.setAt(offset + index, item)
    }

    isEqual(test :' string)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->data.v;
        sjs_array* arr2 = (sjs_array*)test->data.v;
        if (_parent->count != test->count) {
            #return(bool, false);      
        }
        bool result = memcmp(arr1->data + _parent->offset, arr2->data + test->offset, _parent->count) == 0;
        #return(bool, result);      
        --c--
    }

    isGreater(test :' string)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->data.v;
        sjs_array* arr2 = (sjs_array*)test->data.v;
        bool result = memcmp(arr1->data + _parent->offset, arr2->data + test->offset, (_parent->count < test->count ? _parent->count : test->count)) > 0;      
        #return(bool, result);      
        --c--
    }

    isGreaterOrEqual(test :' string)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->data.v;
        sjs_array* arr2 = (sjs_array*)test->data.v;
        bool result = memcmp(arr1->data + _parent->offset, arr2->data + test->offset, (_parent->count < test->count ? _parent->count : test->count)) >= 0;     
        #return(bool, result);      
        --c--
    }

    isLess(test :' string)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->data.v;
        sjs_array* arr2 = (sjs_array*)test->data.v;
        bool result = memcmp(arr1->data + _parent->offset, arr2->data + test->offset, (_parent->count < test->count ? _parent->count : test->count)) < 0;      
        #return(bool, result);      
        --c--
    }

    isLessOrEqual(test :' string)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->data.v;
        sjs_array* arr2 = (sjs_array*)test->data.v;
        bool result = memcmp(arr1->data + _parent->offset, arr2->data + test->offset, (_parent->count < test->count ? _parent->count : test->count)) <= 0;     
        #return(bool, result);      
        --c--
    }
    
    toUpperCase()'string {
        v := nullptr
        --c--
        sjs_array* arr = createarray(1, ((_parent->count - 1) / 256 + 1) * 256);
        v = arr;
        --c--
        a : array!char(v)
        for i : 0 to count {
            a.initAt(i, data[i].toUpperCase())
        }
        string(count : count, data : a)
    }

    nullTerminate() {
        if !_isNullTerminated {
            if count + 1 > data.totalCount {
                data = data.clone(offset, count, count + 1)
                offset = 0
            }
            --c--
            ((sjs_array*)_parent->data.v)->data[_parent->count] = 0;
            --c--
            _isNullTerminated = true
        }
        void
    }

    hash()'u32 {
        --c--
        #return(u32, kh_str_hash_func(((sjs_array*)_parent->data.v)->data + _parent->offset, _parent->count);
        --c--
    }
) { this }

