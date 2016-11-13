# Bare Bones

## Introduction

This source provides a complete port of the C Bare Bones tutorial from
http://wiki.osdev.org. I copied and modified the linker script from the D port
as the original didn't work for me and also did the same with the startup code
from the original C port.

The full documentation and build instructions for this project can be found
[here](http://wiki.osdev.org/Ada_Bare_bones).

Once you have cloned this repository, you need to set up the links to the
RTS inside ```rts/boards/i386/adainclude/``` to point to those in ```rts/src/``` as follows:

```bash
for f in "ada.ads" "a-unccon.ads" "a-uncdea.ads" "gnat.ads" "g-souinf.ads" \
"interfac.ads" "s-atacco.adb" "s-atacco.ads" "s-maccod.ads" "s-stoele.adb" \
"s-stoele.ads"
do
ln -s `pwd`/rts/src/$f `pwd`/rts/boards/i386/adainclude/$f
done
```

## Prerequisites

To test using make QEMU, you will need GRUB 2 installed for the grub2-mkrescue (GRUB 2 should be installed if you're on
a modern distribution) command. This command also requires xorriso - which you will have to install separately.

### Debian

```bash
$ sudo apt-get install qemu xorriso
```

### Gentoo

```bash
$ emerge -av libisoburn
```

### GRUB

```bash
$ git clone git://git.savannah.gnu.org/grub.git
$ cd grub
$ ./autogen.sh
$ mkdir ../other/build-grub && cd ../other/build-grub
$ ../grub/configure --prefix=`pwd`/../../gen/grub --target=i586-elf
$ make -j4
$ make install
```

## Booting the kernel

### PC (x86)

```bash
$ make qemu
```

This will boot qemu and stop at the GRUB command prompt, then type the following:

```bash
multiboot /boot/bare_bones-i586.elf
boot
```

## Bugs

None at present.

## Who did this?

Luke A. Guest

## Licence

As advised in the forum sticky on osdev.org, the code here is released under the
[CC0 license](http://creativecommons.org/publicdomain/zero/1.0/) placing this work under public domain with no
copyright.
