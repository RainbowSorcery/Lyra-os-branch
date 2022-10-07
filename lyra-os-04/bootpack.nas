[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_io_load_eflags
	EXTERN	_io_cli
	EXTERN	_io_out8
	EXTERN	_io_store_eflags
	EXTERN	_io_hlt
[FILE "bootpack.c"]
[SECTION .text]
	ALIGN	2
	GLOBAL	_set_palette
_set_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ECX
	MOV	EBX,DWORD [8+EBP]
	MOV	EDI,DWORD [12+EBP]
	MOV	ESI,DWORD [16+EBP]
	CALL	_io_load_eflags
	MOV	DWORD [-16+EBP],EAX
	CALL	_io_cli
	PUSH	EBX
	PUSH	968
	CALL	_io_out8
	CMP	EBX,EDI
	POP	EAX
	POP	EDX
	JLE	L6
L8:
	MOV	EAX,DWORD [-16+EBP]
	MOV	DWORD [8+EBP],EAX
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	JMP	_io_store_eflags
L6:
	MOV	AL,BYTE [ESI]
	INC	EBX
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	MOV	AL,BYTE [1+ESI]
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	MOV	AL,BYTE [2+ESI]
	SHR	AL,2
	ADD	ESI,3
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_io_out8
	ADD	ESP,24
	CMP	EBX,EDI
	JLE	L6
	JMP	L8
[SECTION .data]
_table_rgb.0:
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	0
	DB	-1
	DB	-1
	DB	0
	DB	0
	DB	0
	DB	-1
	DB	-1
	DB	0
	DB	-1
	DB	0
	DB	-1
	DB	-1
	DB	-1
	DB	-1
	DB	-1
	DB	0
	DB	-124
	DB	0
	DB	-124
	DB	-124
	DB	0
	DB	0
	DB	0
	DB	-124
	DB	-124
	DB	0
	DB	-124
	DB	0
	DB	-124
	DB	-124
	DB	-124
	DB	-124
	DB	-124
	DB	-74
	DB	-93
	DB	-68
	DB	-26
	DB	-26
	DB	-6
[SECTION .text]
	ALIGN	2
	GLOBAL	_init_palette
_init_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	_table_rgb.0
	PUSH	16
	PUSH	0
	CALL	_set_palette
	LEAVE
	RET
	ALIGN	2
	GLOBAL	_boxfill8
_boxfill8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ESI
	MOV	ECX,DWORD [24+EBP]
	MOV	EDI,DWORD [28+EBP]
	CMP	ECX,DWORD [32+EBP]
	JG	L22
	MOV	EBX,DWORD [12+EBP]
	IMUL	EBX,ECX
L20:
	MOV	EDX,DWORD [20+EBP]
	CMP	EDX,EDI
	JG	L24
	MOV	EAX,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	DWORD [-16+EBP],EAX
	LEA	EAX,DWORD [EAX+EDX*1]
L19:
	INC	EDX
	MOV	BYTE [EAX],14
	INC	EAX
	CMP	EDX,EDI
	JLE	L19
L24:
	INC	ECX
	ADD	EBX,DWORD [12+EBP]
	CMP	ECX,DWORD [32+EBP]
	JLE	L20
L22:
	POP	EBX
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EBP,ESP
	CALL	_init_palette
	XOR	EAX,EAX
L30:
	MOV	BYTE [687360+EAX],14
	INC	EAX
	CMP	EAX,319
	JLE	L30
	MOV	BYTE [655360],0
	MOV	EDX,655840
	MOV	EAX,198
L35:
	MOV	BYTE [EDX],15
	ADD	EDX,320
	DEC	EAX
	JNS	L35
L36:
	CALL	_io_hlt
	JMP	L36
