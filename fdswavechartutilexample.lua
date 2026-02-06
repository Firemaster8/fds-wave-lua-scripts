--display the wave table with dots
waveUtils = require("fdsWavetUtils");

function displayFDSCallback()
	local xOff = 1
	local yOff = 1
	
	
	drawFDSWaveDots(xOff,yOff)
	xOff = xOff + 70
	drawFDSWaveConnectedLines(xOff,yOff)
	xOff = xOff + 70
	drawFDSWaveVerticalLines(xOff,yOff)
	
	printFDSWaveValues(1,73)
	
end
addWaveWriteCallback()
--add misc callbacks
emu.addEventCallback(displayFDSCallback, emu.eventType.endFrame)
--Display a startup message
emu.displayMessage("Script", "LET'S FREAKING GOOOOOO!!!!!")