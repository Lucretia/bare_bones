OUTPUT_FORMAT(elf32-i586)
STARTUP(startup.o)
ENTRY (startup)

SECTIONS
{
    . = 0x00100000;

    .text : {
        *(.text)
    }

    .rodata ALIGN (0x1000) : {
        *(.rodata)
    }

    .data ALIGN (0x1000) : {
        *(.data)
    }

    .bss : {
        *(COMMON)
        *(.bss)
    }

    .note : {
    	  *(.note)
    }

    .debug : {
    	  *(.debug)
    }
}
