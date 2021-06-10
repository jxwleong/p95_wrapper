#include <Array.au3>
#include <WinAPISys.au3>
#include <WinAPIProc.au3>
#include <MsgBoxConstants.au3>

#AutoIt3Wrapper_Change2CUI=y
;=========================CONSTANT========================
$PRIME95_PATH = @ScriptDir & "\p95v303b6.win32\prime95.exe"
ConsoleWrite ( $PRIME95_PATH & @CRLF)
$CMD_TO_KILL_PRIME95 = @ComSpec & " /C " & " TASKKILL /F /IM Prime95.exe"

#comments-start
https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_EnumProcessWindows.htm

Success: 	The 2D array of the handles to the window and class for the specified process.
[0][0] - Number of rows in array (n)
[0][1] - Unused
[n][0] - Window handle
[n][1] - Window class name
#comments-end
$2D_ARRAY_INDEX_MAIN_WINDOW = 1
$2D_ARRAY_INDEX_MAIN_WINDOW_HANDLE = 0
#comments-start
https://www.autoitscript.com/autoit3/docs/functions/WinList.htm

The array returned is two-dimensional and is made up as follows:
    $aArray[0][0] = Number of windows returned
    $aArray[1][0] = 1st window title
    $aArray[1][1] = 1st window handle (HWND)
    $aArray[2][0] = 2nd window title
    $aArray[2][1] = 2nd window handle (HWND)
    ...
    $aArray[n][0] = nth window title
    $aArray[n][1] = nth window handle (HWND)
#comments-end
$2D_ARRAY_INDEX_WORKER_WINDOW = 4
$2D_ARRAY_INDEX_WINDOW_HANDLE = 0

$mainHwnd = 0
; Array from https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_EnumChildWindows.htm
$childHwnd = 0
$WorkerWinHwnd = 0

;=========================Virtual Key Code================================
; Window Information is grab by https://github.com/jvanegmond/au3_uiautomation/blob/master/Spy/Inspect.exe
; https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
$VKEY_RETURN = 0x0D ; ENTER
$VKEY_ALT = 0x12

$VKEY_0 = 0x30
$VKEY_1 = 0x31
$VKEY_2 = 0x32
$VKEY_3 = 0x33
$VKEY_4 = 0x34
$VKEY_5 = 0x35
$VKEY_6 = 0x36
$VKEY_7 = 0x37
$VKEY_8 = 0x38
$VKEY_9 = 0x39

$VKEY_B = 0x42
$VKEY_C = 0x43
$VKEY_E = 0x45
$VKEY_I = 0x49
$VKEY_L = 0x4C
$VKEY_M = 0x4D
$VKEY_N = 0x4E
$VKEY_X = 0x58
$VKEY_T = 0x54

;=======================TORTURE TEST SUBROUTINE=======================
Func _TORTURE_TEST_NUMBER_OF_THREADS($threads=0)
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_T, 0)
   If $threads <> 0 Then Send(string($threads))
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_T, 2)
EndFunc

Func _TORTURE_TEST_SMALLEST_FFT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_2, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_2, 2)
EndFunc

Func _TORTURE_TEST_SMALL_FFT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_3, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_3, 2)
EndFunc

; MEDIUM FFT is grayed out in my machine...
; p95v303b6.win32
Func _TORTURE_TEST_MEDIUM_FFT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_4, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_4, 2)
EndFunc

Func _TORTURE_TEST_LARGE_FFT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_L, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_L, 2)
EndFunc

Func _TORTURE_TEST_BLEND_FFT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_B, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_B, 2)
EndFunc

Func _TORTURE_TEST_CUSTOM_FFT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_C, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_C, 2)
EndFunc

Func _TORTURE_TEST_CUSTOM_MIN_FFT($fftSize=0)
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_N, 0)
   If $fftSize <> 0 Then Send(string($fftSize))
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_N, 2)
EndFunc

Func _TORTURE_TEST_CUSTOM_MAX_FFT($fftSize=0)
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_X, 0)
   If $fftSize <> 0 Then Send(string($fftSize))
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_X, 2)
EndFunc

Func _TORTURE_TEST_CUSTOM_RUN_INPLACE()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_I, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_I, 2)
EndFunc

Func _TORTURE_TEST_CUSTOM_MEMORY($memory=0)
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_M, 0)
   If $memory <> 0 Then Send(string($memory))
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_M, 2)
EndFunc

Func _TORTURE_TEST_CUSTOM_TIME_FOR_EACH_FFT($time=0)
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_T, 0)
   If $time <> 0 Then Send(string($time))
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_T, 2)
EndFunc

Func _TORTURE_TEST_OK($hWnd)
   ControlClick($hWnd, "", "OK")
   ;send("{ENTER}")

EndFunc


;====================MENU ITEM========================
Func _PRIME_95_MENU_ITEM_TEST()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_T, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_T, 2)
EndFunc

Func _PRIME_95_STOP_ALL_WORKER()
   ; Assume after calling _PRIME_95_MENU_ITEM_TEST()
   ; there the drop down boxes are not highlighted.
   Send("{UP}")
   Send("{UP}")
   Send("{ENTER}")
   Send("{ENTER}")
EndFunc

Func _PRIME_95_MENU_ITEM_EDIT()
   ; 0 - Down, 2 - Up
   ; https://www.autoitscript.com/autoit3/docs/libfunctions/_WinAPI_Keybd_Event.htm
   _WinAPI_Keybd_Event ($VKEY_ALT, 0)
   _WinAPI_Keybd_Event ($VKEY_E, 0)
   _WinAPI_Keybd_Event ($VKEY_ALT, 2)
   _WinAPI_Keybd_Event ($VKEY_E, 2)
EndFunc

Func _PRIME_95_GET_LOG($logPath="prime95.log")
   ; https://www.autoitscript.com/forum/topic/117880-how-to-delete-contents-of-a-text-file-s/
   Sleep(350)
   Send("{ENTER}")
   $hFO = FileOpen($logPath, 2)
   FileWrite($hFO, "")
   FileClose($hFO)
   ; https://www.autoitscript.com/forum/topic/48666-wats-the-function-for-copypaste/
   FileWrite($logPath, ClipGet())
   ClipPut("")
EndFunc

;=====================Window Handler Functions========================
Func _GetHwndFromPID($PID)
    $hWnd = 0
    $stPID = DllStructCreate("int")
    Do
        $winlist2 = WinList()
        For $i = 1 To $winlist2[0][0]
            If $winlist2[$i][0] <> "" Then
                DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $winlist2[$i][1], "ptr", DllStructGetPtr($stPID))
                If DllStructGetData($stPID, 1) = $PID Then
                    $hWnd = $winlist2[$i][1]
                    ExitLoop
                EndIf
            EndIf
        Next
        Sleep(100)
    Until $hWnd <> 0
    Return $hWnd
 EndFunc ;==>_GetHwndFromPID

; Find all the window handlers given PID
; Will set $mainHwnd for main window And
; $childHwnd for child window(s)
; $WorkerWinHwnd for Worker status windows (merged)
Func getWinHwnd($pid)
   Global $mainHwnd
   Global $childHwnd
   Global $WorkerWinHwnd
   Global $2D_ARRAY_INDEX_WORKER_WINDOW
   Global $2D_ARRAY_INDEX_WINDOW_HANDLE

   $mainHwndArray = _WinAPI_EnumProcessWindows ( $PID )
   $mainHwnd = $mainHwndArray[$2D_ARRAY_INDEX_MAIN_WINDOW][$2D_ARRAY_INDEX_MAIN_WINDOW_HANDLE]
   $childHwnd = _WinAPI_EnumChildWindows($mainHwnd)
   $WorkerWinHwnd = $childHwnd[$2D_ARRAY_INDEX_WORKER_WINDOW][$2D_ARRAY_INDEX_WINDOW_HANDLE]
EndFunc

;=================MISC================
Func runExe($exe_path)
   Local $PID = Run($exe_path, "")
   WinWaitActive ("Prime95")	; Activate prime95 windows
   return $PID
EndFunc   ;==>Example

;=================MAIN===============
;~ _TORTURE_TEST_SMALLEST_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_NUMBER_OF_THREADS("2")
;~ Sleep(1000)
;~ _TORTURE_TEST_SMALLEST_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_SMALL_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_MEDIUM_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_LARGE_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_BLEND_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_FFT()
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_MIN_FFT("8")
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_MAX_FFT("2222")
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_RUN_INPLACE()
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_RUN_INPLACE()
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_MEMORY("111")
;~ Sleep(1000)
;~ _TORTURE_TEST_CUSTOM_TIME_FOR_EACH_FFT("12")
;~ ;Send("2")



RunWait($CMD_TO_KILL_PRIME95, "", @SW_HIDE) ;~ Runs command hidden
$pid = runExe($PRIME95_PATH)
; This is the "Torture test" handler
$prime95Hwnd = _GetHwndFromPID($pid)

WinWaitActive ("Run a Torture Test")
;WinSetOnTop("Run a Torture Test", "", $WINDOWS_ONTOP)
BlockInput($BI_DISABLE)

_TORTURE_TEST_OK($prime95Hwnd)

; This function set $mainHwnd, $childHwnd and $WorkerWinHwnd
getWinHwnd($PID)
WinWaitActive ($mainHwnd)
;WinSetOnTop ($mainHwnd, "", $WINDOWS_ONTOP)
BlockInput($BI_ENABLE)

Sleep(10000)

BlockInput($BI_DISABLE)
WinActivate($mainHwnd, "")
Sleep(100)
_PRIME_95_MENU_ITEM_TEST()
_PRIME_95_STOP_ALL_WORKER()
_PRIME_95_MENU_ITEM_EDIT()
_PRIME_95_GET_LOG()
BlockInput($BI_ENABLE)

ConsoleWrite ("KILL!" & @CRLF)
RunWait($CMD_TO_KILL_PRIME95, "", @SW_HIDE) ;~ Runs command hidden




