::<?xml version="1.0" encoding="Cp850"?><contenido><![CDATA[
:: This is just an example or demo. It is intended to illustrate a non obvious
:: feature of some CMD commands. It is not meant to be used in real life.
:: [PROTOTYPE] of how to dump a command output to a SINGLE variable.
@ECHO OFF
SETLOCAL EnableDelayedExpansion

FOR /F "tokens=* USEBACKQ" %%i IN (`dir`) DO (
	(SET var=!var!%%i^
%=Keep this line empty and unindented=%
)
)

SET var

EXIT /B 0 & ENDLOCAL
::]]></contenido>
