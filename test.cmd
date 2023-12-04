@SETLOCAL EnableDelayedExpansion & @ECHO OFF
	SET "Fact=@Error_Level"
	SET "Remark=Argument evaluates to !Fact!=0"
	SET "Assertion=:assert.ErrorLevel"
	SET "Act=!Assertion! Argument !Fact!"
		SET "Argument=" & CALL :STAGE
		SET "Argument=nul" & CALL :STAGE
		SET "Argument=CALL nul" & CALL :STAGE
		SET "Argument=FOR" & CALL :STAGE
		SET "Argument=CALL FOR" & CALL :STAGE
		SET "Argument=WRONG" & CALL :STAGE
		SET "Argument=CALL WRONG" & CALL :STAGE
		SET "Argument=1>2" & CALL :STAGE
		SET "Argument=CALL 1>2" & CALL :STAGE
		SET "Argument=vivid.cmd --random" & CALL :STAGE
	SET "Fact=@vivid.STORE"
	SET "Assertion=:assert.Readability"
	SET "Remark=Argument evaluates to a readable output."
	SET "Act=!Assertion! Argument"
		SET "Argument=vivid.cmd --random" & CALL :STAGE
		SET "Argument=vivid.cmd --random" & CALL :STAGE
EXIT /B  %ErrorLevel%


:STAGE & SETLOCAL
	SET "THEME=vivid.cmd"
	SET "LOG=test.cmd.log"
	CALL !THEME! 100,100,255;0,0,0
	SET "ID=%TIME::=%"
		CALL !Act!
	SET Error=%ErrorLevel%
	IF %Error% EQU 0 SET "Status=PASS" & CALL !THEME! 100,255,100;0,0,0
	IF %Error% NEQ 0 SET "Status=FAIL" & CALL !THEME! 255,100,100;0,0,0
		SET Report=[!ID!]!Status!: !Remark!; actual !Fact!=!%Fact%!
		ECHO !Report!
		SET Argument
		ECHO !Report! >> !LOG!
		SET Argument >> !LOG!
		SET Assertion >> !LOG!
		SET !Fact! >> !LOG!
		ECHO. >> !LOG!
	CALL !THEME! --off
EXIT /B %ErrorLevel%


:assert.ErrorLevel
	CMD /C "fromScript.cmd %~1"
	SET "%~2=%ErrorLevel%"
EXIT /B !%~2!


:assert.Readability
	CALL !%~1!
	SET "Q=" & SET /P Q=[%~0] Input something if output is readable, or press ENTER
	IF "%Q%" NEQ "" SET ErrorLevel=0
EXIT /B  %ErrorLevel%

