--                              -*- Mode: Ada -*-
--  Filename        : memory.adb
--  Description     : Memory routines.
--  Author          : Luke A. Guest
--  Created On      : Thur Nov 17 15:07:32 2016
--  Licence         : See LICENCE in the root directory.
with Interfaces;
--  with System.Address_To_Access_Conversions;

package body Memory is
   type Byte_Array is array (Integer range <>) of aliased Interfaces.Integer_8;

   --     package Convert is new System.Address_To_Access_Conversions
   --       (Object => Byte_Array);

   function Copy (Dest   : System.Address;
                  Source : System.Address;
                  Size   : Integer) return System.Address is

      --        S : Convert.Object_Pointer := Convert.To_Pointer (Source);
      --        D : Convert.Object_Pointer := Convert.To_Pointer (Dest);
      S : Byte_Array (0 .. Size) with
        Address => Source;

      pragma Import (Convention => C, Entity => S);

      D : Byte_Array (0 .. Size) with
        Address => Dest;

      pragma Import (Convention => C, Entity => D);
   begin
      for I in S'Range loop
         D (I) := S (I);
      end loop;

      return Dest;
   end Copy;
end Memory;
