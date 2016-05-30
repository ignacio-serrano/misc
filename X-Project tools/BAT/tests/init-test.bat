::<?xml version="1.0" encoding="cp850"?>
:: TODO: Work in Progress
:: SCRIPT init-test
::   Prueba autom ticamente la subrutina ..\lib\init.bat
:: USO:
::   CALL init
::
:: Dependencias: NINGUNA

SETLOCAL

SET testResult=EXITO
FOR /F "usebackq eol=# tokens=1 delims=ª" %%i IN (init-test.properties) DO (
	SET %%i
)

ECHO libDir=%libDir%

SETLOCAL
CALL %libDir%\init

IF "%lib%" NEQ "%libDir%" (
	ECHO lib deb¡a valer ®%libDir%¯ pero vale ®%lib%¯
	SET testResult=FALLO
)
ENDLOCAL & SET testResult=%testResult%

ECHO testResult=%testResult%
ENDLOCAL

EXIT /B 0

::]]></contenido>