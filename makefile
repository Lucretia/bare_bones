#                              -*- Mode: GNUmakefile -*-
#  Filename        : makefile
#  Description     : Makefile for the kernel, which utilises the GPR.
#  Author          : Luke A. Guest
#  Created On      : Thu Jun 14 11:59:53 2012
#  Licence         : See LICENCE in the root directory.

###############################################################################
# These variables should be edited depending on the platform you are building
# for bare bones for.
###############################################################################
BOARD		=	pc
BUILD		=	debug
#BUILD		=	release

# The next option is for when there is a bug box and we need to build with
# extra options so we can file a bug.
#BUG		=	bug
BUG		=	clean

###############################################################################
# Everything after here should not be touched.
###############################################################################
PWD		=	$(shell pwd)

GNATMAKE	=	gnatmake
AS		=	as

###############################################################################
# Platform specific.
###############################################################################
ifeq ($(BOARD),pc)
ARCH		=	i386
TOOL_PREFIX	=

AS_FLAGS	=	--32 -march=$(ARCH)

AS_OBJS		=	obj/startup.o
ADA_OBJS	=	obj/multiboot.o

OUTDIR		=	disk/boot/
else
ifeq ($(BOARD),rpi)
ARCH		=	arm
TOOL_PREFIX	=	arm-none-eabi-

AS_FLAGS	=	-march=armv6zk -mfpu=vfp -mfloat-abi=hard -marm \
			-mcpu=arm1176jzf-s -mtune=arm1176jzf-s
endif
endif

###############################################################################
# Force make not to try to build these objects as gnatmake and the project
# file does this for us.
###############################################################################
.PHONY: $(ADA_OBJS)

OBJS		=	$(AS_OBJS) $(ADA_OBJS)
RTS_DIR		=	$(PWD)/rts/boards/$(ARCH)

###############################################################################
# Debug specific flags.
###############################################################################
ifeq ($(BUILD),debug)
AS_FLAGS	+=	-g
else
ifeq ($(BUILD),release)
endif
endif

###############################################################################
# Rules.
###############################################################################
all: $(OUTDIR)bare_bones

$(OUTDIR)bare_bones: $(OBJS) src/bare_bones.adb
	$(TOOL_PREFIX)$(GNATMAKE) --RTS=$(RTS_DIR) \
		-XBoard=$(BOARD) -XBuild=$(BUILD) -XBug=$(BUG) \
		-Pbare_bones.gpr

obj/startup.o: src/$(BOARD)/startup.s
	$(AS) $(AS_FLAGS) src/$(BOARD)/startup.s -o obj/startup.o

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
	-rm obj/* *~ bare_bones

