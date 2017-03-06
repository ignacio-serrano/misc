::<?xml version="1.0" encoding="cp850"?>

:: SUBRUTINA init
::   Prepara el entorno de ejecuci¢n (variables, directorios temporales y 
:: cosas as¡) para el uso de las subrutinas que forman lib.
:: USO: 
::   CALL init
::
:: Dependencias: NINGUNA

SETLOCAL

CALL :findOutInstall "%~0"

ENDLOCAL & SET lib=%installDir%
EXIT /B 0

:::::::::: SUBRUTINAS ::::::::::
:::: INI: Subrutina findOutInstall
:findOutInstall
SET installDir=%~$PATH:1
IF "%installDir%" EQU "" (
	SET installDir=%~f1
)

CALL :removeFileName "%installDir%"
SET installDir=%_removeFileName%

EXIT /B 0
:::: FIN: Subrutina findOutInstall

:::: INI: Subrutina removeFileName
:removeFileName
SET _removeFileName=%~dp1

PUSHD %_removeFileName%
SET _removeFileName=%CD%
POPD

EXIT /B 0
:::: FIN: Subrutina removeFileName

::]]></contenido>