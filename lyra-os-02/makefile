TOOLPATH = 	D:\os\30daysOS\tolset\z_tools


# 文件生成规则
asm : ipl.nas MakeFile
	nask ipl.nas ipl.bin ipl.lst

img : ipl.bin lyra-os.sys
	edimg.exe   imgin:D:\os\30daysOS\tolset\z_tools\fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 copy from:lyra-os.sys to:@: imgout:lyra-os.img

build : 
	make.exe  asm
	make.exe  img
run : lyra-os.img Makefile
	copy lyra-os.img $(TOOLPATH)\qemu\fdimage0.bin
	make.exe -C $(TOOLPATH)\qemu

clear :
	del ipl.bin
	del lyra-os.img
	del ipl.lst