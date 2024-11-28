/* Linker script for ARM Cortex-M microcontroller */
OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

/* Memory region definitions */
MEMORY
{
    flash (rx)  : ORIGIN = 0x08000000, LENGTH = 0x100000 /* 1MB Flash */
    ram   (rwx) : ORIGIN = 0x20000000, LENGTH = 0x20000  /* 128KB RAM */
}

/* Symbol definitions */
PROVIDE(_stack_top = ORIGIN(ram) + LENGTH(ram));
PROVIDE(_heap_start = _end);
PROVIDE(_heap_end = _stack_top - 0x1000); /* Reserve 4KB for stack */

/* Entry point */
ENTRY(Reset_Handler)

SECTIONS
{
    /* Vector table and reset handler */
    .vector :
    {
        . = ALIGN(4);
        _svector = .;
        KEEP(*(.vectors))
        KEEP(*(.reset_handler))
        . = ALIGN(4);
        _evector = .;
    } > flash
    
    /* Code and read-only data */
    .text :
    {
        . = ALIGN(4);
        _stext = .;
        *(.text)           /* Program code */
        *(.text.*)         /* Program code */
        *(.rodata)         /* Read-only data */
        *(.rodata*)        /* Read-only data */
        *(.glue_7)         /* ARM/Thumb interworking */
        *(.glue_7t)        /* ARM/Thumb interworking */
        . = ALIGN(4);
        _etext = .;
    } > flash
    
    /* Initialization data */
    .data :
    {
        . = ALIGN(4);
        _srelocate = .;
        _sdata = .;
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        _erelocate = .;
        _edata = .;
    } > ram AT > flash
    
    /* Zero-initialized data */
    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > ram
    
    /* End of used RAM */
    . = ALIGN(4);
    _end = .;
    
    /* Remove unused sections */
    /DISCARD/ :
    {
        *(.comment)
        *(.note.*)
    }
}

/* Provide sizes for initialization */
PROVIDE(_data_size = SIZEOF(.data));
PROVIDE(_data_flash_start = LOADADDR(.data));
PROVIDE(_bss_size = SIZEOF(.bss));