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
GLOBAL _load_gdtr
GLOBAL _load_idtr
GLOBAL _asm_inthandler21
GLOBAL _io_sti

EXTERN	_inthandler21


[SECTION .text]
_io_hlt:
    hlt
    ret

_asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

_write_mem8:
    mov ecx, [esp+4]
    mov al, [esp+8]
    mov [ecx], al
    ret

_io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET
_io_cli:
    cli
    ret

_io_sti:
    sti
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

_load_gdtr:
    mov ax, [esp + 4];
    mov [esp + 6], ax
    lgdt [esp + 6]
    ret

_load_idtr:
    mov ax, [esp + 4];
    mov [esp + 6], ax
    lidt [esp + 6]
    ret