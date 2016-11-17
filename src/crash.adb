--                              -*- Mode: Ada -*-
--  Filename        : crash.adb
--  Description     : Provides access to the multiboot information from GRUB
--                    Legacy and GRUB 2.
--  Author          : Luke A. Guest
--  Created On      : Thur Nov 17 16:52:05 2016
--  Licence         : See LICENCE in the root directory.
with Ada.Unchecked_Conversion;
with Interfaces.C;
with System.Address_To_Access_Conversions;
with System.Address_Operations; use System.Address_Operations;

with VGA_Console; use VGA_Console;

procedure Crash (Source_Location : System.Address; Line : Integer) is
   package C renames Interfaces.C;

   --  Get the length of the C NULL terminated string.
   function Length (Source_Location : System.Address) return C.size_t is
      use type C.size_t;

      function Convert is new Ada.Unchecked_Conversion (Source => C.size_t,
                                                        Target => System.Address);

      package To_Char is new System.Address_To_Access_Conversions (Object => C.char);

      Count : C.size_t               := 0;
      Char  : To_Char.Object_Pointer := To_Char.To_Pointer (AddA (Source_Location, Convert (Count)));
   begin
      while C.char'Pos (Char.all) /= 0 loop
         Count := Count + 1;
         Char  := To_Char.To_Pointer (AddA (Source_Location, Convert (Count)));
      end loop;

      return Count;
   end Length;

   --  This is really ugly, just to convert an address pointing to a C NULL terminated string to an Ada String!
   Source_Length : constant C.size_t := Length (Source_Location);

   type Source_Chars is new C.char_array (0 .. Source_Length);

   package To_Source is new System.Address_To_Access_Conversions (Object => Source_Chars);

   Source_Str    : constant String := C.To_Ada (C.char_array (To_Source.To_Pointer (Source_Location).all));
begin
   Put (Str        => "** Kernel crashed at: " & Source_Str & ":" & Integer'Image (Line) & " **",
        X          => 1,
        Y          => 10,
        Foreground => White,
        Background => Red);

   --  TODO: Dump registers.

   Hang : loop
      null;
   end loop Hang;
end Crash;
