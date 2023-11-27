@SETLOCAL EnableDelayedExpansion & @ECHO OFF
	SET "Log=%~n0.log"
::	SET "Act=WRONG"
	SET "Act=:ASSERT.manually vivid.bat --random"
	SET "Value=@vivid.STORE"
	SET "Remark=%Value% is readable"
	:continue_TEST
		CALL :STAGE Remark Act Value
	GOTO :continue_TEST
EXIT /B  %ErrorLevel%




:STAGE
SETLOCAL
	SET "ErrorLevel=1"
	SET "!%~3!="
	CALL !%~2!
	SET "Fail=%ErrorLevel%"
	SET "Detail=!%Value%!"
	IF "%Fail%" EQU "0" SET "Message=*pass*" & CALL vivid.bat 100,255,100;0,0,0
	IF "%Fail%" NEQ "0" SET "Message=*fail*" & CALL vivid.bat 255,100,100;0,0,0
	SET "Message=%Message%	{%Time%} !%~1! %Detail%"
	ECHO [%~0]%Message%
	IF "%Fail%" NEQ "0" ECHO %Message% >> %Log%
EXIT /B %ErrorLevel%




:ASSERT.manually
	CALL %*
	SET "Q=" & SET /P Q=[%~0] Is !%Value%! readable? (input something if yes)
	IF "%Q%" NEQ "" SET ErrorLevel=0
EXIT /B  %ErrorLevel%



