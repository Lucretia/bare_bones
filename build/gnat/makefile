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
MODE		=	debug
#MODE		=	release

# The next option is for when there is a bug box and we need to build with
# extra options so we can file a bug.
#BUG		=	bug
BUG		=	clean

###############################################################################
# Everything after here should not be touched.
###############################################################################
CWD		=	$(shell pwd)

TOP_DIR		=	../../
SRC_DIR		=	$(TOP_DIR)/src
GEN_DIR		=	$(CWD)/gen
BUILD_DIR	=	$(GEN_DIR)/$(BOARD)/$(MODE)
OBJ_DIR		=	$(BUILD_DIR)/.obj

GNATMAKE	=	gnatmake
AS		=	as

###############################################################################
# Platform specific.
###############################################################################
ifeq ($(BOARD),pc)
ARCH		=	i586
TOOL_PREFIX	=	$(ARCH)-elf-

AS_FLAGS	=	--32 -march=$(ARCH)

AS_OBJS		=	$(OBJ_DIR)/startup.o
#ADA_OBJS	=	obj/multiboot.o

IMAGE		=	$(BUILD_DIR)/boot.iso
QEMU		=	qemu-system-i386
QEMU_FLAGS	=	-s -cdrom $(IMAGE)
QEMUD_FLAGS	=	-S $(QEMU_FLAGS)

DISK_DIR	=	$(BUILD_DIR)/disk
OUT_DIR		=	$(DISK_DIR)/boot

GRUB_DIR	=	$(GEN_DIR)/grub
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
#.PHONY: $(ADA_OBJS)

RTS_VER			=	$(shell gcc -dumpversion | cut -f1,2 -d.)
RTS_SRC_DIR		=	$(CWD)/rts/$(RTS_VER)/adainclude
RTS_ARCH_SRC_DIR	=	$(RTS_SRC_DIR)/arch/$(ARCH)
RTS_COMMON_SRC_DIR	=	$(CWD)/rts/common/adainclude
RTS_SRCS		=	ada.ads \
				a-unccon.ads \
				a-uncdea.ads \
				gnat.ads \
				g-souinf.ads \
				interfac.ads \
				s-addima.adb s-addima.ads \
				s-atacco.adb s-atacco.ads \
				s-imgint.adb s-imgint.ads \
				s-maccod.ads \
				s-stoele.ads s-stoele.adb

RTS_ARCH_SRCS		=	system.ads
RTS_COMMON_SRCS		=	last_chance_handler.adb last_chance_handler.ads \
				memory.ads memory.adb \
				s-secsta.ads s-secsta.adb
RTS_DIR			=	$(GEN_DIR)/rts/$(ARCH)

###############################################################################
# Debug specific flags.
###############################################################################
ifeq ($(BUILD),debug)
AS_FLAGS	+=	-g
else
ifeq ($(BUILD),release)
endif
endif

# The final output filename.
TARGET		=	$(OUT_DIR)/bare_bones-$(ARCH).elf

###############################################################################
# Rules.
###############################################################################
.PHONY: kernel obj-dir setup-rts $(AS_OBJS)

all: kernel

kernel: $(TARGET)

$(TARGET): $(AS_OBJS) #src/bare_bones.adb
	$(TOOL_PREFIX)$(GNATMAKE) -p --RTS=$(RTS_DIR) -XCWD=$(CWD) -XBoard=$(BOARD) -XMode=$(MODE) -XBug=$(BUG) \
		-Pbare_bones.gpr

$(OBJ_DIR)/startup.o: obj-dir $(SRC_DIR)/$(BOARD)/startup.s
	$(TOOL_PREFIX)$(AS) $(AS_FLAGS) $(SRC_DIR)/$(BOARD)/startup.s -o $(OBJ_DIR)/startup.o

obj-dir:
	-mkdir -p $(OBJ_DIR)

rts: setup-rts
	$(TOOL_PREFIX)$(GNATMAKE) -p --RTS=$(RTS_DIR) -XCWD=$(CWD) -XBoard=$(BOARD) -XMode=$(MODE) -XBug=$(BUG) \
		-Prts.gpr

setup-rts:
	-mkdir -p $(RTS_DIR)/adalib &> /dev/null
	-mkdir -p $(RTS_DIR)/adainclude &> /dev/null
	-$(foreach f, $(RTS_SRCS), ln -s $(RTS_SRC_DIR)/$(f) $(RTS_DIR)/adainclude/$(f) &> /dev/null;)
	-$(foreach f, $(RTS_ARCH_SRCS), ln -s $(RTS_ARCH_SRC_DIR)/$(f) $(RTS_DIR)/adainclude/$(f) &> /dev/null;)
	-$(foreach f, $(RTS_COMMON_SRCS), ln -s $(RTS_COMMON_SRC_DIR)/$(f) $(RTS_DIR)/adainclude/$(f) &> /dev/null;)

# This will start qemu, but then stop the emulation, press ctrl+alt+shift+f2
# to get to the console, press c to continue once GDB has been configured. For
# more on QEMU's monitor, see http://en.wikibooks.org/wiki/QEMU/Monitor
#
# To debug using GDB:
# ./gdb-qemu.sh
qemud: image
	$(QEMU) $(QEMUD_FLAGS)

qemu: image
	$(QEMU) $(QEMU_FLAGS)

# The PC boot.iso image that qemu uses.
.phony: image image-$(ARCH) grub-cfg

image: kernel grub-cfg image-$(ARCH)

image-$(ARCH): $(IMAGE)

# PC (x86) boot disk image for qemu.
$(IMAGE): $(TARGET)
	$(GRUB_DIR)/bin/grub-mkrescue -v -o $(IMAGE) $(DISK_DIR) 2> /dev/null

grub-cfg:
	-mkdir $(OUT_DIR)/grub
	-cp grub-pc.cfg $(OUT_DIR)/grub/grub.cfg

.PHONY: clean clean-rts clean-image

clean: clean-rts clean-image

clean-rts:
	-rm -rf $(GEN_DIR)/rts

clean-image:
	-rm -rf gen/$(BOARD)


