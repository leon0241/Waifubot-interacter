#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

;Variables setup

;GUI_X, GUI_Y, screenResX, screenResY, variables ;Variables for determining the size of the box
;totalTime, progressBar, remainTime, PAUSE_TIMER, waifuCounter ;Variables to calculate GUI elements
;Global buttonText, , buttonToggle
Global statusToggle

variables := "variables.ini"
GUI_X := 400
GUI_Y := 200
scriptState := "Running"

IniRead, waifuCounter, %variables%, waifubot, waifuCount
IniRead, PAUSE_TIMER, %variables%, waifubot, pauseTimer

;GUI box code
GoSub, gui_box_calc
GoSub, gui_elements
GoSub, time_calculator
exit

~^F3::
  Pause, Toggle, 1
  scriptState := "Paused"
  GuiControl, , statusToggle, % "Current Status:" . scriptState
return

~^F4::
  scriptState := "Stopping"
  GuiControl, , statusToggle, % "Current Status:" . scriptState
  IniRead, exitScript, %variables%, waifubot, exitScript
  loop{
    IniRead, exitScript, %variables%, waifubot, exitScript
  }until exitScript = 1
  exitApp
return

gui_box_calc: ;Calculates the screen resolution and the total time it takes
  SysGet, ScreenRes, MonitorWorkArea
  screenResX := ScreenResRight - GUI_X
  screenResY := ScreenResBottom - GUI_Y

  totalTime := Round((waifuCounter + 1) * (0.1 + PAUSE_TIMER / 1000))
  remainTime := totalTime
return

gui_elements:
  Gui, 1: New, +AlwaysOnTop, Waifubot
  Gui, add, Text, ,Waifubot GUI
  Gui, add, Text, vremainTime, % "Time Remaining: " . remainTime . " seconds"
  Gui, add, Progress, vprogressBar W350 H20 cRed, 100
  Gui, add, Text, , % "Press Ctrl+F3 to pause or Ctrl+F4 to stop"
  Gui, add, Text, vstatusToggle, % "Current Status: Running"
  Gui, show, W%GUI_X% H%GUI_Y% X%screenResX% Y%screenResY% NoActivate
return

time_calculator:
  While remainTime > 0
  {
    Sleep 1000
    remainTime--
    GuiControl, Text, remainTime, % "Time Remaining: " . remainTime . " seconds"
    barPercent := (remainTime / totalTime * 100)
    GuiControl, , progressBar, %barPercent%

    if(scriptState != Running)
    {
      scriptState := "Running"
      GuiControl, Text, statusToggle, % "Current Status: " . scriptState
    }
  }
return
