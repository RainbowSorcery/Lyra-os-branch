TOOLPATH = C:\Project\os\30daysOS\tolset\z_tools\
INCPATH  = C:\Project\os\30daysOS\tolset\z_tools\haribote\

# 文件生成规则
asm : ipl.nas
	nask ipl.nas ipl.bin
	nask asmhead.nas lyra-os.bin

img : 
	edimg imgin:C:\Project\os\30daysOS\tolset\z_tools\fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 copy from:lyra-os.sys to:@: imgout:lyra-os.img

build-obj:
	cc1 -I$(INCPATH) -Os -Wall -quiet -o bootpack.gas bootpack.c
	GAS2NASK bootpack.gas bootpack.nas
	nask bootpack.nas bootpack.obj bootpack.lst
	nask naskfunc.nas naskfunc.obj naskfuns.lst
<<<<<<< HEAD
	obj2bim @C:\Project\os\30daysOS\tolset\z_tools\haribote\haribote.rul out:bootpack.bim stack:3136k map:bootpack.map bootpack.obj naskfunc.obj 
=======
	obj2bim @E:\os\30daysOS\tolset\z_tools\haribote\haribote.rul out:bootpack.bim stack:3136k map:bootpack.map bootpack.obj naskfunc.obj font.obj
>>>>>>> aad89d8aadac75e4f1f4f6acb75bfdb976f2e05d
	BIM2HRB bootpack.bim bootpack.hrb 0
	copy /B lyra-os.bin+bootpack.hrb lyra-os.sys
build-font:
	makefont hankaku.txt font.bin
	bin2obj font.bin font.obj _font

build : 
	make  asm
	make build-font
	make build-obj
	make  img

run :
	make clear
	make build
	copy lyra-os.img C:\Project\os\30daysOS\tolset\z_tools\qemu\fdimage0.bin
	$(MAKE) -C C:\Project\os\30daysOS\tolset\z_tools\qemu

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