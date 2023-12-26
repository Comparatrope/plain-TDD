@ECHO OFF
	SET "Result="
	%Input% | FINDSTR /I "%~1"
::	%Input% | FIND /I "%~1"
	SET "Result=%ErrorLevel%"
EXIT /B %Result%

