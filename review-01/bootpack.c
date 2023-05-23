void io_hlt(void);

void write_mem8(int addr, int data);

int io_cli();
void io_out8(int port, int data);
int io_store_eflags(int eflags);
int io_load_eflags();

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
void printFont8(unsigned char *vram, int x_size, char c, int x, int y, char font[16])
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

void init_screen(char *wram, int x_size, int y_size)
{

	boxfill8(wram,x_size, 0, 0, x_size, 180, 0x0f);
	boxfill8(wram,x_size, 0, y_size - 20, x_size, 200, 0x08);
	boxfill8(wram,x_size, 0, y_size - 19, x_size, 182, 0x07);
	boxfill8(wram,x_size, 2, y_size - 15, x_size - 280, 186, 0x07);
	boxfill8(wram,x_size, 3, y_size - 6, x_size - 280, 195, 0x0e);
	boxfill8(wram,x_size, 2, y_size - 15, x_size - 317, 195, 0x07);
	boxfill8(wram,x_size, 40, y_size - 15, x_size - 279, 196, 0x00);
	boxfill8(wram,x_size, 2, y_size - 5, 40, x_size - 124, 0x00);
	// boxfill8(wram, 40, y_size - 6, 40, x_size - 123, 0x05);
}


void HariMain(void)
{
	struct Boot_info *boot_info = (struct Boot_info *)0x0ff0;

	init_palette();

	init_screen(boot_info->vram, boot_info->scrnx, boot_info->scrny);


	// printFont8(boot_info->vram, boot_info->scrnx, 0x07, 8, 8, hankaku + 'B' * 16);


fin:
	io_hlt();

	goto fin;
}
