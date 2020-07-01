#NoEnv
SendMode Input
SetWorkingDir C:\Users\%A_UserName%
#SingleInstance force

#Enter::Run, *runas wt.exe
#b::Run, firefox.exe
#q::WinClose, A
