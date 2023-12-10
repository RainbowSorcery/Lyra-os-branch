#define FLAGS_OVERUN 0x0001

#include "fifo.h"

/**
 * 初始化缓冲区
 * *fifof: 缓冲区指针
 * size: 缓冲区大小
 * buf: 缓冲区元素地址
 */
void fifo8_init(struct Fifo8 *fifo, int size, unsigned char *buf)
{
    fifo->size = size;
    fifo->buffer = buf;
    fifo->size = size;
    fifo->read = 0;
    fifo->write = 0;
    fifo->flag = 0;
    fifo->free = size;
}

int fifo8_put(struct Fifo8 *fifo, unsigned char data)
{
    // 如果缓冲区没有空闲空间了则设置缓冲区的溢出状态为已溢出并直接返回
    if (fifo->free == 0)
    {
        fifo->flag = FLAGS_OVERUN;

        return -1;
    }

    fifo->free--;

    fifo->buffer[fifo->write] = data;
    fifo->write++;

    if (fifo->write == fifo->size)
    {
        fifo->write = 0;
    }

    return 0;
}

char fifo8_get(struct Fifo8 *fifo)
{
    // 判断缓冲区是否为空
    if (fifo->free == fifo->size)
    {
        return -1;
    }

    unsigned char data = fifo->buffer[fifo->read];

    fifo->free++;

    fifo->read++;
    if (fifo->read > fifo->size)
    {
        fifo->read = 0;
    }
  
    return data;
}

int fifo8_status(struct Fifo8* fifo) 
{
    return fifo->size - fifo->free;
}
