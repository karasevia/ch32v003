##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [3.18.0-B7] date: [Sat Jan 14 13:30:28 ICT 2023]
##########################################################################################################################

# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

######################################
# target
######################################
TARGET = template


######################################
# building variables
######################################
# debug build?
DEBUG = 0
# optimization
OPT = -Os


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES =  \
src/main.c \
src/system_ch32v00x.c \
library/Debug/debug.c \
library/Peripheral/src/ch32v00x_adc.c \
library/Peripheral/src/ch32v00x_dbgmcu.c \
library/Peripheral/src/ch32v00x_dma.c \
library/Peripheral/src/ch32v00x_exti.c \
library/Peripheral/src/ch32v00x_flash.c \
library/Peripheral/src/ch32v00x_gpio.c \
library/Peripheral/src/ch32v00x_i2c.c \
library/Peripheral/src/ch32v00x_iwdg.c \
library/Peripheral/src/ch32v00x_misc.c \
library/Peripheral/src/ch32v00x_opa.c \
library/Peripheral/src/ch32v00x_pwr.c \
library/Peripheral/src/ch32v00x_rcc.c \
library/Peripheral/src/ch32v00x_spi.c \
library/Peripheral/src/ch32v00x_tim.c \
library/Peripheral/src/ch32v00x_usart.c \
library/Peripheral/src/ch32v00x_wwdg.c \
library/Peripheral/src/Arduino.c \
library/Peripheral/src/I2C.c \
library/Peripheral/src/ik_ina219.c \
library/Peripheral/src/neopixels.c \
library/Peripheral/src/oled.c \
library/Peripheral/src/SPI.c \
library/Peripheral/src/st7302.c

# ASM sources
ASM_SOURCES =  \
startup_ch32v00x.s

##########################################################################################################################
# modified by Ngo Hung Cuong
ifeq ($(OS),Windows_NT)
# Windows
	GCC_PATH = C:/xPacks/riscv-embedded-gcc-12/bin
	OCD_PATH = C:/MounRiver/MounRiver_Studio/toolchain/OpenOCD/bin
else
# Linux
	GCC_PATH = "/home/ngohungcuong/Downloads/MRS_Toolchain_Linux_x64_V1.60/RISC-V Embedded GCC/bin"
	OCD_PATH = "/home/ngohungcuong/Downloads/MRS_Toolchain_Linux_x64_V1.60/OpenOCD/bin"
endif

ifdef OCD_PATH
	ifeq ($(OS), Windows_NT)
		OCD = "$(OCD_PATH)/openocd"
	else
		OCD = $(OCD_PATH)/openocd
	endif
else
	OCD = openocd
endif
##########################################################################################################################

#######################################
# binaries
#######################################
PREFIX = riscv-none-elf-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
	ifeq ($(OS), Windows_NT)
		CC = "$(GCC_PATH)/$(PREFIX)gcc"
		AS = "$(GCC_PATH)/$(PREFIX)gcc" -x assembler-with-cpp
		CP = "$(GCC_PATH)/$(PREFIX)objcopy"
		SZ = "$(GCC_PATH)/$(PREFIX)size"
	else
		CC = $(GCC_PATH)/$(PREFIX)gcc
		AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
		CP = $(GCC_PATH)/$(PREFIX)objcopy
		SZ = $(GCC_PATH)/$(PREFIX)size
	endif
else
	CC = $(PREFIX)gcc
	AS = $(PREFIX)gcc -x assembler-with-cpp
	CP = $(PREFIX)objcopy
	SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -march=rv32ecxw

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi

# mcu
MCU = $(CPU) -mabi=ilp32e -msmall-data-limit=0 -msave-restore -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized

#riscv-none-embed-gcc   -c -o "$@" "$<"
# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  

# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-I. \
-Isrc \
-Ilibrary/Core \
-Ilibrary/Debug \
-Ilibrary/Peripheral/inc

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT)

CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT)

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF "$(@:%.o=%.d)"

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = Link.ld

# libraries
#LIBS = -lc -lm -lnosys 
LIBS = 
LIBDIR = 
LDFLAGS = $(MCU) -g --specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -lprintf -nostartfiles -Xlinker --gc-sections -Wl,-Map=$(BUILD_DIR)/$(TARGET).map --specs=nosys.specs $(OPT)

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -g -std=gnu99 -MT "$(@)" -c "$<" -o "$@"

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) -g -MT "$(@)" -c "$<" -o "$@"

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# flash
#######################################
flash: $(BUILD_DIR)/$(TARGET).hex
	$(OCD) -f wch-riscv.cfg  -c init -c halt  -c "program $(BUILD_DIR)/$(TARGET).hex" -c "verify_image $(BUILD_DIR)/$(TARGET).hex" -c wlink_reset_resume -c exit

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***