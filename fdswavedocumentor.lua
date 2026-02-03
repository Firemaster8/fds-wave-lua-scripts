--display the wave table with dots gyatt
require("fdsWavetUtils");
require("Selector");
Selector.x =100
lastClick = false
foundWaveTables ={}
foundWaveTables[0] = waveBuffer
function wavesMatched(wave1,wave2)
	for i = 0,#wave1 do
		if wave1[i] ~= wave2[i] then
			return false
		end
	end
	return true
end

function getWaveCopy()
	copyBuffer = {}
	for i =0, #waveBuffer do
		copyBuffer[i] = waveBuffer[i];
	end
	return copyBuffer
end

function getWaveIndex(waveData)
	if Selector.count ==0 then
		return -1
	end
	for i = 0,#foundWaveTables do
		curWave = foundWaveTables[i]
		if wavesMatched(curWave,waveData) then
			return i
		end
	end
	return -1
end

function checkWaveBuffer()
	if waveUpdated==false then
		return
	end
	local index = getWaveIndex(waveBuffer)
	--if wave not in list add it
	if index ==-1 then
		foundWaveTables[Selector.count] =  getWaveCopy()
		Selector.count = Selector.count +1
		Selector:changeIndex(Selector.count-1)
	else
		Selector:changeIndex(index)
	end
	--otherwise move selector to current index
	emu.displayMessage("test", index)
	waveUpdated = false
end

function mainCallback()
	mouseState = emu.getMouseState()
	Selector:checkButtons()
	checkWaveBuffer()
	dispWave= foundWaveTables[Selector.index]
	local xOff = 1
	local yOff = 1
	drawFDSWaveVerticalLines(xOff,yOff,dispWave)
	Selector:draw()
	lastClick = mouseState.left
end



--add callbacks
addWaveWriteCallback()
emu.addEventCallback(mainCallback, emu.eventType.endFrame)
--Display a startup message
emu.displayMessage("Script", "LET'S FREAKING GOOOOOO!!!!!")