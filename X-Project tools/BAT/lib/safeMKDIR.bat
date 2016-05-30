::<?xml version="1.0" encoding="Cp850"?><contenido><![CDATA[

:: SUBRUTINA safeMKDIR
::   Crea un directorio borr ndolo previemente si ya exist¡a.
::
:: USO: 
::	 CALL %lib%\safeMKDIR "®Directorio a crear¯"
:: Donde...
::   ®Directorio a crear¯: Ruta absoluta o relativa del directorio a crear. El 
::                         entrecomillado es opcional si la ruta no contiene 
::                         espacios y obligatorio en caso contrario.
:: SALIDA: Ninguna

IF EXIST %1 (
	RD /S /Q %1
)
MD %1

EXIT /B 0

::]]></contenido>