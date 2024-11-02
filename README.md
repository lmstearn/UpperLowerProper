# UpperLowerProper
Batch File and Folder Case Renamer.

The script will scan for the first occurrence of the Skyrim (SSE) installation<br />(MYBASESKYRIM) on the drives commencing from A: drive (finding it typically on <br />
C:), and renaming all subfolders and the files to either upper, lower or proper case.<br />
A list of the renamed files is found in Tes5Rename.log, on the MYGAMESSKYRIM<br />
(see below) directory. Non-standard game folder names can be inserted to the<br />
following section in the script.

REM ==================================================<br />
If your Skyrim location is not default or standard, use an editor<br />
to modify the line "MYBASESKYRIM=Your_Different_Skyrim_Foldername"<br />
Can use wildcard "*". Do not include drive letters!<br />
Optionally check and adjust locations for MYGAMESSKYRIM and MYAPPDATASKYRIM.<br />
REM ==================================================<br />
SET "MYBASESKYRIM=Games\Steam\steamapps\common\Skyrim Special Edition"<br />
SET "MYGAMESSKYRIM=Users\%USERNAME%\Documents\My Games\Skyrim Special Edition"<br />
SET "MYAPPDATASKYRIM=Users\%USERNAME%\AppData\Local\Skyrim Special Edition"<br />
REM ==================================================<br />

An option exists to scan for a second or third installation of the game on the same drive.<br />
In that case, consider using a text editor for the inclusion of extra folders to the<br />
above MYBASESKYRIM assignment, each separated by a semicolon.<br />
If, instead using an upper level folder like "Games" for MYBASESKYRIM, expect a longer<br />
wait for the search to complete. To scan for the default or original MYBASESKYRIM folder<br />
on a different drive, input just the new drive letter at the prompt.<br />
An option also exists to rename the contents of the MYGAMESSKYRIM and <br />
MYAPPDATASKYRIM folders. Similar scripts will be included for GOG versions,<br />
other TES Games, and a generic Windows folder/file rename utility.<br />

Gotchas:<br />
Will not support UNC share drives. A milestone. 
The script will omit renaming files or folders with a semicolon in thir names.<br />
The collection of combined nested folder names do not exceed 8191 characters.<br />
If they do, the script may not complete the renaming.<br />
A partial workaround is to reverse the order of folders as explained here: <br />
https://stackoverflow.com/a/25265061/2128797, the 8192 limit is sure to be<br />
reached before the script completes, however.<br />
