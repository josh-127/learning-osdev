
%define MAGIC     0x1BADB002
%define FLAGS     0x3
%define CHECKSUM -(MAGIC + FLAGS)

extern kmain
global __loader


section .multiboot
    dd MAGIC
    dd FLAGS
    dd CHECKSUM


section .text
    __loader:
        lgdt [__gdtptr]

        mov esp, kernel_stack
        push eax
        push ebx
        call kmain
    .idle:
        cli
        hlt
        jmp .idle

section .rodata
    __gdtptr:
        dw __gdt_data_end - __gdt_data - 1
        dd __gdt_data

    __gdt_data:
        ; Null Descriptor
        dd 0
        dd 0
        ; Code Descriptor
        dw 0xFFFF
        dw 0
        db 0
        db 0b10011010
        db 0b11001111
        db 0xFF
        ; Data Descriptor
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
        db 0b11001111
        db 0xFF
    __gdt_data_end:


section .bss
    resb 0x200000
    kernel_stack:
