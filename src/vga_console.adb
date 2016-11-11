--                              -*- Mode: Ada -*-
--  Filename        : vga_console.adb
--  Description     : Implementation of a console for PC using VGA text mode.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 12:09:31 2012
--  Licence         : See LICENCE in the root directory.
-------------------------------------------------------------------------------
package body VGA_Console is
   procedure Put
     (Char       : Character;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Colour := White;
      Background : Background_Colour := Black) is
   begin
      Video_Memory (Y)(X).Char              := Char;
      Video_Memory (Y)(X).Colour.Foreground := Foreground;
      Video_Memory (Y)(X).Colour.Background := Background;
   end Put;

   procedure Put
     (Str        : String;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Colour := White;
      Background : Background_Colour := Black) is
   begin
      for Index in Str'First .. Str'Last loop
         Put (Str (Index),
              X + Screen_Width_Range (Index) - 1,
              Y,
              Foreground,
              Background);
      end loop;
   end Put;

   --  procedure Put
   --    (Data       : in Natural;
   --     X          : in Screen_Width_Range;
   --     Y          : in Screen_Height_Range;
   --     Foreground : in Foreground_Colour := White;
   --     Background : in Background_Colour := Black) is

   --     type Numbers_Type is array (0 .. 9) of Character;

   --     Numbers : constant Numbers_Type :=
   --        ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
   --     Str     : String (1 .. 20);
   --     Value   : Natural := Data;
   --     Length  : Natural := 1;
   --     Mask    : Natural := 16#0000_000F#;

   --     procedure PutStringBackwards
   --        (Str        : in String;
   --         Length     : in Natural;
   --         X          : in Screen_Width_Range;
   --         Y          : in Screen_Height_Range;
   --         Foreground : in Foreground_Colour := White;
   --         Background : in Background_Colour := Black);

   --     procedure PutStringBackwards
   --        (Str        : in String;
   --         Length     : in Natural;
   --         X          : in Screen_Width_Range;
   --         Y          : in Screen_Height_Range;
   --         Foreground : in Foreground_Colour := White;
   --         Background : in Background_Colour := Black) is
   --     begin
   --        for Index in reverse Integer (Str'First) .. Integer (Length) loop
   --           Put (Str (Index),
   --                X + Screen_Width_Range (Index) - 1,
   --                Y,
   --                Foreground,
   --                Background);
   --        end loop;
   --     end PutStringBackwards;
   --  begin
   --     --  Find how many digits we need for this value.
   --     while Value /= 0 loop
   --        Str (Integer (Length)) := Numbers (Integer (Value and Mask));

   --        Value  := Value / 10;
   --        Length := Length + 1;
   --     end loop;

   --     PutStringBackwards (Str, Length, X, Y, Foreground, Background);
   --  end Put;

   procedure Clear (Background : Background_Colour := Black) is
   begin
      for X in Screen_Width_Range'First .. Screen_Width_Range'Last loop
         for Y in Screen_Height_Range'First .. Screen_Height_Range'Last loop
            Put (' ', X, Y, Background => Background);
         end loop;
      end loop;
   end Clear;
end VGA_Console;
