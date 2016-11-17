--                              -*- Mode: Ada -*-
--  Filename        : crash.ads
--  Description     : Provides access to the multiboot information from GRUB
--                    Legacy and GRUB 2.
--  Author          : Luke A. Guest
--  Created On      : Thur Nov 17 16:52:05 2016
--  Licence         : See LICENCE in the root directory.
with System;

procedure Crash (Source_Location : System.Address; Line : Integer) with
  Export     => True,
  Convention => Ada;
