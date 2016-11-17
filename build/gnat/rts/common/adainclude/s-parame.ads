--                              -*- Mode: Ada -*-
--  Filename        : s-parame.ads
--  Description     : Custom package.
--  Author          : Luke A. Guest
--  Created On      : Thur Nov 17 17:52:04 2016
--  Licence         : See LICENCE in the root directory.
package System.Parameters is
   pragma Pure;

   ----------------------------------------------
   -- Characteristics of types in Interfaces.C --
   ----------------------------------------------

   long_bits : constant := Long_Integer'Size;
   --  Number of bits in type long and unsigned_long. The normal convention
   --  is that this is the same as type Long_Integer, but this is not true
   --  of all targets. For example, in OpenVMS long /= Long_Integer.

   ptr_bits  : constant := Standard'Address_Size;
   subtype C_Address is System.Address;
   --  Number of bits in Interfaces.C pointers, normally a standard address,
   --  except on 64-bit VMS where they are 32-bit addresses, for compatibility
   --  with legacy code.
end System.Parameters;
