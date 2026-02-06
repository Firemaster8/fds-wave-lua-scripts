--collect and save wave data.
require("fdsWavetUtils")
require("Selector")
require("MouseState")
require("button")
require("pathStuff")
require("waveDocumentorUtil")
require("waveDocumentorFileIO")

showWave = true

Selector.x =92
Selector.y =1
saveButton = Button:new(68,1,20,"Save",saveAllWaveData)
loadButton = Button:new(68,11,20,"Load",loadWaveAllWaveData)
showButton = Button:new(1,1,21,"Hide",function (self) 
	showWave = not showWave
	self.text = "Show"
	if showWave then
		self.text = "Hide"
	end
end)
clearButton = Button:new(68,21,22,"Clear",function()
	resetEverything()
	emu.displayMessage("Clear", "Wave data cleared!")
end)

function mainCallback()
	MouseState:update()
	checkWaveBuffer()
	showButton:checkClick()
	showButton:draw()
	if showWave== false then
		return
	end
	Selector:checkButtons()
	saveButton:checkClick()
	loadButton:checkClick()
	clearButton:checkClick()
	dispWave= waveBuffer
	if #foundWaveTables ~= 0 then
		dispWave= foundWaveTables[Selector.index].waveData
	end
	drawFDSWaveVerticalLines(1,1,dispWave)
	
	Selector:draw()
	saveButton:draw()
	loadButton:draw()
	clearButton:draw()
end



--add callbacks
addWaveWriteCallback()
emu.addEventCallback(mainCallback, emu.eventType.endFrame)
--Display a startup message
emu.displayMessage("Script", "Wave table documentor started!")