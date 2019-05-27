#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Variable setup   ;
;____________________;

GUI_X := 400 ;Sets variable for the X size of the GUI
GUI_Y := 200 ;Sets variable for the Y size of the GUI
PAUSE_TIMER := 4500
variables := "variables.ini" ;Variable for the ini file. Sorta uneccesary but doesn't really matter
scriptState := "Running" ;Initialisation for status text variable
IniRead, waifuCounter, %variables%, waifubot, waifuCount ;Reads waifu count from the main script passthrough

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Main Script(Subroutine jumps)   ;
;___________________________________;

GoSub, gui_calc ;Calculates the position of the GUI and the total time
GoSub, gui_elements ;Creates the GUI and the GUI elements
GoSub, update_loop ;Creates running loop to change GUI elements
exitApp ;Exits the script

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Additional hotkeys   ;
;________________________;

~^F3:: ;Pauses script on ctrl+F3. ~ is so it can work at the same time as the GUI script
  Pause, Toggle, 1 ;Pauses the thread. Don't really know the options of the pause command but it works so ¯\_(ツ)_/¯
  scriptState := "Paused" ;Sets the script state to paused. This is used later in the update loop to change it back to running
  GuiControl, , statusToggle, % "Current Status: " . scriptState ;Changes the text of the status element
return

~^F4:: ;Pauses script on ctrl+F4. ~ is so it can work at the same time as the GUI script
  scriptState := "Stopped" ;Sets script state to stopped. Same reason as F3 hotkey
  GuiControl, , statusToggle, % "Current Status: " . scriptState ;Changes the text of the status element

  ; loop to wait until the main script is also finished before it stops the GUI.
  IniRead, exitScript, %variables%, waifubot, exitScript ;Reads the exitScript variable from the ini to see its value
  loop{ ;Loops until the exitScript returns as 1
    IniRead, exitScript, %variables%, waifubot, exitScript ;Continues reading the exitScript variable to detect changes
  }until exitScript = 1
  exitApp ;Exits the script
return

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Main subroutines   ;
;______________________;

gui_calc: ;Calculates the position of the GUI and the total time
  SysGet, ScreenRes, MonitorWorkArea ;Gets the screen resolution of your monitor
  screenResX := ScreenResRight - GUI_X ;position variable that stores the width - x-size of GUI
  screenResY := ScreenResBottom - GUI_Y ;position variable that stores the height - y-size of GUI

  totalTime := Round((waifuCounter + 1) * (0.1 + PAUSE_TIMER / 1000)) ;Calculates the total time using the waifuCount and pause timer
  remainTime := totalTime ;Sets the remaining time to the total time so you can compare when doing the progress bar
return

gui_elements: ;Creates the GUI and the GUI elements
  Gui, 1: New, +AlwaysOnTop, Waifubot ;Creates GUI
  Gui, add, Text, ,Waifubot GUI ;Creates title text
  Gui, add, Text, vremainTime, % "Estimated time remaining: " . remainTime . " seconds" ;Creates remaining time text with remainTime modifier
  Gui, add, Progress, vprogressBar W350 H20 cRed, 0 ;Creates a progress bar that counts up to 100 with progressBar modifier
  Gui, add, Text, , % "Press Ctrl+F3 to pause or Ctrl+F4 to stop" ;Creates instruction text
  Gui, add, Text, vstatusToggle, % "Current Status: Running" ;Creates current status text with statusToggle modifier
  Gui, show, W%GUI_X% H%GUI_Y% X%screenResX% Y%screenResY% NoActivate ;Shows GUI with dimensions calculated in gui_calc. NoActivate puts the GUI in the background
return

update_loop: ;Creates running loop to change GUI elements
  While remainTime > 0 ;Loops for every second in the timer
  {
    Sleep 1000 ;Waits 1 second/1000ms
    remainTime-- ;Takes away 1 from remainTime
    GuiControl, Text, remainTime, % "Estimated time remaining: " . remainTime . " seconds" ;Updates the remaining time text
    barPercent := (100 - (remainTime / totalTime * 100)) ;Calculates the progress bars percentage
    GuiControl 1:, , progressBar, %barPercent% ;Updates the progress bars percentage

    if(scriptState != Running) ;Checks if the the script state isn't running(paused)
    {
      scriptState := "Running" ;Sets the script state to running
      GuiControl, Text, statusToggle, % "Current Status: " . scriptState ;Changes the state back to running
    }
  }
return
