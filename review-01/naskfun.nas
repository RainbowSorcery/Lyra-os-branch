[FORMAT "WCOFF"]
[BITS 32]

[INSTRSET 'i386p']

[FILE "naskfun.nas"]
GLOBAL _io_hlt
GLOBAL _write_mem8
GLOBAL _io_cli
GLOBAL _io_out8
GLOBAL _io_store_eflags
GLOBAL _io_load_eflags

[SECTION .text]
_io_hlt:
    hlt
    ret

_write_mem8:
    mov ecx, [esp+4]
    mov al, [esp+8]
    mov [ecx], al
    ret

_io_out8:
    mov edx, [esp+4]
    mov al, [esp+8]
    out dx, al
    ret

_io_cli:
    cli
    ret

_io_store_eflags:
    mov eax, [esp + 4]
    push eax
    popfd
    ret

_io_load_eflags:
    pushfd
    pop eax
    ret