package array {
    create!t(size : 'i32, item : 't) {
        v := nullptr
        --c--
        sjs_array* arr = createarray(sizeof(#type(t)), size);
        #type(t)* p = (#type(t)*)arr->data;
        for (int i = 0; i < size; i++) {
            #retain(t, p[i], item);
        }
        arr->count = size;  
        v = arr;
        --c--  
        array!t(v)
    }
}

--cstruct--
struct {
    int refcount;
    int size;
    int count;
    char data[0];
} g_empty = { 1, 0, 0 };
--cstruct--

array!t (
    v := nullptr

    getCount() {
        --c--
        #return(i32, ((sjs_array*)_parent->v)->count);
        --c--        
    }

    getTotalCount()'i32 {
        --c--
        #return(i32, ((sjs_array*)_parent->v)->size);
        --c--
    }

    getAt(index : 'i32)'t {
        --c--
        sjs_array* arr = (sjs_array*)_parent->v;
        if (index >= arr->count || index < 0) {
            halt("getAt: out of bounds\n");
        }
        #type(t)* p = (#type(t)*)arr->data;
        #return(t, p[index]);       
        --c--
    }
    
    initAt(index : 'i32, item : 't)'void {
        --c--
        sjs_array* arr = (sjs_array*)_parent->v;
        if (index != arr->count) {
            halt("initAt: can only initialize last element\n");     
        }
        if (index >= arr->size || index < 0) {
            halt("initAt: out of bounds %d:%d\n", index, arr->size);
        }

        #type(t)* p = (#type(t)*)arr->data;
        #retain(t, p[index], item);
        arr->count = index + 1;
        --c--
    }

    setAt(index : 'i32, item : 't)'void {
        --c--
        sjs_array* arr = (sjs_array*)_parent->v;
        if (index >= arr->count || index < 0) {
            halt("setAt: out of bounds %d:%d\n", index, arr->count);
        }

        #type(t)* p = (#type(t)*)arr->data;
        #release(t, p[index]);
        #retain(t, p[index], item);
        --c--
    }

    find(item : 't)'i32 {
        match = -1
        --c--   
        sjs_array* arr = (sjs_array*)_parent->v;
        #type(t)* p = (#type(t)*)arr->data;
        for (int index = 0; index < arr->count; i++) {
            if (p[index] == item) {
                match = index;
            }
        }
        --c--
        match
    }

    findcb(cb : '(:t)bool)'t? {
        i := 0
        while i < getCount() && !cb(getAt(i)) {
            i++
        }

        if i < getCount() {
            valid(getAt(i))
        } else {
            empty't
        }
    }

    each(cb : '(:t)void)'void {
        for i : 0 to getCount() {
            cb(getAt(i))
        }
    }

    map!new_t(cb : '(:t)new_t)'array!new_t {
        newData := nullptr
        --c--
        sjs_array* arr = (sjs_array*)_parent->v;
        sjs_array* newArr = createarray(sizeof(#type(new_t)), arr->count);
        newArr->count = arr->count;
        newdata = (void*)newArr;
        --c--
        for i : 0 to getCount() {
            newItem : cb(getAt(i))
            --c--
            #type(new_t)* p = (#type(new_t)*)newArr->data;
            #retain(new_t, p[i], newitem);
            --c--
        }       
        array!new_t(newData)
    }

    filter(cb : '(:t)bool)'array!t {
        newData := nullptr
        --c--
        sjs_array* arr = (sjs_array*)_parent->v;
        sjs_array* newArr = createarray(sizeof(#type(t)), arr->count);
        newdata = (void*)newArr;
        --c--
        for i : 0 to getCount() {
            item : getAt(i)
            if (cb(item)) {
                --c--
                #type(t)* p = (#type(t)*)newArr->data;
                #retain(t, p[newArr->count], item);
                newArr->count++;
                --c--
            }
        }       
        array!t(newData)
    }

    foldl!result(initial : 'result, cb : '(:result, :t)result)'result {
        r := initial
        for i : 0 to getCount() {
            r = cb(r, getAt(i))
        }           
        r
    }

    foldr!result(initial : 'result, cb : '(:result, :t)result)'result {
        r := initial
        for i : 0 toReverse getCount() {
            r = cb(r, getAt(i))
        }           
        r
    }

    clone(offset : 'i32, count : 'i32, newSize :' i32)'array!t {
        newv := nullptr
        --c--
        sjs_array* arr = (sjs_array*)_parent->v;
        if (offset + count > arr->count) {
            halt("grow: offset %d count %d out of bounds %d\n", offset, count, arr->count);
        }

        if (count > arr->count - offset) {
            halt("grow: new count larger than old count %d:%d\n", count, arr->count - offset);
        }
        
        sjs_array* newArr = createarray(sizeof(#type(t)), newsize);
        if (!newArr) {
            halt("grow: out of memory\n");
        }

        newv = newArr;
        #type(t)* p = (#type(t)*)arr->data + offset;
        #type(t)* newp = (#type(t)*)newArr->data;

        newArr->refcount = 1;
        newArr->size = newsize;
        newArr->count = count;

##if #isValue(t)
        memcpy(newp, p, sizeof(#type(t)) * count);
##else
        for (int i = 0; i < count; i++) {
            #retain(t, newp[i], p[i]);
        }
##endif
        --c--
        array!t(newv)
    } 

    _quickSort(left : 'i32, right : 'i32)'void {
        i := left
        j := right

        pivot : getAt((left + right) / 2)
        while i <= j {
            while getAt(i) < pivot {
                i++
            }

            while getAt(j) > pivot {
                j--
            }

            if i <= j {
                tmp : getAt(i)
                setAt(i, getAt(j))
                setAt(j, tmp)
                i++
                j--
            }
        }

        if left < j {
            _quickSort(left, j);
        }
        if i < right {
            _quickSort(i, right);
        }
    }

    _quickSortCallback(left : 'i32, right : 'i32, cb : '(:t, :t)i32)'void {
        i := left
        j := right

        pivot : getAt((left + right) / 2)
        while i <= j {
            shouldContinue := true
            while i < getCount() && shouldContinue {
                shouldContinue = cb(getAt(i), pivot) < 0
                if shouldContinue {
                    i++
                }
            }

            shouldContinue = true
            while j >= 0 && shouldContinue {
                shouldContinue = cb(getAt(j), pivot) > 0
                if shouldContinue {
                    j--
                }
            }

            if i <= j {
                tmp : getAt(i)
                setAt(i, getAt(j))
                setAt(j, tmp)
                i++
                j--
            }
        }

        if left < j {
            _quickSortCallback(left, j, cb);
        }
        if i < right {
            _quickSortCallback(i, right, cb);
        }
    }

    sort()'void {
        if getCount() > 1 {
            _quickSort(0, getCount() - 1)
        }
    }

    sortcb(cb : '(:t, :t)i32)'void {
        if getCount() > 1 {
            _quickSortCallback(0, getCount() - 1, cb)
        }
    }

    reverse() {
        for i : 0 to getCount() / 2 {
            j : getCount() - i - 1
            tmp : getAt(i)
            setAt(i, getAt(j))
            setAt(j, tmp)
        }
    }

    asString(sep : ", ") {
        result := ""
        for i : 0 to getCount() {
            if i != 0 {
                result = result + sep
            }
            result = result + getAt(i)?.asString()??
        }
        result
    }

    asHash![key, value](cb : '(:t)tuple2![key,value]) {
        hash : hash![key, value]()
        for i : 0 to getCount() {
            tuple : cb(getAt(i))
            hash[tuple.item1] = tuple.item2
        }        
        hash
    }

    isEqual(test :' array!t)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->v;
        sjs_array* arr2 = (sjs_array*)test->v;
        if (arr1->count != arr2->count) {
            #return(bool, false);      
        }
        bool result = memcmp(arr1->data, arr2->data, arr1->count * sizeof(#type(t))) == 0;
        #return(bool, result);      
        --c--
    }

    isGreater(test :' array!t)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->v;
        sjs_array* arr2 = (sjs_array*)test->v;
        bool result = memcmp(arr1->data, arr2->data, (arr1->count < arr2->count ? arr1->count : arr2->count) * sizeof(#type(t))) > 0;      
        #return(bool, result);      
        --c--
    }

    isGreaterOrEqual(test :' array!t)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->v;
        sjs_array* arr2 = (sjs_array*)test->v;
        bool result = memcmp(arr1->data, arr2->data, (arr1->count < arr2->count ? arr1->count : arr2->count) * sizeof(#type(t))) >= 0;     
        #return(bool, result);      
        --c--
    }

    isLess(test :' array!t)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->v;
        sjs_array* arr2 = (sjs_array*)test->v;
        bool result = memcmp(arr1->data, arr2->data, (arr1->count < arr2->count ? arr1->count : arr2->count) * sizeof(#type(t))) < 0;      
        #return(bool, result);      
        --c--
    }

    isLessOrEqual(test :' array!t)'bool {
        --c--
        sjs_array* arr1 = (sjs_array*)_parent->v;
        sjs_array* arr2 = (sjs_array*)test->v;
        bool result = memcmp(arr1->data, arr2->data, (arr1->count < arr2->count ? arr1->count : arr2->count) * sizeof(#type(t))) <= 0;     
        #return(bool, result);      
        --c--
    }
) {
    --c--
    if (_this->v == 0) {
        _this->v = &g_empty;
    }
    sjs_array* arr = (sjs_array*)_this->v;
    arr->refcount++;
    --c--
    this
} copy {
    --c--
    sjs_array* arr = (sjs_array*)_this->v;
    arr->refcount++;
    --c--
} destroy {
    --c--
    sjs_array* arr = (sjs_array*)_this->v;
    arr->refcount--;
    if (arr->refcount == 0) {
##if !#isValue(t) && !#isStack(t)
        #type(t)* p = (#type(t)*)arr->data;
        for (int i = 0; i < arr->count; i++) {
            #release(t, p[i]);
        }
##endif
        free(arr);
    }
    --c--
}
