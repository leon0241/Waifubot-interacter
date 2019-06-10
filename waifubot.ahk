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

PAUSE_TIMER := 4500 ;Variable for how long it waits before sending the next message
variables := "variables.ini" ;Variable for the ini file. Sorta uneccesary but doesn't really matter
iniWrite, 0, %variables%, waifubot, waifuCount ;Writes in a blank value into the ini file

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Additional Hotkey setup   ;
;_____________________________;

~^F3:: ;Pauses script on ctrl+F3. ~ is so it can work at the same time as the GUI script
  Pause
Return

~^F4:: ;Breaks loop on ctrl+F4 to stop the script. ~ is so it can work at the same time as the GUI script
  loopBreak := 1 ;Variable for break condition. A statement in the loop checks if it's 1 or 0
Return

;‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾;
;   Main Scripts   ;
;__________________;

;F1 script - Interacts with all waifus
^F1:: ;Starts script on Ctrl+F1
  ;Variable setup
  waifuCount := 0 ;Resets waifu count number
  loopBreak := 0 ;Resets break condition
  iniWrite, 0, %variables%, waifubot, exitScript ;[GUI] resets exit script condition

  ;Input for your waifus
  InputBox, waifuCount, Interact counter, % "How many waifus do you want to interact with?", , ,150, , , , , % "e.g: 24" ;Message box to determine how many waifus you want to interact with
  if(ErrorLevel = 1) ;Checks to see if you cancelled the message box
    loopBreak = 1 ;Sets break condition
  else ;GUI launch
  {
    iniWrite, %waifuCount%, %variables%, waifubot, waifuCount ;[GUI] Writes the amount of waifus you have
    Run, waifubot_gui.ahk ;Runs the script for the GUI
  }

  ;Output for your waifus
  Loop, % waifuCount ;Starts loop which repeats for every waifu you have
  {
    if(loopBreak = 1) ;Check for cancellation with the break condition
    {
      MsgBox, Interaction cancelled ;Message box to signal a cancellation
      break ;Breaks the while loop
    }

    Send, % "w.interact " . waifuCount ;Type out the "w.interact [x]" message
    Sleep, 100 ;Short pause. the enter keystroke doesn't register if you don't pause. potentially can be lower but i couldn't be bothered testing the boundaries
    Send, {enter} ;Enter keystroke to send the message into the chat
    Sleep, %PAUSE_TIMER% ;Pause to wait for the cooldown
    waifuCount-- ;Takes away 1 from var waifuCount so the loop will end once it's at 0
  }

  ;Finish
  MsgBox, Successfully interacted ;Message box to signal ending
  iniWrite, 1, %variables%, waifubot, exitScript ;[GUI] Writes exit script condition
return

;F2 script - interact with individual waifus
^F2:: ;Starts event on Ctrl+F2
  ;Variable setup
  waifuCount := 0 ;Resets waifu count number. Also acts as running total counter
  loopBreak := 0 ;Resets break condition
  iWaifucount := [] ;Sets up the array for the individual waifus.

  ;Input for your waifus
  loop{ ;Loops infinitely until you cancel/escape
    Inputbox, msgValue , Interact counter, % "Type the waifus you want to interact with one by one. Press the cancel button when you've inputted all your waifus in.", , , ,120, , , , % "e.g: 151"
    If(ErrorLevel = 1) ;stops when you press the cancel button. Reason why it's an if break loop and not a loop until is so it doesn't store the "e.g: 151" as part of the array
      break ;Breaks the loop and moves over to the output

    iWaifuCount[waifuCount] := msgValue ;Puts variable in [x] of array
    waifuCount++ ;[GUI] Increases the waifu count by 1
  }

  ;GUI launch
  iniWrite, %waifuCount%, %variables%, waifubot, waifuCount
  iniWrite, 0, %variables%, waifubot, exitScript
  Run, waifubot_gui.ahk

  waifuCount -- ;Takes 1 away from waifuCount. Used so the first line isn't empty

  ;Output of your waifus
  if(waifuCount >= 0) ;Whole second loop around an if statement. This is only so it doesn't spit out an empty interaction if you cancel from the get-go
  {
    loop, %WaifuCount% ;Loops infinitely until it meets the until condition
    {
      if(loopBreak = 1) ;Check for cancellation
      {
        MsgBox, Interaction cancelled ;Message box to signal a cancellation
        break ;Breaks the while loop
      }

      Send, % "w.interact " . iWaifuCount[waifuCount] ;Types out the "w.interact [x]" message
      Sleep, 100 ;Short pause since the enter keystroke doesn't register if you don't pause. potentially can be lower but i couldn't be bothered testing the boundaries
      Send, {enter} ;Enter keystroke to send the message into the chat
      Sleep, %PAUSE_TIMER% ;Pause to wait for the cooldown
      waifuCount-- ;Decrements arrayX by one for the running total
    }
  }

  ;Finish
  MsgBox, Successfully interacted ;Message box to signal ending
  iniWrite, 1, %variables%, waifubot, exitScript ;[GUI] Writes exit script condition
return

^F5::
  retireCheck = 0
  individualCheck = 0

  Gui, 2: new, , Waifubot
  Gui, add, text, ,Waifu worker
  Gui, add, Checkbox, gretire_check, % "retire currently working waifus"
  Gui, add, Checkbox, gindividual_check, % "Send individual waifus to work"
  Gui, add, button, Y75 X50 W100 gw_confirm, Confirm
  Gui, add, button, Y75 X250 W100 gw_cancel, Cancel
  Gui, show, W400 H100
return

retire_check:
  retireCheck = 1
return

individual_check:
  individualCheck = 1
return

w_confirm:
  Gui, hide

  if(retireCheck = 1)
    waifuCount := 10
  else
    waifuCount = 5

  if(individualCheck = 0)
  {
    Inputbox, workID , Waifu worker, % "Type the lowest id for the waifus you want to work", , , ,120, , , , % "e.g: 24"

      Loop, % WaifuCount
      {
        if (waifuCount > 5)
          Send, % "w.retire " . workID
        else
          Send, % "w.work " . workID ;Type out the "w.interact [x]" message

        Sleep, 100 ;Short pause. the enter keystroke doesn't register if you don't pause. potentially can be lower but i couldn't be bothered testing the boundaries
        Send, {enter} ;Enter keystroke to send the message into the chat
        ;Sleep, %PAUSE_TIMER% ;Pause to wait for the cooldown
        workID ++
        waifuCount --
      }

  }
  else
  {
    loop, % waifuCount
    {
      InputBox, workID, Waifu worker, % "Type the id of the waifu you want to work", , , ,120
      iWorkID[A_Index] := workID
    }

    loop, % waifuCount
    {
      if(waifuCount > 5)
      {
        Send, % "w.work" . iWorkID[A_Index]
      }


      Send, % "w.work" . iWorkID[A_Index]
      Sleep, 100
      Send, {enter}
    }

  }
return

w_cancel:
  Gui, hide
return
