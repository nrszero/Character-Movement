::Nathan Schmitt
::Version - 0.1

@echo off
@setlocal enabledelayedexpansion
pushd %~dp0
del Echos.txt
del Map.txt
set width=120
set height=30
set /a h=%height%-3
set /a w=%width%-3
set /a bordw=%width%-8
mode con: cols=%width% lines=%height%

echo 1: Start
echo 2: Quit
choice /c 12 > nul
if errorlevel 2 goto endIt 
if errorlevel 1 goto startIt

:startIt
set obj=ÜÜÜ
set size=3
set horspace=

::Set Horizontal
for /l %%d in (1,1,%w%) do ( 
	set "horspace=!horspace! "
	set varw[%%d]=!horspace!
)
::Set Vertical
for /l %%n in (1,1,%h%) do ( 
	echo echo. >> Echos.txt
)

::Starting Point for Obj
::Space from top
set vspace=8
::Space from Left
set hspace=20
set counter=0

:loop
cls
set counter+=1

::Pick Placement Code
::Pick Vertical
set /a vertspace=%h%-%vspace%

for /f "skip=%vertspace%" %%b in (Echos.txt) do (
	%%b
)

::Pick Horizontal
set char=!varw[%hspace%]!%obj%


::Map
::Top
cls
for /l %%y in (1,1,%w%) do ( 
	set "topborder=!topborder!Ä"
)
echo: %topborder% > Map.txt

::Middle Section
set /a rw=%w%-2
set /a fill=%rw%-%hspace%-%size%
for /l %%z in (1,1,%h%) do ( 
	set sideborder=³
	
	REM Blank Starting Map
	if %%z NEQ %vspace% echo: !sideborder!!varw[%rw%]!!sideborder! >> Map.txt
	if %%z==%vspace% echo: !sideborder!%char%!varw[%fill%]!!sideborder! >> Map.txt
	
	REM Show other Objects
	
)

::Bottom
for /l %%x in (1,1,%w%) do ( 
	set "bottomborder=!bottomborder!Ä"	
)
echo: %bottomborder% >> Map.txt

::Draw Map
if exist Map.txt type Map.txt
::ping -n 1 -w 500 1.1.1.1 > NUL

::Reset Map
set bottomborder=
set topborder=

::echo Vert: %vspace%
::echo Hori: %hspace%

::Movement
choice /c adws /n >nul
if %errorlevel% EQU 4 goto down
if %errorlevel% EQU 3 goto up
if %errorlevel% EQU 2 goto right
if %errorlevel% EQU 1 goto left

:BoundsCheck
::Bounds Check
if %hspace% GEQ %bordw% set /a hspace=%bordw%
if %vspace% GEQ %h% set /a vspace=%h%
if %hspace% LEQ 0 set /a hspace=0
if %vspace% LEQ 1 set /a vspace=1
exit /b

:up
set /a vspace=%vspace%-1
call :BoundsCheck
goto loop
:down
set /a vspace=%vspace%+1
call :BoundsCheck
goto loop
:left
set /a hspace=%hspace%-2
call :BoundsCheck
goto loop
:right
set /a hspace=%hspace%+2
call :BoundsCheck
goto loop

::End Loop

pause >nul

:endIt