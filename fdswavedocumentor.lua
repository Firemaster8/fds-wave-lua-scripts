--collect and save wave data. note wip, highly recommend editing the saving part of the script for your preference
--or just remove the feature lol
require("fdsWavetUtils")
require("Selector")
require("MouseState")
require("button")
require("pathStuff")
require("waveDocumentorUtil")
require("waveDocumentorFileIO")

Selector.x =92
Selector.y =1
saveButton = Button:new(68,1,20,"Save",saveAllWaveData)
loadButton = Button:new(68,11,20,"Load",loadWaveAllWaveData)

function mainCallback()
	MouseState:update()
	Selector:checkButtons()
	checkWaveBuffer()
	saveButton:checkClick()
	loadButton:checkClick()
	dispWave= foundWaveTables[Selector.index]
	drawFDSWaveVerticalLines(1,1,dispWave)
	Selector:draw()
	saveButton:draw()
	loadButton:draw()
end



--add callbacks
addWaveWriteCallback()
emu.addEventCallback(mainCallback, emu.eventType.endFrame)
--Display a startup message
emu.displayMessage("Script", "LET'S FREAKING GOOOOOO!!!!!")