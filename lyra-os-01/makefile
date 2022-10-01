# 文件生成规则
ipl.bin : ipl.nas MakeFile
	../z_tools/nask.exe ipl.nas ipl.bin ipl.lst
os.img : ipl.bin MakeFile
	..\z_tools\edimg.exe   imgin:../z_tools/fdimg0at.tek \
	wbinimg src:ipl.bin len:512 from:0 to:0   imgout:os.img