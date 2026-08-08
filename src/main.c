#include <stdint.h>
#include "stm32f1xx.h"


void delay(volatile int count) {
	while (count--);
}

int main(void) {
	RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;
	GPIOC->CRH &= ~ (0xF << 20);
	GPIOC->CRH |= (0X2 << 20);

	while (1) {
		GPIOC->ODR &= ~(1 << 13);
		delay(100000);
		GPIOC->ODR |= (1 << 13);
		delay(100000);
	}
}
