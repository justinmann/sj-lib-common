package console {
    write(data : 'string)'void {
        data.nullTerminate()
        --c--
        printf("%s", (char*)data->data.data);
        --c--
    }

    writeLine(data : 'string)'void {
        data.nullTerminate()
        --c--
        printf("%s\n", (char*)data->data.data);
        --c--
    }

    readLine()'string { 
        data := nullptr
        dataSize := 1024
        --c--
        char* str = (char*)malloc(console_datasize);
        int index = 0;
        char ch = ' ';
        do {
            ch = getchar();
            if (ch != '\n') {
                str[index] = ch;
                index++;
                if (index >= console_datasize) {
                    console_datasize *= 2;
                    str = (char*)realloc(str, console_datasize);
                }
            }
        } while (ch != '\n');

        console_data = (void*)str;
        console_datasize = index;
        --c--

        string(count := dataSize, data := array!char(dataSize := dataSize, data := data, count := dataSize))
    }
}