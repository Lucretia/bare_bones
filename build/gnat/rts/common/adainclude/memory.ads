--                              -*- Mode: Ada -*-
--  Filename        : memory.ads
--  Description     : Memory routines.
--  Author          : Luke A. Guest
--  Created On      : Thur Nov 17 15:04:08 2016
--  Licence         : See LICENCE in the root directory.
with System;

package Memory is
   function Copy (Dest   : System.Address;
                  Source : System.Address;
                  Size   : Integer) return System.Address with
     Export        => True,
     Convention    => C,
     External_Name => "memcpy";
end Memory;
