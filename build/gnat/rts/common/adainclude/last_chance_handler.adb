--                              -*- Mode: Ada -*-
--  Filename        : last_chance_handler.adb
--  Description     : Implementation of the exception handler for the kernel.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 12:06:48 2012
--  Licence         : See LICENCE in the root directory.
--  with Console; use Console;

procedure Last_Chance_Handler
  (Source_Location : System.Address; Line : Integer) is

   procedure Crash (Source_Location : System.Address; Line : Integer) with
     Import     => True,
     Convention => Ada;
begin
   --  TODO: Add in code to dump the info to serial/screen which
   --  is obviously board specific.
   --     Put ("Exception raised",
   --          Screen_Width_Range'First,
   --          Screen_Height_Range'Last);
   Crash (Source_Location => Source_Location, Line => Line);
end Last_Chance_Handler;
