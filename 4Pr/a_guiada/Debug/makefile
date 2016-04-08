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
a_guiada.hex \

SECONDARY_LIST += \
a_guiada.lst \

SECONDARY_SIZE += \
a_guiada.siz \


# All Target
all: a_guiada.elf secondary-outputs

# Tool invocations
a_guiada.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: ARM Sourcery Windows GCC C Linker'
	arm-none-eabi-gcc -T"C:\hlocal\EclipseARMwspace\a_guiada\commonUart\ram_ice.ld" -nostartfiles -L"C:\hlocal\EclipseARMwspace\a_guiada\commonUart" -L"C:\software\electronica\ARM\EclipseARM\eclipse\/../sourcery-g++-lite-arm-2011.03/arm-none-eabi/lib" -L"C:\software\electronica\ARM\EclipseARM\eclipse\/../sourcery-g++-lite-arm-2011.03/lib/gcc/arm-none-eabi/4.5.2" -Wl,-Map,a_guiada.map -mcpu=arm7tdmi -g3 -gdwarf-2 -o "a_guiada.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

a_guiada.hex: a_guiada.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Create Flash Image'
	arm-none-eabi-objcopy -O binary a_guiada.elf  "a_guiada.hex"
	@echo 'Finished building: $@'
	@echo ' '

a_guiada.lst: a_guiada.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Create Listing'
	arm-none-eabi-objdump -h -S a_guiada.elf > "a_guiada.lst"
	@echo 'Finished building: $@'
	@echo ' '

a_guiada.siz: a_guiada.elf
	@echo 'Invoking: ARM Sourcery Windows GNU Print Size'
	arm-none-eabi-size  --format=berkeley a_guiada.elf
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(SECONDARY_SIZE)$(OBJS)$(C_DEPS)$(ASM_DEPS)$(SECONDARY_FLASH)$(EXECUTABLES)$(SECONDARY_LIST)$(S_UPPER_DEPS) a_guiada.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_LIST) $(SECONDARY_SIZE)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
