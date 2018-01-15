list!t(
    arr := array!t()

    getCount() {
        arr.count
    }

    getAt(index : 'i32)'t {
        arr.getAt(index)
    }

    setAt(index : 'i32, item : 't)'void {
        arr.setAt(index, item)
    }

    each(cb : '(:t)void)'void {
        arr.each(cb)
    }

    map!new_t(cb : '(:t)new_t)'arr!new_t {
        arr.map!new_t(cb)
    }

    sort() {
        arr.sort()
    }

    sortcb(cb : '(:t, :t)i32) {
        arr.sortcb(cb)
    }

    filter(cb : '(:t)bool)'list!t {
        list!t(arr.filter(cb))
    }

    foldl!result(initial : 'result, cb : '(:result, :t)result)'result {
        arr.foldl!result(cb)
    }

    foldr!result(initial : 'result, cb : '(:result, :t)result)'result {
        arr.foldr!result(cb)
    }
    
    add(item :'t) {
        if arr.count == arr.totalCount {
            arr = arr.clone(0, arr.count, 10.max(arr.totalCount * 2))
            void
        }

        arr.initAt(arr.count, item)
    }

    removeAt(index : 'i32)'void {
        --c--
        if (index < 0 || index >= ((sjs_array*)_parent->arr.v)->count) {
            halt("removeAt: out of bounds %d:%d\n", index, ((sjs_array*)_parent->arr.v)->count);
        }
        #type(t)* p = (#type(t)*)((sjs_array*)_parent->arr.v)->data;
        #release(t, p[index]);
        if (index != ((sjs_array*)_parent->arr.v)->count - 1) {
            memcpy(p + index, p + index + 1, (((sjs_array*)_parent->arr.v)->count - index - 1) * sizeof(#type(t)));
        }
        ((sjs_array*)_parent->arr.v)->count--;
        --c--
    }
) { this }