--                              -*- Mode: Ada -*-
--  Filename        : multiboot.adb
--  Description     : Provides access to the multiboot information from GRUB
--                    Legacy and GRUB 2.
--  Author          : Luke A. Guest
--  Created On      : Sat Jun 16 12:27:30 2012
--  Licence         : See LICENCE in the root directory.
with System.Address_To_Access_Conversions;
with Ada.Unchecked_Conversion;

package body Multiboot is
   --  This forward declaration is to keep GNAT happy.
   function Unsigned_32_To_Entry_Access
     (Addr : Unsigned_32) return Memory_Map_Entry_Access;

   function To_Address is new Ada.Unchecked_Conversion
     (Source => Unsigned_32,
      Target => System.Address);

   function To_Unsigned_32 is new Ada.Unchecked_Conversion
     (Source => System.Address,
      Target => Unsigned_32);

   package Convert is new  System.Address_To_Access_Conversions
     (Object => Memory_Map_Entry_Access);

   function To_Entry_Access is new Ada.Unchecked_Conversion
     (Source => Convert.Object_Pointer,
      Target => Memory_Map_Entry_Access);

   function To_Object_Pointer is new Ada.Unchecked_Conversion
     (Source => Memory_Map_Entry_Access,
      Target => Convert.Object_Pointer);

   function Unsigned_32_To_Entry_Access
     (Addr : Unsigned_32) return Memory_Map_Entry_Access is
   begin
      return To_Entry_Access (Convert.To_Pointer
        (To_Address (Addr)));
   end Unsigned_32_To_Entry_Access;

   function First_Memory_Map_Entry return Memory_Map_Entry_Access is
   begin
      if not Info.Flags.BIOS_Memory_Map then
         return null;
      end if;

      if Info.Memory_Map.Addr = 0 then
         return null;
      end if;

      return Unsigned_32_To_Entry_Access (Info.Memory_Map.Addr);
   end First_Memory_Map_Entry;

   function Next_Memory_Map_Entry
     (Current : Memory_Map_Entry_Access) return Memory_Map_Entry_Access is

      Current_Addr : constant Unsigned_32 := To_Unsigned_32
        (Convert.To_Address
           (To_Object_Pointer (Current)));
      Next_Addr    : Unsigned_32;
   begin
      if  Current_Addr >= Info.Memory_Map.Addr + Info.Memory_Map.Length then
         return null;
      end if;

      Next_Addr := Current_Addr + Current.Size +
        (Unsigned_32'Size / System.Storage_Unit);

      return Unsigned_32_To_Entry_Access (Next_Addr);
   end Next_Memory_Map_Entry;
end Multiboot;
