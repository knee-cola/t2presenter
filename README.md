# What's this?

This is an [AutoHotkey](https://www.autohotkey.com) progam which converts a cheap AirMouse (inertial mouse wireless mouse) into a presentation controler, which can be used with Powerpoint or Google Present.

# Motivation

Since I do a lot of (PowerPoint) presentations, I was thinking of buying a presentation tool [Gyration](http://www.gyration.com) which turns your mouse cursor into a on-screen laser pointer and enables you to easily move from slide to slide.

The problem with Gyration air mouse is that it costs $100. At the same time on e-bay you can find an AirMouse without the presentation features for as little as $7.77

I ended buying the cheap [2.4G T2 AirMouse](url=http://goo.gl/EId07k) and was trying to add features found in Gyration mouse.
The solution came in the form of AutoHotkey. I managed to reproduce the most important feature of the Gyration and have managed to turn the cheep AirMouse into a usefull presentation tool.

In the attachment you can find the source code with all the needed files. The code is designed to work with T2 AirMouse, and might need to be changed in order to work with other devices 

# User instruction manual
## Installation
1) download and install [AutoHotkey](https://www.autohotkey.com) on your computer
2) download the **T2Presenter.ahk** file from this repository 
3) plugin the T2 AirMouse and make sure it works as a regular mouse (Windows should recognize automatically)

## Using it in you presentation
1) run the **T2Presenter.ahk**
3) start your presentation (i.e. Powerpoint)
4) on the AirMouse press the **mute button** to turn on the "presentation mode"

In presentation mode the mouse cursor is relaced by a red laser dot. The laser dot is by default hidden in order it not interfering with the presentation. You need to press the **OK button** on your AirMouse for it to be displayed.

While holding the OK button move the pointer as you wish ... do your presentaton!

After releasing the OK button, the laser pointer becomes invisible again.

Press **mute button** to exit presentation mode.

## Pointer initial position

When the OK button is pressed the laser pointer is positioned in the bottom left corner of the screen.

If however after releasing the OK button you press it again within 2 seconds, the cursor/pointer will be shown at the last position it was visible. After 2 seconds have elapsed, the cursor position will be reset to it's initial position - bottom-left corner of the screen.

## Using other buttons
Here's a list of all the T2 AirMouse buttons and their function (listed as they are positioned on the T2 AirMouse. First let's have a look at key diagram:

![t2presenter-key-diagram](https://rawgit.com/knee-cola/t2presenter/master/assets/key-diagram.jpg | width=100)

### Standard mouse mode

  * **(1) Power** = hold for 5 sec to put the computer in standby mode
  * **(2&3) Volume Up/Down** = volume up/down
  * **(4-7) Up/Down/Left/Right** = up/down/left/right - like similar keys on your keyboard
  * **(8) OK** = left mouse button in standard
  * **(9) Back** = right mouse button
  * **(10) Menu** = display context menu
  * **(11) Home** = open the home page
  * **(12) Cursor On/Off** = turns cursor tracking on/off
  * **(13&14) Page Up/Down** = page up/down in standard
  * **(15) Mute** = turn the presentation mode On

### Presenation mode

  * **(1) Power** = same as in standard mouse mode
  * **(2&3) Volume Up/Down** = change the laser pointer shape
  * **(4-7) Up/Down/Left/Right** = goto next/previous slide
  * **(8) OK** = pointer on/off button
  * **(9) Back** = clear all drawn lines
  * **(10) Menu** = turn drawing mode On (does not work in Google Slides)
  * **(11) Home** = toggle the Powerpoint black screen (does not work in Google Slides)
  * **(12) Cursor On/Off** = turns cursor tracking on/off
  * **(13&14) Page Up/Down** = disabled/not in use
  * **(15) Mute** = turn the presentation mode Off

### Drawing mode (works only in Powerpoint)

  * **(8) OK** = draw a line
  * **(9) Back** = clear all drawn lines
  * **(10) Menu** = turn drawing mode Off
