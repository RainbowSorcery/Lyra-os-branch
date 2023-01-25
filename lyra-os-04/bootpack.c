
void io_hlt(void);
void write_mem8(int addr, int data);
int io_load_eflags(void);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);
void init_palette(void);
void init_screen(char *wram, int x_size, int y_size);
void putfonts8_asc(char *varm, int szize, int x, int y, char c, unsigned char *s);
void init_gdtidt(void);

struct BootInfo
{
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *wram;
};


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

	init_gdtidt();
	
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
