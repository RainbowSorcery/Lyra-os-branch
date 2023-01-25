[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_palette
	EXTERN	_init_screen
	EXTERN	_putfonts8_asc
	EXTERN	_init_gdtidt
	EXTERN	_io_hlt
[FILE "bootpack.c"]
[SECTION .data]
_font_A.0:
	DB	0
	DB	0
	DB	0
	DB	0
	DB	0
	DB	0
	DB	0
	DB	0
	DB	8
	DB	8
	DB	8
	DB	8
	DB	8
	DB	15
	DB	0
	DB	0
LC0:
	DB	"Hello Lyra OS",0x00
[SECTION .text]
	ALIGN	2
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	MOV	ESI,DWORD [4088]
	MOVSX	EBX,WORD [4084]
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_screen
	PUSH	LC0
	PUSH	4
	PUSH	5
	PUSH	5
	PUSH	EBX
	PUSH	ESI
	CALL	_putfonts8_asc
	ADD	ESP,36
	CALL	_init_gdtidt
L2:
	CALL	_io_hlt
	JMP	L2
