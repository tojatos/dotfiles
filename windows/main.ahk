#NoEnv
SendMode Input
SetWorkingDir C:\Users\%A_UserName%
#SingleInstance force

#Enter::Run, *runas wt.exe
#b::Run, firefox.exe
#q::WinClose, A

#SingleInstance force

; Paste from clipboard script
; Define the hotkey for Shift + Insert
+Insert::
{
    ; Retrieve the current clipboard content
    ClipContent := Clipboard

    ; Check if clipboard contains text
    if (ClipContent)
    {
        ; Send the clipboard contents as keystrokes
        SendRaw, %ClipContent%
    }
    else
    {
        ; If clipboard is empty, send a message
        MsgBox, Clipboard is empty!
    }
}
return
