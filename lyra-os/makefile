TOOLPATH = D:\os\30dayMakeOS\tolset\z_tools

make:
	make run

asm : ipl.nas
	nask ipl.nas ipl.bin
	nask asmhead.nas asmhead.bin
	nask naskfun.nas naskfun.obj
	cc1 -I D:\os\30dayMakeOS\tolset\z_tools\haribote -o bootpack.gas .\bootpack.c
	gas2nask .\bootpack.gas bootpack.nas
	makefont hankaku.txt font.bin
	bin2obj font.bin font.obj _font
	nask .\bootpack.nas .\bootpack.obj bootpack.lst
	obj2bim @D:\os\os\tolset\z_tools\haribote\haribote.rul out:bootpack.bim stack:3136k map:bootpack.map .\bootpack.obj naskfun.obj font.obj
	bim2hrb bootpack.bim bootpack.hrb 0
	copy /B asmhead.bin+bootpack.hrb lyra-os.sys

img : ipl.bin lyra-os.sys
	bximage -q -fd=1.44M -func=create -sectsize=512 -imgmode=flat lyra-os.img
	dd if=ipl.bin of=lyra-os.img seek=0 count=1 conv=notrunc
	winimage lyra-os.img  /i lyra-os.sys /f /q /h

build:
	make asm
	make img
	copy lyra-os.img ..\build\lyra-os.img
	 
run :
	make clear
	make build
	bochsdbg -q -f D:\Bochs-2.7\bochsrc

clear :
	del bootpack.hrb
	del bochsout.txt
	del *.bin
	del ..\build\lyra-os.img
	del *img
	del *.sys
	del *.bim
	del *.obj
	del bootpack.nas
	del *.map
	del *.lst
	del *.gas
	