package file {
    loadString(filename : 'string) {
        count := 0
        data := nullptr
        --c--
        FILE* file = fopen((char*)filename->data.data, "rb");
        fseek(file, 0, SEEK_END);
        count = ftell(file); 
        rewind(file);
        data = (char*)malloc(sizeof(int) + count + 1) + sizeof(int);
        int* refcount = (int*)data - 1;
        *refcount = 1;
        fread(data, 1, count, file);
        fclose(file);
        --c--
        string(count := count, data := array!char(dataSize := count + 1, count := count, data := data))
    }
}