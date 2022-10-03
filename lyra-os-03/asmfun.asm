[BITS 32]
GLOBAL _io_hlt

[SECTION .text]
_io_hlt : ;void io_hlt(void);
	HLT
	RET
