:::::::::::::::::::::::::::::::::::::::::
REM Automatically check & get admin rights (thanks to TanisDLJ at Stackoverflow)
:::::::::::::::::::::::::::::::::::::::::
@echo off
color 1E
mode 101
VERIFY > nul
CLS


REM BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\icacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
goto gotAdmin
)

REM https://superuser.com/questions/80485/exit-batch-file-from-subroutine
IF "%selfWrapped%"=="" (
REM this is necessary so that we can use "exit" to terminate the batch file,
REM and all subroutines, but not the original cmd.exe
SET "selfWrapped=true"
%ComSpec% /s /c ""%~0" %*"
GOTO :eof
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo args = "" >> "%temp%\getadmin.vbs"
echo For Each strArg in WScript.Arguments >> "%temp%\getadmin.vbs"
echo args = args ^& strArg ^& " "  >> "%temp%\getadmin.vbs"
echo Next >> "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", args, "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs" %*
    goto :eof

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
	timeout /t 1 >nul

FSUTIL.exe behavior set disable8dot3 1 >NUL
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 echo Unable to enable extensions
Setlocal EnableDelayedExpansion & cd "%CD%" & CD /D "%~dp0"
::::::::::::::::::::::::::::
::START
::::::::::::::::::::::::::::


REM Run shell as admin (example) - put here code as you like


REM Extended Attributes are only available on NTFS volumes
REM Check CMD extensions: https://ss64.org/viewtopic.php?f=2&t=33
REM if "%%~x0"=="%~x0" echo Command extensions not available
REM if "~x0"=="%~x0" echo Command extensions v1 available
REM if CmdExtVersion 2 echo Command extensions v2 or later available



set CREATKIT=
set TESVGAME=
set TES5EDIT=


tasklist /fi "IMAGENAME eq CreationKit.exe" | find /i "CreationKit.exe" > nul

if %errorlevel% EQU 0 set "CREATKIT=Creation Kit is running so the file will not be renamed."


REM tasklist /fi "IMAGENAME eq tesv.exe" | find /i "tesv.exe" > nul
tasklist /fi "IMAGENAME eq SkyrimSE.exe" | find /i "SkyrimSE.exe" > nul

if %errorlevel% EQU 0 set "TESVGAME=Skyrim is running so the file will not be renamed."


REM tasklist /fi "IMAGENAME eq TES5Edit.exe" | find /i "TES5Edit.exe" > nul
tasklist /fi "IMAGENAME eq SSEEdit.exe" | find /i "SSEEdit.exe" > nul

if %errorlevel% EQU 0 set "TES5EDIT=SSEEdit is running"

echo(
echo(
If DEFINED CREATKIT echo %CREATKIT%
If DEFINED TESVGAME echo %TESVGAME%
If DEFINED TES5EDIT echo %TES5EDIT%
echo(
echo(







SET renameChoice=
echo                          Welcome to the Skyrim Rename Tool!
echo(
echo **********************Please type enter after each key response.*************************
echo(
echo          Folders and files are renamed to either lower case, upper case, or proper case.
echo     The Tool scans drives, starting with A, locating Skyrim on the first drive, typically C.
echo    Upon proceeding, the existing filename case pattern is not saved, thus cannot be restored.
echo    The FOLDERSET variable contains only a subset of locations for the game on a drive, it can be
echo   modified to include more - e.g. for a root folder beginning with Z or z, add Z* to the variable.
echo    If there are other copies of Skyrim installations on a drive, type C after the selection, e.g.
echo    "LC" renames to lower case all Skyrim installations on the first and optionally other drives.
echo   For items from Documents\My Games\Skyrim and Appdata\Local\Skyrim, type M after selection, e.g.
echo   "UM" renames to upper case items in Skyrim base plus My Games\Skyrim and Appdata\Local\Skyrim.
echo   "LCM" (not LMC MCL etc) renames items to lower case in the game directory and ..\My Games\Skyrim.
echo(
SET /P renameChoice="Type L for lower, U for upper, P for proper case, other key or close window exits, no change."


if /I !renameChoice!==l set "choice=y"
if /I !renameChoice!==u set "choice=y"
if /I !renameChoice!==p set "choice=y"
if /I !renameChoice!==lc (
set "choice=y"
set "multiSkyrim=1"
set "renameChoice=l"
)
if /I !renameChoice!==lm (
set "choice=y"
set "renameChoice=l"
set "myGames=1"
)
if /I !renameChoice!==lcm (
set "choice=y"
set "multiSkyrim=1"
set "renameChoice=l"
set "myGames=1"
)
if /I !renameChoice!==uc (
set "choice=y"
set "multiSkyrim=1"
set "renameChoice=u"
)
if /I !renameChoice!==um (
set "choice=y"
set "renameChoice=u"
set "myGames=1"
)
if /I !renameChoice!==ucm (
set "choice=y"
set "multiSkyrim=1"
set "renameChoice=u"
set "myGames=1"
)
if /I !renameChoice!==pc (
set "choice=y"
set "multiSkyrim=1"
set "renameChoice=p"
)
if /I !renameChoice!==pm (
set "choice=y"
set "renameChoice=p"
set "myGames=1"
)
if /I !renameChoice!==pcm (
set "choice=y"
set "multiSkyrim=1"
set "renameChoice=p"
set "myGames=1"
)
if not defined choice (
set "EMPTYDIRECTORY=Valid input is one of "l,u,p,lc,uc,pc,lm,um,pm,pc,lcm,ucm,pcm.""
goto ENDSCRIPT
)




@echo off
echo(
echo _______________________________......Processing for %USERNAME%......__________________________________
echo(
set /A SSEDRIVE=0
set "CURRDRIVE=A:"
set CC=
set DD=
set YY=
@set multidrive=
set "INITIAL=1"
set FOUNDLASTSKYRIM=
SET SKYRIMFOLDER=
set FOLDERSETINPUT=
set FOLDERSET=
set FOLDERSET1=
set ANOTHERDRIVE=

REM =======================================================================================================
REM ===If Skyrim location differs to one below, change "MYBASESKYRIM=Your_Different_Skyrim_Foldername"===
REM ======================Can use wildcard "*". Do not include drive letters!==============================
REM ============Optionally check and adjust locations for MYGAMESSKYRIM and MYAPPDATASKYRIM================
REM =======================================================================================================
SET "MYBASESKYRIM=Games\Steam\steamapps\common\Skyrim Special Edition"
SET "MYBASESKYRIM=Users\lmstearn\Desktop\desktemp"
SET "MYGAMESSKYRIM=Users\%USERNAME%\Documents\My Games\Skyrim Special Edition"
SET "MYAPPDATASKYRIM=Users\%USERNAME%\AppData\Local\Skyrim Special Edition"
REM =======================================================================================================




if defined myGames (
@SET "FOLDERSETINPUT=!MYBASESKYRIM!;!MYGAMESSKYRIM!;!MYAPPDATASKYRIM!"
set "multiSkyrim=1
) else (
@SET "FOLDERSETINPUT=!MYBASESKYRIM!
)

@Call :EXPANDFOLDERSET



:SEARCHDRIVES

set BREAKLOOP=
REM BLOCK

REM No CDs?
REM for /f "skip=1" %%d IN ('wmic logicaldisk where drivetype^!=5 get deviceid') DO echo/%%d

for %%B in (A:\ B:\ C:\ D:\ E:\ F:\ G:\ H:\ I:\ J:\ K:\ L:\ Z:\) do (
set "YY=%%B"
set "DD=!YY:~0,2!"

if defined multidrive (
if not multidrive==!DD! (
@set multidrive=
@set "BREAKLOOP=1"
)
)

if defined ANOTHERDRIVE (
if /I !ANOTHERDRIVE!==!DD! (
@set BREAKLOOP=
) else (
@set "BREAKLOOP=1"
)
)

if not defined BREAKLOOP (
if exist !DD! (
!DD!
cd \ >NUL



if DEFINED FOUNDLASTSKYRIM (


call :CheckANOTHERDRIVE


if defined DD (
SET SKYRIMFOLDER1=
SET SKYRIMFOLDER2=
SET SKYRIMFOLDER3=
FOR %%A IN (!FOLDERSET!) DO (
@set "FOLDERSET1=%%A"

for /f "delims=;" %%C in ('dir /b /s /a !FOLDERSET1!') do (

set "XX=%%C"
set "CC=!XX:~3!"
set "ZZ=!YY!!CC!"


for /D %%G in (!ZZ!) do (



if /i %%~nxG==SKYRIMSE.EXE (
set "CURRDRIVE=!DD!"

if defined SKYRIMFOLDER1 (
if defined SKYRIMFOLDER2 (
if not defined SKYRIMFOLDER3 (
set "SKYRIMFOLDER3=%%~dpG"
if "!SKYRIMFOLDER3:~-1!"=="\" (
set "SKYRIMFOLDER=!SKYRIMFOLDER3:~0,-1!"
) else (
set "SKYRIMFOLDER=!SKYRIMFOLDER3!"
SET "SKYRIMFOLDER3=!SKYRIMFOLDER3!\"
)
pushd !SKYRIMFOLDER! >> !logFile! 2>&1

@call :GOTSKYRIMFOLDER
@popd
goto :FINISH
)
) else (
set "SKYRIMFOLDER2=%%~dpG"
if "!SKYRIMFOLDER2:~-1!"=="\" (
set "SKYRIMFOLDER=!SKYRIMFOLDER2:~0,-1!"
) else (
set "SKYRIMFOLDER=!SKYRIMFOLDER2!"
SET "SKYRIMFOLDER2=!SKYRIMFOLDER2!\"
)
pushd !SKYRIMFOLDER! >> !logFile! 2>&1

@call :GOTSKYRIMFOLDER
@popd
)
) else (



set "SKYRIMFOLDER1=%%~dpG"

if "!SKYRIMFOLDER1:~-1!"=="\" (
set "SKYRIMFOLDER=!SKYRIMFOLDER1:~0,-1!"
) else (
set "SKYRIMFOLDER=!SKYRIMFOLDER1!"
SET "SKYRIMFOLDER1=!SKYRIMFOLDER1!\"
)
set "FOUNDLASTSKYRIM=!DD!"
pushd !SKYRIMFOLDER! >> !logFile! 2>&1

@call :GOTSKYRIMFOLDER
@popd
REM Following fails
REM call :GOTSKYRIMFOLDER 1>> "!logFile!" 2>&1
set "CURRDRIVE=!DD!"

goto :FINISH

)

)
)
)
)
)
) else (



call :CheckANOTHERDRIVE

if defined DD (

set /A g=1
set "FOLDERSET!g!=%FOLDERSET:;=" & set /A g+=1 & set "FOLDERSET!g!=%"
for /L %%g in (1;1;%g%) do (
set "FOLDERSET1=!FOLDERSET%%g!"

if defined INITIAL (

If /I NOT !FOLDERSET1!==!MYBASESKYRIM! (
If /I !FOLDERSET1!==!MYGAMESSKYRIM! set "myGames=DONOW"
If /I !FOLDERSET1!==!MYAPPDATASKYRIM! set "myGames=DONOW"
)
)

if !myGames!==DONOW (


set "CC=!FOLDERSET1:~3!"
set "SKYRIMFOLDER=!YY!!CC!"


pushd !SKYRIMFOLDER! >> !logFile! 2>&1

IF EXIST !SKYRIMFOLDER! (
@call :GOTSKYRIMFOLDER
@popd
If /I !FOLDERSET1!==!MYAPPDATASKYRIM! goto :FINISH
) else (
@echo on
echo PROBLEM WITH "!SKYRIMFOLDER!" >> !logFile!
@echo off
@SET "BREAKLOOP=1"
)

) else (


for /f "delims=;" %%C in ('dir /b /s /a !FOLDERSET1!') do (

set "XX=%%C"
set "CC=!XX:~3!"
set "ZZ=!YY!!CC!"


for /D %%G in (!ZZ!) do (

REM tesv.exe is for Oldrim
if /i %%~nxG==SKYRIMSE.EXE (
if defined SKYRIMFOLDER1 (
REM Here if multiSkyrim
if defined SKYRIMFOLDER2 (
if not defined SKYRIMFOLDER3 (
set "SKYRIMFOLDER3=%%~dpG"
if "!SKYRIMFOLDER3:~-1!"=="\" (
set "SKYRIMFOLDER=!SKYRIMFOLDER3:~0,-1!"
) else (
set "SKYRIMFOLDER=!SKYRIMFOLDER3!"
SET "SKYRIMFOLDER3=!SKYRIMFOLDER3!\"
)
pushd !SKYRIMFOLDER! >> !logFile! 2>&1

@call :GOTSKYRIMFOLDER
@popd
goto :FINISH
)
) else (
set "SKYRIMFOLDER2=%%~dpG"

if "!SKYRIMFOLDER2:~-1!"=="\" (
set "SKYRIMFOLDER=!SKYRIMFOLDER2:~0,-1!"
) else (
set "SKYRIMFOLDER=!SKYRIMFOLDER2!"
SET "SKYRIMFOLDER2=!SKYRIMFOLDER2!\"
)

pushd !SKYRIMFOLDER! >> !logFile! 2>&1
@call :GOTSKYRIMFOLDER
@popd
)
) else (


set "SKYRIMFOLDER1=%%~dpG"

if "!SKYRIMFOLDER1:~-1!"=="\" (
set "SKYRIMFOLDER=!SKYRIMFOLDER1:~0,-1!"
) else (
set "SKYRIMFOLDER=!SKYRIMFOLDER1!"
SET "SKYRIMFOLDER1=!SKYRIMFOLDER1!\"
)
set "FOUNDLASTSKYRIM=!DD!"

REM All this can be done up top, DRIVE is not known yet
REM 
if exist !MYGAMESSKYRIM! (
set "logFile=!YY!!MYGAMESSKYRIM!\Tes5Rename.log"
) else (
set "logFile=%~dp0Tes5Rename.log"
)
pushd !SKYRIMFOLDER! >> !logFile! 2>&1

@call :GOTSKYRIMFOLDER

@popd

REM Following fails
REM call :GOTSKYRIMFOLDER 1>> "!logFile!" 2>&1
set "CURRDRIVE=!DD!"

if defined multiSkyrim (
@set "multidrive=!DD!"
) else (
set SKYRIMFOLDER1=
goto :FINISH
)

)

)
REM Exist SkyrimSE
)
)
)
)
)

REM FOUNDLASTSKYRIM DEFINED
)
REM Exist Drive
)
REM BREAKLOOP
)
REM Drives Loop
)



if Defined FOUNDLASTSKYRIM (
if %SSEDRIVE% EQU 0 (
REM Should never get here
GOTO ENDSCRIPT
) else (
GOTO FINISH
)
)




echo(
echo No Skyrim installed on any of the default paths as itemised in FOLDERSET.
@goto NOSKYRIMPROMPT
exit /b
:NOSKYRIMPROMPT
if NOT DEFINED FOUNDLASTSKYRIM @set "CURRDRIVE=NOTFOUND"
SET "validateText="
echo(
echo Input at least the first letter of Skyrim's base Parent_Folder [Driveletter:]\Parent_Folder.
echo Can use asterisk as wildcard. Separate multiple install locations with semicolons. To reduce
REM call for paranoia
@call SET validateText=&SET /P validateText="search overhead, drive letter with colon (Driveletter:) optional, separated by a semicolon."

@echo off
if "!validateText!"=="" (
GOTO ENDSCRIPT
) else (

if "!validateText!"==" " GOTO ENDSCRIPT
if "!validateText:~0,1!"==" " GOTO NOSKYRIMPROMPT

set INITIAL=
@set "FOLDERSETINPUT=!validateText!"
REM MYGAMESSKYRIM and MYAPPDATASKYRIM accounted for
set "FOLDERSET=!MYBASESKYRIM!"

call :CHECKPATHS 

)

@GOTO EXPANDFOLDERSET
exit /b
:CHECKPATHS
set ANOTHERDRIVE=
set CC=
set XX= 
set FOLDERSET1=
set /A G=1
set "FOLDERSETINPUT!g!=%FOLDERSETINPUT:;=" & set /A g+=1 & set "FOLDERSETINPUT!g!=%"
for /L %%g in (1;1;%g%) do (


set "CC=!FOLDERSETINPUT%%g!"

set YY=
call :CheckInputDrive YY !CC!


if defined YY (

if !YY!==INVALID (

set "EMPTYDIRECTORY=Drive not supported. Please rerun^!"
GOTO ENDSCRIPT
)
REM Only one drive accepted
if not defined ANOTHERDRIVE (
if exist !YY! (
set "ANOTHERDRIVE=!YY!"
) else (
set "ANOTHERDRIVE=!FOUNDLASTSKYRIM!"
)
)
) else (

REM strip drive letter from path - does it have a drive ID?
set "YY=!CC:~0,2!"
set XX=
if defined YY call :CheckInputDrive XX !YY!


if defined XX (
rem Now retrieve path
set "CC=!CC:~3!"
if not defined spareDrive set "spareDrive=!XX!"

)
set FOLDERSET=

@set "FOLDERSET1=!FOLDERSET1!!CC!"
@set "FOLDERSET1=!FOLDERSET1!;"
)

)

if defined spareDrive (
if not defined ANOTHERDRIVE set "ANOTHERDRIVE=!spareDrive!"
)

if defined FOLDERSET (
if DEFINED FOUNDLASTSKYRIM (
set "FOLDERSETINPUT=!MYBASESKYRIM:~3!"
) else (
set "FOLDERSETINPUT=!MYBASESKYRIM!"
)
) else (
if not defined ANOTHERDRIVE set "ANOTHERDRIVE=!FOUNDLASTSKYRIM!"
@set FOLDERSETINPUT=!FOLDERSET1:~0,-1!"
)

exit /b
:CheckInputDrive
set ZZ=
if /I %~2==A: set "ZZ=%~2"
if /I %~2==B: set "ZZ=%~2"
if /I %~2==C: set "ZZ=%~2"
if /I %~2==D: set "ZZ=%~2"
if /I %~2==E: set "ZZ=%~2"
if /I %~2==F: set "ZZ=%~2"
if /I %~2==G: set "ZZ=%~2"
if /I %~2==H: set "ZZ=%~2"
if /I %~2==I: set "ZZ=%~2"
if /I %~2==J: set "ZZ=%~2"
if /I %~2==K: set "ZZ=%~2"
if /I %~2==L: set "ZZ=INVALID"
if /I %~2==M: set "ZZ=INVALID"
if /I %~2==N: set "ZZ=INVALID"
if /I %~2==O: set "ZZ=INVALID"
if /I %~2==P: set "ZZ=INVALID"
if /I %~2==Q: set "ZZ=INVALID"
if /I %~2==R: set "ZZ=INVALID"
if /I %~2==S: set "ZZ=INVALID"
if /I %~2==T: set "ZZ=INVALID"
if /I %~2==U: set "ZZ=INVALID"
if /I %~2==V: set "ZZ=INVALID"
if /I %~2==W: set "ZZ=INVALID"
if /I %~2==X: set "ZZ=INVALID"
if /I %~2==Y: set "ZZ=INVALID"
if /I %~2==Z: set "ZZ=%~2"
set "%~1=%ZZ%"

exit /b
:FINISH
color 1E


IF DEFINED MOINSTALLED (
echo(
echo TES Data directory contents have likely moved to a MO dir. andor there exists a backup drive.
echo(
)


echo(
IF %SSEDRIVE% EQU 1 (
echo Success: Skyrim folders ^& files renamed on one drive. Log opens [Notepad if no viewer associated.]
) else (
echo Success: Skyrim folders ^& files renamed in locations. Log opens [Notepad if no viewer associated.]
)
echo(
@goto PROMPTFINISH
exit /b
:PROMPTFINISH

SET "validateText="
SET /P validateText="S: delete script, L: delete log, A: delete script + log, K: keep all, D: another drive. [S/L/A/K/D]"



if /i !validateText!==D goto NOSKYRIMPROMPT
if /i !validateText!==S (
FOR /F "Tokens=1 delims=," %%G IN ('ASSOC .log') DO (@Set "ASSOCLOG=%%G")
if DEFINED ASSOCLOG ("%LOGFILE%"
) else (
start "" notepad "%LOGFILE%")
call :deleteSelf
EXIT 0
)

if /i !validateText!==L (
If EXIST "%logFile%" (del "%LOGFILE%" /F /S /Q)
EXIT 0
)

if /i !validateText!==A (
If EXIST "%logFile%" (del "%LOGFILE%" /F /S /Q)
call :deleteSelf
EXIT 0
)

if /i !validateText!==K (
FOR /F "Tokens=1 delims=," %%G IN ('ASSOC .log') DO (@Set "ASSOCLOG=%%G")
if DEFINED ASSOCLOG ("%LOGFILE%"
) else (
start "" notepad "%LOGFILE%")
EXIT 0
)

GOTO :PROMPTFINISH

:ENDSCRIPT
color C0

ECHO  (^G)
cls
@echo off
echo(
echo(
echo(
if defined EMPTYDIRECTORY (
echo                        !EMPTYDIRECTORY!
) else (
echo                        Some, or all of the Skyrim files were not renamed at this time.
)
echo(
pause >nul
endlocal
EXIT 0

:deleteSelf
start /b "" cmd /c del /F /Q "%~f0"&exit 0
exit /b

:GOTSKYRIMFOLDER
REM max of 3 occurrences of SkyrimSE.exe considered on each drive



echo(
echo _______________________________......Processing for %USERNAME%......__________________________________
echo(
echo(
echo(
echo(
@echo off



REM Recycle log if too large
@set /A TESTVAL=%SSEDRIVE% * 3000
for %%a in ("!logFile!") do if %%~za gtr TESTVAL (
type nul > "!logFile!"
)

if exist "!logFile!" (set "operator=>>") else (set "operator=>")
set "log=%operator% "!logFile!""


%log% (

echo Start time is: %date% %TIME%

@echo on






REM Renaming here

REM If the %logfile% is in any of the target directories there will be:
REM "The process cannot access the file because it is being used by another process."


REM Lowercase
@if /I !renameChoice!==l (
@for /r %%D in (.) do (
@for /f "eol=: delims=" %%F in ('dir /l/b/a/d "%%D"') do (
@echo on
echo %%D\%%F "%%F"
ren "%%D\%%F" "%%F" 2>&1
@echo off
)
)
)

REM Uppercase
@if /I !renameChoice!==u (
@for %%f in (*) do (
@set "filename=%%~f"

@for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
@call set "filename=!filename:%%A=%%A!"
)
@echo on
echo "%%f" "!filename!"
ren "%%f" "!filename!" 2>&1
@echo off
)



@for /f "eol=:  delims=" %%z in (' dir /A:D /s/b/d ') do (
@pushd %%z
@for %%f in (*) do (
@set "filename=%%~f"

@for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do @call set "filename=!filename:%%A=%%A!"

@echo on
echo "%%f" "!filename!"
ren "%%f" "!filename!" 2>&1
@echo off

)
@set "dirname=%%~nxz"
@for %%A in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do @call set "dirname=!dirname:%%A=%%A!"

@popd
@echo on
echo "%%z" "!dirname!"
ren "%%z" "!dirname!" 2>&1
@echo off
)
)


REM Propercase
@if /I !renameChoice!==p (


@REM ~n: name without extension
for /f tokens^=* %%W in ('where .:*')do (


@SET "BASENAME=%%~NXW"
@SET "NAME=%%~NXW"
@SET "FF=TRUE"
@SET "NEWNAME="
@SET "DELIM=FALSE"
@SET "UNDERSCORE=_"
@SET "SPACE= "
@SET "PARENTHESIS=("
@CALL :CONVERT
)

@for /f "eol=: delims=" %%W in (' dir /A:D /s/b ') do (
@pushd %%W

@for %%X in (*) do (
@SET "BASENAME=%%~NXX"
@SET "NAME=%%~NXX"
@SET "FF=TRUE"
@SET "NEWNAME="
@SET "DELIM=FALSE"
@SET "UNDERSCORE=_"
@SET "SPACE= "
@SET "PARENTHESIS=("
@CALL :CONVERT
)
popd
@SET "BASENAME=%%~NXW"
@SET "NAME=%%~NXW"
@SET "FF=TRUE"
@SET "NEWNAME="
@SET "DELIM=FALSE"
@SET "UNDERSCORE=_"
@SET "SPACE= "
@SET "PARENTHESIS=("
@CALL :CONVERT
)
)

)

@echo off
@set /A SSEDRIVE=SSEDRIVE+1


exit /b




:CONVERT

@REM Lowercase
@FOR %%V IN (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO @call SET "NAME=!NAME:%%V=%%V!"

@REM Uppercase
@SET "LL=!NAME:~0,1!"
@IF !FF!==TRUE (
@SET "INITIAL=!LL!"
@FOR %%V IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO @call SET INITIAL=!INITIAL:%%V=%%V!
@SET "NEWNAME=!NEWNAME!!INITIAL!"
@SET "DELIM=FALSE"
) ELSE (
@SET "NEWNAME=!NEWNAME!!LL!"
)

@REM Detect delimiter
@IF "!LL!"=="!UNDERSCORE!" @SET "DELIM=TRUE"

@IF "!LL!"=="!SPACE!" @SET "DELIM=TRUE"

@IF "!LL!"=="!PARENTHESIS!" @SET "DELIM=TRUE"

@IF !DELIM!==TRUE (
@SET "FF=TRUE"
) ELSE (
@SET "FF=FALSE"
)

@REM Output
@SET "NAME=!NAME:~1!"
@IF DEFINED NAME @GOTO CONVERT

IF NOT %DIR%!BASENAME!==%DIR%!NEWNAME! (
@echo on
REN "%DIR%!BASENAME!" "!NEWNAME!" 2>&1
Echo %DIR%!BASENAME! %DIR%!NEWNAME!
@echo off
)

@REM End
@exit /b

:CheckCURRDRIVE

if defined ANOTHERDRIVE (
@for %%G in (A B C D E F G H I J K L Z) do (
@call set "ANOTHERDRIVE=!ANOTHERDRIVE:%%G=%%G!"
)
@set "DD=!ANOTHERDRIVE!"
exit /b
)

set DD=
if !FOUNDLASTSKYRIM!==A: (
if !DD!==A set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==B: (
if !DD!==A: set DD=
if !DD!==B: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==C: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==D: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==E: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==F: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==G: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==H: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
if !DD!==H: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==I: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
if !DD!==H: set DD=
if !DD!==I: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==J: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
if !DD!==H: set DD=
if !DD!==I: set DD=
if !DD!==J: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==K: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
if !DD!==H: set DD=
if !DD!==I: set DD=
if !DD!==J: set DD=
if !DD!==K: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==L: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
if !DD!==H: set DD=
if !DD!==I: set DD=
if !DD!==J: set DD=
if !DD!==K: set DD=
if !DD!==L: set DD=
exit /b
)
if !FOUNDLASTSKYRIM!==Z: (
if !DD!==A: set DD=
if !DD!==B: set DD=
if !DD!==C: set DD=
if !DD!==D: set DD=
if !DD!==E: set DD=
if !DD!==F: set DD=
if !DD!==G: set DD=
if !DD!==H: set DD=
if !DD!==I: set DD=
if !DD!==J: set DD=
if !DD!==K: set DD=
if !DD!==Z: set DD=
exit /b
)
exit /b
:CheckANOTHERDRIVE
if defined ANOTHERDRIVE (
if not !DD!==!ANOTHERDRIVE! set DD=
)
exit /b
:EXPANDFOLDERSET
REM Expand wildcards in FOLDERSETINPUT for first drive found - backslashes are fine
rem https://stackoverflow.com/a/33091367/2128797
@set LASTFOLDER=
@set FOLDERSET=
set GG=
set /A CT=0
set /A g=1
set "FOLDERSETINPUT!g!=%FOLDERSETINPUT:;=" & set /A g+=1 & set "FOLDERSETINPUT!g!=%"
for /L %%g in (1;1;%g%) do (
set /A CT+=1
set VALIDATEFAIL=
set "GG=!FOLDERSETINPUT%%g!"


rem https://stackoverflow.com/questions/69464104/checking-each-character-of-a-string-batch-script
for /F "delims=" %%B in ('cmd /D /U /C @echo !GG!^| find /V ""') do (
if "%%B"=="/" set "VALIDATEFAIL=1"
if "%%B"=="|" set "VALIDATEFAIL=1"
if "%%B"=="%%" set "VALIDATEFAIL=1"
if "%%B"=="""" set "VALIDATEFAIL=1"
if "%%B"=="^" set "VALIDATEFAIL=1"
if "%%B"=="<" set "VALIDATEFAIL=1"
if "%%B"==">" set "VALIDATEFAIL=1"
)

if DEFINED VALIDATEFAIL (
if !CURRDRIVE!==NOTFOUND (
goto NOSKYRIMPROMPT
) else (
set "EMPTYDIRECTORY=Invalid characters found in Folderset. Please rerun^!"
GOTO ENDSCRIPT
)
)

call :RESOLVEEACH "!GG!"

REM INIT
REM if not "%~1"=="" (
if defined INITIAL (
if !CT!==1 set "MYBASESKYRIM=!LASTFOLDER!"
if !CT!==2 set "MYGAMESSKYRIM=!LASTFOLDER!"
if !CT!==3 set "MYAPPDATASKYRIM=!LASTFOLDER!"
)


if defined multiSkyrim (
@set "FOLDERSET=!FOLDERSET!!LASTFOLDER!;"
) else (
goto FinalizeFOLDERSET
)
)


goto FinalizeFOLDERSET
exit /b
:RESOLVEEACH

set BREAKLOOP=


for %%B in (A:\ B:\ C:\ D:\ E:\ F:\ G:\ H:\ I:\ J:\ K:\ L:\ Z:\) do (




if not defined multiSkyrim (
if defined LASTFOLDER @set "BREAKLOOP=1
)

if not defined BREAKLOOP (
set "YY=%%B"
set "DD=!YY:~0,2!"

if DEFINED FOUNDLASTSKYRIM @call :CheckCURRDRIVE

if defined ANOTHERDRIVE @set "DD=!ANOTHERDRIVE!"


set XX=
set CC=

if defined DD (

if exist !DD! (

cd !DD! >NUL

REM check dir exists
if exist %~1\* (
@set "XX=!DD!\%~1"
if not !LASTFOLDER!==!XX! (
@set "LASTFOLDER=!XX!"
@set "BREAKLOOP=1"
)

) else (

set ZZ=
set "FSELEMENT=!DD!\%~1"

if not "!FSELEMENT:~-1!"=="*" set "FSELEMENT=!FSELEMENT!*"


cd \ >NUL



for /f %%C in ('dir /b /s /a:d !FSELEMENT! 2^>NUL') do (
REM It may occur the full path directory of FSELEMENT is returned first (reparse point?)



set "CC=%%C"
set "XX=%%~dC"

if !XX!==!DD! (

if not defined ZZ (

set "XX=!CC:~3!"


set "ZZ=!YY!!XX!"
)
)
)



if not defined ZZ (
REM we must get filename

for /f %%C in ('dir /b /s /a:-d !FSELEMENT! 2^>NUL') do (
REM file on drive?

set "CC=%%C"
set "XX=!CC:~0,3!"

if !XX!==!YY! (

set ZZ=

for %%F in ("!CC!") do (
if not defined ZZ set "ZZ=%%~fF"
)

cd !ZZ! >NUL

set "ZZ=!CD!"

)
) 


REM string limit is 8191 characters!
)


if defined ZZ (
if not !LASTFOLDER!==!ZZ! (
@set "LASTFOLDER=!ZZ!"
@set "BREAKLOOP=1"
)
)



)
)

) else (
if defined ANOTHERDRIVE @set "BREAKLOOP=1"
)
)
)
exit /b
:FinalizeFOLDERSET

if DEFINED LASTFOLDER (

if defined multiSkyrim (
@set "FOLDERSET=!FOLDERSET:~0,-1!"
) else (
@set "FOLDERSET=!LASTFOLDER!"
)
if !CURRDRIVE!==NOTFOUND set "CURRDRIVE=A:"


goto SEARCHDRIVES
) else (
set "EMPTYDIRECTORY=No subdirectories or files found^!"
GOTO ENDSCRIPT
)

exit /b
