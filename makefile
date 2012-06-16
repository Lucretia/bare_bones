#                              -*- Mode: GNUmakefile -*-
#  Filename        : makefile
#  Description     : Makefile for the kernel, which utilises the GPR.
#  Author          : Luke A. Guest
#  Created On      : Thu Jun 14 11:59:53 2012
#  Licence         : See LICENCE in the root directory.
ARCH		=	i386
RTS_DIR		=	`pwd`/rts/boards/$(ARCH)

ifeq ($(ARCH),i386)
GNATMAKE	=	gnatmake
AS		=	as
ASFLAGS		=	--32 -march=i386 -g

OBJS		=	obj/startup.o obj/multiboot.o obj/console.o
BOARD		=	pc

OUTDIR		=	disk/boot/

.PHONY: obj/multiboot.o obj/console.o

endif

all: $(OUTDIR)bare_bones

$(OUTDIR)bare_bones: $(OBJS) src/bare_bones.adb
	$(GNATMAKE) --RTS=$(RTS_DIR) -XBoard=$(BOARD) -Pbare_bones.gpr

obj/startup.o: src/$(BOARD)/startup.s
	$(AS) $(ASFLAGS) src/$(BOARD)/startup.s -o obj/startup.o

# This will start qemu, but then stop the emulation, press ctrl+alt+shift+f2
# to get to the console, press c to continue once GDB has been configured. For
# more on QEMU's monitor, see http://en.wikibooks.org/wiki/QEMU/Monitor
#
# To debug using GDB:
# ./gdb-qemu.sh
qemud: boot.iso
	qemu -S -s -cdrom boot.iso

qemu: boot.iso
	qemu -cdrom boot.iso

boot.iso: $(OUTDIR)bare_bones
	grub-mkrescue -o boot.iso disk/

.PHONY: clean

clean:
	-rm obj/* *~ bare_bones bare_bones.bin

