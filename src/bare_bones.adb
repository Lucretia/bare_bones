--                              -*- Mode: Ada -*-
--  Filename        : bare_bones.adb
--  Description     : A "hello world" style OS kernel written in Ada.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 11:59:53 2012
--  Licence         : See LICENCE in the root directory.
pragma Restrictions (No_Obsolescent_Features);
with VGA_Console; use VGA_Console;
with Multiboot; use Multiboot;
--  with System.Address_To_Access_Conversions;
--  with Ada.Unchecked_Conversion;

use type Multiboot.Magic_Values;

procedure Bare_Bones is
   Line : Screen_Height_Range := Screen_Height_Range'First;
begin
   null;
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

   --  Line := Line + 1;

   --  if Info.Flags.Memory then
   --     Put ("Memory info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.Boot_Device then
   --     Put ("Boot device info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.Command_Line then
   --     Put ("Command line info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.Modules then
   --     Put ("Modules info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;

   --     if Info.Modules.Count = 2 then
   --        declare
   --           type My_Modules_Array is new Modules_Array
   --             (1 .. Natural (Info.Modules.Count));
   --           type My_Modules_Array_Access is access all My_Modules_Array;

   --           --  My_Modules : aliased Modules_Array
   --           --    (1 .. Natural (Info.Modules.Count));
   --           --  pragma Unreferenced (My_Modules);

   --           package To_Modules is new System.Address_To_Access_Conversions
   --             (Object => My_Modules_Array_Access);

   --           function Conv is new Ada.Unchecked_Conversion
   --             (Source => To_Modules.Object_Pointer,
   --              Target => My_Modules_Array_Access);

   --           Modules : constant My_Modules_Array_Access :=
   --             Conv (To_Modules.To_Pointer
   --                     (Info.Modules.First));

   --           M : Multiboot.Modules;
   --           pragma Unreferenced (M);
   --        begin
   --           Put ("2 modules loaded is correct",
   --                Screen_Width_Range'First, Line);

   --           for I in 1 .. Info.Modules.Count loop
   --              M := Modules (Natural (I));
   --           end loop;

   --           Line := Line + 1;
   --        end;
   --     end if;
   --  end if;

   --  if Info.Flags.Symbol_Table then
   --     Put ("Symbol table info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.Section_Header_Table then
   --     Put ("Section header table info present",
   --        Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.BIOS_Memory_Map then
   --     Put ("BIOS memory map info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;

   --     declare
   --        Map : Memory_Map_Entry_Access := Multiboot.First_Memory_Map_Entry;
   --     begin
   --        while Map /= null loop
   --           Map := Multiboot.Next_Memory_Map_Entry (Map);
   --        end loop;
   --     end;
   --  end if;

   --  if Info.Flags.Drives then
   --     Put ("Drives info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.ROM_Configuration then
   --     Put ("ROM configuration info present",
   --          Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.Boot_Loader then
   --     Put ("Boot loader info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.APM_Table then
   --     Put ("APM table info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  if Info.Flags.Graphics_Table then
   --     Put ("Graphics table info present", Screen_Width_Range'First, Line);

   --     Line := Line + 1;
   --  end if;

   --  raise Constraint_Error;

   --  raise Console.TE;
   --  raise Constraint_Error;

   --  Put (Natural 'Image (54),
   --       Screen_Width_Range'First,
   --       Screen_Height_Range'First + 1);
   --  exception
   --     when Constraint_Error =>
   --        Put ("Constraint Error caught", 1, 15);
   --     when Program_Error =>
   --        null;
   --  when Console.TE =>
   --     Put ("TE caught", 1, 2);
end Bare_Bones;
pragma No_Return (Bare_Bones);
