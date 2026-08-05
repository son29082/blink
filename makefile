CC = arm-none-eabi-gcc
SIZE = arm-none-eabi-size

# Directories
SRC_DIR = src
INC_DIR = inc
BUILD_DIR = build

CFLAGS = -c -mcpu=cortex-m3 -mthumb  -O0 -g -Wall -Wextra -std=gnu11 -I$(INC_DIR)
LDFLAGS = -mcpu=cortex-m3 -mthumb -T stm32f103c8t6.ld -nostdlib -Wl,-Map=$(BUILD_DIR)/main.map

# Source and object files
SRCS = $(wildcard $(SRC_DIR)/*.c)
#patsubst (pattern, replacement, text) replaces the pattern in text with the replacement
OBJS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))

TARGET = $(BUILD_DIR)/main.elf

all: $(TARGET)

# Compile source files into object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

# Link the object files into the final executable
$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CC) $(LDFLAGS) $^ -o $@
	$(SIZE) $@

# Create the build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

flash: $(TARGET)
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg -c "program $(TARGET) verify reset exit"

clean:
	rm -rf $(BUILD_DIR)

erase:
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg -c "init" -c "reset halt" -c "flash erase_sector 0 0 last" -c "exit"

.PHONY: all clean flash erase