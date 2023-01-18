[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_load_gdtr
	EXTERN	_load_idtr
	EXTERN	_io_load_eflags
	EXTERN	_io_cli
	EXTERN	_io_out8
	EXTERN	_io_store_eflags
	EXTERN	_io_hlt
[FILE "bootpack.c"]
[SECTION .text]
	ALIGN	2
	GLOBAL	_init_gdtidt
_init_gdtidt:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	MOV	ESI,2555904
	MOV	EBX,8191
L6:
	PUSH	0
	PUSH	0
	PUSH	0
	PUSH	ESI
	ADD	ESI,8
	CALL	_set_segmdesc
	ADD	ESP,16
	DEC	EBX
	JNS	L6
	PUSH	4242
	MOV	ESI,2553856
	PUSH	0
	MOV	EBX,255
	PUSH	-1
	PUSH	2555912
	CALL	_set_segmdesc
	PUSH	16538
	PUSH	0
	PUSH	-524289
	PUSH	2555920
	CALL	_set_segmdesc
	ADD	ESP,32
	PUSH	2555904
	PUSH	65535
	CALL	_load_gdtr
	POP	EAX
	POP	EDX
L11:
	PUSH	0
	PUSH	0
	PUSH	0
	PUSH	ESI
	ADD	ESI,8
	CALL	_set_gatedesc
	ADD	ESP,16
	DEC	EBX
	JNS	L11
	PUSH	2553856
	PUSH	2047
	CALL	_load_idtr
	LEA	ESP,DWORD [-8+EBP]
	POP	EBX
	POP	ESI
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_set_segmdesc
_set_segmdesc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	MOV	EDX,DWORD [12+EBP]
	MOV	ECX,DWORD [16+EBP]
	MOV	EBX,DWORD [8+EBP]
	MOV	EAX,DWORD [20+EBP]
	CMP	EDX,1048575
	JBE	L17
	SHR	EDX,12
L17:
	MOV	WORD [EBX],DX
	MOV	BYTE [5+EBX],AL
	SHR	EDX,16
	SAR	EAX,8
	AND	EDX,15
	MOV	WORD [2+EBX],CX
	AND	EAX,-16
	SAR	ECX,16
	OR	EDX,EAX
	MOV	BYTE [4+EBX],CL
	MOV	BYTE [6+EBX],DL
	SAR	ECX,8
	MOV	BYTE [7+EBX],CL
	POP	EBX
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_set_gatedesc
_set_gatedesc:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [16+EBP]
	MOV	EBX,DWORD [20+EBP]
	MOV	ECX,DWORD [12+EBP]
	MOV	WORD [2+EDX],AX
	MOV	BYTE [5+EDX],BL
	MOV	WORD [EDX],CX
	MOV	EAX,EBX
	SAR	EAX,8
	SAR	ECX,16
	MOV	BYTE [4+EDX],AL
	MOV	WORD [6+EDX],CX
	POP	EBX
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_set_palette
_set_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	EAX
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
	POP	ECX
	POP	EAX
	JLE	L24
L26:
	MOV	EAX,DWORD [-16+EBP]
	MOV	DWORD [8+EBP],EAX
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	JMP	_io_store_eflags
L24:
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
	JLE	L24
	JMP	L26
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
	PUSH	ECX
	PUSH	ECX
	MOV	DL,BYTE [28+EBP]
	MOV	EAX,DWORD [24+EBP]
	MOV	BYTE [-13+EBP],DL
	MOV	ESI,DWORD [20+EBP]
	MOV	EDX,DWORD [16+EBP]
	CMP	EDX,EAX
	JGE	L40
	MOV	EBX,EDX
	SUB	EAX,EDX
	IMUL	EBX,EBX,320
	MOV	EDX,EAX
L38:
	MOV	ECX,DWORD [12+EBP]
	CMP	ECX,ESI
	JGE	L42
	MOV	EDI,DWORD [8+EBP]
	ADD	EDI,EBX
	ADD	EDI,ECX
	MOV	DWORD [-20+EBP],EDI
L37:
	MOV	EDI,DWORD [-20+EBP]
	MOV	AL,BYTE [-13+EBP]
	INC	ECX
	MOV	BYTE [EDI],AL
	INC	EDI
	MOV	DWORD [-20+EBP],EDI
	CMP	ECX,ESI
	JL	L37
L42:
	ADD	EBX,320
	DEC	EDX
	JNE	L38
L40:
	POP	EAX
	POP	EDX
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_putfont8
_putfont8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	XOR	EBX,EBX
	PUSH	EDI
	PUSH	EDI
	MOV	AL,BYTE [24+EBP]
	MOV	EDI,DWORD [16+EBP]
	MOV	BYTE [-17+EBP],AL
L56:
	MOV	ECX,DWORD [28+EBP]
	MOV	DL,BYTE [EBX+ECX*1]
	TEST	DL,DL
	JNS	L48
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [EAX+ESI*1],CL
L48:
	MOV	AL,DL
	AND	EAX,64
	TEST	AL,AL
	JE	L49
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [1+EAX+ESI*1],CL
L49:
	MOV	AL,DL
	AND	EAX,32
	TEST	AL,AL
	JE	L50
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [2+EAX+ESI*1],CL
L50:
	MOV	AL,DL
	AND	EAX,16
	TEST	AL,AL
	JE	L51
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [3+EAX+ESI*1],CL
L51:
	MOV	AL,DL
	AND	EAX,8
	TEST	AL,AL
	JE	L52
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [4+EAX+ESI*1],CL
L52:
	MOV	AL,DL
	AND	EAX,4
	TEST	AL,AL
	JE	L53
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [5+EAX+ESI*1],CL
L53:
	MOV	AL,DL
	AND	EAX,2
	TEST	AL,AL
	JE	L54
	MOV	EAX,DWORD [20+EBP]
	MOV	ESI,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	CL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [6+EAX+ESI*1],CL
L54:
	AND	EDX,1
	TEST	DL,DL
	JE	L46
	MOV	EAX,DWORD [20+EBP]
	MOV	ECX,DWORD [8+EBP]
	ADD	EAX,EBX
	MOV	DL,BYTE [-17+EBP]
	IMUL	EAX,DWORD [12+EBP]
	ADD	EAX,EDI
	MOV	BYTE [7+EAX+ECX*1],DL
L46:
	INC	EBX
	CMP	EBX,15
	JLE	L56
	POP	EBX
	POP	ESI
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_init_screen
_init_screen:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	EAX
	PUSH	EAX
	PUSH	15
	PUSH	180
	PUSH	DWORD [12+EBP]
	PUSH	0
	PUSH	0
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	PUSH	8
	SUB	EAX,20
	PUSH	200
	PUSH	DWORD [12+EBP]
	PUSH	EAX
	PUSH	0
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [16+EBP]
	ADD	ESP,48
	SUB	EAX,19
	PUSH	7
	PUSH	182
	PUSH	DWORD [12+EBP]
	PUSH	EAX
	PUSH	0
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EDI,DWORD [16+EBP]
	PUSH	7
	MOV	ESI,DWORD [12+EBP]
	PUSH	186
	SUB	ESI,280
	PUSH	ESI
	SUB	EDI,15
	PUSH	EDI
	PUSH	2
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EBX,DWORD [16+EBP]
	ADD	ESP,48
	SUB	EBX,6
	PUSH	14
	PUSH	195
	PUSH	ESI
	PUSH	EBX
	PUSH	3
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [12+EBP]
	PUSH	7
	SUB	EAX,317
	PUSH	195
	PUSH	EAX
	PUSH	EDI
	PUSH	2
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [12+EBP]
	ADD	ESP,48
	SUB	EAX,279
	PUSH	0
	PUSH	196
	PUSH	EAX
	PUSH	EDI
	PUSH	40
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [12+EBP]
	PUSH	0
	SUB	EAX,124
	PUSH	EAX
	MOV	EAX,DWORD [16+EBP]
	PUSH	40
	SUB	EAX,5
	PUSH	EAX
	PUSH	2
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	MOV	EAX,DWORD [12+EBP]
	ADD	ESP,48
	SUB	EAX,123
	PUSH	5
	PUSH	EAX
	PUSH	40
	PUSH	EBX
	PUSH	40
	PUSH	DWORD [8+EBP]
	CALL	_boxfill8
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
[SECTION .data]
_font_A.1:
	DB	0
	DB	24
	DB	24
	DB	24
	DB	24
	DB	36
	DB	36
	DB	36
	DB	36
	DB	126
	DB	66
	DB	66
	DB	66
	DB	-25
	DB	0
	DB	0
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
	PUSH	_font_A.1
	PUSH	2
	PUSH	150
	PUSH	70
	PUSH	EBX
	PUSH	ESI
	CALL	_putfont8
	ADD	ESP,36
	CALL	_init_gdtidt
L61:
	CALL	_io_hlt
	JMP	L61
