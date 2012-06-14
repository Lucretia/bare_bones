--                              -*- Mode: Ada -*-
--  Filename        : bare_bones.adb
--  Description     : A "hello world" style OS kernel written in Ada.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 11:59:53 2012
--  Licence         : See LICENCE in the root directory.
with Console; use Console;

procedure Bare_Bones is
begin
   Clear;

   Put ("Hello, bare bones in Ada",
        Screen_Width_Range'First,
        Screen_Height_Range'First);

   --  Put (Natural 'Image (54),
   --       Screen_Width_Range'First,
   --       Screen_Height_Range'First + 1);
end Bare_Bones;
pragma No_Return (Bare_Bones);
