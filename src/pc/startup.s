.global startup                         # Make the startup entry point symbol visible to the linker

                                        # Setup the Multiboot header (see GRUB docs for details)
.set ALIGN,    1<<0                     # Align loaded modules on page boundaries
.set MEMINFO,  1<<1                     # Provide memory map
.set FLAGS,    ALIGN | MEMINFO          # This is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002               # 'magic number' lets your bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS)         # Checksum required

header:                                 # Must be in the first 8kb of the kernel file
.align 4, 0x90                          # Pad the location counter (in the current subsection) to a 4-byte (DWORD) storage boundary.
                                        # The way alignment is specified can vary with host system architecture.
.long MAGIC
.long FLAGS
.long CHECKSUM

                                        # Reserve initial kernel stack space
.set STACKSIZE, 0x4000                  # 0x4000 being 16k.
.lcomm stack, STACKSIZE                 # Reserve 16k stack on a doubleword (32bit) boundary
.comm  mbd, 4                           # Declare common symbol mbd, allocate it 4-bytes (DWORD) of uninitialized memory.
.comm  magic, 4                         # Declare common symbol magic, allocate it 4-bytes (DWORD) of uninitialized memory.

startup:
    movl  $(stack + STACKSIZE), %esp    # Set up the stack

                                        # The following saves the contents of the registers as they will likely be
                                        # overwritten because main is not our actual entry point, Bare_Bones is. We will
                                        # use these 2 symbols inside Bare_Bones.

    movl  %eax, magic                   # EAX indicates to the OS that it was loaded by a Multiboot-compliant boot loader
    movl  %ebx, mbd                     # EBX must contain the physical address of the Multiboot information structure

    call  main                          # Call main (created by gnatbind)

    cli                                 # Disable interrupts. then intentionally hang the system.
                                        # CLI only affects the interrupt flag for the processor on which it is executed.

hang:
    hlt                                 # Because the HLT instruction halts until an interrupt occurs, the combination of a
                                        # CLI followed by a HLT is used to intentionally hang the computer if the kernel returns.
                                        # HLT is in a loop just in case a single HLT instruction fails to execute for some reason,
                                        # (such as in the case of an NMI).
    jmp   hang
