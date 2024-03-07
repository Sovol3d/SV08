#ifndef __WS2811_H
#define __WS2811_H
#include <stdint.h> 

void RGB_IOInit(void);
void SendOne(void);
void SendZero(void);
void SendRGB(uint8_t red, uint8_t green, uint8_t blue);
void RGB_Reset(void);
void lcd_init(void);

#endif
