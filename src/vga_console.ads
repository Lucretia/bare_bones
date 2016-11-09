--                              -*- Mode: Ada -*-
--  Filename        : console.ads
--  Description     : Definition of a console for PC using VGA text mode.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 12:08:58 2012
--  Licence         : See LICENCE in the root directory.
-------------------------------------------------------------------------------
with System;

package Console is
   pragma Preelaborate (Console);

   TE : exception;
   type Background_Colour is
     (Black,
      Blue,
      Green,
      Cyan,
      Red,
      Magenta,
      Brown,
      Light_Grey);

   for Background_Colour use
     (Black      => 16#0#,
      Blue       => 16#1#,
      Green      => 16#2#,
      Cyan       => 16#3#,
      Red        => 16#4#,
      Magenta    => 16#5#,
      Brown      => 16#6#,
      Light_Grey => 16#7#);

   for Background_Colour'Size use 4;

   type Foreground_Colour is
     (Black,
      Blue,
      Green,
      Cyan,
      Red,
      Magenta,
      Brown,
      Light_Grey,
      Dark_Grey,
      Light_Blue,
      Light_Green,
      Light_Cyan,
      Light_Red,
      Light_Magenta,
      Yellow,
      White);

   for Foreground_Colour use
     (Black         => 16#0#,
      Blue          => 16#1#,
      Green         => 16#2#,
      Cyan          => 16#3#,
      Red           => 16#4#,
      Magenta       => 16#5#,
      Brown         => 16#6#,
      Light_Grey    => 16#7#,
      Dark_Grey     => 16#8#,
      Light_Blue    => 16#9#,
      Light_Green   => 16#A#,
      Light_Cyan    => 16#B#,
      Light_Red     => 16#C#,
      Light_Magenta => 16#D#,
      Yellow        => 16#E#,
      White         => 16#F#);

   for Foreground_Colour'Size use 4;

   type Cell_Colour is
      record
         Foreground : Foreground_Colour;
         Background : Background_Colour;
      end record;

   for Cell_Colour use
      record
         Foreground at 0 range 0 .. 3;
         Background at 0 range 4 .. 7;
      end record;

   for Cell_Colour'Size use 8;

   type Cell is
      record
         Char   : Character;
         Colour : Cell_Colour;
      end record;

   for Cell'Size use 16;

   Screen_Width  : constant Natural := 80;
   Screen_Height : constant Natural := 25;

   subtype Screen_Width_Range  is Natural range 1 .. Screen_Width;
   subtype Screen_Height_Range is Natural range 1 .. Screen_Height;

   type Row    is array (Screen_Width_Range)  of Cell;
   type Screen is array (Screen_Height_Range) of Row;

   Video_Memory : Screen;

   for Video_Memory'Address use System'To_Address (16#000B_8000#);

   pragma Import (Ada, Video_Memory);

   procedure Put
     (Char       : Character;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Colour := White;
      Background : Background_Colour := Black);

   procedure Put
     (Str        : String;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Colour := White;
      Background : Background_Colour := Black);

   --  procedure Put
   --    (Data       : in Natural;
   --     X          : in Screen_Width_Range;
   --     Y          : in Screen_Height_Range;
   --     Foreground : in Foreground_Colour := White;
   --     Background : in Background_Colour := Black);

   procedure Clear (Background : Background_Colour := Black);
end Console;
