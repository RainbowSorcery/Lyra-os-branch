; naskfun
; tab = 4
[FORMAT "WCOFF"]
[BITS 32]

[INSTRSET "i486p"]	

[FILE "naskfunc.nas"]
    GLOBAL _io_hlt
    GLOBAL _write_mem8
    GLOBAL _io_cli
    GLOBAL _io_out8
    GLOBAL _io_load_eflags
    GLOBAL _io_store_eflags
    GLOBAL _io_sti


[SECTION .text]
_io_hlt: 
    hlt
    RET

_write_mem8:
    mov ecx, [esp + 4]
    mov al, [esp + 8]
    mov [ecx], al
    RET

_io_cli: 
    cli
    RET

_io_out8:
    mov edx, [esp + 4] ; port
    mov al, [esp + 8] ; data
    out dx, al
    RET

_io_load_eflags:
    pushfd
    pop eax
    RET

_io_store_eflags:
    mov eax, [esp + 4]
    push eax
    popfd
    RET

_io_sti:
    sti
    RET