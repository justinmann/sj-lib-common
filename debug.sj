package debug {
    write(data : 'string)'void {
        --c--
        debugout("%s", string_char(data));
        --c--
    }

    writeLine(data : 'string)'void {
        --c--
        debugout("%s\n", string_char(data));
        --c--
    }
}
