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

   type MB_Info;

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

   ----------------------------------------------------------------------------
   --  Boot device information.
   ----------------------------------------------------------------------------
   type Boot_Devices is
      record
         Drive       : Unsigned_8;
         Partition_1 : Unsigned_8;
         Partition_2 : Unsigned_8;
         Partition_3 : Unsigned_8;
      end record;

   for Boot_Devices use
      record
         Drive       at 0 range 0 .. 7;
         Partition_1 at 1 range 0 .. 7;
         Partition_2 at 2 range 0 .. 7;
         Partition_3 at 3 range 0 .. 7;
      end record;

   for Boot_Devices'Size use 32;

   Invalid_Partition : constant Unsigned_8 := 16#ff#;

   ----------------------------------------------------------------------------
   --  Memory information.
   --  These values are in KB
   ----------------------------------------------------------------------------
   type Memory_Info is
      record
         Upper : Unsigned_32;
         Lower : Unsigned_32;
      end record;

   pragma Convention (C, Memory_Info);

   ----------------------------------------------------------------------------
   --  Loadable module information.
   ----------------------------------------------------------------------------
   type Modules is
      record
         First    : System.Address; --  Address of module start .. end.
         Last     : System.Address;
         Data     : System.Address; --  NULL terminated C string.
         Reserved : Unsigned_32;    --  Should be 0.
      end record;

   type Modules_Array is array (Natural range <>) of Modules;

   pragma Convention (C, Modules_Array);

   --  type Modules_Array_Access is access Modules_Array;

   --  pragma Convention (C, Modules_Array_Access);

   type Modules_Info is
      record
         Count : Unsigned_32;
         First : System.Address;
      end record;

   ----------------------------------------------------------------------------
   --  Symbols information.
   ----------------------------------------------------------------------------
   pragma Convention (C, Modules_Info);

   type Symbols_Variant is (Aout, ELF);

   function Get_Symbols_Variant return Symbols_Variant;

   ----------------------------------------------------------------------------
   --  a.out symbols or ELF sections
   --
   --  TODO: a.out only - This can be implemented by anyone who wants to use
   --  aout.
   --
   --  From what I can tell from the spec, Addr points to a size followed by
   --  an array of a.out nlist structures. This is then followed by a size
   --  of a set of strings, then the sizeof (unsigned), then the strings
   --  (NULL terminated).
   --
   --  Table_Size and String_Size are the same as the ones listed above.
   ----------------------------------------------------------------------------
   type Symbols (Variant : Symbols_Variant := ELF) is
      record
         case Variant is
            when Aout =>
               Table_Size  : Unsigned_32;
               String_Size : Unsigned_32;
               Aout_Addr   : System.Address;
               Reserved    : Unsigned_32;     --  Always 0.
            when ELF =>
               Number      : Unsigned_32;
               Size        : Unsigned_32;
               ELF_Addr    : System.Address;
               Shndx       : Unsigned_32;
         end case;
      end record;

   pragma Convention (C, Symbols);
   pragma Unchecked_Union (Symbols);

   ----------------------------------------------------------------------------
   --  Memory map information.
   ----------------------------------------------------------------------------
   type Memory_Type is range Unsigned_32'First .. Unsigned_32'Last;

   for Memory_Type'Size use 32;

   Memory_Available : constant Memory_Type := 1;
   Memory_Reserved  : constant Memory_Type := 2;

   type Memory_Map_Entry is
      record
         Size            : Unsigned_32;
         Base_Address    : Long_Long_Integer;
         Length_In_Bytes : Long_Long_Integer;
         Sort            : Memory_Type;
      end record;

   type Memory_Map_Entry_Access is access Memory_Map_Entry;

   type Memory_Map_Info is
      record
         Length : Unsigned_32;
         Addr   : Unsigned_32;
      end record;

   pragma Convention (C, Memory_Map_Info);

   ----------------------------------------------------------------------------
   --  Returns null on failure or if the memory map doesn't exist.
   ----------------------------------------------------------------------------
   function First_Memory_Map_Entry return Memory_Map_Entry_Access;

   ----------------------------------------------------------------------------
   --  Returns null on failure or if we have seen all of the memory map.
   ----------------------------------------------------------------------------
   function Next_Memory_Map_Entry
     (Current : Memory_Map_Entry_Access) return Memory_Map_Entry_Access;

   ----------------------------------------------------------------------------
   --  Drives information.
   --  TODO: Complete
   ----------------------------------------------------------------------------
   type Drives_Info is
      record
         Length : Unsigned_32;
         Addr   : Unsigned_32;
      end record;

   pragma Convention (C, Drives_Info);

   ----------------------------------------------------------------------------
   --  APM table.
   ----------------------------------------------------------------------------
   type APM_Table is
      record
         Version         : Unsigned_16;
         C_Seg           : Unsigned_16;
         Offset          : Unsigned_32;
         C_Seg_16        : Unsigned_16;
         D_Seg           : Unsigned_16;
         Flags           : Unsigned_16;
         C_Seg_Length    : Unsigned_16;
         C_Seg_16_Length : Unsigned_16;
         D_Seg_Length    : Unsigned_16;
      end record;

   pragma Convention (C, APM_Table);

   type APM_Table_Access is access APM_Table;

   function Get_APM_Table return APM_Table_Access;

   ----------------------------------------------------------------------------
   --  Graphics information.
   ----------------------------------------------------------------------------
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

   type MB_Info is
      record
         Flags            : Features;
         Memory           : Memory_Info;
         Boot_Device      : Boot_Devices;
         Cmd_Line         : System.Address;  --  NULL terminated C string.
         Modules          : Modules_Info;
         Syms             : Symbols;
         Memory_Map       : Memory_Map_Info;
         Drives           : Drives_Info;
         Config_Table     : System.Address;  --  TODO: Points to BIOS table.
         Boot_Loader_Name : System.Address;  --  NULL terminated C string.
         APM              : System.Address;
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
