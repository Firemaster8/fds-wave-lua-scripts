# fds-wave-mesen-lua-script
Some collecton of mesen lua script that watches,display, and even save data from the fds's wave table. All wip btw

This is the first time I ever used lua, so expect some noobish coding.
These scripts was made for fun but feel free to make suggestions for improvement or make your own modification if you like.

the 2 main scripts to use:
-"fdswavechartutilexample.lua" creates 3 different type of chart that displays the wave table, dots, connected dots, and vertical lines.
Mosty for example purposes, feel free to modify it to your liking.

-"fdswavedocumentor.lua" used for collect and save wave data to bin files used throughout gameplay.

Note:

-The scripts only captures the waves that gets written to the table during runtime, rather than reading off of the ram directly.
This is because the wave table cannot be read until a flag in a register is enabled. Otherwise it returns a garbage value.

all wave files are design to save and load with #wave.bin file naming scheme. As of now there's no way to change the name file.

Waveforms in legend of zelda are seemingly off center by one pixel/byte. Either this is intended behavior or my indexing is off.

Some waveforms in Metroid seems to be generated oddly, not sure if it was captured incorrectly or its normal.
