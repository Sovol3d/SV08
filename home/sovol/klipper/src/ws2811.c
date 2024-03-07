#include "ws2811.h"
#include "generic/armcm_timer.h" // udelay
#include "stm32/internal.h"
#include "stm32/gpio.h"

#define GPIO_CS GPIO('C', 10)

void RGB_IOInit(void)
{
	gpio_peripheral(GPIO_CS, GPIO_OUTPUT, 0);
}

void GPIO_SetBits(uint32_t pin)
{
	gpio_out_setup(pin, 1);
	//gpio_out_write(gpio, 1);
}

void GPIO_ResetBits(uint32_t pin)
{
	gpio_out_setup(pin, 0);
}

void SendOne(void){//T1H -> T1L
	
	GPIO_SetBits(GPIO_CS);//设置为高电平
	//延时580ns~1μs
	__NOP(); //13.89ns*48 ~
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	
	GPIO_ResetBits(GPIO_CS);//设置为低电平
	//延时220ns~380ns
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();//13.89ns*16
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
}

void SendZero(void){//T0H -> T0L
	GPIO_SetBits(GPIO_CS);//设置为高电平
	//延时220ns~380ns
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();//13.89ns*16
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	
	//延时580ns~1μs
	GPIO_ResetBits(GPIO_CS);//设置为低电平
	__NOP();//13.89ns*48 
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();
	__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();__NOP();	
}

void SendRGB(uint8_t red, uint8_t green, uint8_t blue) {
	uint8_t i = 0;
	for(i = 0;i < 8; i++){
		if(red&0x80){
			SendOne();
		}
		else{
			SendZero();
		}
		red = red<<1;
	}
	for(i = 0;i < 8; i++){
		if(green&0x80){
			SendOne();
		}
		else{
			SendZero();
		}
		green = green<<1;
	}
	for(i = 0;i < 8; i++){
		if(blue&0x80){
			SendOne();
		}
		else{
			SendZero();
		}
		blue = blue<<1;
	}
}

void RGB_Reset(void){							//复位信号
	GPIO_ResetBits(GPIO_CS);	//设置为低电平
	udelay(1000);								//延时1ms 满足50us的最小持续时间
	
	GPIO_SetBits(GPIO_CS);		//设置为高电平
	udelay(1000);								//延时1ms 满足280us的最小持续时间
}

void lcd_init(void) {
	RGB_IOInit();
	RGB_Reset();
	SendRGB(200, 0, 10);
}