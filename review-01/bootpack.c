void io_hlt(void);

void write_mem8(int addr, int data);

int io_cli();
void io_out8(int port, int data);
int io_store_eflags(int eflags);
int io_load_eflags();

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
		0x84, 0x00, 0x00,	/*  9:暗红 */
		0x00, 0x84, 0x00, /* 10:暗绿 */
		0x84, 0x84, 0x00, /* 11:暗黄 */
		0x00, 0x00, 0x84, /* 12:暗青 */
		0x84, 0x00, 0x84, /* 13:暗紫 */
		0x00, 0x84, 0x84, /* 14:浅暗蓝 */
		0x84, 0x84, 0x84, /* 15:暗灰 */
		0xb6, 0xa3, 0xbc, /* 16:dreamer鬃毛颜色 */

        0xFF, 0xC0, 0xCB,

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


void boxfill8(unsigned char *vram, int xSize, unsigned int color, int x0, int y0, int x1, int y1) {
	int x, y;

	for (x = x0; x <= x1; x++) {
		for (y = y0; y <= y1; y++) {
			*(vram + xSize * y + x) = color;
		}
	}
}

void HariMain(void)
{
    int j = 0;
    int i = 0xa0000;
    init_palette();

	char *p;

	p = (char *) 0xa0000;

	boxfill8(i, 320, 0xf, 70, 150, 120, 172);


fin:
    io_hlt();

    goto fin;
}
