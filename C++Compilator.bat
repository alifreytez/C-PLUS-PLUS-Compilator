rem Created by Alirio Freytez, 2021.
@echo off

set fullFileNames=
set projectName=
set projectPath=
set gotoRef=
set show=


:ini
cls
echo =======================================================
echo =               AUXILIAR DE COMPILACION               =
echo =======================================================
echo =
echo = 0. Salir
echo = 1. Compilar C++
echo =
echo =======================================================
echo.
echo.
set /p "option=[=] Opcion: "
if "%option%"=="0" goto getExit
if "%option%"=="1" goto compilationCPlusPlus
goto ini


:compilationCPlusPlus
set fullFileNames=
set projectName=
set projectPath=
set gotoRef=pathRequire
set show=true
goto %gotoRef%


:compilationTemplate
cls
echo -------------------------------------------------------
echo -                COMPILAR PROYECTO C++                -
echo -------------------------------------------------------
echo (Opcional) Escribe '-*' para cancelar el proceso.
echo (Opcional) Escribe '*' para reiniciar el proceso.
if "%gotoRef%"=="fileRequire" echo (Opcional) Escribe '-' para dejar de ingresar archivos.
if "%gotoRef%"=="compile" echo (Opcional) Escribe '+' para compilar nuevamente con la misma informacion.
echo.
echo - Ruta: %projectPath%
echo - Nombre: %projectName%
echo - Archivo(s): %fullFileNames%
set show=false
goto %gotoRef%


:pathRequire
if "%show%"=="true" goto compilationTemplate
set show=true
echo.
set /p "currentQuery=[=] Ruta del proyecto: "
if not "%currentQuery%"=="" (
	if "%currentQuery%"=="-*" goto ini
	if "%currentQuery%"=="*" goto compilationCPlusPlus
	if exist "%currentQuery%" (
		set projectPath=%currentQuery%
		set gotoRef=fileRequire
		goto %gotoRef%
	)
)
goto %gotoRef%


:fileRequire
if "%show%"=="true" goto compilationTemplate
set show=true
echo.
set /p "currentQuery=[=] Nombre del archivo (sin terminacion): "
if not "%currentQuery%"=="" (
	if "%currentQuery%"=="-*" goto ini
	if "%currentQuery%"=="*" goto compilationCPlusPlus
	if "%currentQuery%"=="-" goto skip
	if exist "%projectPath%\%currentQuery%.cpp" (
		if "%fullFileNames%"=="" (
			set fullFileNames=%currentQuery%.cpp
		) else (
			set fullFileNames=%fullFileNames% %currentQuery%.cpp
		)
		goto repeatFileRequire
	)
)
goto %gotoRef%


:nameRequire
if "%show%"=="true" goto compilationTemplate
set show=true
echo.
set /p "currentQuery=[=] Nombre del ejecutable: "
if not "%currentQuery%"=="" (
	if "%currentQuery%"=="-*" goto ini
	if "%currentQuery%"=="*" goto compilationCPlusPlus
	if "%currentQuery%"=="-" goto skip
	set projectName=%currentQuery%.exe
	set gotoRef=compile
	goto %gotoRef%
)
goto %gotoRef%


:skip
if not "%fullFileNames%"=="" (
	set gotoRef=nameRequire
	goto %gotoRef%
)
cls
echo No hay archivos seleccionados. No se puede continuar.
pause>nul
goto ini


:compile
if "%show%"=="true" goto compilationTemplate
echo.
if exist "%projectPath%" cd %projectPath%
g++ -o %projectName% %fullFileNames%
goto decisionFinal


:decisionFinal
echo.
set /p "currentQuery=[=] Decision: "
if not "%currentQuery%"=="" (
	if "%currentQuery%"=="-*" goto ini
	if "%currentQuery%"=="*" goto compilationCPlusPlus
	if "%currentQuery%"=="+" (
		set show=true
		goto compile
	)
)
goto decisionFinal


:repeatFileRequire
echo.
set /p "other=- Ingresar otro archivo? [Y/N]: "
if "%other%"=="y" goto %gotoRef%
if "%other%"=="Y" goto %gotoRef%
if not "%other%"=="n" (if not "%other%"=="N" (goto repeatFileRequire))
set gotoRef=nameRequire
goto %gotoRef%


:getExit
exit

pause>nul
exit