
void io_hlt(void);
void write_mem8(int addr, int data);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);
void io_cli();


struct BootInfo
{
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *wram;
};

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
		// 为什么要 / 4 rgb 红绿蓝（R、G、B）都是一个具有 6 位值（从 0 到 63）的字节+ 两个 0)
		// 前两位0不识别 所以要右移两位使得前两位死别
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}

	// 开中断
	io_store_eflags(eflags);

	return;
}

void init_palette(void)
{
	// vag调色盘最多只能设置16种不同的颜色
	static unsigned char table_rgb[16 * 3] = {
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
	set_palette(0, 16, table_rgb);

	return;
}

void boxfill8(unsigned char *varm, int x0, int y0, int x1, int y1, char color)
{
	int i, j;

	for (i = y0; i < y1; i++)
	{
		for (j = x0; j < x1; j++)
		{
			varm[i * 320 + j] = color;
		}
	}

	return;
}

void putfont8(char *vram, int xsize, int x, int y, char c, char *font)
{
	int i;
	char d;
	for (i = 0; i < 16; i++)
	{
		d = font[i];
		// 第一位，如果第一位为1那么就在该位置上色
		// 0x80=10000000
		// 0x40=1000000依次类推
		if ((d & 0x80) != 0)
		{
			vram[(y + i) * xsize + x + 0] = c;
		}
		if ((d & 0x40) != 0)
		{
			vram[(y + i) * xsize + x + 1] = c;
		}
		if ((d & 0x20) != 0)
		{
			vram[(y + i) * xsize + x + 2] = c;
		}
		if ((d & 0x10) != 0)
		{
			vram[(y + i) * xsize + x + 3] = c;
		}
		if ((d & 0x8) != 0)
		{
			vram[(y + i) * xsize + x + 4] = c;
		}
		if ((d & 0x4) != 0)
		{
			vram[(y + i) * xsize + x + 5] = c;
		}
		if ((d & 0x2) != 0)
		{
			vram[(y + i) * xsize + x + 6] = c;
		}
		if ((d & 0x1) != 0)
		{
			vram[(y + i) * xsize + x + 7] = c;
		}
	}

	return;
}

void init_screen(char *wram, int x_size, int y_size)
{

	boxfill8(wram, 0, 0, x_size, 180, 0x0f);
	boxfill8(wram, 0, y_size - 20, x_size, 200, 0x08);
	boxfill8(wram, 0, y_size - 19, x_size, 182, 0x07);
	boxfill8(wram, 2, y_size - 15, x_size - 280, 186, 0x07);
	boxfill8(wram, 3, y_size - 6, x_size - 280, 195, 0x0e);
	boxfill8(wram, 2, y_size - 15, x_size - 317, 195, 0x07);
	boxfill8(wram, 40, y_size - 15, x_size - 279, 196, 0x00);
	boxfill8(wram, 2, y_size - 5, 40, x_size - 124, 0x00);
	boxfill8(wram, 40, y_size - 6, 40, x_size - 123, 0x05);
}

void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s) {
	extern char font[4096];
	
	while (*s != '\0') {
		putfont8(vram, xsize, x, y, c, font + *s * 16);
		x += 8;
		s++;
	}
}

void HariMain(void)
{
	struct BootInfo *bootInfo;
	bootInfo = (struct BootInfo *)0x0ff0;

	// int i;
	// int j;
	char *p = bootInfo->wram;

	short x_size = bootInfo->scrnx;
	short y_size = bootInfo->scrny;

	// 初始化调色板
	init_palette();

	init_screen(bootInfo->wram, bootInfo->scrnx, bootInfo->scrny);

	static char font_A[16] = {	
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x08, 0x08, 0x08, 0x08, 0x08, 0x0F, 0x00, 0x00};

	putfonts8_asc(p, x_size, 5, 5, 0x4, "Hello Lyra OS");

	char s[100];


	sprintf(s, "scrnx = %c", 'c');
	putfonts8_asc(bootInfo->wram, bootInfo->scrnx, 16, 64, 0x1, s);
	// 	for (i = 50; i < 100; i++) {
	// 	for (j = 100; j < 150; j++) {
	// 		*(p + i * 320 + j) = 0x1;
	// 	}
	// }

	for (;;)
	{
		io_hlt();
	}
}
