# 文件生成规则
asm : ipl.asm
	nasm ipl.asm -o ipl.bin
	nasm lyra-os.asm -o lyra-os.sys

img : ipl.bin lyra-os.sys
	dd if=/dev/zero of=ipl.bin bs=512 seek=1 skip=1 count=2879 
	mv ipl.bin lyra-os.img
	sudo mount lyra-os.img /mnt
	sudo cp lyra-os.sys /mnt
	sudo umount /mnt

build : 
	make  asm
	make  img
run : lyra-os.img 
	qemu-system-i386 -fda lyra-os.img

clear :
	rm -rf ipl.bin
	rm -rf lyra-os.img
	rm -rf lyra-os.sys
