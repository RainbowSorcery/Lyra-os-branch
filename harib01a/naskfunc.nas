; naskfun
; tab = 4
[FORMAT "WCOFF"]
[BITS 32]

[INSTRSET "i486p"]	

[FILE "naskfunc.nas"]
    GLOBAL _io_hlt,_write_mem8


[SECTION .text]
_io_hlt: 
    hlt
    RET

_write_mem8:
    mov ecx, [esp + 4]
    mov al, [esp+8]
    mov [ecx], al
    RET