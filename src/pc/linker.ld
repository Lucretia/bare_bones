OUTPUT_FORMAT(elf32-i386)
STARTUP(startup.o)
ENTRY (startup)

SECTIONS
{
    . = 0x00100000;

    .text :{
        code = .; _code = .; __code = .;
        *(.text)
        *(.rodata)
    }

    .rodata ALIGN (0x1000) : {
        *(.rodata)
    }

    .data ALIGN (0x1000) : {
        data = .; _data = .; __data = .;
        *(.data)
    }

    .bss : {
        sbss = .;
        bss = .; _bss = .; __bss = .;
        *(COMMON)
        *(.bss)
        ebss = .;
    }
    end = .; _end = .; __end = .;
}
