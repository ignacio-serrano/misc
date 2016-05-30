::<?xml version="1.0" encoding="cp850"?>
:: TODO: Probar
:: SUBRUTINA extractDrive
::   Devuelve la letra de unidad (y los dos puntos) del fichero pasado como par metro.
:: USO: 
::   CALL %lib%\extractDrive ®["]fileName["]¯ ®retVar¯
:: Donde...
::   ®["]fileName["]¯: Ruta absoluta o relativa del fichero. El entrecomillado 
::                     es opcional si la ruta no contiene espacios y 
::                     obligatorio en caso contrario.
::   ®retVar¯:         Nombre de una variable existente o no a trav‚s de la que se 
::                     devolver  la letra de unidad.

SETLOCAL
SET retVar=%2
ENDLOCAL & SET %retVar%=%~d2
EXIT /B 0

::]]></contenido>