::<?xml version="1.0" encoding="Cp850"?><contenido><![CDATA[
:: TODO:
::   Habilitar especificar la variable de retorno como se hace en extractDrive.bat
::
:: SUBRUTINA concreteFileName
::   Obtiene el nombre completo de un fichero a partir de una expresi¢n. La
:: sintaxis de expresiones es la misma soportada por el comando DIR.
:: 
:: USO:
::	 CALL %lib%\concreteFileName ®expresion¯
::   ECHO %_concreteFileName%
:: Donde...
::   ®expresion¯: Una expresi¢n de nombre de archivo absoluta o relativa que 
::                puede contener * como comod¡n.
::
:: SALIDA:
::   _concreteFileName: Nombre completo del fichero sin ruta (ni absoluta ni
::                      relativa.
:: EJEMPLO:
::   [Script]
::     CALL %lib%\concreteFileName registry-server*
::     ECHO %_concreteFileName%
::   [Consola]
::     registry-server-0.4.0-17.war

SETLOCAL EnableDelayedExpansion

FOR /F "usebackq tokens=*" %%i IN (`DIR /B "%~1"`) DO (
	SET ret=%%i
)

ENDLOCAL & SET _concreteFileName=%ret%
EXIT /B 0

::]]></contenido>