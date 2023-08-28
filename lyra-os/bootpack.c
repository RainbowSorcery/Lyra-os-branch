#include <stdio.h>


#define PIC0_ICW1		0x0020
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021
#define PIC1_ICW1		0x00a0
#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1


void io_hlt(void);

void write_mem8(int addr, int data);

int io_cli();
void io_out8(int port, int data);
int io_store_eflags(int eflags);
int io_load_eflags();
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int arr);
void asm_inthandler21(void);
void io_sti(void);
void inthandler21(int *esp);

struct Boot_info
{
	// 引导扇区设置
	char cyls;
	// LED 指示灯状态
	char leds;
	// 关于颜色的信息
	char vmode;
	// 分辨率X
	short scrnx;
	// 分辨率y
	short scrny;
	// 图像缓冲区的起始地址
	char *vram;
};

struct Segment_descriptor
{
	// 段界限
	short limit_low;
	// 段基址
	short base_low;
	char base_mid;
	// 访问权限
	char access_right;
	char limit_high;
	char base_high;
};

struct Gate_descriptor
{
	// offset 中断处理程序入口点，当中断触发时，跳转到中断程序的入口点进行执行
	short offset_low;
	// selector 高13位确定了段下标，低2位表示特权级
	short selector;
	// 中断描述符属性
	char dw_count;
	
	char access_right;

	short offset_hight;
};

void init_gdt_idt(void){
	// GDT开始地址
	struct Segment_descriptor *gdt = (struct Segment_descriptor *) 0x00270000;
	// IDT开始地址
	struct Gate_descriptor *idt = (struct Gate_descriptor *) 0x0026f800;

		// GDT寄存器共有48位，前32位为全局描述符地址，也就是0x00270000，后16位是段上限。段上限只有16位，段上限指明了操作系统共初始化了多少个段
		// 再这16位前13位是段索引，最大2^13=jhjjhgttytioo   ll;l88878956454132 .0.0第321536544614位 
		// 所以可以最大初始化2^16 = 65535个，每个段8个字节 65535 / 8 = 8191。我们可以初始化8191个段，0xffff最大可以初始化8192个段，如果超了8191，后面的肯定就没办法访问了。
		int i;
		for (i = 0; i < 8192; i++) {
			set_segment_descriptor(gdt + i, 0, 0, 0);
		}

	load_gdtr(0xffff, 0x00270000);

	// 段1为cpu管理的全部内存 0x00000000-0xffffffff共4G
	set_segment_descriptor(gdt + 1, 0xffffffff, 0x00000000, 0x4092);
	// 段2则是我们的bootpack这个程序 共512k
	set_segment_descriptor(gdt + 2, 0x0007ffff, 0x00280000, 0x409a);

	// idt是 一个最大256表项的数组
	for (i = 0; i < 256; i++) {
		set_gated_descriptor(idt + i, 0, 0, 0);
	}

	// 段界限 段地址 为了将ldtr和gdtr寄存器保证一致，所以即便是最大只能设置256个idt表项也依旧将界限设置成16位
	// 如果设置成不保存一致的情况的话，cpu还需要特殊为寄存器进行特殊处理，这样会增加系统的设计复杂性。
	// 界限表示段所占字节数 - 1，并不是idt数，是指256 * 8 - 1，并不是256
	load_idtr(0x7ff, 0x0026f800);

	set_gated_descriptor(idt + 0x2c, (int) asm_inthandler21, 2 * 8, 0x008e);

	struct Boot_info *binfo = (struct Boot_info *) 0x0ff0;
	printFont8_ascii(binfo->vram, binfo->scrnx, 10, 10, 0x07, "INT 21 (IRQ-1) : PS/2 keyboard");


	// set_gated_descriptor(idt + 0x27, (int) asm_inthandler21, 2 * 8, 0x008e);
	// set_gated_descriptor(idt + 0x2c, (int) asm_inthandler21, 2 * 8, 0x008e);
}

/**
 * 设置idt 
*/
void set_gated_descriptor(struct Gate_descriptor *gd, int offset, int selector, int ar) {
	gd -> offset_low = offset & 0xffff;
	gd -> selector = selector;
	gd -> dw_count = (ar >> 8) & 0xff;
	gd -> access_right = ar & 0xff;
	gd -> offset_hight = (offset >> 16) & 0xffff;
	return;
}

void init_pic() {
	// IMR为中断屏蔽寄存器，该寄存器有8位，分别对应每一路IRQ信号，如果值为1，则拼屏蔽对应的信号
	io_out8(PIC0_IMR, 0xff);
	io_out8(PIC1_IMR, 0xff);

	
	io_out8(PIC0_ICW1, 0x11);
	io_out8(PIC0_ICW2, 0x20);
	io_out8(PIC0_ICW3, 1 << 2);
	io_out8(PIC0_ICW4, 0x01);

	io_out8(PIC1_ICW1, 0x11);
	io_out8(PIC1_ICW2, 0x28);
	io_out8(PIC1_ICW3, 2);
	io_out8(PIC1_ICW4, 0x01);

	io_out8(PIC0_IMR, 0xfb);
	io_out8(PIC1_IMR, 0xff);

}



void inthandler21(int *esp)
/* 来自PS/2键盘的中断 */
{
	struct Boot_info *binfo = (struct Boot_info *) 0x0ff0;
	boxfill8(binfo->vram, binfo->scrnx, 0x07, 0, 0, 32 * 8 - 1, 15);
	printFont8_ascii(binfo->vram, binfo->scrnx, 10, 10, 0x07, "INT 21 (IRQ-1) : PS/2 keyboard");
	for (;;) {
		io_hlt();
	}
}


/**
 * 初始化gtd
 * gdt: gdt地址
 * limit: 段界限，段的长度
 * base: 段基址 段的起始地址
 * attr: 段属性 
*/
void set_segment_descriptor(struct Segment_descriptor *gdt, int base, unsigned int limit, int attr) {
	// 如果段上限大于 0xffff 设置G位为1
	if (limit > 0xffff) {
		attr != 0x8000;
		// limit缩小4k
		limit /= 0x1000;
	}

	gdt->limit_low = limit & 0xffff;
	// 先获取高8位 之后左移获取 对中间四位进行或运算
	gdt->limit_high = (limit >> 16) & 0x0f | ((attr >> 8) & 0xf0);
	gdt->base_low = base & 0xffff;
	gdt->base_mid = (base >> 16) & 0xff;
	gdt->base_high = (base >> 24) & 0xff;
	gdt->access_right = attr & 0xff;
}



void init_palette(void)
{
	// vag调色盘最多只能设置16种不同的颜色
	static unsigned char table_rgb[18 * 3] = {
		0x00, 0x00, 0x00, /*  0:黑 */
		0xff, 0x00, 0x00, /*  1:梁红 */
		0x00, 0xff, 0x00, /*  2:亮绿 */
		0xff, 0xff, 0x00, /*  3:亮黄 */
		0x99, 0xdd, 0xcc, /*  4:淡蓝 */
		0xff, 0x00, 0xff, /*  5:亮紫 */
		0x00, 0xff, 0xff, /*  6:浅亮蓝 */
		0xff, 0xff, 0xff, /*  7:白 */
		0xc6, 0xc6, 0xc6, /*  8:亮灰 */
		// 0x84, 0x00, 0x00,	/*  9:暗红 */
		0x00, 0x84, 0x00, /* 10:暗绿 */
		0x84, 0x84, 0x00, /* 11:暗黄 */
		0x00, 0x00, 0x84, /* 12:暗青 */
		0x84, 0x00, 0x84, /* 13:暗紫 */
		0x00, 0x84, 0x84, /* 14:浅暗蓝 */
		0x84, 0x84, 0x84, /* 15:暗灰 */
		0xb6, 0xa3, 0xbc, /* 16:dreamer鬃毛颜色 */

	};

	set_palette(0, 18, table_rgb);
	return;
}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	// 记录中断寄存器中的值
	eflags = io_load_eflags();
	// 关中断
	io_cli();
	io_out8(0x03c8, start);

	for (i = start; i <= end; i++)
	{
		// 将调色板中记录的RGB值存储到0x03c9地址中
		// 为什么要 / 4, rgb 红绿蓝（R、G、B）都是一个具有 6 位值（从 0 到 63）的字节+ 两个 0) 前两位0不识别 所以要右移两位使得前两位识别 /4就相当于右移两位补零
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}

	// 开中断
	io_store_eflags(eflags);

	return;
}

void boxfill8(unsigned char *vram, int xSize, int x0, int y0, int x1, int y1, unsigned char color)
{
	int x, y;

	for (x = x0; x <= x1; x++)
	{
		for (y = y0; y <= y1; y++)
		{
			*(vram + xSize * y + x) = color;
		}
	}
}

static char font_A[16] = {
	0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24,	
	0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00};

/**
 * varam: 显存地址
 * xSize: 每行像素数 320 * 200就是320
 * c: 颜色下标
 * x: 字符串显示x轴 从左到右空出多少个像素
 * y: 字符显示y轴
 * font: 字符序列
 */
void put_font_8(unsigned char *vram, int x_size, char c, int x, int y, char font[16])
{
	int i;
	char *p, d /* data */;
	for (i = 0; i < 16; i++)
	{
		// 和矩形计算公式一样 根据行数和列数 计算出字符需要展示的位置
		p = vram + (y + i) * x_size + x;
		d = font[i];

		if ((d & 0x80) != 0)
		{
			p[0] = c;
		}
		if ((d & 0x40) != 0)
		{
			p[1] = c;
		}
		if ((d & 0x20) != 0)
		{
			p[2] = c;
		}
		if ((d & 0x10) != 0)
		{
			p[3] = c;
		}
		if ((d & 0x08) != 0)
		{
			p[4] = c;
		}
		if ((d & 0x04) != 0)
		{
			p[5] = c;
		}
		if ((d & 0x02) != 0)
		{
			p[6] = c;
		}
		if ((d & 0x01) != 0)
		{
			p[7] = c;
		}
	}
	return;
}

void init_screen(char *vram, int x_size, int y_size)
{

	boxfill8(vram, x_size, 0, 0, x_size, 180, 0x0f);
	boxfill8(vram, x_size, 0, y_size - 20, x_size, 200, 0x08);
	boxfill8(vram, x_size, 0, y_size - 19, x_size, 182, 0x07);
	boxfill8(vram, x_size, 2, y_size - 15, x_size - 280, 186, 0x07);
	boxfill8(vram, x_size, 3, y_size - 6, x_size - 280, 195, 0x0e);
	boxfill8(vram, x_size, 2, y_size - 15, x_size - 317, 195, 0x07);
	boxfill8(vram, x_size, 40, y_size - 15, x_size - 279, 196, 0x00);
	boxfill8(vram, x_size, 2, y_size - 5, 40, x_size - 124, 0x00);
	// boxfill8(wram, 40, y_size - 6, 40, x_size - 123, 0x05);
}
extern char font[4096];

void printFont8_ascii(char *vram, int x_size, int x, int y, char color, unsigned char *str)
{
	// 末尾字符是0x00
	for (; *str != 0x00; str++)
	{
		put_font_8(vram, x_size, color, x, y, font + *str * 16);
		x += 8;
	}
}

void init_mouse_cursor8(char *mouse, char bc)
/* マウスカーソルを準備（16x16） */
{
	static char cursor[16][16] = {
    "*...............",
    "**..............",
    "*O*.............",
    "*OO*............",
    "*OOO*...........",
    "*OOOO*..........",
    "*OOOOO*.........",
    "*OOOOOO*........",
    "*OOOOOOO*.......",
    "*OOOO*****......",
    "*OO*O*..........",
    "*O*.*O*.........",
    "**..*O*.........",
    "*....*O*........",
    ".....*O*........",
    "......*........."
	};
	int x, y;

	for (y = 0; y < 16; y++) {
		for (x = 0; x < 16; x++) {
			if (cursor[y][x] == '*') {
				mouse[y * 16 + x] = 0x00;
			}
			if (cursor[y][x] == 'O') {
				mouse[y * 16 + x] = 0x07;
			}
			if (cursor[y][x] == '.') {
				mouse[y * 16 + x] = bc;
			}
		}
	}
	return;
}

void putblock8_8(char *vram, int vxsize, int pxsize,
	int pysize, int px0, int py0, char *buf, int bxsize)
{
	int x, y;
	for (y = 0; y < pysize; y++) {
		for (x = 0; x < pxsize; x++) {
			vram[(py0 + y) * vxsize + (px0 + x)] = buf[y * bxsize + x];
		}
	}
	return;
}


void HariMain(void)
{


	struct Boot_info *boot_info = (struct Boot_info *)0x0ff0;

	init_palette();

	init_gdt_idt();
	init_pic();
	io_sti(); 
	
	init_screen(boot_info->vram, boot_info->scrnx, boot_info->scrny);

	char s[16];
	sprintf(s, "size_x:%d", boot_info->scrnx);

	char mour[256];

	int	mx = (boot_info->scrnx - 16) / 2; /* 计算画面的中心坐标*/
	int my = (boot_info->scrny - 28 - 16) / 2;

	init_mouse_cursor8(mour, 0x0f);
	putblock8_8(boot_info->vram, boot_info->scrnx, 16, 16, mx, my, mour, 16);

	// io_out8(PIC0_IMR, 0xf9); /* 开放PIC1和键盘中断(11111001) */
	// io_out8(PIC1_IMR, 0xef); /* 开放鼠标中断(11101111) */

	fin:
		io_hlt();
	
	goto fin;

}
