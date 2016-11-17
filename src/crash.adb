--                              -*- Mode: Ada -*-
--  Filename        : crash.adb
--  Description     : Provides access to the multiboot information from GRUB
--                    Legacy and GRUB 2.
--  Author          : Luke A. Guest
--  Created On      : Thur Nov 17 16:52:05 2016
--  Licence         : See LICENCE in the root directory.
with VGA_Console; use VGA_Console;
with System.Address_Image;

procedure Crash (Source_Location : System.Address; Line : Integer) is
begin
   Put (Str        =>
          "** Kernel crashed on Line: " & Integer'Image (Line) &
          " at address: 0x" & System.Address_Image (Source_Location) & " **",
        X          => 1,
        Y          => 10,
        Foreground => White,
        Background => Red);

   Hang : loop
      null;
   end loop Hang;
end Crash;
