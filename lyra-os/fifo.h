#define FLAGS_OVERUN 0x0001

struct Fifo8
{
    // 缓冲区元素指针
    unsigned char *buffer;
    // 读指针
    int read;
    // 写指针
    int write;
    // 缓冲区大小
    int size;
    // 是否溢出
    int flag;
    // 缓冲区剩余空闲空间
    int free;
};

/**
 * 初始化缓冲区
 * *fifof: 缓冲区指针
 * size: 缓冲区大小
 * buf: 缓冲区元素地址
 */
void fifo8_init(struct Fifo8 *fifo, int size, unsigned char *buf);
int fifo8_put(struct Fifo8 *fifo, unsigned char data);
char fifo8_get(struct Fifo8 *fifo);
int fifo8_status(struct Fifo8* fifo);
