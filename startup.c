extern unsigned int _estack;
extern unsigned int _sdata, _edata, _sidata;
extern unsigned int _sbss, _ebss;
extern int main(void);

void Reset_Handler(void)
{
	unsigned int *src = &_sidata;
	unsigned int *dest = &_sdata;

	while (dest < &_edata) *dest++ = *src++;

	dest = &_sbss;
	while (dest < &_ebss) *dest++ = 0;

	main();
	while (1); 
}
__attribute__((section(".vectors")))
void (*const vector_table[])(void)= {
	(void (*)(void))(&_estack),
	Reset_Handler
};
