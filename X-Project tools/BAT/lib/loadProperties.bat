::<?xml version="1.0" encoding="Cp850"?><contenido><![CDATA[

:: SUBRUTINA loadProperties
::   Lee un fichero de propiedades y lo carga en variables de entorno.
::
:: USO:
::	 CALL %lib%\loadProperties "®Ruta al fichero de propiedades¯"
:: Donde...
::   ®Ruta al fichero de propiedades¯: Ruta absoluta o relativa del fichero de 
::                                     propiedades a leer.
:: SALIDA:
::   Tantas variables de entorno como propiedades haya en el fichero (y 
:: llamadas igual).

IF EXIST "%logFile%" (
	>>"%logFile%" 2>&1 ECHO [%~n0%~x0]: - Leyendo par metros de ejecuci¢n desde "%~1":
)
FOR /F "usebackq eol=# tokens=1 delims=ª" %%i IN (%~1) DO (
	IF EXIST "%logFile%" (
		>>"%logFile%" 2>&1 ECHO [%~n0%~x0]: %%i
	)
	SET %%i
)

EXIT /B 0

::]]></contenido>