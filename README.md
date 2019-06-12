# Waifubot-interacter
Scripts to interact with the discord bot WaifuBot written in AutoHotKey

## Why would you want this?
Waifubot has an annoying cooldown timer, and it's a lot of hassle spending 20 minutes of your time spamming a chat with interactions

## Installing
There are multiple files included, but if you're just using it, waifubot.exe is the only one you need to pay attention to. A list of the files and their uses are down below if you want to read more. Double click on any of the files to run the file

If you want the script to run on startup,
- create a shortcut to your script
- type %appdata% into your file managers path bar.
- navigate to Microsoft\Windows\Start Menu\Programs\Startup
- put your shortcut in there

## How to use
There are 3 scripts in the file, one to interact with all your waifus going down a list, one where you pick the waifus you want interacted with and one to work / retire your waifus

For the first script, press ctrl+f1 to run the script, and type the highest id in your list into the message box. It will cycle through them one by one.

For the second script, press ctrl+f2 to run, and type each waifu you want interacted with one by one into the message box. When you've entered them all, press cancel and it will cycle through your inputted list.

For the third script, press ctrl+f5 to run, and check your preferred options. Enter your inputs and it will cycle through the list

If you ever want to cancel the script halfway through, Press Ctrl+F4, and the GUI should change to stopping status. Then, when the message box appears, the script has stopped.
You can also press ctrl+F3 to pause the script, and press it again to resume it

## Files and their uses
- variables.ini: Acts as a passthrough for variables between the GUI and master script. Also includes the variable for the waiting timer in case you ever want to edit that to make it longer/shorter
- waifubot.ahk: Master AHK file that runs the scripts.
- waifubot_exe.ahk: AHK file with a changed run command so it will run the GUI's exe file instead of the autohotkey
- waifubot.exe: Compiled version of waifubot_exe.ahk
- waifubot_gui.ahk: Code for the GUI
- waifubot_gui.exe: compiled version of the GUI

## To Do list
### priority
- ~~Add working/retire script~~
- Add central GUI for convenience
- Move f2 script to the side
- add stop message if on wrong channel
- ~~Change loop to use loop, count and a_index~~

### uncertain if possible
- add some way to do it minimised
- add some way to do an f2 script without typing numbers yourself
