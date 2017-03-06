::<?xml version="1.0" encoding="Cp850"?><contenido><![CDATA[
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: PROGRAM ®git-backup¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Copies files from a directory to a local git repository.
::
:: USAGE:
::    git-backup.bat
::
:: DEPENDENCIES: :findOutInstall :loadProperties :validateProgramAvailable
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF
SETLOCAL EnableDelayedExpansion
:::::::::::::::::::::::::::::::::: PREPROCESS ::::::::::::::::::::::::::::::::::
:: This variable will be used to manage the final ERRORLEVEL of the program.
SET errLvl=0

:: This program admits no parameters right now.
REM CALL :parseParameters %*
REM IF ERRORLEVEL 1 (
REM 	SET errLvl=1
REM 	GOTO :exit
REM )
CALL :findOutInstall "%~0" installDir
CALL :loadProperties "%installDir%\git-backup.properties"

CALL :validateProgramAvailable git.exe
SET errLvl=%ERRORLEVEL%
IF %errLvl% GTR 0 (
	GOTO :exit
)


:::::::::::::::::::::::::::::::::::: PROCESS :::::::::::::::::::::::::::::::::::
:: Counts localGitRepository properties.
SET localGitRepository.length=0
FOR /F "delims=ª" %%i IN ('SET localGitRepository[') DO (
	SET /A "localGitRepository.length+=1"
)
SET /A "localGitRepository.lastIndex=localGitRepository.length-1"

:: Chooses to work with the last existent directory.
FOR /L %%i IN (0,1,%localGitRepository.lastIndex%) DO (
	IF EXIST "!localGitRepository[%%i]!" (
		SET chosenLocalGitRepository=!localGitRepository[%%i]!
	)
)
ECHO Backing up to "%chosenLocalGitRepository%"
PUSHD "%chosenLocalGitRepository%"

:: Verifies whether the local Git repository is in an appropiate state to copy 
:: files to it without messing up some work in progress.
::TODO: Extract to a subroutine.
:: [PROTOTYPE] of how to dump a command output to an array of variables.
SET var.length=0
FOR /F "usebackq tokens=*" %%i IN (`git status`) DO (
	SET var[!var.length!]=%%i
	SET /A "var.length+=1"
)

IF "%var[0]%" NEQ "On branch master" (
	ECHO ERROR: Target local repository "%chosenLocalGitRepository%" not on branch master.
	SET errLvl=1
	GOTO :exit
)

IF "%var[1]%" NEQ "Your branch is up-to-date with 'origin/master'." (
	ECHO ERROR: Target local repository "%chosenLocalGitRepository%" not up-to-date with its remote. Pull it and try again.
	SET errLvl=1
	GOTO :exit
)

IF "%var[2]%" NEQ "nothing to commit, working tree clean" (
	ECHO ERROR: Target local repository "%chosenLocalGitRepository%" working directory not clean.
	SET errLvl=1
	GOTO :exit
)

SET /P answer=Did you remember to remove all sensible data from whitelisted files? [y/N]:
IF /I NOT "%answer%" == "y" (
	ECHO Backup aborted.
	SET errLvl=-1
	GOTO :exit
)

FOR /F "usebackq eol=# tokens=* delims=ª" %%i IN ("%installDir%\git-backup.whitelist") DO (
	CALL :doCopy "%%i"
)

:: Resets variable "answer". Otherwise, previous value would stay if user just 
:: presses ENTER
SET answer=
SET /P answer=Commit changes? [y/N]:
IF /I NOT "%answer%" == "y" (
	ECHO Backup finished.
	SET errLvl=-1
	GOTO :exit
)
git add .
git commit -a -m "Periodic backup of files."

:: Resets variable "answer". Otherwise, previous value would stay if user just 
:: presses ENTER
SET answer=
SET /P answer=Push changes? [y/N]:
IF /I NOT "%answer%" == "y" (
	ECHO Backup finished.
	SET errLvl=-1
	GOTO :exit
)
git push

GOTO :exit
:::::::::::::::::::::::::::::::::: POSTPROCESS :::::::::::::::::::::::::::::::::
:exit
POPD
PAUSE

EXIT /B %errLvl% & ENDLOCAL

:::::::::::::::::::::::::::::::::: SUBROUTINES :::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: BEGINNING: SUBROUTINE ®doCopy¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Copies the directory or file passed as parameter using the most appropiate 
:: method.
:: 
:: USAGE: 
::    CALL :doCopy ®["]path["]¯
:: WHERE...
::    ®["]path["]¯: Path of the file or directory to copy, relative to the 
::                  directory where git-backup.bat lives. If the path contains 
::                  white spaces, it must be enclosed in double quotes. It is 
::                  optional otherwise.
::
:: DEPENDENCIES: NONE
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:doCopy
SETLOCAL

SET errLvl=0
SET srcPath=%installDir%\%~1
SET tgtPath=%chosenLocalGitRepository%\%~1

:: If the path is a directory (note the trailing "\") uses ROBOCOPY. Most flags 
:: are just to prevent ROBOCOPY to output anything. "/E" is to ensure that 
:: empty subfolders are copied as well.
:: If the path is a file uses COPY. It could be done by means of ROBOCOPY but 
:: syntax would more complex.
:: If the path doesn't exist simply warns that it doesn't exist and will be 
:: skipped.
IF EXIST "%srcPath%\" (
	ECHO Copying "%srcPath%"
	ROBOCOPY "%srcPath%" "%tgtPath%" /E /NFL /NDL /NJH /NJS /NP

) ELSE IF EXIST "%srcPath%" (
	ECHO Copying "%srcPath%"
	>NUL COPY "%srcPath%" "%tgtPath%"
) ELSE (
	ECHO SKIPPING "%srcPath%" ^(doesn't exist^)
)

ENDLOCAL & EXIT /B %errLvl%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END: SUBROUTINE ®doCopy¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: BEGINNING: SUBROUTINE ®findOutInstall¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Computes the absolute path of the .bat passed as parameter. This 
:: subroutine helps identify the installation directory of .bat script which 
:: invokes it.
:: 
:: USAGE: 
::    CALL :findOutInstall "%~0" ®retVar¯
:: WHERE...
::    ®retVar¯: Name of a variable (existent or not) by means of which the 
::              directory will be returned.
::
:: DEPENDENCIES: :removeFileName
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:findoutInstall
SETLOCAL
SET retVar=%2

SET installDir=%~$PATH:1
IF "%installDir%" EQU "" (
	SET installDir=%~f1
)

CALL :removeFileName "%installDir%" _removeFileName
SET installDir=%_removeFileName%

ENDLOCAL & SET %retVar%=%installDir%
EXIT /B 0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END: SUBROUTINE ®findOutInstall¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: BEGINNING: SUBROUTINE ®removeFileName¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Removes the file name from a path.
::
:: USAGE: 
::    CALL :removeFileName ®["]path["]¯ ®retVar¯
:: WHERE...
::    ®["]path["]¯: Path from which the file name is to be removed. If the path
::                  contains white spaces, it must be enclosed in double quotes.
::                  It is optional otherwise.
::    ®retVar¯:     Name of a variable (existent or not) by means of which the 
::                  directory will be returned.
::
:: DEPENDENCIES: NONE
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:removeFileName
SETLOCAL
SET retVar=%2
SET path=%~dp1

PUSHD %path%
SET path=%CD%
POPD

ENDLOCAL & SET %retVar%=%path%
EXIT /B 0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END: SUBROUTINE ®removeFileName¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: BEGINNING: SUBROUTINE ®loadProperties¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Reads a propreties file and loads it in environment variables.
::
:: USAGE: 
::    CALL :loadProperties "®properties file path¯"
:: WHERE...
::    ®properties file path¯: Absolute or relative path of the properties file 
::                            to read.
::
:: DEPENDENCIES: NONE
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:loadProperties
FOR /F "usebackq eol=# tokens=1 delims=ª" %%i IN ("%~1") DO (
	SET %%i
)
EXIT /B 0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END: SUBROUTINE ®loadProperties¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: BEGINNING: SUBROUTINE ®validateProgramAvailable¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Verifies whether an executable file is present in PATH environment 
:: variable.
::
:: USAGE: 
::    CALL :validateProgramAvailable ®["]program["]¯
:: WHERE...
::    ®["]program["]¯: Name of the executable file. If the file name contains 
::                     white spaces, it must be enclosed in double quotes. It 
::                     is optional otherwise.
::
:: DEPENDENCIES: NONE
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:validateProgramAvailable
SETLOCAL
SET errLvl=0
IF "%~$PATH:1" == "" (
	ECHO ERROR: Program ®%1¯ cannot be found in PATH. git-backup requires a ®%1¯ installation to work.
	SET errLvl=1
)
ENDLOCAL & EXIT /B %errLvl%
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END: SUBROUTINE ®validateProgramAvailable¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::]]></contenido>
