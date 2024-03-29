[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
[FILE "fifo.c"]
[SECTION .text]
	ALIGN	2
	GLOBAL	_fifo8_init
_fifo8_init:
	PUSH	EBP
	MOV	EBP,ESP
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [12+EBP]
	MOV	DWORD [12+EDX],EAX
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [16+EBP]
	MOV	DWORD [EDX],EAX
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [12+EBP]
	MOV	DWORD [12+EDX],EAX
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [4+EAX],0
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [8+EAX],0
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [16+EAX],0
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [12+EBP]
	MOV	DWORD [20+EDX],EAX
	POP	EBP
	RET
	ALIGN	2
	GLOBAL	_fifo8_put
_fifo8_put:
	PUSH	EBP
	MOV	EBP,ESP
	SUB	ESP,8
	MOV	EAX,DWORD [12+EBP]
	MOV	BYTE [-1+EBP],AL
	MOV	EAX,DWORD [8+EBP]
	CMP	DWORD [20+EAX],0
	JNE	L3
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [16+EAX],1
	MOV	DWORD [-8+EBP],-1
	JMP	L2
L3:
	MOV	EAX,DWORD [8+EBP]
	DEC	DWORD [20+EAX]
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [8+EBP]
	MOV	EAX,DWORD [8+EAX]
	MOV	EDX,DWORD [EDX]
	ADD	EDX,EAX
	MOV	AL,BYTE [-1+EBP]
	MOV	BYTE [EDX],AL
	MOV	EAX,DWORD [8+EBP]
	INC	DWORD [8+EAX]
	MOV	EAX,DWORD [8+EBP]
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [8+EAX]
	CMP	EAX,DWORD [12+EDX]
	JNE	L4
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [8+EAX],0
L4:
	MOV	DWORD [-8+EBP],0
L2:
	MOV	EAX,DWORD [-8+EBP]
	LEAVE
	RET
	ALIGN	2
	GLOBAL	_fifo8_get
_fifo8_get:
	PUSH	EBP
	MOV	EBP,ESP
	SUB	ESP,8
	MOV	EAX,DWORD [8+EBP]
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [20+EAX]
	CMP	EAX,DWORD [12+EDX]
	JNE	L6
	MOV	DWORD [-8+EBP],-1
	JMP	L5
L6:
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [8+EBP]
	MOV	EAX,DWORD [4+EAX]
	ADD	EAX,DWORD [EDX]
	MOV	AL,BYTE [EAX]
	MOV	BYTE [-1+EBP],AL
	MOV	EAX,DWORD [8+EBP]
	INC	DWORD [20+EAX]
	MOV	EAX,DWORD [8+EBP]
	INC	DWORD [4+EAX]
	MOV	EAX,DWORD [8+EBP]
	MOV	EDX,DWORD [8+EBP]
	MOV	EAX,DWORD [4+EAX]
	CMP	EAX,DWORD [12+EDX]
	JLE	L7
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [4+EAX],0
L7:
	MOVSX	EAX,BYTE [-1+EBP]
	MOV	DWORD [-8+EBP],EAX
L5:
	MOV	EAX,DWORD [-8+EBP]
	LEAVE
	RET
	ALIGN	2
	GLOBAL	_fifo8_status
_fifo8_status:
	PUSH	EBP
	MOV	EBP,ESP
	MOV	ECX,DWORD [8+EBP]
	MOV	EAX,DWORD [8+EBP]
	MOV	EDX,DWORD [20+EAX]
	MOV	EAX,DWORD [12+ECX]
	SUB	EAX,EDX
	POP	EBP
	RET
