; Disassembly of file: bootpack.o
; Mon Oct  3 13:12:09 2022
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: 80386


main:   ; Function begin
        push    ebp                                     ; 0000 _ 55
        mov     ebp, esp                                ; 0001 _ 89. E5
        nop                                             ; 000D _ 90
        pop     ebp                                     ; 000E _ 5D
        ret                                             ; 000F _ C3
; main End of function



