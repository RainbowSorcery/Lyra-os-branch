TOOLPATH = D:\os\30daysOS\tolset\z_tools
# 文件生成规则
asm : ipl.nas
	nask ipl.nas ipl.bin
	nask lyra-os.nas lyra-os.sys

img : ipl.bin lyra-os.sys
	edimg imgin:$(TOOLPATH)\fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 copy from:lyra-os.sys to:@: imgout:lyra-os.img

build : 
	make  asm
	make  img
run : lyra-os.img 
	make img
	copy lyra-os.img $(TOOLPATH)\qemu\fdimage0.bin
	$(MAKE) -C $(TOOLPATH)\qemu

clear :
	del ipl.bin
	del lyra-os.img
	del lyra-os.sys
