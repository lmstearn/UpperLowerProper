# UpperLowerProper
Batch File and Folder Case Renamer (Windows) for use in the transfer of modded<br />
games over to devices with operating systems that use a mixed case file system.<br />

The script will scan for the first occurrence of your game installation<br />
(`MYBASEGAME`) on the drives commencing from A: drive (finding it typically on <br />
C:), and renaming all subfolders and the files to either upper, lower or proper case.<br />
A list of the renamed files is found in GameRename.log, on the `MYGAMESGAME`<br />
(see below) directory. Non-standard game folder names can be inserted to the<br />
following section in the script.


`REM ==================================================`<br />
`REM ==If MYGAMEEXE location differs to one below,`<br />
`REM ==change "MYBASEGAME=Your_Different_MYGAMEEXE_Foldername"==`<br />
`REM =====Can use wildcard "*". Do not include drive letters!=====`<br />
`REM =Optionally check & adjust locations for MYGAMESGAME & MYAPPDATAGAME=`<br />
`REM ==================================================`<br />
`SET "MYBASEGAME=Games\Steam\steamapps\common\Some_Game_Folder"`<br />
`SET "MYGAMESGAME=%UserProfile%\Documents\My Games\Some_Game_Settings"`<br />
`SET "MYAPPDATAGAME=%LocalAppData%\Some_Game_Data"`<br />
`REM ==================================================`<br />

For generic games not referenced in this repo, also modify the following value:<br />

`SET "MYGAMEEXE=Some_Game.exe"`<br />

An option exists to scan for a 2nd or 3rd installation of the game on the same drive.<br />
In that case, consider using a text editor for the inclusion of extra folders to the<br />
above `MYBASEGAME` assignment, each separated by a semicolon.<br />
If, instead using an upper level folder like "Games" for `MYBASEGAME`, expect a longer<br />
wait for the search to complete. To scan for the default or original `MYBASEGAME`<br />
folder on a different drive, input just the new drive letter at the prompt.<br />
An option also exists to rename the contents of the `MYGAMESGAME` and <br />
`MYAPPDATAGAME` folders. Similar scripts will be included for GOG versions,<br />
other TES Games, and a folder/file rename utility for a generic game.<br />

The [xEdit](https://github.com/TES5Edit/TES5Edit) _pas_ file changes the Bethesda `MAST` filenames to lower case.<br />

The 1.1 Gamma releases include logs [LC](https://raw.githubusercontent.com/lmstearn/UpperLowerProper/refs/heads/main/GameRenameLC.log) and [UC](https://raw.githubusercontent.com/lmstearn/UpperLowerProper/refs/heads/main/GameRenameUC.log) for a basic SkyrimSE Steam install,<br />
with just SKSE and the Unofficial Patches, 30,832 files in all. As can be seen from the logs,<br />
the time taken to rename the files and folders to lower case was just over 20 seconds,<br />
the time to rename the files and folders to upper case was around 35 minutes on the HDD!<br />
The longer time in the latter would also apply to proper case file/folder renaming,<br />
which also uses slow character by character comparisons and substitutions in loops,<br />
thus demonstrating the limitations of the CMD batch language in performing this task.<br />


### For considerations of hardware and time expenditure,<br />
### the renaming of a large number of files and folders 
### to upper or proper case is not recommended here.<br />


<br />
<br />

**Milestone**: Convert scripts to Bash (or similar e.g. Zsh tcsh) for use on target OS.<br />

### Gotchas:<br />
* Will not support UNC share drives. A milestone.<br />
* Does not support data on [FAT](https://learn.microsoft.com/en-us/troubleshoot/windows-client/backup-and-storage/fat-hpfs-and-ntfs-file-systems#fat-overview) drives.<br />
* Currently supports drives A-L, and Z. Drives M-Y another milestone.<br />
* The script will omit renaming files or folders with a semicolon in thir names.<br />
* The collection of combined nested folder names do not exceed 8191 characters.<br />
 In the case they do, the script may not complete the renaming.<br />
 A partial workaround is to reverse the order of folders as explained here: <br />
 https://stackoverflow.com/a/25265061/2128797, Sod's Law determines that<br />
 the 8192 limit is sure to be reached before the script completes, however.<br />
