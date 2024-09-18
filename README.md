# README

## Description
This is a simple OSX program to create "Lighthouse" puzzles for print and solve.

## Rules
The board is a 2 dimensional square grid.
Each cell may have one of three types:
  Water
  Lighthouse
  Boat


## Requirements
OSX 14 (Sonoma) or later. (that is what it was written on, but has very little specific code, so may work on earlier)
XCode 16 or later. (Again what it was written on, code might work on earlier if you make a new project)

## Run
Run in XCode, or launch from icon.
Choose width, height, and number of ships. (if ships are too dense, no puzzle will be generated)

Choose a filename and press "save"
in: /Users/<Current User>/Library/Containers/com.npc.LighthouseGenerator/Data
you should see:
<Filename>_<save count>_puzzle.pdf
<Filename>_<save count>_solved.pdf

you can then print the "Puzzle" one and try to solve. 
