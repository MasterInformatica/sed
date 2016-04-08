################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := cs-rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include commonUart/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
b_uart1.hex \

SECONDARY_LIST += \
b_uart1.lst \

SECONDARY_SIZE += \
b_uart1.siz \


# All Target
all: b_uart1.elf secondary-outputs

# Tool invocations
b_uart1.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM Sourcery Windows GCC C Linker'
	arm-none-eabi-gcc -T"C:\hlocal\EclipseARMwspace\b_uart1\commonUart\ram_ice.ld" -nostartfiles -L"C:\hlocal\EclipseARMwspace\b_uart1\commonUart" -LC:\software\electronica\ARM\EclipseARM\eclipse\/../sourcery-g++-litle-arm-2011.03/lib/gcc/arm-none-eabi/4.5.2 -L"C:\software\electronica\ARM\EclipseARM\eclipse\/../sourcery-g++-litle-arm-2011.03/arm-none-eabi/lib" -Wl,-Map,b_uart1.map -mcpu=arm7tdmi -g3 -gdwarf-2 -o "b_uart1.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

b_uart1.hex: b_uart1.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Create Flash Image'
	arm-none-eabi-objcopy -O binary b_uart1.elf  "b_uart1.hex"
	@echo 'Finished building: $@'
	@echo ' '

b_uart1.lst: b_uart1.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Create Listing'
	arm-none-eabi-objdump -h -S b_uart1.elf > "b_uart1.lst"
	@echo 'Finished building: $@'
	@echo ' '

b_uart1.siz: b_uart1.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Print Size'
	arm-none-eabi-size  --format=berkeley b_uart1.elf
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(SECONDARY_SIZE)$(OBJS)$(C_DEPS)$(ASM_DEPS)$(SECONDARY_FLASH)$(EXECUTABLES)$(SECONDARY_LIST)$(S_UPPER_DEPS) b_uart1.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
