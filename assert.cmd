@SETLOCAL EnableDelayedExpansion & @ECHO OFF
	SET "THEME=vivid.cmd"
	CALL !THEME! 100,150,255;0,0,0
		CMD /C !Metric!
		SET "FAIL=%ErrorLevel%"
	IF %FAIL% EQU 0 CALL !THEME! 100,255,100;0,0,0
	IF %FAIL% NEQ 0 CALL !THEME! 255,100,100;0,0,0
		SET Report=[%TIME::=:%] FAIL=%FAIL%: !Remark!
		ECHO !Report!
		SET Input
		SET Metric
		ECHO !Report!>> !LOG!
		SET Input>> !LOG! 2>1
		SET Metric>> !LOG!
		ECHO.>> !LOG!
	CALL !THEME! --off
GOTO :EOF

