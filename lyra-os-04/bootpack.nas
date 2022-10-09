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
	DB	-58
	DB	-58
	DB	-58
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
	PUSH	EDI
	PUSH	EDI
	MOV	DL,BYTE [28+EBP]
	MOV	EAX,DWORD [24+EBP]
	MOV	BYTE [-13+EBP],DL
	MOV	ESI,DWORD [20+EBP]
	MOV	EDX,DWORD [16+EBP]
	CMP	EDX,EAX
	JGE	L22
	MOV	EBX,EDX
	SUB	EAX,EDX
	IMUL	EBX,EBX,320
	MOV	EDX,EAX
L20:
	MOV	ECX,DWORD [12+EBP]
	CMP	ECX,ESI
	JGE	L24
	MOV	EDI,DWORD [8+EBP]
	ADD	EDI,EBX
	ADD	EDI,ECX
	MOV	DWORD [-20+EBP],EDI
L19:
	MOV	EDI,DWORD [-20+EBP]
	MOV	AL,BYTE [-13+EBP]
	INC	ECX
	MOV	BYTE [EDI],AL
	INC	EDI
	MOV	DWORD [-20+EBP],EDI
	CMP	ECX,ESI
	JL	L19
L24:
	ADD	EBX,320
	DEC	EDX
	JNE	L20
L22:
	POP	EBX
	POP	ESI
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
	PUSH	15
	PUSH	180
	PUSH	320
	PUSH	0
	PUSH	0
	PUSH	655360
	CALL	_boxfill8
	PUSH	8
	PUSH	200
	PUSH	320
	PUSH	180
	PUSH	0
	PUSH	655360
	CALL	_boxfill8
	ADD	ESP,48
	PUSH	7
	PUSH	182
	PUSH	320
	PUSH	181
	PUSH	0
	PUSH	655360
	CALL	_boxfill8
	PUSH	7
	PUSH	186
	PUSH	40
	PUSH	185
	PUSH	2
	PUSH	655360
	CALL	_boxfill8
	ADD	ESP,48
	PUSH	14
	PUSH	195
	PUSH	40
	PUSH	194
	PUSH	3
	PUSH	655360
	CALL	_boxfill8
	PUSH	7
	PUSH	195
	PUSH	3
	PUSH	185
	PUSH	2
	PUSH	655360
	CALL	_boxfill8
	ADD	ESP,48
	PUSH	0
	PUSH	196
	PUSH	41
	PUSH	185
	PUSH	40
	PUSH	655360
	CALL	_boxfill8
	PUSH	0
	PUSH	196
	PUSH	40
	PUSH	195
	PUSH	2
	PUSH	655360
	CALL	_boxfill8
	ADD	ESP,48
	PUSH	5
	PUSH	195
	PUSH	40
	PUSH	194
	PUSH	40
	PUSH	655360
	CALL	_boxfill8
	ADD	ESP,24
L26:
	CALL	_io_hlt
	JMP	L26
