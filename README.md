# fds-wave-mesen-lua-script
Some collection of mesen lua script that watches, displays, and even saves data from the fds's wave table.

This is the first time I ever used lua, so expect some noobish coding. These scripts was made for fun but feel free to make suggestions for improvement. 
Also feel free to use this for your own project if you like.

The utility script can display the values in the following: -dots -connected lines -vertical lines (most recommended)

The 2 main scripts to use: 
-"fdswavechartutilexample.lua" creates 3 different types of chart that displays the wave table along with a list of values. 
Mostly for example purposes, feel free to use it as a template.

-"fdswavedocumentor.lua" used for collecting and saving wave data to bin files used throughout gameplay.

Note:
-These scripts only capture the waves that get written to the table during runtime, rather than reading off of the ram directly. 
This is because the wave table cannot be read until a flag in a register is enabled. Otherwise it returns the value of the wave position... which is pretty useless.
As of now, I have no idea how to read directly from the ram table without waiting for the flag to be enabled.

-All wave files are design to save and load with #wave.bin file naming scheme. As of now, there's no way to change the name file.

-Waveforms in legend of zelda are seemingly off center by one pixel/byte. Either this is intended behavior or my indexing is off.

-Some waveforms in Metroid seem to be generated oddly, not sure if it was captured incorrectly or its normal.
