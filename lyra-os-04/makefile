TOOLPATH = d:\os\30dayMakeOS\tolset\z_tools\
INCPATH  = d:\os\30dayMakeOS\tolset\z_tools\haribote\


# 文件生成规则
asm : ipl.nas
	nask ipl.nas ipl.bin
	nask asmhead.nas lyra-os.bin

img : 
	edimg imgin:D:\os\30dayMakeOS\tolset\z_tools\fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 copy from:lyra-os.sys to:@: imgout:lyra-os.img

build-obj:
	cc1 -I$(INCPATH) -Os -Wall -quiet -o bootpack.gas bootpack.c
	GAS2NASK bootpack.gas bootpack.nas
	nask bootpack.nas bootpack.obj bootpack.lst
	nask naskfunc.nas naskfunc.obj naskfuns.lst
	obj2bim @D:\os\30dayMakeOS\tolset\z_tools\haribote\haribote.rul out:bootpack.bim stack:3136k map:bootpack.map graphic.obj dsctbl.obj bootpack.obj naskfunc.obj font.obj
	BIM2HRB bootpack.bim bootpack.hrb 0
	copy /B lyra-os.bin+bootpack.hrb lyra-os.sys
build-font :
	makefont hankaku.txt font.bin
	bin2obj font.bin font.obj _font

build : 
	make  asm
	make build-nas
	make build-font
	make build-obj
	make img
	copy lyra-os.img ..\build\


build-nas :
	make graphic.gas
	make graphic.nas
	make graphic.obj
	make dsctbl.gas 
	make dsctbl.nas
	make dsctbl.obj 
run :
	make clear
	make build
	bochsdbg -q -f D:\Bochs-2.7\bochsrc

graphic.gas : graphic.c Makefile
	cc1 -o graphic.gas graphic.c

graphic.nas : graphic.gas Makefile
	GAS2NASK graphic.gas graphic.nas

graphic.obj : graphic.nas Makefile
	nask graphic.nas graphic.obj graphic.lst

dsctbl.gas : dsctbl.c Makefile
	cc1 -o dsctbl.gas dsctbl.c

dsctbl.nas : dsctbl.gas Makefile
	GAS2NASK dsctbl.gas dsctbl.nas

dsctbl.obj : dsctbl.nas Makefile
	nask dsctbl.nas dsctbl.obj dsctbl.lst

clear :
	del *.sys
	del *.bin
	del *.obj
	del *.map
	del *.hrb
	del *.gas
	del *.bim
	del *.lst
	del *.img
	del ..\build\lyra-os.img