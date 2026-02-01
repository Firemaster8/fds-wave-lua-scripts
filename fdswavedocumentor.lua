--display the wave table with dots
waveUtils = require("fdsWavetUtils");
lastPress= false
function mainCallback()
	local curPress = emu.isKeyPressed("\\")
	if curPress == true and lastPress == false then
		emu.displayMessage("Script", "Yeet!")
	end
	lastPress = curPress

	local xOff = 1
	local yOff = 1
	
	drawFDSWaveVerticalLines(xOff,yOff)
	
end

--add callbacks
addWaveWriteCallback();
emu.addEventCallback(mainCallback, emu.eventType.endFrame)
--Display a startup message
emu.displayMessage("Script", "LET'S FREAKING GOOOOOO!!!!!")