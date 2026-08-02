CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

CFLAGS = -mcpu=cortex-m3 -mthumb -nostdlib -O0
LDFLAGS = -T stm32f103c8t6.ld

all: main.bin

main.elf: main.c startup.c
	$(CC) $(CFLAGS) $(LDFLAGS) main.c startup.c -o main.elf

main.bin: main.elf
	$(OBJCOPY) -O binary main.elf main.bin

flash: main.bin
	st-flash write main.bin 0x08000000

clean:
	rm -f *.elf *.bin

erase:
	st-flash erase
