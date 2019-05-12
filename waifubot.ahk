;The main thing you will be editing is line 26 - the "Sleep, 4500"
;You can increase this number to get more reliable results because the ping of waifubot varies
;The minimum cooldown accounting for no lag is around 3.4 seconds

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance	; Only allows one instance of the script to run.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   Script to interact with all your waifus.              ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^F1:: ;Starts script on Ctrl+F1

InputBox, waifuCount, Interact counter, How many waifus do you want to interact with?, , ,150, , , , , e.g: 24 ;Message box to determine how many waifus you want to interact with

while(waifuCount >= 0) ;Starts loop which repeats for every waifu you have
{
  if(GetKeyState("F4", "P") or ErrorLevel = 1) ;Check for cancellation
  {
    MsgBox, Interaction cancelled ;Message box to signal a cancellation
    break ;Breaks the while loop
  }

  Send, w.interact %waifuCount% ;Type out the "w.interact [x]". %% indicates the use of a variable
  Sleep, 100 ;Short pause. the enter keystroke doesn't register if you don't pause. potentially can be lower but i couldn't be bothered testing the boundaries
  Send, {enter} ;Enter keystroke to send the message into the chat
  Sleep, 4500 ;Pause to wait for the cooldown
  waifuCount-- ;Takes away 1 from var waifuCount so the loop will end once it's counted down to 0
}

MsgBox, Successfully interacted ;Message box to signal ending
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                         ;
;   Script to interact with multiple individual waifus.   ;
;                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^F2:: ;Starts event on Ctrl+F2

arrayX := 0 ;Sets up the running total counter. There might be a more efficient way of doing this but I can't be bothered looking it up so feel free to do it yourself
iWaifucount := [] ;Sets up the array for the individual waifus.

loop{ ;Loops infinitely until you type stop
  Inputbox, msgCounter , Interact counter, Type the waifus you want to interact with one by one. Press the cancel button when you've inputted all your waifus in., , , ,120, , , ,e.g: 151 ;message box
  If(ErrorLevel = 1) ;stops when you press the cancel button. Reason why it's an if break loop and not a loop until is so it doesn't store the "e.g: 151" as part of the array
  {
    break ;Breaks the loop and moves onto the next part
  }

  iWaifuCount[arrayX] := msgCounter ;Puts variable in [arrayX] of array
  tempCounter := iWaifuCount[arrayX] ;Stores a variable so it can read if the command is to stop
  arrayX++ ;increments arrayX by 1 so the next loop stores the variable in the next array cell
}

arrayX -- ;Takes 1 away from arrayX. Basically a reversal of the the "arrayX++" line so the first entry isn't an empty cell

if(arrayX >= 0) ;Whole second loop around an if statement. This is only so it doesn't spit out an empty interaction if you cancel from the get-go
{
  loop ;Loops infinitely until it meets the until condition on line 80
  {
    if(GetKeyState("F4", "P")) ;Check for cancellation
    {
      MsgBox, Interaction cancelled ;Message box to signal a cancellation
      break ;Breaks the while loop
    }

    tempCounter := iWaifuCount[arrayX] ;stores the counter[arrayX] into the temporary variable so it can be read by the send command
    Send, w.interact %tempCounter%
    Sleep, 100 ;Short pause since the enter keystroke doesn't register if you don't pause. potentially can be lower but i couldn't be bothered testing the boundaries
    Send, {enter} ;Enter keystroke to send the message into the chat
    Sleep, 4500 ;Pause to wait for the cooldown
    arrayX-- ;Decrements arrayX by one for the running total
  }until arrayX < 0 ;Stops the loop when arrayX reaches the bottom so it doesn't loop infinitely
}

MsgBox, Successfully interacted ;Message box to signal ending
return
