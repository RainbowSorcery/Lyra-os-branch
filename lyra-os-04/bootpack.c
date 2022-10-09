void io_hlt(void);
void write_mem8(int addr, int data);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);
void io_cli();





void set_palette(int start, int end, unsigned char *rgb) {
	int i, eflags;
	// 记录中断寄存器中的值
	eflags = io_load_eflags();
	// 关中断
	io_cli();
	io_out8(0x03c8, start);

	for (i = start; i <= end; i++) {
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

void init_palette(void) {
	// vag调色盘最多只能设置16种不同的颜色
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0:黑 */
		0xff, 0x00, 0x00,	/*  1:梁红 */
		0x00, 0xff, 0x00,	/*  2:亮绿 */
		0xff, 0xff, 0x00,	/*  3:亮黄 */
		0x00, 0x00, 0xff,	/*  4:亮蓝 */
		0xff, 0x00, 0xff,	/*  5:亮紫 */
		0x00, 0xff, 0xff,	/*  6:浅亮蓝 */
		0xff, 0xff, 0xff,	/*  7:白 */
		0xc6, 0xc6, 0xc6,	/*  8:亮灰 */
		// 0x84, 0x00, 0x00,	/*  9:暗红 */
		0x00, 0x84, 0x00,	/* 10:暗绿 */
		0x84, 0x84, 0x00,	/* 11:暗黄 */
		0x00, 0x00, 0x84,	/* 12:暗青 */
		0x84, 0x00, 0x84,	/* 13:暗紫 */
		0x00, 0x84, 0x84,	/* 14:浅暗蓝 */
		0x84, 0x84, 0x84,	/* 15:暗灰 */
		0xb6, 0xa3, 0xbc,	/* 16:dreamer鬃毛颜色 */
		// 0xaf, 0xdf, 0xef
	};
	set_palette(0, 16, table_rgb);

	return;
}

void boxfill8(unsigned char *varm, int x0, int y0, int x1, int y1, char color) {
	int i, j;

	for (i = y0; i < y1; i++) {
		for (j = x0; j < x1; j++) {
			varm[i * 320 + j] = color;
		}
	}

	return;
}

void HariMain(void) {
	int i; 
	int j;
	char *p = (char *)0xa0000;

	// 初始化调色板
	init_palette();


	boxfill8(p, 0, 0, 320, 180, 0x0f);
	boxfill8(p, 0, 180, 320, 200, 0x08);
	boxfill8(p, 0, 181, 320, 182, 0x07);

	boxfill8(p, 2, 185, 40, 186, 0x07);

	boxfill8(p, 3, 194, 40, 195, 0x0e);

	boxfill8(p, 2, 185, 3, 195, 0x07);
	
	boxfill8(p, 40, 185, 41, 196, 0x00);

	boxfill8(p, 2, 195, 40, 196, 0x00);

	boxfill8(p, 40, 194, 40, 195, 0x05);


	// 	for (i = 50; i < 100; i++) {
	// 	for (j = 100; j < 150; j++) {
	// 		*(p + i * 320 + j) = 0x1;
	// 	}
	// }


	for (;;) {
		io_hlt();
	}
}
