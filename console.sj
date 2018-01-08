package console {
    write(data : 'string)'void {
        data.nullTerminate()
        --c--
        printf("%s", string_char(data));
        --c--
    }

    writeLine(data : 'string)'void {
        data.nullTerminate()
        --c--
        printf("%s\n", string_char(data));
        --c--
    }

    readLine()'string { 
        data := nullptr
        dataSize := 1024
        --c--
        char* str = (char*)malloc(datasize);
        int index = 0;
        char ch = ' ';
        do {
            ch = getchar();
            if (ch != '\n') {
                str[index] = ch;
                index++;
                if (index >= datasize) {
                    datasize *= 2;
                    str = (char*)realloc(str, datasize);
                }
            }
        } while (ch != '\n');

        data = (void*)str;
        datasize = index;
        --c--

        string(count := dataSize, data := array!char(dataSize := dataSize, data := data, count := dataSize))
    }
}

consoleWriter #writer(
    write(s : 'string) {
        console.write(s)
        void
    }

    reset() { void }
) { this }