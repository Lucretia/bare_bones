--                              -*- Mode: Ada -*-
--  Filename        : s-secsta.adb
--  Description     : Secondary stack
--  Author          : Luke A. Guest
--  Created On      : Wed Nov 16 17:06:31 2016
--  Licence         : See LICENCE in the root directory.
package body System.Secondary_Stack is
   procedure SS_Allocate
     (Addr         : out System.Address;
      Storage_Size : SSE.Storage_Count) is

      Align : constant Mark_Id := Mark_Id (Standard'Maximum_Alignment);
   begin
      --  Make sure this won't go over the end of the stack.
      if SS_Top + Mark_Id (Storage_Size) + Align > Mark_Id (SS_Pool'Last) then
         raise Storage_Error;
      else
         Addr   := SS_Pool (SS_Top)'Address;
         SS_Top := SS_Top + Mark_Id (Storage_Size) + Align;
      end if;
   end SS_Allocate;

   procedure SS_Free (Stk : in out System.Address) is
   begin
      null;
   end SS_Free;

   function SS_Mark return Mark_Id is
   begin
      return SS_Top;
   end SS_Mark;

   procedure SS_Release (M : Mark_Id) is
   begin
      SS_Top := M;
   end SS_Release;
end System.Secondary_Stack;
