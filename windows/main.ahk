SendMode("Input")
SetWorkingDir("C:\\Users\\" A_UserName)
#SingleInstance Force

#HotIf
#Enter::Run('*runas wt.exe')
#b::Run('firefox.exe')
#q::WinClose('A')
#HotIf

#SingleInstance Force

; Paste from clipboard script
; Define the hotkey for Shift + Insert
+Insert:: {
    ClipContent := A_Clipboard
    if ClipContent {
        SendText(ClipContent)
    } else {
        MsgBox('Clipboard is empty!')
    }
}
return
