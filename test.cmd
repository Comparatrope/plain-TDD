@SETLOCAL EnableDelayedExpansion & @ECHO OFF
	SET "STAGE=assert.cmd"
	SET "LOG=test.cmd.log"

	SETLOCAL
		SET "Input=vivid.cmd"
		SET "Metric=assert#ErrorLevel.cmd"
		SET "Remark=Input evaluates to ErrorLevel=0"
			CALL !STAGE!
	ENDLOCAL
	SETLOCAL
		SET "Input=vivid.cmd"
		SET "Output=help"
		SET "Metric=assert#stdOUT.cmd !Output!"
		SET "Remark=Input evaluates to stdOUT with string '!Output!'"
			CALL !STAGE!
	ENDLOCAL

	CALL :test.Faulty_Argument
GOTO :EOF


:test.Faulty_Argument
SETLOCAL
	SET "Metric=assert#ErrorLevel.cmd"
	SET "Remark=Input evaluates to ErrorLevel=0"
	SETLOCAL
		SET "Input=%*"
		CALL !STAGE!
	ENDLOCAL
	SETLOCAL
		SET "Input=%*CALL"
		CALL !STAGE!
	ENDLOCAL
	SETLOCAL
		SET "Input=%*NUL"
		CALL !STAGE!
	ENDLOCAL
	SETLOCAL
		SET "Input=%*EQU"
		CALL !STAGE!
	ENDLOCAL
	SETLOCAL
		SET "Input=%*IF"
		CALL !STAGE!
	ENDLOCAL
GOTO :EOF

