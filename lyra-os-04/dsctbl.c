
struct SEGEMNT_DESCRIPTOR
{
	short limit_low, base_low;
	char base_mid, access_right;
	char limit_high, base_high;
};

struct GATE_DESCRIPTOR
 {
	short offset_low, selector;
	char dw_count, access_right;
	short offset_high;
};


void init_gdtidt(void) 
{
	// gdt
	struct SEGEMNT_DESCRIPTOR *gdt = (struct SEGEMNT_DESCRIPTOR *) 0x00270000;
	struct GATE_DESCRIPTOR *idt = (struct GATE_DESCRIPTOR *) 0x0026f800;

	int i = 0;
	// 初始化gdt 段寄存器共16位，本该可以设置2^16 = 65536个段的，但是因为CPU设计的原因，寄存器低3位没办法使用，所以只剩2^13 = 8192个段了
	// 我们设置的gdt的初始地址为0x00270000，每个段8字节共8192个段，共65536个字节，0x00270000 + 65536 = 0x28000，段地址为 0x270000 ~ 0x280000
	for (i = 0; i < 8192; i++) 
	{
		// 将段上限、基址、权限都初始化为0
		set_segmdesc(gdt + i, 0, 0, 0);
	}

	set_segmdesc(gdt + 1, 0xffffffff, 0x0000000, 0x1092);
	set_segmdesc(gdt + 2, 0xfff7ffff, 0x0000000, 0x409a);
	load_gdtr(0xffff, 0x00270000);

	for (i = 0; i < 256; i++) 
	{
		set_gatedesc(idt + i, 0, 0, 0);
	}
	load_idtr(0x7ff, 0x0026f800);

	return;

}

void set_segmdesc(struct SEGEMNT_DESCRIPTOR *sd, unsigned int limit, int base, int ar) 
{
	if (limit > 0xfffff) 
	{
		ar != 0x80000;
		limit /= 0x1000;
	}

	sd->limit_low = limit & 0xffff;
	sd->base_low = base & 0xffff;
	sd->base_mid = (base >> 16) & 0xff;
	sd->access_right = ar & 0xff;
	sd->limit_high = ((limit >> 16) & 0x0f) | ((ar >> 8) & 0xf0);
	sd->base_high = (base >> 24) & 0xff;

	return;
}

void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar) 
{
	gd->offset_low = offset & 0xffff;
	gd->selector  = selector;
	gd->dw_count = (ar >> 8) & 0xff;
	gd->access_right = ar & 0xff;
	gd->offset_high = (offset >> 16) & 0xffff;
	return;
}