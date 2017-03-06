::<?xml version="1.0" encoding="Cp850"?><contenido><![CDATA[
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: BEGINNING: SUBROUTINE ®extractDrive¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::    Obtains the drive letter (and the colon) of the file passed as parameter.
::
:: USAGE: 
::    CALL :extractDrive ®["]fileName["]¯ ®retVar¯
:: WHERE...
::    ®["]fileName["]¯: Absolute or relative path of the file. If the path 
::                      contains white spaces, it must be enclosed in double 
::                      quotes. It is optional otherwise.
::    ®retVar¯:         Name of a variable (existent or not) by means of which 
::                      the drive letter will be returned.
::
:: DEPENDENCIES: NONE
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:extractDrive
SETLOCAL
SET retVar=%2
ENDLOCAL & SET %retVar%=%~d2
EXIT /B 0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: END: SUBROUTINE ®extractDrive¯
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::]]></contenido>