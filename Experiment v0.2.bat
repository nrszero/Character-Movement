::Nathan Schmitt
::Version 0.2
::Change Log - Added code for passing object, Not finished.

@echo off
@setlocal enabledelayedexpansion
pushd %~dp0
del Echos.txt
del Map.txt
set width=120
set height=30
set /a h=%height%-4
set /a w=%width%-3
set /a bordw=%width%-8
mode con: cols=%width% lines=%height%

echo 1: Start
echo 2: Quit
choice /c 12 > nul
if errorlevel 2 goto endIt 
if errorlevel 1 goto startIt

:startIt
set obj=лл
set size=2
set horspace=

::Set horizontal spaces variables
for /l %%d in (1,1,%w%) do ( 
	set "horspace=!horspace! "
	set varw[%%d]=!horspace!
)

::Starting Point for Obj
::Space from top
set vspace=8
::Space from Left
set hspace=20
set invert=20
set counter=0

:loop
cls
set counter+=1
set /a chingh=%h%
set /a chingw=%w%

::Pick Placement Code
set char=!varw[%hspace%]!%obj%

::Map
::Top
cls
for /l %%y in (1,1,%w%) do ( 
	set "topborder=!topborder!Ф"
)
echo: %topborder% > Map.txt

::Middle Section
set /a rw=%w%-2
set /a charfill=%rw%-%hspace%-%size%
set /a objleftfill=50
set /a objrightfill=%w%-%objleftfill%-4
set /a customLoc0=%h%-4
set /a charobjdiff=%objleftfill%-%hspace%-%size%
set /a chingh=%h%

::Change window border size if pass
if %vspace%==%customLoc0% (
	for /l %%t in (1,1,1) do (
		echo: !sideborder!!varw[%rw%]!!sideborder! >> Map.txt
	)	
)

for /l %%z in (1,1,%chingh%) do (
	set sideborder=Г
	
	REM Blank Starting Map
	rem makes sides with middle space
    if %%z NEQ %vspace% echo: !sideborder!!varw[%rw%]!!sideborder! >> Map.txt
	
	
	if %vspace% NEQ %customLoc0% (
		rem places objects
		if %%z==%customLoc0% echo: !sideborder!!varw[%objleftfill%]!%obj%!varw[%objrightfill%]!!sideborder! >> Map.txt
		if %%z==%customLoc0% rem echo Obj code
	)
	
	REM Character pass vertical on left
	if %vspace%==%customLoc0% (
		
		rem overlap char and objects
		if %%z==!customLoc0! echo: !sideborder!%char%!varw[%charobjdiff%]!%obj%!varw[%objrightfill%]!!sideborder! >> Map.txt
		if %%z==!customLoc0! rem echo Pass code: Space between: %charobjdiff%
		
	)
	
	if %vspace% NEQ %customLoc0% (
		rem places character in middle with sides
		if %%z==%vspace% echo: !sideborder!%char%!varw[%charfill%]!!sideborder! >> Map.txt
		if %%z==%vspace% rem echo Character code
	)	
	
)

::Bottom
for /l %%x in (1,1,%w%) do ( 
	set "bottomborder=!bottomborder!Ф"	
)
echo: %bottomborder% >> Map.txt

::Draw Map
if exist Map.txt type Map.txt
ping -n 1 -w 500 1.1.1.1 > NUL

::Reset Map
set bottomborder=
set topborder=

::echo Vert: %vspace%
::echo Hori: %hspace%
::echo Block:%customLoc0%

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
set /a invert=%invert%-2
call :BoundsCheck
goto loop

::End Loop

pause >nul

:endIt