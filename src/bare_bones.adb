--                              -*- Mode: Ada -*-
--  Filename        : bare_bones.adb
--  Description     : A "hello world" style OS kernel written in Ada.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 11:59:53 2012
--  Licence         : See LICENCE in the root directory.
with Console; use Console;
with Multiboot; use Multiboot;

use type Multiboot.Magic_Values;

procedure Bare_Bones is
   Line : Screen_Height_Range := Screen_Height_Range'First;
begin
   Clear;

   Put ("Hello, bare bones in Ada",
        Screen_Width_Range'First,
        Line);

   Line := Line + 1;

   if Magic = Magic_Value then
      Put ("Magic numbers match!", Screen_Width_Range'First, Line);
   else
      Put ("Magic numbers don't match!", Screen_Width_Range'First, Line);

      raise Program_Error;
   end if;

   Line := Line + 1;

   if Info.Flags.Memory then
      Put ("Memory info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Boot_Device then
      Put ("Boot device info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Command_Line then
      Put ("Command line info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Modules then
      Put ("Modules info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Symbol_Table then
      Put ("Symbol table info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Section_Header_Table then
      Put ("Section header table info present",
         Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.BIOS_Memory_Map then
      Put ("BIOS memory map info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Drives then
      Put ("Drives info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.ROM_Configuration then
      Put ("ROM configuration info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Boot_Loader then
      Put ("Boot loader info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.APM_Table then
      Put ("APM table info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   if Info.Flags.Graphics_Table then
      Put ("Graphics table info present", Screen_Width_Range'First, Line);

      Line := Line + 1;
   end if;

   --  raise Console.TE;
   --  raise Constraint_Error;

   --  Put (Natural 'Image (54),
   --       Screen_Width_Range'First,
   --       Screen_Height_Range'First + 1);
--  exception
--     when Constraint_Error =>
--        Put ("Constraint Error caught", 1, 2);
   --  when Console.TE =>
   --     Put ("TE caught", 1, 2);
end Bare_Bones;
pragma No_Return (Bare_Bones);
