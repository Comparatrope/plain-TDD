@SETLOCAL EnableDelayedExpansion & @ECHO OFF
	SET "_STORE_=@%~n0.STORE"
	SET "_LOG_=%~n0.log"
	SET "--help=:HELP ESC"
	SET "--random=:ESC"
	SET "--off=:ESC OFF"
	SET "--on=:ESC ON"
	SET "--clear=SET %_STORE_%="
	SET "_task_=%~1"
	
	IF "%_task_%" EQU ""    CALL :HELP & GOTO :EOF
	IF     DEFINED %_task_% CALL !%_task_%!
	IF NOT DEFINED %_task_% CALL :ESC %*
	SET "_RETURN_=!%_STORE_%!"
	ENDLOCAL & SET "%_STORE_%=%_RETURN_%"
EXIT /B %ErrorLevel%


:HELP
SETLOCAL
	IF "%~1" EQU "ESC" CALL :ESC
	SET "_tab_=    "
	ECHO.
	ECHO %~nx0  [--help/--clear/--off/--on ["Rf","Gf","Bf";"Rb","Gb","Bb"]]
	ECHO %_tab_% {Rf,Gf,Bf}  (f)oreground-RGB ESC[38;2;Rf;Gf;Bfm
	ECHO %_tab_% {Rb,Gb,Bb}  (b)ackground-RGB ESC[48;2;Rb;Gb;Bbm
	ECHO %_tab_%      --off  use default-ANSI ESC[m 
	ECHO %_tab_%       --on  use %_STORE_%
	ECHO %_tab_%    --clear  delete %_STORE_%
	ECHO %_tab_%   --random  use random-RGB(0-255)
	ECHO %_tab_%     --help  random %_STORE_% !%_STORE_%!
EXIT /B %ErrorLevel%


:ESC
	FOR /F %%E IN ('ECHO PROMPT $E^| CMD') DO SET "_ESC_=%%E"
	IF "%~1" EQU "OFF" ECHO %_ESC_%[m& GOTO :EOF
	IF "%~1" EQU "ON"  CALL %~nx0 !%_STORE_%! & GOTO :EOF
	SET "Rf=%~1" & IF "%~1"=="" SET /A Rf=%RANDOM%*255/32767
	SET "Gf=%~2" & IF "%~2"=="" SET /A Gf=%RANDOM%*255/32767
	SET "Bf=%~3" & IF "%~3"=="" SET /A Bf=%RANDOM%*255/32767
	SET "Rb=%~4" & IF "%~4"=="" SET /A Rb=%RANDOM%*255/32767
	SET "Gb=%~5" & IF "%~5"=="" SET /A Gb=%RANDOM%*255/32767
	SET "Bb=%~6" & IF "%~6"=="" SET /A Bb=%RANDOM%*255/32767

	CALL :RELATE Rf,Rb;  R0,R1,dR,pC;
	CALL :RELATE Gf,Gb;  G0,G1,dG,pC;
	CALL :RELATE Bf,Bb;  B0,B1,dB,pC;
	CALL :ADJUST pC; R0,R1,dR; G0,G1,dG; B0,B1,dB;
	SET %_STORE_%="%Rf%","%Gf%","%Bf%";"%Rb%","%Gb%","%Bb%"
	ECHO %_ESC_%[38;2;%Rf%;%Gf%;%Bf%m%_ESC_%[48;2;%Rb%;%Gb%;%Bb%m
EXIT /B %ErrorLevel%



:RELATE
	SET "_=	"
	IF !%1! LEQ !%2! SET "_min_=%1" & SET "_max_=%2"
	IF !%1! GTR !%2! SET "_min_=%2" & SET "_max_=%1"
	SET /A "_contrast_=!%_max_%! - !%_min_%!"
	IF !%6! LEQ %_contrast_% SET "_majorant_=%_contrast_%"
	SET %3=%_min_%
	SET %4=%_max_%
	SET %5=%_contrast_%
	SET %6=%_majorant_%
::	ECHO %6:!%6!%_% {%1,%2~%5}:{!%1!,!%2!~!%5!}
EXIT /B %ErrorLevel%



:ADJUST
	SET /A "tolerance=120"
	IF !%1! GEQ %tolerance% EXIT /B %ErrorLevel%
	SET "_=	"
	SET /A "precision=10"
	SET /A "bias=%precision% * 255 / !%1!"
	:continue_ADJUST
		SET _min_=!%2!
		SET _max_=!%3!
		SET _contrast_=!%4!
		SET /A "%_min_%=0"
		SET /A "%_max_%=%_contrast_% * %bias% / %precision%"
::		ECHO bias:%bias%%_%%_min_%:!%_min_%!%_%%_max_%:!%_max_%!%_%%4:%_contrast_%
		SHIFT /2
		SHIFT /2
		SHIFT /2
	IF "%4" NEQ "" GOTO :continue_ADJUST
EXIT /B %ErrorLevel%
