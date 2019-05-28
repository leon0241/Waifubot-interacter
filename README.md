# Waifubot-interacter
Scripts to interact with the discord bot WaifuBot written in AutoHotKey

## Why would you want this?
Waifubot has an annoying cooldown timer, and it's a lot of hassle spending 20 minutes of your time spamming a chat with interactions

## Installing
There are multiple files included, but the ones you'll need are waifubot.ahk or waifubot.exe. A list of the files and their uses are down below if you want to read more. Double click on any of the files to run the file

If you want the script to run on startup,
- create a shortcut to your script
- type %appdata% into your file managers path bar.
- navigate to Microsoft\Windows\Start Menu\Programs\Startup
- put your shortcut in there

## How to use
There are 2 scripts in the file, one to interact with all your waifus going down a list, and one where you pick the waifus you want interacted with.

For the first script, press ctrl+f1 to run the script, and type the highest id in your list into the message box. It will cycle through them one by one.

For the second script, press ctrl+f2 to run, and type each waifu you want interacted with one by one into the message box. When you've entered them all, press cancel and it will cycle through your inputted list.

If you ever want to cancel the script halfway through, *hold* f4 until the message box appears saying it's cancelled.

## Files and their uses
- variables.ini: Acts as a passthrough for variables between the GUI and master script. Also includes the variable for the waiting timer in case you ever want to edit that to make it longer/shorter
- waifubot.ahk: Master AHK file that runs the scripts.
- waifubot_exe.ahk: AHK file with a changed run command so it will run the GUI's exe file instead of the autohotkey
- waifubot.exe: Compiled version of waifubot_exe.ahk
- waifubot_gui.ahk: Code for the GUI
- waifubot_gui.exe: compiled version of the GUI

## To Do list
###priority
- Add working/retire script
- Add central GUI for convenience
- Move f2 script to the side
- add stop message if on wrong channel
###uncertain if possible
- add some way to do it minimised
- add some way to do an f2 script without typing numbers yourself
