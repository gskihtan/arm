                       DKREADME.TXT
**********************************************************
 Microsoft(R) FoxPro(R) Version 2.6 Professional Edition

               Distribution Kit for MS-DOS(R)

   (C)1994 Microsoft Corporation. All Rights Reserved.
**********************************************************

=========
CONTENTS
=========

Part   Description
----   -----------
 1      Installation
 2      Knowledge Base Articles
 3      Changes to Distribution Kit User's Guide Since 
        Printing
 4      Answers to Commonly Asked Questions
 5      Error Messages
----------------------------------------------------------

=====================
Part 1: Installation
=====================

Installing the Professional Edition of FoxPro 2.6
-------------------------------------------------
The Professional Edition of FoxPro 2.6 includes the
following kits:

Distribution Kit
Connectivity Kit
Library Construction Kit
WorkGroup Extensions (FoxPro for Windows only) 

To install the Professional Edition of FoxPro, first install
the main FoxPro product, then follow the installation 
instructions included with each individual kit.  The order 
in which the kits are installed does not matter.
----------------------------------------------------------

FoxPro version 2.6 now includes the FoxPro Wizards, located
in the WIZARDS subdirectory. The FoxPro Wizards and 
CATALOG.APP should not be distributed with your applications.
----------------------------------------------------------

================================
Part 2: Knowledge Base Articles
================================

If you installed the Knowledge Base articles, you can view 
them by running the application KBVIEW.APP.  These articles 
contain useful information about a variety of FoxPro topics.
----------------------------------------------------------

=================================================
Part 3: Changes to Distribution Kit User's Guide 
        Since Printing
=================================================

In the Distribution Kit User's Guide, references to FoxPro
2.5 should be read as references to FoxPro 2.6.
----------------------------------------------------------

Chapter 1, page 2:  The first bulleted item should read:

"The Distribution Kit files, in both 5.25-inch and
3.5-inch disk formats."
----------------------------------------------------------

Chapter 2, page 10, under "Available Runtime Menus and Menu
Options," the File menu item should read:

File menu: Close, Save, Save As and Revert
----------------------------------------------------------

Chapter 2, page 11, under "Features Not Available in
Distributed Applications," add the following section below
the "Menus" section:

Menu Pads

The following FoxPro menu pads aren't available in the
applications you distribute.

SYSTEM Menu:  Macros..., Filer
  FILE Menu:  New..., Open..., Printer setup...,
              Print..., Quit
WINDOW Menu:  Color..., Command, Debug, Trace, View
----------------------------------------------------------

The files with extensions .ESL or .ESO have been renamed for
the new version.  For example:

FOXPRO.ESL is now FOXD2600.ESL
FOXPRO.ESO is now FOXD2600.ESO
FOXPROX.ESL is now FOXDX260.ESL

The new file names impact the following pages in the
Distribution Kit User's Guide:

Chapter 1, page 5, the Distribution Kit Files table.

Chapter 3, page 22, change the last sentence to read:

"The .EXE Support Library consists of three files:
FOXD2600.ESL, the standard .EXE Support Library
FOXD2600.ESO, and the 32-bit Extended .EXE Support
Library FOXDX260.ESL."

Chapter 5, page 32, the table called Files Required on
Distribution Disks Based on Type of Application has
these changes: 

In the "You must also distribute these files" column,
substitute the .ESL and .ESO file names with the new
File names.
----------------------------------------------------------

Chapter 2, page 15, under the heading "Help in a Project"
add the following information:

"If your help files are included in your project but
marked as excluded, you must distribute the .DBF and .FPT
files with your application. These files can be changed by
the user. If you don't want your users to have the ability
to change the contents of your help files, include them in
your project, but don't mark them as excluded."
----------------------------------------------------------

Chapter 5, page 33, the Files Your Application May
Require table should include DRIVER2.PLB as a file your
application may require.  This file contains printer 
drivers.  You must distribute this file if your
application requires printer drivers.
----------------------------------------------------------

============================================
Part 4: Answers to Commonly Asked Questions
============================================

Question 1

What type of applications (single-user, multi-user) can
be built with the Distribution Kit?

Answer 1

You can build single-user or multi-user applications 
with the Distribution Kit.  
----------------------------------------------------------

Question 3

Suppose I write a program for Client A and compile the 
program as a compact .EXE file and give the 
application to Client A, together with the *.ES? Library 
files with which to run the application.  Client A owns 
the application and the copyright.  Client A then sells 
the application to many other people.

Question 3.1

Does Client A also have to purchase the Distribution Kit?

Answer 3.1

No, Client A does not need to purchase the Distribution
Kit. Only the developer who uses the Distribution Kit to
build the original .EXE file must own a licensed copy of
the Distribution Kit.

Question 3.2 

Does Client A have to purchase the FoxPro 2.6 development
system?

Answer 3.2

Client A does not have to purchase FoxPro 2.6 because
the client is not building their own .EXE; Client A is
just reseller.  Client A must distribute the application
in its original form, however, and cannot remove the
runtime files to include the application with another
application.

Question 3.3 

Does the above also apply to stand-alone .EXE files?

Answer 3.3

Yes.
----------------------------------------------------------

Question 4

Why is Build Executable dimmed after I install the Distribution
Kit?

Answer 4

Two possible reasons: First, the Distribution Kit must
be installed in your FoxPro directory. Ensure that the
FoxPro files are not marked as read-only before installing
the Distribution Kit. Second, the project does not include
a SET MAIN program. Select the main menu or program, then
choose Main from the Project menu.
----------------------------------------------------------

Question 5

When I compile an .EXE file, the process stops with a
"Cannot Open File" error message that refers to a
Distribution Kit program file.  When I grant all access
rights (except for delete) to the program directory, the
program compiles.  However, the compilation process
leaves several files in the program directory with names
like WLK02112.--A, WLK02112.--B, WLK02112.--C, and so on.
What are these files?

Answer 5

Compiling program files in the FoxPro Distribution Kit
places temporary files in the directory from which you
start FoxPro. The TMPFILES statement in the CONFIG.FP
file does not affect file placement.

Include the full path to the network drive and directory
where the FoxPro development and distribution programs
are installed. Start FoxPro from a user directory
that has all rights, including erase or delete rights,
assigned to it.  The process of compiling using the
Distribution Kit creates files in and deletes files from
the user directory. The system administrator can designate
the program directory read only.
----------------------------------------------------------

Question 6

I have created an application that does not allow me to
edit my table/.DBF files. How can I correct this problem?

Answer 6

Mark your table/.DBF as excluded in the project, then
rebuild your application. You must distribute these files
to your end users. Including the table/.DBF in the project
automatically makes these files read only.
----------------------------------------------------------

Question 8

How do you instruct an MS-DOS .FXP, .APP or compact .EXE
file to run in extended mode from within Windows?

Answer 8

An .FXP, .APP or .EXE file will run in standard mode when
run from within Windows, even though there is enough
memory for the extended mode Support Library to run.  To
force use of the Extended Support Library from within 
Windows, you can use the +X loader switch to launch your
application.
----------------------------------------------------------

=======================
Part 5: Error Messages
=======================

Message: "Feature Not Available"

Question 1

My executable file runs correctly in the development
version of FoxPro, but I receive the error message
"Feature Not Available" when running the stand-alone
application. How can I correct this problem?

Answer 1.1

You will get the "Feature not available" error message
when you use commands, features, and menus that require
the development version of FoxPro.  Refer to the "Features
Not Available in Distributed Applications"  list in the 
FoxPro Distribution Kit User's Guide for a list of these
commands and functions.  These commands and functions
include: BUILD APP, BUILD EXE, BUILD PROJECT, COMPILE,
FILER, CREATE/MODIFY MENU, CREATE/MODIFY QUERY,
CREATE/MODIFY SCREEN, SET VIEW ON, and SUSPEND and
features specific to the interactive development
environment such as the Trace, Debug, Command, and
View windows.

Answer 1.2

You will get the "Feature not available" error message
when using commands containing macro substitution in
a stand-alone .EXE file. When you compile a stand-alone
.EXE file, the compiler includes only the code necessary
to run the commands explicitly included in the
application.  If there is macro substitution anywhere
in a line of code, that entire line is skipped, since
FoxPro does not explicitly "see" the command referenced
by the macro-substituted variable. The result is that
the code to execute the substituted command is not built
into the .EXE file.

The following examples illustrate two methods for
ensuring that macro-substituted commands are included
in your compiled .EXE file:

Example 1

As a developer you might want to allow the user to
choose either reports or labels by storing the choice
"report" or "label" in a memory variable called
m.output. You could then store the file name in the
memory variable m.filename.  You would include the
following command to run the report or labels in your
application:

&output FORM &filename TO PRINT NOCONSOLE

The Distribution Kit compiler will successfully create
a stand-alone .EXE file with this code. However, when
FoxPro attempts to execute the command, you will get a
"Feature Not Available" runtime error because the code
for the REPORT FORM and the LABEL FORM commands is not
included in the .EXE file. To avoid this problem,
include the following If statement at the beginning of
your application:

  IF .F.
    REPORT FORM dummy
    LABEL FORM dummy
  ENDIF

The file names do not have to exist.  The IF .F.
guarantees the code will never be executed. You are
simply making these commands visible to the compiler.

Example 2

This code example illustrates the use of macro
substitution for the PACK command. Because the code
does not explicitly issue the PACK command, FoxPro does
not include the required code in the stand-alone .EXE
file. An attempt to run the PACK command from the macro
substitution fails.

testcom="pack"
&testcom

To address this situation, create another procedure,
such as the following, and include it in the project.

procedure addon
pack
return
----------------------------------------------------------

Message: "Dynamic memory exhausted"

Question 1

What is the cause and solution for a "Dynamic memory
exhausted" error message when compiling a stand-alone
.EXE file?

Answer 1

This error message is sent by the WATCOM linker, which
is one of the tools in the FoxPro Distribution Kit used
to create a stand-alone application.  The message is
displayed when the amount of available conventional
memory is too low.  The WATCOM linker (WLINK8.EXE) uses
only conventional memory.

If the CONFIG.FP file contains the DOSMEM=ON statement,
edit the file to remove the statement. If the CONFIG.FP
file does not contain a DOSMEM statement, edit the
AUTOEXEC.BAT and CONFIG.SYS files to remove unnecessary
device drivers and memory-resident applications to
maximize available conventional memory.
----------------------------------------------------------

Message: "Link command failed"

Question 1

When I attempt to build an executable file, I receive the
error message "Link command failed."  How can I correct
this problem?

Answer 1

If you receive this error message, check the following
items:

a. Make sure that enough conventional memory is available.
   Modify the CONFIG.SYS and AUTOEXEC.BAT files to free
   conventional memory.

b. Make sure that enough disk space is available.

c. Increase the number of file handles available to
   Microsoft FoxPro for MS-DOS.  To do this, you can
   modify the FILES statement in the CONFIG.SYS file to
   increase the number of available files. In the Novell
   NetWare environment, modify the FILE HANDLES
   statement in the SHELL.CFG file to increase the number
   of available files.

d. If the AUTOEXEC.BAT file loads the SHARE utility,
   increase the values specified by the /F and /L 
   parameters. For example:

   SHARE /F:5120 /L:500

e. Make sure that FoxPro can find your COMMAND.COM file.
   Modify the SHELL statement in the CONFIG.SYS file to
   specify the /P (permanent) option switch.  Be sure
   SHELL= or COMSPEC= is set for the proper path to
   COMMAND.COM.

f. Make sure that the following files are in a directory
   listed in the MS-DOS PATH environment variable in the
   AUTOEXEC.BAT file:

   WLINK8.EXE and FOXSWAP.COM.

g. If you are running the Extended Version of FoxPro,
   remove the DOSMEM=ON statement (if it is present) from
   the CONFIG.FP file.
----------------------------------------------------------
                    ===================
                    END OF DKREADME.TXT
                    ===================
