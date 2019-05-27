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
  {
    loopBreak = 1 ;Sets break condition
  }
  else ;GUI launch
  {
    iniWrite, %waifuCount%, %variables%, waifubot, waifuCount ;[GUI] Writes the amount of waifus you have
    Run, waifubot_gui.ahk ;Runs the script for the GUI
  }

  ;Output for your waifus
  while(waifuCount >= 0) ;Starts loop which repeats for every waifu you have
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
    {
      break ;Breaks the loop and moves over to the output
    }

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
    loop ;Loops infinitely until it meets the until condition
    {
      if(loopBreak = 1) ;Check for cancellation
      {
        MsgBox, Interaction cancelled ;Message box to signal a cancellation
        break ;Breaks the while loop
      }

      tempCounter := iWaifuCount[waifuCount] ;stores the counter[x] into the temporary variable so it can be read by the send command
      Send, % "w.interact " . tempCounter ;Types out the "w.interact [x]" message
      Sleep, 100 ;Short pause since the enter keystroke doesn't register if you don't pause. potentially can be lower but i couldn't be bothered testing the boundaries
      Send, {enter} ;Enter keystroke to send the message into the chat
      Sleep, %PAUSE_TIMER% ;Pause to wait for the cooldown
      waifuCount-- ;Decrements arrayX by one for the running total
    }until waifuCount < 0 ;Stops the loop when arrayX reaches the bottom so it doesn't loop infinitely
  }

  ;Finish
  MsgBox, Successfully interacted ;Message box to signal ending
  iniWrite, 1, %variables%, waifubot, exitScript ;[GUI] Writes exit script condition
return

^F5::
  Gui, 2: new, +AlwaysOnTop, Waifubot
  Gui, add, text, ,Waifu worker
  Gui, add, Checkbox, , % "Value retires currently working waifus"
  Gui, add, Checkbox, , % "Send individual waifus to work"
  Gui, add, text, ,Type in the lowest ID of the waifu you want to retire
  Gui, Add, edit
  Gui, Add, UpDown, vMyUpDown Range1-10, 5
  Gui, add, button, , Ok
  Gui, add, button, , Cancel
return
