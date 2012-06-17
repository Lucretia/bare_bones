with GNAT.Source_Info;
with Last_Chance_Handler;

package body Ada.Exceptions is
   procedure Raise_Exception
     (E       : Exception_Id;
      Message : String := "") is
      pragma Unreferenced (E);
      pragma Unreferenced (Message);
      File             : String := GNAT.Source_Info.File;
      Line             : Positive := GNAT.Source_Info.Line;
      Source_Location  : String := GNAT.Source_Info.Source_Location;
      Enclosing_Entity : String := GNAT.Source_Info.Enclosing_Entity;
      pragma Unreferenced (File, Line, Source_Location, Enclosing_Entity);
   begin
      Last_Chance_Handler (System.Null_Address, 0);

      loop
         null;
      end loop;
   end Raise_Exception;
end Ada.Exceptions;
