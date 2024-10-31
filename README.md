# UpperLowerProper
Batch File and Folder Case Renamer.

The script will scan for the first occurrence of the Skyrim (SSE) installation<br />(MYBASESKYRIM) on the drives commencing from A: drive (finding it typically on <br />
C:), and renaming all subfolders and the files to either upper, lower or Proper case.<br />
A list of the renamed files is found in Tes5Rename.log, on the MYGAMESSKYRIM<br />
(see below) directory. Non-standard game folder names can be inserted to the<br />
following section in the script.

=======================================================<br />
If Skyrim location isn't default, change"MYBASESKYRIM=Your_Different_Skyrim_Foldername"<br />
Can use wildcard "*". Do not include drive letters!<br />
Optionally check and adjust locations for MYGAMESSKYRIM and MYAPPDATASKYRIM.<br />
====================================================================<br />
SET "MYBASESKYRIM=Games\Steam\steamapps\common\Skyrim Special Edition"<br />
SET "MYGAMESSKYRIM=Users\%USERNAME%\Documents\My Games\Skyrim Special Edition"<br />
SET "MYAPPDATASKYRIM=Users\%USERNAME%\AppData\Local\Skyrim Special Edition"<br />
REM ===================================================<br />

An option exists to scan for a second or third installation of the game on the same drive.<br />
In that case, consider using a text editor for the addition of extra folders to the above<br />
MYBASESKYRIM assignment, separated by a semicolon.<br />
If, instead using an upper level folder like "Games" for MYBASESKYRIM, expect a longer<br />
wait for the search to complete. To scan for the default or original MYBASESKYRIM folder<br />
on a different drive, input just the new drive letter.<br />
An option also exists to rename contents of the MYGAMESSKYRIM and MYAPPDATASKYRIM folders.<br />
Similar scripts will be included for GOG versions, other TES Games, and a generic <br />Windows folder/file rename utility.<br />

Gotchas:<br />
The script will omit renaming files or folders with a semicolon in thir names.<br />
The collection of combined nested folder names do not exceed 8191 characters.<br />
If they do, the script may not complete the renaming.<br />
A partial workaround is to reverse the order of folders as explained here: <br />https://stackoverflow.com/a/25265061/2128797, the 8192 limit is sure to be<br />
reached before the script completes, however.<br />
