.global startup                         # Make entry point visible to linker

                                        # Set up Multiboot header (see GRUB docs for details)
.set ALIGN,    1<<0                     # Align loaded modules on page boundaries
.set MEMINFO,  1<<1                     # Provide memory map
.set FLAGS,    ALIGN | MEMINFO          # This is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002               # 'magic number' lets bootloader find header
.set CHECKSUM, -(MAGIC + FLAGS)         # Checksum required

header:
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

                                        # Reserve initial kernel stack space
.set STACKSIZE, 0x4000                  # 0x4000 being 16k.
.lcomm stack, STACKSIZE                 # Reserve 16k stack on a doubleword boundary
.comm  mbd, 4                           # We will use this in Bare_Bones
.comm  magic, 4                         # We will use this in Bare_Bones

startup:
    movl  $(stack + STACKSIZE), %esp    # Set up the stack

                                        # The following saves the contents of the registers as they will likely be
                                        # overwritten as main is not our actual entry point, Bare_Bones is. We will
                                        # use these 2 variables inside Bare_Bones.

    movl  %eax, magic                   # Multiboot magic number
    movl  %ebx, mbd                     # Multiboot data structure

    call  main                          # Call main created by gnatbind

    cli                                 # In a real kernel, execution should never get to this point.


hang:
    hlt                                 # Halt machine should kernel return
    jmp   hang
