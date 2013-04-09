#SingleInstance Force
#Include %A_ScriptDir%\common.ahk

OutputDebug ahkba: Hi from AutoHotkey.ahk


; ----------------------- end of auto-exec --------------------- 

mywin_ctrl(class,cmd_line,working_dir = "")
{
  IfWinActive, ahk_class %class% 
  {
       WinMinimize
  }
  else IfWinExist ahk_class %class%
  {
	WinActivate
  }
  else
  {
	Run %cmd_line%, %working_dir%
  }
  return
}

app_toggle_chrome() {
  mywin_ctrl("Chrome_WidgetWin_1","c:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
}
app_toggle_onenote() {
  mywin_ctrl("Framework::CFrame","C:\Program Files (x86)\Microsoft Office\Office14\ONENOTEM.EXE")
}
app_toggle_totalcmd() {
  mywin_ctrl("TTOTAL_CMD","c:\Program Files (x86)\Total Commander\Totalcmd.exe")
}
app_toggle_procexp() {
  mywin_ctrl("PROCEXPL","c:\Program Files (x86)\Procexp\procexp.exe")
}
app_toggle_nx() {
  mywin_ctrl("cygwin/xfree86 rl","c:\Program Files (x86)\NX Client for Windows\nxclient.exe")
}
app_toggle_vs() {
  mywin_ctrl("SlickEdit","c:\Program Files (x86)\SlickEditV15.0.1\win\vs.exe")
}
app_toggle_foobar2k() {
  mywin_ctrl("{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}","c:\Program Files (x86)\foobar2000\foobar2000.exe")
}

app_toggle_conemu() {
  mywin_ctrl("VirtualConsoleClass", "C:\Program Files\Far Manager\ConEmu64.exe", "C:\Users\assaf")
}


print_hot_string_and_keys()
{
  hotstrings :=
  hotkeys := 
  FileRead, Script, %A_ScriptName%
  Loop, parse, script, `n, `r
  {
    RegExMatch(A_LoopField,"\:.*\:(.*)\:\:",hs)
    If (hs1 <> "")
      hotstrings .= A_LoopField . "`n"
    hs= ; just to be sure

    RegExMatch(A_LoopField,"[<>#\^!\+]+([a-zA-Z0-9_]+)\:\:[^a-zA-Z0-9_]",hk)
    If (hk1 <> "")
      hotkeys .= A_LoopField . "`n"
    hk= ; just to be sure
  }
  MsgBox % "Hotstrings" . "`n" . hotstrings . "Hotkeys" . "`n" . hotkeys
}


; ----------------------- Hot-keys section ---------------------

; Map the capslock to ctrl, maps shift-capslock to capslock 
+Capslock::Capslock
Capslock::Ctrl

Ralt & j::AltTab  ; the original alt-tab window
Ralt & k::ShiftAltTab 

;SC027::
#Tab:: 
Run c:\Users\assaf\Scripts\window_list.ahk
return

#Numpad5:: app_toggle_conemu()

#m::
  WinGetClass, Class, A
  WinGetActiveTitle, Title
  WinGet, Style, Style, A
  MsgBox ,
  (
  The active window info is:
  Title = %Title%
  Class = %Class%
  Style = %Style%
  )
return


/*
Global hotkeys:
<#Capslock::    AutoCommandPicker (other AHK script)
#Numpad0::    ; Run Everything (config in app)
#Numpad1::    ; Mount favorite TC: MyStuff truecrypt (config in app)
#Numpad2::    ; force dismount TC (config in app)
*/

#Numpad3:: print_hot_string_and_keys()

#F2::  app_toggle_chrome()    ; Chrome
#F3::  app_toggle_onenote()   ; MS-Note
#F4::  app_toggle_conemu()    ; Conemu64
#F6::  app_toggle_totalcmd()  ; TotalCommander
#F7::  app_toggle_procexp()   ; process-exp
#F8::  app_toggle_nx()        ; NX
#F9::  app_toggle_vs()        ; SlickEdit
#F10:: app_toggle_foobar2k()  ; FooBar2000

; ----------------------- Hot-strings section ---------------------

:*:]d::  ; Replaces "]d" with the current date
FormatTime, CurrentDateTime,, yyyy/MM/dd  
SendInput %CurrentDateTime%
return

:*:]758::assaf758@gmail.com
:*:]ab::Assaf Ben-Amitai
