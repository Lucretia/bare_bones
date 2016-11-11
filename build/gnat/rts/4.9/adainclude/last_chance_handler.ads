--                              -*- Mode: Ada -*-
--  Filename        : last_chance_handler.ads
--  Description     : Definition of the exception handler for the kernel.
--  Author          : Luke A. Guest
--  Created On      : Thu Jun 14 12:06:21 2012
--  Licence         : See LICENCE in the root directory.
with System;

procedure Last_Chance_Handler
  (Source_Location : System.Address; Line : Integer);
pragma Export (C, Last_Chance_Handler, "__gnat_last_chance_handler");
pragma Preelaborate (Last_Chance_Handler);
