; naskfun
; tab = 4
[FORMAT "WCOFF"]
[BITS 32]

[FILE "naskfun.nsk"]
GLOBAL _io_hlt

[SECTION .text]
_io_hlt: 
    hlt
    RET