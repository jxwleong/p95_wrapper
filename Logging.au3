#include <Date.au3>
#include <File.au3>

const $WRITE_MODE_ERASE_FILE_CONTENT = 2

Func _Log($Message, $File=(StringSplit(@ScriptName, ".")[1]) & ".log", $Mode="a")
   ; Calculated the number of Hours this year
   ; _NowCalc() return string with this format YYYY/MM/DD HH:MM:SS
   $CurrentTime = StringReplace(_NowCalc(), "/", ":")

   ConsoleWrite($CurrentTime & " : " &$Message & @CRLF)
   If $Mode = "w" Then
	  $File = FileOpen($File, $WRITE_MODE_ERASE_FILE_CONTENT)
   EndIf
   _FileWriteLog($File, $Message & @CRLF) ; Write to the logfile passing the filehandle returned by FileOpen.
   FileClose($File) ; Close the filehandle to release the file.
EndFunc
