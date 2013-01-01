
#Include c:\Users\assaf\Scripts
;#Include AltTab.ahk

; Map the capslock to ctrl, maps shift-capslock to capslock 
+Capslock::Capslock
Capslock::Ctrl

mywin_ctrl(class,cmd_line)
{
;  return
  IfWinActive, ahk_class %class%
       WinMinimize
  else IfWinExist ahk_class %class%
	WinActivate
  else
	Run %cmd_line%
  return

}

#m::
WinGetClass, Class, A
WinGetActiveTitle, Title
MsgBox, The active window info is: `n * Title = "%Title%"`n * Class = "%Class%"
return

; Global hotkeys:
; activate/minimize/run control key assignments
; Chrome	  #F2
; MS Note         #F3
; ConEmu	  #F4
; TotalCommander  #F6
; process-exp 	  #F7
; NX 	      	  #F8
; SlickEdit   	  #F9
; foobar      	  #F10
; ConEmu - 	  ^`      (setup in app)

#F2::
  mywin_ctrl("Chrome_WidgetWin_1","c:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
return
#F3::
  mywin_ctrl("Framework::CFrame","C:\Program Files (x86)\Microsoft Office\Office14\ONENOTEM.EXE")
return
#F6::
  mywin_ctrl("TTOTAL_CMD","c:\Program Files (x86)\Total Commander\Totalcmd.exe")
return
#F7::
  mywin_ctrl("PROCEXPL","c:\Program Files (x86)\Procexp\procexp.exe")
return
#F8::
  mywin_ctrl("cygwin/xfree86 rl","c:\Program Files (x86)\NX Client for Windows\nxclient.exe")
return
#F9::
  mywin_ctrl("SlickEdit","c:\Program Files (x86)\SlickEditV15.0.1\win\vs.exe")
return
#F10::
  mywin_ctrl("{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}","c:\Program Files (x86)\foobar2000\foobar2000.exe")
return
