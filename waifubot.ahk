;The main thing you can adjust is the PAUSE_TIMER variable
;You can increase this number to get more reliable results because the ping of waifubot varies
;The minimum cooldown accounting for no lag is around 3.4 seconds

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance	; Only allows one instance of the script to run.

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Variable setup   ;
;____________________;

iniWrite, 0, %VARIABLES%, waifubot, waifuCount ;Writes in a blank value into the ini file
PAUSE_TIMER := 4500 ;Variable for how long it waits before sending the next message
VARIABLES := "variables.ini" ;Variable for the ini file

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Additional Hotkey setup   ;
;_____________________________;

~^F3:: ;Pauses script on ctrl+F3. ~ is so it can work at the same time as the GUI script
  Pause
Return

~^F4:: ;Breaks loop on ctrl+F4 to stop the script
  loopBreak := 1 ;Variable for break condition. A statement in the loop checks if it's 1 or 0
Return

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Main Scripts   ;
;__________________;

;F1 script - Interacts with all waifus
^F1:: ;Starts script on Ctrl+F1
  ;Variable setup
  GoSub, variable_setup ;Jump to L106

  ;Input for your waifus
  InputBox, waifuCount, Interact counter, % "How many waifus do you want to interact with?", , ,150, , , , , % "e.g: 24"
  GoSub, gui_check ;Jump to L118

  ;Output for your waifus
  Loop, % (waifuCount + 1) ;Starts loop which repeats for every waifu you have
  {
    if(loopBreak = 1) ;Check for cancellation
      break ;Breaks the while loop

    Send, % "w.interact " . waifuCount ;Type out the "w.interact [x]" message
    GoSub, message_finish ;Jump to L130
    waifuCount-- ;Takes away 1 from var waifuCount so the loop will end once it's at 0
  }

  ;Finish
  GoSub, script_finish ;Jump to L136
return

;F2 script - interact with individual waifus
^F2:: ;Starts event on Ctrl+F2
  ;Variable setup
  GoSub, variable_setup ;Jump to L106

  ;Input for your waifus
  loop
  { ;Loops infinitely until you cancel/escape
    Inputbox, msgValue , Interact counter, % "Type the waifus you want to interact with one by one. Press the cancel button when you've inputted all your waifus in.", , , ,120, , , , % "e.g: 151"
    If(ErrorLevel = 1)
      break ;Breaks the loop and moves over to the output

    iWaifuCount[waifuCount] := msgValue ;Puts variable in [x] of array
    waifuCount++ ;[GUI] Increases the waifu count by 1
  }

  ;GUI launch
  if(ErrorLevel = 1 AND waifuCount = 0) ;Checks to see if you cancelled the message box
    loopBreak := 1 ;Sets break condition
  else ;GUI launch
    GoSub, run_gui ;Jump to L125

  waifuCount -- ;Takes 1 away from waifuCount. Used so the first line isn't empty

  ;Output of your waifus
  if(waifuCount >= 0) ;Whole second loop around an if statement. This is only so it doesn't spit out an empty interaction if you cancel from the get-go
  {
    loop, % WaifuCount ;Loops infinitely until it meets the until condition
    {
      if(loopBreak = 1) ;Check for cancellation
        break ;Breaks the while loop

      Send, % "w.interact " . iWaifuCount[waifuCount] ;Types out the "w.interact [x]" message
      GoSub, message_finish ;Jump to L130
      waifuCount-- ;Decrements arrayX by one for the running total
    }
  }

  ;Finish
  GoSub, script_finish ;Jump to L136
return

^F5::
  GoSub, variable_setup ;Jump to L106
  GoSub, create_working_gui ;Jump to L144
return

variable_setup: ;[general] Setups variables and arrays
  waifuCount := 0 ;Resets waifu count number
  loopBreak := 0 ;Resets break condition
  iniWrite, 0, %VARIABLES%, waifubot, exitScript ; resets exit script condition

  iWaifucount := [] ;Sets up the array for the individual waifus.

  retireCheck := 0
  individualCheck := 0
  iWorkID := []
return

gui_check: ;[general] Checks to see if you cancelled to see whether to run the GUI
  if(ErrorLevel = 1) ;Checks to see if you cancelled the message box
    loopBreak := 1 ;Sets break condition
  else ;GUI launch
    GoSub, run_gui ;Jump to L125
return

run_gui: ;[general] Sets the waifu count and runs the GUI script
  iniWrite, %waifuCount%, %VARIABLES%, waifubot, waifuCount ;[GUI] Writes the amount of waifus you have
  Run, waifubot_gui.ahk ;Runs the script for the GUI
return

message_finish: ;[general] Returns and waits after any message
  Sleep, 100 ;Short wait to ensure the enter keystroke is measured
  Send, {enter} ;Enter keystroke to send the message into the chat
  Sleep, % PAUSE_TIMER ;Pause to wait for the cooldown
return

script_finish: ;[general] Actions for after the script has finished looping
  iniWrite, 1, %VARIABLES%, waifubot, exitScript ;Writes exit script condition
  if(loopBreak = 1)
    MsgBox, Interaction cancelled ;Message box to signal a cancellation
  else
    MsgBox, Successfully interacted ;Message box to signal ending
return

create_working_gui: ;[general] Creates GUI for working script
  Gui, 2: new, , Waifubot ;Creates new GUI
  Gui, add, text, ,Waifu worker ;Title text
  Gui, add, Checkbox, gretire_check, % "retire currently working waifus" ;Checkbox for retiring waifus
  Gui, add, Checkbox, gindividual_check, % "Send individual waifus to work" ;Checkbox for sending individual waifus to work
  Gui, add, button, Y75 X50 W100 gw_confirm, % "Confirm" ;Confirm button
  Gui, add, button, Y75 X250 W100 gw_cancel, % "Cancel" ;Cancel button
  Gui, show, W400 H100
return

retire_check: ;[working] Increments if the retire waifus checkbox is pressed
  retireCheck := 1
return

individual_check: ;[working] Increments if the individual waifus checkbox is pressed
  individualCheck := 1
return

w_cancel: ;[working] Cancellation for GUI selection
   Gui, hide
   MsgBox, Interaction cancelled
return

w_confirm: ;[working] Actions to take after you press the confirm button(main body)
  Gui, hide

  if(retireCheck = 1)
    waifuCount := 10
  else
    waifuCount := 5

  if(individualCheck = 0)
  {
    Inputbox, workID , Waifu worker, % "Type the lowest id for the waifus you want to work", , , ,120, , , , % "e.g: 24"
    GoSub, gui_check ;Jump to L118
    GoSub, working_loop ;Jump to L196
    GoSub, script_finish ;Jump to L136
  }
  else
  {
    loop, % waifuCount
    {
      InputBox, workID, Waifu worker, % "Type the id of the waifu you want to work", , , ,120
      iWorkID[A_Index] := workID
    }

    GoSub, run_gui ;Jump to L125
    GoSub, working_loop ;Jump to L196
    GoSub, script_finish ;Jump to L136
  }
return

working_loop: ;[working] Types and increments working values
  Loop, % WaifuCount
  {
    if(loopBreak = 1) ;Check for cancellation
      break ;Breaks the while loop

    ;Check to see what message to send in the chat
    if (waifuCount > 5 AND individualCheck = 0) ;retire and increment
      Send, % "w.retire " . workID
    else if (waifuCount > 5 AND individualCheck = 1) ;retire and individual
      Send, % "w.retire " . iWorkID[A_Index]
    else if (individualCheck = 0) ;work and increment
      Send, % "w.work " . workID
    else ;work and individual
      Send, % "w.work " . iWorkID[A_Index]
    workID ++ ;Increments workID. Doesn't affect individual since it uses a different var.
    waifuCount -- ;Decrements waifuCount. Used for the if loop
    GoSub, message_finish ;Jump to L127
  }
return
