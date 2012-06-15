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

# To debug using GDB:
# gdb disk/boot/bare_bones
# target remote :1234
qemu: boot.iso
	qemu -s -cdrom boot.iso

boot.iso: $(OUTDIR)bare_bones
	grub-mkrescue -o boot.iso disk/

.PHONY: clean

clean:
	-rm obj/* *~ bare_bones bare_bones.bin

