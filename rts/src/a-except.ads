with System;

package Ada.Exceptions is
   pragma Preelaborate (Exceptions);

   type Exception_Id is private;
   pragma Preelaborable_Initialization (Exception_Id);

   Null_Id : constant Exception_Id;

   procedure Raise_Exception
     (E       : Exception_Id;
      Message : String := "");
   pragma No_Return (Raise_Exception);
private
   type Exception_Id is new Natural;

   Null_Id : constant Exception_Id := Exception_Id'First;
end Ada.Exceptions;
