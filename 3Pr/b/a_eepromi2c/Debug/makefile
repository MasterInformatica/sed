################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := cs-rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include commonEclipse/subdir.mk
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
a_eepromi2c.hex \

SECONDARY_LIST += \
a_eepromi2c.lst \

SECONDARY_SIZE += \
a_eepromi2c.siz \


# All Target
all: a_eepromi2c.elf secondary-outputs

# Tool invocations
a_eepromi2c.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM Sourcery Windows GCC C Linker'
	arm-none-eabi-gcc -T"C:\hlocal\EclipseARMwspace\a_eepromi2c\commonEclipse\ld_script_iic.ld" -nostartfiles -L"C:\software\electronica\ARM\EclipseARM\eclipse\/../sourcery-g++-lite-arm-2011.03/arm-none-eabi/lib" -L"C:\hlocal\EclipseARMwspace\a_eepromi2c\commonEclipse" -L"/../sourcery-g++-lite-arm-2011.03/lib/gcc/arm-none-eabi/4.5.2" -Wl,-Map,a_eepromi2c.map -mcpu=arm7tdmi -g3 -gdwarf-2 -o "a_eepromi2c.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

a_eepromi2c.hex: a_eepromi2c.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Create Flash Image'
	arm-none-eabi-objcopy -O binary a_eepromi2c.elf  "a_eepromi2c.hex"
	@echo 'Finished building: $@'
	@echo ' '

a_eepromi2c.lst: a_eepromi2c.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Create Listing'
	arm-none-eabi-objdump -h -S a_eepromi2c.elf > "a_eepromi2c.lst"
	@echo 'Finished building: $@'
	@echo ' '

a_eepromi2c.siz: a_eepromi2c.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Print Size'
	arm-none-eabi-size  --format=berkeley a_eepromi2c.elf
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(SECONDARY_SIZE)$(OBJS)$(C_DEPS)$(ASM_DEPS)$(SECONDARY_FLASH)$(EXECUTABLES)$(SECONDARY_LIST)$(S_UPPER_DEPS) a_eepromi2c.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
