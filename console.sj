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
        count := 0
        --c--
        sjs_array* str = createarray(1, 1024);
        int index = 0;
        char ch = ' ';
        do {
            ch = getchar();
            if (ch != '\n') {
                str->data[index] = ch;
                index++;
                if (index >= str->size) {
                    str = reallocarray(str, 1, str->size * 2);
                }
            }
        } while (ch != '\n');

        data = (void*)str;
        count = index;
        --c--

        string(count : count, data : array!char(data))
    }
}

consoleWriter #writer(
    write(s : 'string) {
        console.write(s)
        void
    }

    reset() { void }
) { this }