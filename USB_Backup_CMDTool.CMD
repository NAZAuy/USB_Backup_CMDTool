@ECHO OFF
CHCP 65001
SETLOCAL enabledelayedexpansion
SET appver=24.01.30
SET maindir=%CD%
TITLE USB Backup CMDTool v%appver% [by naza.uy]
SET "Path=%Path%;%CD%;%CD%\bin;"
CD /d %~dp0

REM LICENCIA MIT
REM El siguiente código está bajo la Licencia MIT:
REM
REM Copyright (c) [2024] [Jesús GÓMEZ]
REM
REM Permiso otorgado a cualquier persona que obtenga una copia de este software y archivos de documentación asociados
REM (el "Software"), para tratar el Software sin restricciones, incluyendo sin limitación los derechos
REM para usar, copiar, modificar, fusionar, publicar, distribuir, sublicenciar y/o vender
REM copias del Software, y permitir a las personas a quienes se les proporciona el Software hacerlo,
REM sujeto a las siguientes condiciones:
REM
REM El aviso de copyright anterior y este aviso de permisos se incluirán en todas las copias o porciones sustanciales del Software.
REM
REM EL SOFTWARE SE PROPORCIONA "TAL CUAL", SIN GARANTÍA DE NINGÚN TIPO, EXPRESA O IMPLÍCITA,
REM INCLUYENDO PERO NO LIMITADO A LAS GARANTÍAS DE COMERCIALIZACIÓN,
REM ADECUACIÓN PARA UN PROPÓSITO PARTICULAR Y NO INFRACCIÓN.
REM EN NINGÚN CASO LOS AUTORES O TITULARES DE DERECHOS DE AUTOR SERÁN RESPONSABLES DE NINGUNA RECLAMACIÓN,
REM DAÑO U OTRA RESPONSABILIDAD, YA SEA EN UNA ACCIÓN DE CONTRATO, AGRAVIO O DE OTRA MANERA,
REM DERIVADA DE, FUERA DE O EN RELACIÓN CON EL SOFTWARE O EL USO U OTRO TRATAMIENTO DEL SOFTWARE.
REM
REM FIN DE LA LICENCIA MIT

REM PROCEDIMIENTOS:
:DIRLIST
REM PROCE#1 - Listado de directorios en el directorio actual
SET "directoryList="
SET "firstDir=true"
FOR /d %%i in (*) do (
    IF not defined firstDir (
        SET "directoryList=!directoryList!; "
    ) ELSE (
        SET "firstDir="
    )
    SET "directoryList=!directoryList!%%i"
)

:MENU
CALL :DISKSUSB
REM ECHO.[41m
CLS
ECHO.
ECHO [1m[4mSCRIPT PARA RESPALDO DE UNIDADES EXTRAIBLES[0m
ECHO.
ECHO        1 - RESPALDAR UNIDAD USB
ECHO        2 - RESTAURAR UNIDAD USB
ECHO        3 - VER ÚLTIMO REGISTRO
ECHO        4 - AYUDA
ECHO        0 - SALIR
ECHO.
ECHO        UNIDADES EXTRAIBLES ACTUALES: %usbdisks%
ECHO.
ECHO.
SET /p choice=OPCION: 
IF "%choice%" equ "1" GOTO BACKUP
IF "%choice%" equ "2" GOTO RESTORE
IF "%choice%" equ "3" GOTO VIEWREG
IF "%choice%" equ "4" GOTO HELP
IF "%choice%" equ "0" EXIT /b 0

:BACKUP
CLS
SET /p source_unit=¿Especifique la Unidad USB de ORIGEN? ( Ejemplo "E", Actuales: %usbdisks%): 
SET /p backup_criteria=¿Especifique destino? ( ACTUALES: %directoryList%): 

ECHO Respaldo Unidad USB
SET LOGREG=Task_bkup_%backup_criteria%
ROBOCOPY "!source_unit:~0,1!:" "%maindir%\%backup_criteria%" /MIR /S /V /Z /xf *.log.* *.tmp /XD "%source_unit%:\System Volume Information" /LOG:%LOGREG%.log /tee
PAUSE
GOTO MENU

:RESTORE
CLS
SET /p target_unit=¿Especifique la Unidad USB de DESTINO? ( Ejemplo "E", %usbdisks%): 
SET /p restore_criteria=¿Especifique origen? ( ACTUALES: %directoryList%): 

ECHO Restauración Unidad USB
SET LOGREG=Task_restore_%restore_criteria%
ROBOCOPY "%maindir%\%restore_criteria%" "!target_unit:~0,1!:" /MIR /S /V /Z /xf *.log.* *.tmp /XD "%source_unit%:\System Volume Information" /LOG:%LOGREG%.log /tee
PAUSE
GOTO MENU

:VIEWREG
CLS
IF not defined LOGREG (
    ECHO No hay registro aún de esta instancia.
) ELSE (
    type %LOGREG%.log
)
ECHO.
PAUSE
GOTO MENU

:HELP
CLS
ECHO.
ECHO   ██╗  ██╗█████╗██╗   █████╗
ECHO   ██║  ██║██╔══╝██║   ██╔═█║
ECHO   ███████║████╗ ██║   █████║
ECHO   ██╔══██║██╔═╝ ██║   ██╔══╝
ECHO   ██║  ██║█████╗█████╗██║   
ECHO   ╚═╝  ╚═╝╚════╝╚════╝╚═╝   
ECHO.
ECHO   ACERCA DE LA APLICACIÓN:
ECHO   La aplicación "USB Backup CMDTool v%appver%" es una herramienta diseñada para simplificar y automatizar el proceso de respaldo y restauración de contenido almacenado en unidades USB o pendrives en sistemas Windows 7 o superior. Ofrece una interfaz de línea de comandos amigable para el usuario.
ECHO ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
ECHO   REQUISITOS:
ECHO   Sistema Operativo Windows 7 o Superior.
ECHO ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
ECHO   RESPALDAR UNIDAD USB: 
ECHO   PASO 1: Especifique la Unidad removible (pendrive) de ORIGEN. Ejemplo: Si la ruta es "E:\", ingrese "E".
ECHO   PASO 2: Ingrese una palabra de referencia al contenido del pendrive, ejemplo: "SOFTWARE", "DOCUMENTOS", etc.
ECHO   PASO 3: Podrá ver el procedimiento mientras se realiza; el respaldo es espejo.
ECHO ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
ECHO   RESTAURAR UNIDAD USB: 
ECHO   PASO 1: Especifique la Unidad removible (pendrive) de DESTINO. Ejemplo: Si la ruta es "E:\", ingrese "E".
ECHO   PASO 2: Ingrese la palabra de referencia al contenido del pendrive existente.
ECHO   PASO 3: Podrá ver el procedimiento mientras se realiza; el respaldo es espejo.
ECHO ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
ECHO   VER ÚLTIMO REGISTRO: 
ECHO   Los procedimientos de RESPALDO y RESTAURACIÓN generan archivos LOG.
ECHO   En este apartado podrá visualizar el último realizado.
ECHO ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
ECHO   ACERCA DE: USB Backup CMDTool
ECHO   Este programa fue desarrollado por:
ECHO   Desarrollador: Jesús GÓMEZ
ECHO   Correo Electrónico: naza79@gmail.com
ECHO   Versión: %appver%
ECHO ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
PAUSE
GOTO MENU

:DISKSUSB
REM PROCE#2 - Listar unidades USB presentes
SET "usbDisks="
SET "firstUSB=true"
SET "CountDisks=0"
FOR /f "skip=1" %%i in ('wmic logicaldisk where drivetype^=2 get caption') do (
    IF not defined firstUSB (
        SET "usbDisks=!usbDisks!"
    ) ELSE (
        SET "firstUSB="
    )
    SET "usbDisks=!usbDisks!%%i "
    SET /A "CountDisks+=1"
)
IF %CountDisks% EQU 1 (set usbDisks=[41m NO HAY UNIDADES [0m)