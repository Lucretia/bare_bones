--                              -*- Mode: Ada -*-
--  Filename        : s-secsta.ads
--  Description     : Secondary stack
--  Author          : Luke A. Guest
--  Created On      : Wed Nov 16 17:06:11 2016
--  Licence         : See LICENCE in the root directory.
with System.Storage_Elements;

package System.Secondary_Stack is
   package SSE renames System.Storage_Elements;

   Default_Secondary_Stack_Size : Natural := 2 * 1024;  -- 2KB

   type Mark_Id is private;

   --  Allocate Storage_Size + Maxium_Alignment amount of space on the stack
   --  and return the address in Addr.
   procedure SS_Allocate
     (Addr         : out System.Address;
      Storage_Size : SSE.Storage_Count);

   --  Static stack, so we don't need to do anything here. In fact, it's,
   --  probably not even required.
   procedure SS_Free (Stk : in out System.Address);

   --  Return the current state (or top) of the stack.
   function SS_Mark return Mark_Id;

   --  Set the stack to M, freeing the last object allocated.
   procedure SS_Release (M : Mark_Id);
private
   type Mark_Id is new SSE.Storage_Count;

   --     SS_Pool : Integer;

   --  type Pools is array (SSE.Storage_Count range <>) of SSE.Storage_Element;

   SS_Size : constant Mark_Id := Mark_Id (Default_Secondary_Stack_Size);
   --     SS_Size : constant SSE.Storage_Count with
   --       import        => True,
   --       Convention    => Asm,
   --       External_Name => "sec_stack_size";

   SS_First : constant Mark_Id := 0;
   SS_Top   : Mark_Id          := SS_First;

   type Pools is array (Mark_Id range <>) of aliased SSE.Storage_Element;

   SS_Pool  : Pools (SS_First .. SS_Size);
end System.Secondary_Stack;
