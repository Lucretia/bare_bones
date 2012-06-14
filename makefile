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
ASFLAGS		=	--32 -march=i386

OBJS		=	obj/startup.o obj/multiboot.o obj/console.o
BOARD		=	pc

.PHONY: obj/multiboot.o obj/console.o

endif

all: bare_bones

bare_bones: $(OBJS) src/bare_bones.adb
	$(GNATMAKE) --RTS=$(RTS_DIR) -XBoard=$(BOARD) -Pbare_bones.gpr

obj/startup.o: src/$(BOARD)/startup.s
	$(AS) $(ASFLAGS) src/$(BOARD)/startup.s -o obj/startup.o

.PHONY: clean

clean:
	-rm obj/* *~ bare_bones
