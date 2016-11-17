# Bare Bones

## Introduction

This source provides a complete port of the C Bare Bones tutorial from http://wiki.osdev.org. I copied and modified the
linker script from the D port as the original didn't work for me and also did the same with the startup code from the
original C port.

The full documentation and build instructions for this project can be found
[here](http://wiki.osdev.org/Ada_Bare_bones).

**Note** I am currently in the process of updating this repository.

```bash
$ git clone https://github.com/Lucretia/bare_bones.git
$ cd bare_bones/build/gnat
```

## Prerequisites

To test using make QEMU, you will need GRUB 2 installed for the grub2-mkrescue (GRUB 2 should be installed if you're on
a modern distribution) command. This command also requires xorriso - which you will have to install separately.

### Debian

```bash
$ sudo apt-get install qemu xorriso
```

### Gentoo

I have sudo installed on my machine:

```bash
$ sudo emerge -av libisoburn
```

I also used my [Free Ada](https://github.com/Lucretia/free-ada) build scripts to build useable bare metal cross
compilers.

## x86

### GRUB

```bash
$ mkdir -p others/{build,source}
$ cd others/source
$ git clone git://git.savannah.gnu.org/grub.git
$ cd grub
$ ./autogen.sh
$ mkdir ../../build/grub && cd ../../build/grub
$ ../../source/grub/configure --prefix=`pwd`/../../../gen/pc/grub --target=i586-elf
$ make -j4
$ make install
```

## Booting the kernel

The ```qemu``` target will also make the kernel image and boot.iso.

```bash
$ make rts
$ make qemu
```

## Debugging the kernel

From the ```build/gnat``` directory, in one shell, type the following:

```bash
$ make qemud
```

then in another shell, type:

```bash
$ ./gdb-qemu.sh
```

Boot the kernel within QEMU and GDB will break into the kernel at the main program. e.g.:

```bash
$ ./gdb-qemu.sh
GNU gdb (Gentoo 7.10.1 vanilla) 7.10.1
Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://bugs.gentoo.org/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from gen/pc/debug/disk/boot/bare_bones-i586.elf...done.
0x0000fff0 in ?? ()
Breakpoint 1 at 0x100c20: file /home/laguest/src/mine/bare_bones/src/bare_bones.adb, line 15.


Breakpoint 1, bare_bones () at /home/laguest/src/mine/bare_bones/src/bare_bones.adb:15
15	procedure Bare_Bones is
(gdb)
(gdb) bt
#0  bare_bones () at /home/laguest/src/mine/bare_bones/src/bare_bones.adb:15
(gdb) list
10	--  with System.Address_To_Access_Conversions;
11	--  with Ada.Unchecked_Conversion;
12
13	use type Multiboot.Magic_Values;
14
15	procedure Bare_Bones is
16	   Line : Screen_Height_Range := Screen_Height_Range'First;
17	begin
18	   null;
19	   Clear;
(gdb) q
A debugging session is active.

	Inferior 1 [Remote target] will be detached.

Quit anyway? (y or n) y
Detaching from program: /home/laguest/src/mine/bare_bones/build/gnat/gen/pc/debug/disk/boot/bare_bones-i586.elf, Remote target
Ending remote debugging.
```

## Bugs

None at present.

## Who did this?

Luke A. Guest

## Future

I intend to get this very basic kernel building on a number of boards that I have lying around:

* Raspberry Pi (original version)
* Pandaboard
* Arduino Uno
* ChipKit Uno32
* STM32F4-Discovery
* MSP430 Launchpad

This will show that Ada 2012 can be built and booted directly on top of any type type of board from small limited
devices and upwards.

### Ada features to add

* Port to Ada 2012.
* Secondary stack so that indefinite types can be returned easily.
* Move runtime building to [Free Ada](https://github.com/Lucretia/free-ada).

## Licence

As advised in the forum sticky on osdev.org, the code here is released under the
[CC0 license](http://creativecommons.org/publicdomain/zero/1.0/) placing this work under public domain with no
copyright.
