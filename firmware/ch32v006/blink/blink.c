#include "ch32fun.h"

#define LED_BUILTIN PC3

int main(void)
{
	SystemInit();
	funGpioInitAll();
	funPinMode(LED_BUILTIN, GPIO_Speed_10MHz | GPIO_CNF_OUT_PP);

	while (1)
	{
		funDigitalWrite(LED_BUILTIN, FUN_HIGH);
		Delay_Ms(250);
		funDigitalWrite(LED_BUILTIN, FUN_LOW);
		Delay_Ms(250);
	}
}
