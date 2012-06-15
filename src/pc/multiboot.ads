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
   subtype Magic_Values is Unsigned_32;

   Magic_Value : constant Magic_Values := 16#2BAD_B002#;

   ----------------------------------------------------------------------------
   --  Multiboot information.
   ----------------------------------------------------------------------------
   type Features is
      record
         Memory               : Boolean; --  Bit 0
         Boot_Device          : Boolean; --  Bit 1
         Command_Line         : Boolean; --  Bit 2
         Modules              : Boolean; --  Bit 3
         Symbol_Table         : Boolean; --  Bit 4 - this is Aout only.
         Section_Header_Table : Boolean; --  Bit 5 - this is ELF only.
         BIOS_Memory_Map      : Boolean; --  Bit 6
         Drives               : Boolean; --  Bit 7
         ROM_Configuration    : Boolean; --  Bit 8
         Boot_Loader          : Boolean; --  Bit 9
         APM_Table            : Boolean; --  Bit 10
         Graphics_Table       : Boolean; --  Bit 11
      end record;

   for Features use
      record
         Memory               at 0 range 0 .. 0;
         Boot_Device          at 0 range 1 .. 1;
         Command_Line         at 0 range 2 .. 2;
         Modules              at 0 range 3 .. 3;
         Symbol_Table         at 0 range 4 .. 4;
         Section_Header_Table at 0 range 5 .. 5;
         BIOS_Memory_Map      at 0 range 6 .. 6;
         Drives               at 0 range 7 .. 7;
         ROM_Configuration    at 1 range 0 .. 0;
         Boot_Loader          at 1 range 1 .. 1;
         APM_Table            at 1 range 2 .. 2;
         Graphics_Table       at 1 range 3 .. 3;
      end record;

   for Features'Size use 32;

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
         Flags            : Features;
         Memory           : Memory_Info;
         Boot_Device      : Unsigned_32;
         Cmd_Line         : Unsigned_32;
         Modules          : Modules_Info;
         Symbols          : Symbols_Array;
         Memory_Map       : Memory_Map_Info;
         Drives           : Drives_Info;
         Config_Table     : Unsigned_32;
         Boot_Loader_Name : Unsigned_32;
         APM_Table        : Unsigned_32;
         VBE              : VBE_Info;
      end record;

   pragma Convention (C, MB_Info);

   --  We need to import the "mbd" symbol...
   Info_Address : constant Unsigned_32;

   pragma Import (Assembly, Info_Address, "mbd");

   Info : constant MB_Info;

   --  So we can use the address stored at that location.
   for Info'Address use System'To_Address (Info_Address);

   pragma Volatile (Info);
   pragma Import (C, Info);

   ----------------------------------------------------------------------------
   --  Magic number.
   ----------------------------------------------------------------------------
   Magic : constant Magic_Values;

   pragma Import (Assembly, Magic, "magic");
end Multiboot;
