# 文件生成规则
asm : ipl.nas MakeFile
	../z_tools/nask.exe ipl.nas ipl.bin ipl.lst

img : ipl.bin MakeFile
	../z_tools/edimg.exe   imgin:../z_tools/fdimg0at.tek \
	wbinimg src:ipl.bin len:512 from:0 to:0   imgout:ipl.img
	
build : 
	../z_tools/make.exe  asm
	../z_tools/make.exe  img
run : ipl.img Makefile
	copy ipl.img ..\z_tools\qemu\fdimage0.bin
	..\z_tools\make.exe -C ..\z_tools\qemu

clear :
	del ipl.bin
	del ipl.img
	del ipl.lst