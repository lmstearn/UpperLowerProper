# UpperLowerProper
Batch File and Folder Case Renamer.

The script will scan for the first occurrence of the Skyrim (SSE) installation<br />(MYBASESKYRIM) on the drives commencing from A: drive (finding it typically on <br />
C:), and renaming all subfolders and the files to either upper, lower or Proper case.
A list of the renamed files is found in Tes5Rename.log, on the MYGAMESSKYRIM\
(see below) directory. Non-standard game folder names can be inserted to the\
following section in the script.

==============================================================================\
If Skyrim location is not default, change"MYBASESKYRIM=Your_Different_Skyrim_Foldername"\
Can use wildcard "*". Do not include drive letters!
Optionally check and adjust locations for MYGAMESSKYRIM and MYAPPDATASKYRIM.
==============================================================================\
SET "MYBASESKYRIM=Games\Steam\steamapps\common\Skyrim Special Edition"\
SET "MYGAMESSKYRIM=Users\%USERNAME%\Documents\My Games\Skyrim Special Edition"\
SET "MYAPPDATASKYRIM=Users\%USERNAME%\AppData\Local\Skyrim Special Edition"\
REM ==========================================================================\

An option exists to scan for a second or third installation of the game on the same drive.
In that case, consider using a text editor for the addition of extra folders to the above\
MYBASESKYRIM assignment, separated by a semicolon.
If, instead using an upper level folder like "Games" for MYBASESKYRIM, expect a longer wait\
for the search to complete. To scan for the default or original MYBASESKYRIM folder on a different drive, input just the new drive letter.
An option also exists to rename contents of the MYGAMESSKYRIM and MYAPPDATASKYRIM folders.
Similar scripts will be included for GOG versions, other TES Games, and a generic Windows\ folder /file rename utility.

Gotchas:
The script will omit renaming files or folders with a semicolon in thir names.
The collection of combined nested folder names do not exceed 8191 characters.
If they do, the script may not complete the renaming.
A partial workaround is to reverse the order of folders as explained\
here: https://stackoverflow.com/a/25265061/2128797, the 8192 limit is sure to be\
reached before the script completes, however.
