# tinyarmc

`tinyarmc` is a lightweight project designed to build and run a simple C program on the STM32F4 Discovery Board. The program toggles the onboard user LED. Additionally, the project leverages renode to simulate the device, enabling you to test the code without requiring physical hardware. This approach not only simplifies testing but also accelerates the development process.

## Setup

this project assumes you are developing on an OSX machine. Instructions may vary for other operating systems.

### install the arm toolchain

```bash
brew install armmbed/formulae/arm-none-eabi-gcc
```

### install renode

```bash
# get https://github.com/renode/renode/releases/download/v1.15.3/renode_1.15.3.dmg
curl -LO https://github.com/renode/renode/releases/download/v1.15.3/renode_1.15.3.dmg
open renode_1.15.3.dmg
# move renode to applications (/Volumes/Renode_1.15.3 1/Renode.app) -> /Applications
# mv '/Volumes/Renode_1.15.3 1/Renode.app' /Applications
```

**NOTE**: you may need to allow the app to run on your machine. go to `System Preferences -> Security & Privacy -> General` and allow the app to run. Also, when you run `Renode.app` for the first time, you may be prompted to install `mono` (a C# runtime that renode uses).

## compile, simulate, and run

### compile the code

build with

```bash
arm-none-eabi-gcc \
    -mcpu=cortex-m4 \
    -mthumb \
    -nostartfiles \
    -Tlinker.ld \
    -ICMSIS/Include \
    -Wl,-Map=lab.map \
    -o main.elf \
    startup.s \
    main.c
```

### simulate running on a stm32f4 discovery board

using `renode`, we can run the code with the following commands. this will simulate the stm32f4 discovery board and run the code.

```bash
./run_renode.expect
# spawn mono /Applications/Renode.app/Contents/MacOS/bin/Renode.exe --console
# 23:30:57.7123 [INFO] Loaded monitor commands from: /Applications/Renode.app/Contents/MacOS/scripts/monitor.py
# Renode, version 1.15.3.19185 (03756cb5-202409171039)
# (monitor) mach create
# 23:30:58.0529 [INFO] System bus created.
# (machine-0) machine LoadPlatformDescription @platforms/boards/stm32F4_discovery-kit.repl
# 23:31:02.5808 [INFO] Reading cache
# 23:31:03.2011 [INFO] sysbus: Loaded SVD: /var/folders/ht/70c4_m411w51qrq__drl8m4r0000gn/T/renode-27105/ea4ec311-13d6-49fc-bea8-c955325e0f5a.tmp. Name: STM32F40x. Description: STM32F40x.
# (machine-0) sysbus LoadELF @./main.elf
# 23:31:05.2717 [INFO] sysbus: Loading segment of 132 bytes length at 0x8000000.
# 23:31:05.2896 [INFO] sysbus: Loading segment of 0 bytes length at 0x8000084.
# (machine-0) start
# Starting emulation...
# 23:31:07.3258 [INFO] cpu: Guessing VectorTableOffset value to be 0x8000000.
# 23:31:07.3394 [INFO] cpu: Setting initial values: PC = 0x8000008, SP = 0x20020000.
# 23:31:07.3411 [WARNING] cpu: Patching PC 0x8000008 for Thumb mode.
# 23:31:07.3449 [INFO] machine-0: Machine started.
# (machine-0) logLevel -1 gpioPortD.UserLED
# (machine-0) 23:31:09.4885 [NOISY] gpioPortD.UserLED: LED state changed to True
# 23:31:10.3163 [NOISY] gpioPortD.UserLED: LED state changed to False
# 23:31:11.2929 [NOISY] gpioPortD.UserLED: LED state changed to True
# 23:31:11.9459 [NOISY] gpioPortD.UserLED: LED state changed to False
# 23:31:12.5358 [NOISY] gpioPortD.UserLED: LED state changed to True
# 23:31:13.0501 [NOISY] gpioPortD.UserLED: LED state changed to False
# 23:31:13.7629 [NOISY] gpioPortD.UserLED: LED state changed to True
```

## Notes

you can start renode with the `--console` flag to run the commands in the console. this is useful for scripting the commands.

below is an example that loads the program and runs it.

```bash
renode --console
mach create
machine LoadPlatformDescription @platforms/boards/stm32F4_discovery-kit.repl
sysbus LoadELF @./main.elf
start
logLevel -1 gpioPortD.UserLED
```

### to explore

- [ ] explore cmsis-nn for neural networks on arm cortex-m devices https://arm-software.github.io/CMSIS-NN/latest/
- [ ] improve the build process with a makefile or cmake
- [ ] understand limitations of renode
- [ ] explore/document more complex examples
