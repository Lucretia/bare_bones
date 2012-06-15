.global startup                         # making entry point visible to linker
 
# setting up the Multiboot header - see GRUB docs for details
.set ALIGN,    1<<0                     # align loaded modules on page boundaries
.set MEMINFO,  1<<1                     # provide memory map
.set FLAGS,    ALIGN | MEMINFO          # this is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002               # 'magic number' lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS)         # checksum required

header:	
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM
 
# reserve initial kernel stack space
.set STACKSIZE, 0x4000                  # that is, 16k.
.lcomm stack, STACKSIZE                 # reserve 16k stack on a doubleword boundary
.comm  mbd, 4                           # we will use this in Bare_Bones
.comm  magic, 4                         # we will use this in Bare_Bones
 
startup:
    movl  $(stack + STACKSIZE), %esp    # set up the stack

# The following saves the contents of the registers as they will likely be
# overwritten as main is not our actual entry point, Bare_Bones is. We will
# use these 2 variables inside Bare_Bones.
	
    movl  %eax, magic                   # Multiboot magic number
    movl  %ebx, mbd                     # Multiboot data structure
 
    call  main                          # call main created by gnatbind

# In a real kernel, execution should never get to this point.
	
    cli
hang:
    hlt                                 # halt machine should kernel return
    jmp   hang
