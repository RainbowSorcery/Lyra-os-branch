; hello-os
; TAB=4

org 0x7c00

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述
		DB		0xeb, 0x4e, 0x90
		DB		"HELLOIPL"		; ブートセクタの名前を自由に書いてよい（8バイト）
		DW		512				; 1セクタの大きさ（512にしなければいけない）
		DB		1				; クラスタの大きさ（1セクタにしなければいけない）
		DW		1				; FATがどこから始まるか（普通は1セクタ目からにする）
		DB		2				; FATの個数（2にしなければいけない）
		DW		224				; ルートディレクトリ領域の大きさ（普通は224エントリにする）
		DW		2880			; このドライブの大きさ（2880セクタにしなければいけない）
		DB		0xf0			; メディアのタイプ（0xf0にしなければいけない）
		DW		9				; FAT領域の長さ（9セクタにしなければいけない）
		DW		18				; 1トラックにいくつのセクタがあるか（18にしなければいけない）
		DW		2				; ヘッドの数（2にしなければいけない）
		DD		0				; パーティションを使ってないのでここは必ず0
		DD		2880			; このドライブ大きさをもう一度書く
		DB		0,0,0x29		; よくわからないけどこの値にしておくといいらしい
		DD		0xffffffff		; たぶんボリュームシリアル番号
		DB		"HELLO-OS   "	; ディスクの名前（11バイト）
		DB		"FAT12   "		; フォーマットの名前（8バイト）
		RESB	18				; とりあえず18バイトあけておく


entry: 
    mov ax, 0
    mov ss, ax
    mov sp, 0x7c00
    mov ds, ax
    mov es, ax

    ; 读取磁盘
    mov ax, 0x0820
    mov es, ax
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov si, 0

retry: 
    mov ah, 0x02
    mov al, 1
    mov bx, 0
    mov dl, 0x00
    int 0x13
    jnc ok
    add si, 1
    cmp si, 5
    mov al, [si]
    jae error
    mov ah, 0x00
    mov dl, 0x00
    int 0x13
    jmp retry

error: 
    mov si, errorMsg

putloop: 
    mov al, [si]
    add si, 1
    cmp al, 0
    je fin
    mov ah, 0x0e
    mov bx, 15
    int 0x10
    jmp putloop

ok: 
    mov si, okMsg
    jmp putloop

fin: 
    hlt
    jmp fin

errorMsg:
    DB 0x0a, 0x0a
    DB "load error."
    DB 0

okMsg:
    DB 0x0a, 0x0a
    DB "load ok."
    DB 0

    RESB 0x7dfe-$
    DB 0x55, 0xaa
