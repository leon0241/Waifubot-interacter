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

~^F3:: ;Pauses script on ctrl+F3
  Pause
Return

~^F4:: ;Breaks loop on ctrl+F4 to stop the script
  loopBreak := 1 ;Toggles variable for break condition
Return

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Main Scripts   ;
;__________________;

;F1 script - Interacts with all waifus
^F1::
  GoSub, variable_setup ;Setups variables and arrays

  ;Input for your waifus
  InputBox, waifuCount, Interact counter, % "How many waifus do you want to interact with?", , ,150, , , , , % "e.g: 24"
  GoSub, gui_check ;Checks to see if you cancelled to see whether to run the GUI

  ;Outputting waifu text
  Loop, % (waifuCount + 1) ;Starts loop which repeats for every waifu you have. +1 is so it interacts with id 0
  {
    if(loopBreak = 1) ;Check for cancellation
      break ;Breaks the while loop

    Send, % "w.interact " . waifuCount ;Type out the "w.interact [x]" message
    GoSub, message_finish ;Returns and waits after a message
    waifuCount-- ;Takes away 1 from var waifuCount so the message decrements
  }

  GoSub, script_finish ;Actions for after the script has finished looping
return

;F2 script - interact with individual waifus
^F2::
  GoSub, variable_setup ;Setups variables and arrays

  ;Input for your waifus
  loop ;Loops infinitely until you cancel/escape
  {
    Inputbox, msgValue , Interact counter, % "Type the waifus you want to interact with one by one. Press the cancel button when you've inputted all your waifus in.", , , ,120, , , , % "e.g: 151"
    If(ErrorLevel = 1)
      break ;Breaks the loop and moves over to the output

    iWaifuCount[A_Index] := msgValue ;Puts variable in [x] of array
    waifuCount++ ;Increases the waifu count by 1 for running array
  }

  ;GUI launch
  if(ErrorLevel = 1 AND waifuCount = 0) ;Checks to see if you cancelled from the start
    loopBreak := 1 ;Sets break condition
  else ;GUI launch if not cancelled
    GoSub, run_gui ;Sets the waifu count and runs the GUI script

  ;Outputting waifu text
  waifuCount -- ;Takes 1 away from waifuCount so the first line isn't empty
  loop, % WaifuCount ;Loops for WaifuCount times
  {
    if(loopBreak = 1) ;Check for cancellation
      break ;Breaks the while loop

    Send, % "w.interact " . iWaifuCount[A_Index] ;Types out the "w.interact [x]" message
    GoSub, message_finish ;Returns and waits after a message
  }

  GoSub, script_finish ;Actions for after the script has finished looping
return

^F5::
  GoSub, variable_setup ;Setups variables and arrays
  GoSub, create_working_gui ;Creates GUI for working script
return

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Subprocesses   ;
;__________________;

variable_setup: ;[general] Setups variables and arrays
  waifuCount := 0 ;Resets waifu count number
  loopBreak := 0 ;Resets break condition
  iniWrite, 0, %VARIABLES%, waifubot, exitScript ; resets exit script condition

  iWaifucount := [] ;Sets up the array for the individual waifus.

  retireCheck := 0 ;Resets retire checkbox variable
  individualCheck := 0 ;Resets individual checkbox variable
  iWorkID := [] ;Sets up array for individual work ID's
return

gui_check: ;[general] Checks to see if you cancelled to see whether to run the GUI
  if(ErrorLevel = 1) ;Checks to see if you cancelled the message box
    loopBreak := 1 ;Sets break condition
  else ;GUI launch
    GoSub, run_gui ;Sets the waifu count and runs the GUI script
return

run_gui: ;[general] Sets the waifu count and runs the GUI script
  iniWrite, %waifuCount%, %VARIABLES%, waifubot, waifuCount ;[GUI] Writes the amount of waifus you have into the ini file
  Run, waifubot_gui.exe ;Runs the script for the GUI
return

message_finish: ;[general] Returns and waits after a message
  Sleep, 100 ;Short wait to ensure the enter keystroke is measured
  Send, {enter} ;Enter keystroke to send the message into the chat
  Sleep, % PAUSE_TIMER ;Pause to wait for the cooldown
return

script_finish: ;[general] Actions for after the script has finished looping
  iniWrite, 1, %VARIABLES%, waifubot, exitScript ;Writes exit script condition
  if(loopBreak = 1) ;Checks if break variable is true
    MsgBox, Interaction cancelled ;Message box to signal cancellation
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
   Gui, hide ;Hides GUI
   MsgBox, Interaction cancelled
return

w_confirm: ;[working] Actions to take after you press the confirm button(main body)
  Gui, hide ;Hides GUI

  if(retireCheck = 1) ;Checks if retireCheck is 1 or 0
    waifuCount := 10 ;Sets waifuCount to 10 so it repeats 5 + 5 times for retirement
  else
    waifuCount := 5

  if(individualCheck = 0) ;Runs if the individual waifus checkbox isn't checked.
  {
    Inputbox, workID , Waifu worker, % "Type the lowest id for the waifus you want to work", , , ,120, , , , % "e.g: 24"
    GoSub, gui_check ;Checks to see if you cancelled to see whether to run the GUI
    GoSub, working_loop ;Types and increments working values
    GoSub, script_finish ;Actions for after the script has finished looping
  }
  else ;Runs if individual waifus checkbox is checked
  {
    loop, % waifuCount ;Loops for waifuCount amount
    {
      InputBox, workID, Waifu worker, % "Type the id of the waifu you want to work", , , ,120
      iWorkID[A_Index] := workID ;Sets value of the input box to [x] of the array
    }

    GoSub, run_gui ;Sets the waifu count and runs the GUI script
    GoSub, working_loop ;Types and increments working values
    GoSub, script_finish ;Actions for after the script has finished looping
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
    GoSub, message_finish ;Returns and waits after any message
  }
return
