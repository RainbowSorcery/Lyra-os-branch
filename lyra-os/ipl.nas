; hello-os
; TAB=4

; 读取柱面数 因为ES最大位0xffff bx最大位0xffff，ES:BX最大寻址范围位ES * 16 + bx = 1114095Byte = 1.062483787536621MB 但是实模式只能使用20条地址线，也就是寻址范围只能在1MB以内
; todo 这个算法有问题
; 若读入柱面等于56，因为我们是从0x820开始读的，ES = 0x0820, AX = 0 从0x8200地址开始读取 56个柱面 * 2个磁头 * 18个扇区 * 512字节 + 0x8200 = 1.01611328125M 超过1MB了，所有会报错
CYLS    EQU 55

org 0x7c00

; 以下は標準的なFAT12フォーマットフロッピーディスクのための記述
		DB		0xeb, 0x4e, 0x90
		DB		"LYRA IPL"		; ブートセクタの名前を自由に書いてよい（8バイト）
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

readLoop:
    mov si, 0

retry: 
    ; 读盘
    mov ah, 0x02
    ; 同时连续处理扇区数
    mov al, 1
    ; es:bx 缓冲地址
    mov bx, 0
    mov dl, 0x00
    int 0x13
    jnc next
    add si, 1
    cmp si, 5
    jae error
    mov ah, 0x00
    mov dl, 0x00
    ; 调用读盘中断
    int 0x13
    jmp retry

next:
    mov ax, es
    add ax, 0x0020
    mov es, ax
    add cl, 1
    cmp cl, 18
    jbe readLoop
    mov cl, 1
    add dh, 1
    cmp dh, 2
    jb readLoop
    mov dh, 0
    add ch, 1
    cmp ch, CYLS

    jb readLoop

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

fin: 
    mov [0x0ff0],CH
    jmp 0xc200

errorMsg:
    DB 0x0a, 0x0a
    DB "load error."
    DB 0
     TIMES 0x1fe-($-$$) DB 0
    DB 0x55, 0xaa
