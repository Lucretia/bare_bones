--                              -*- Mode: Ada -*-
--  Filename        : multiboot.ads
--  Description     : Provides access to the multiboot information from GRUB
--                    Legacy and GRUB 2.
--  Author          : Luke A. Guest
--  Created On      : Fri Jun 15 14:43:04 2012
--  Licence         : See LICENCE in the root directory.
with System;
with Interfaces; use Interfaces;

package Multiboot is
   subtype Magics is Unsigned_32;

   Magic_Value : constant Magics := 16#1BAD_B002#;

   ----------------------------------------------------------------------------
   --  Multiboot header
   ----------------------------------------------------------------------------
   type Boot_Flags is
      record
         Align_Modules       : Boolean; --  Bit 0
         Provide_Memory_Info : Boolean; --  Bit 1
         Provide_Video_Info  : Boolean; --  Bit 2
         Aout_Kernel         : Boolean; --  Bit 16
      end record;

   for Boot_Flags use
      record
         Align_Modules       at 0 range  0 ..  0;
         Provide_Memory_Info at 0 range  1 ..  1;
         Provide_Video_Info  at 0 range  2 ..  2;
         Aout_Kernel         at 0 range 16 .. 16;
      end record;

   for Boot_Flags'Size use 32;

   type Memory_Info (Present : Boolean) is
      record
         case Present is
            when True =>
               Header_Addr   : Unsigned_32;
               Load_Addr     : Unsigned_32;
               Load_End_Addr : Unsigned_32;
               BSS_End_Addr  : Unsigned_32;
               Entry_Addr    : Unsigned_32;
            when False =>
               null;
         end case;
      end record;

   pragma Unchecked_Unions (Memory_Info);

   type Video_Info (Present : Boolean) is
      record
         case Present is
            when True =>
               Mode_Type : Unsigned_32;
               Width     : Unsigned_32;
               Height    : Unsigned_32;
               Depth     : Unsigned_32;
            when False =>
               null;
         end case;
      end record;

   pragma Unchecked_Unions (Video_Info);

   --  This header isn't really required to be accessed from the kernel,
   --  it's here more for completeness of the multiboot spec.
   type Header is
      record
         Magic    : Magics;  --  Must equal Magic_Value, above.
         Flags    : Boot_Flags;
         Checksum : Unsigned_32;
         Memory   : Memory_Info (Flags.Provide_Memory_Info);
         Video    : Video_Info  (Flags.Aout_Kernel);
      end record;

   --  This is defined in startup.s before the kernel entry point.
   MB_Header : Header;

   pragma Import (Asm, MB_Header, "mb_header");

   --  Header_Address : System.Address;
   --  pragma Import (Assembly, Header_Address, "mb_header");

   --  MB_Header : Header;

   --  for MB_Header'Address use Header_Address;
   --  pragma Volatile (MB_Header);

   ----------------------------------------------------------------------------
   --  Multiboot information.
   ----------------------------------------------------------------------------
   type Memory_Info is
      record
         Upper : Unsigned_32;
         Lower : Unsigned_32;
      end record;

   pragma Convention (C, Memory_Info);

   type Modules_Info is
      record
         Count : Unsigned_32;
         Addr  : Unsigned_32;
      end record;

   pragma Convention (C, Modules_Info);

   type Memory_Map_Info is
      record
         Length : Unsigned_32;
         Addr   : Unsigned_32;
      end record;

   pragma Convention (C, Memory_Map_Info);

   type Drives_Info is
      record
         Length : Unsigned_32;
         Addr   : Unsigned_32;
      end record;

   pragma Convention (C, Drives_Info);

   type VBE_Info is
      record
         Control_Info  : Unsigned_32;
         Mode_Info     : Unsigned_32;
         Mode          : Unsigned_32;
         Interface_Seg : Unsigned_32;
         Interface_Off : Unsigned_32;
         Interface_Len : Unsigned_32;
      end record;

   pragma Convention (C, VBE_Info);

   type Symbols_Array is array (1 .. 4) of Unsigned_32;

   pragma Convention (C, Symbols_Array);

   type MB_Info is
      record
         Flags             : Unsigned_32;
         Memory            : Memory_Info;
         --  Mem_Upper         : Unsigned_32;
         --  Mem_Lower         : Unsigned_32;
         Boot_Device       : Unsigned_32;
         Cmd_Line          : Unsigned_32;
         Modules           : Modules_Info;
         --  Mods_Count        : Unsigned_32;
         --  Mods_Addr         : Unsigned_32;
         --  Syms1             : Unsigned_32;
         --  Syms2             : Unsigned_32;
         --  Syms3             : Unsigned_32;
         --  Syms4             : Unsigned_32;
	 Symbols           : Symbols_Array;
         Memory_Map        : Memory_Map_Info;
         --  MMap_Length       : Unsigned_32;
         --  MMap_Addr         : Unsigned_32;
         Drives            : Drives_Info;
         --  Drives_Length     : Unsigned_32;
         --  Drives_Addr       : Unsigned_32;
         Config_Table      : Unsigned_32;
         Boot_Loader_Name  : Unsigned_32;
         APM_Table         : Unsigned_32;
         --  VBE_Control_Info  : Unsigned_32;
         --  VBE_Mode_Info     : Unsigned_32;
         --  VBE_Mode          : Unsigned_32;
         --  VBE_Interface_Seg : Unsigned_32;
         --  VBE_Interface_Off : Unsigned_32;
         --  VBE_Interface_Len : Unsigned_32;
         VBE               : VBE_Info;
      end record;
   
   pragma Convention (C, MB_Info);

   --  We need to import the "mbd" symbol...
   Info_Address : System.Address;

   pragma Import (Assembly, Info_Address, "mbd");

   Info : MB_Info;

   -- So we can use the address stored at that location.
   for Info'Address use Info_Address;

   pragma Volatile (MB_Info);

   ----------------------------------------------------------------------------
   --  Magic number.
   ----------------------------------------------------------------------------

   --  We need to import the "magic" symbol...
   Magic_Address : System.Address;

   pragma Import (Assembly, Magic_Address, "magic");

   Magic : Magics;  --  This should also match Magic_Value, above.

   -- So we can use the address stored at that location.
   for Magic'Address use Magic_Address;

   pragma Volatile (Magic);
end Multiboot;
