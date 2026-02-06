--use this if you want to use require()
-- wave table addresses 0x4040,0x407F
waveStartAddress = 0x4040
waveEndAddress = 0x407F
waveEnableAddress = 0x4089
waveByteLength = waveEndAddress -waveStartAddress +1
local waveHeight = 63
--color
local backColor = 0x302060FF
local waveColor = 0xFF0000
waveWriteEnabled = false
waveWritingCycleCompleted = false
--init array buffer
waveBuffer = {}

--reset buffer and flags
function resetWaveUtil()
	waveBuffer = {}
	waveWriteEnabled = false
	waveWritingCycleCompleted = false
end


--capture written data to table
function writeCallback(address, value)
	waveBuffer[(address - waveStartAddress) +1] = value
	waveUpdated = true
end

--use to flip flags for if the wave table has been enabled
function enableWriteCallback(address, value)
	local enableFlag = value & 128
	if enableFlag == 128 then
		waveWriteEnabled = true
		waveWritingCycleCompleted = false
	end
	if enableFlag == 0 then
		waveWriteEnabled = false
		waveWritingCycleCompleted = true
	end
end

--meant to be called every frame
function waveWrittenSinceLastCheck()
	if waveWritingCycleCompleted then
		waveWritingCycleCompleted = false
		return true
	end
	return false
end

--display raw byte values
function printFDSWaveValues(startX,startY,waveData)
	waveData = waveData or waveBuffer
	local yOff = startY
	local xOff = startX
	for i = 1,#waveData do
		 strHexValue = string.format("%x", waveData[i] )
		 emu.drawString(xOff, yOff, strHexValue, waveColor, backColor)
		 xOff = xOff + 13
		 if xOff >= 244 then 
		 	xOff =startX
		 	yOff = yOff + 10
		 end
	end
end


--drawbackground of wave
function drawWaveBack(xOff,yOff)
	emu.drawRectangle(xOff , yOff, waveByteLength, waveHeight+1, backColor, true, 1)
end

--draw dots of wave table
function drawFDSWaveDots(xOff,yOff,waveData)
	waveData = waveData or waveBuffer
	drawWaveBack(xOff ,yOff)
	for i = 1,#waveData do
		emu.drawPixel(xOff + i -1,yOff -waveData[i] + waveHeight,waveColor);
	end
end

--draw connected dots as lines
function drawFDSWaveConnectedLines(xOff,yOff,waveData)
	waveData = waveData or waveBuffer
	drawWaveBack(xOff ,yOff)
	if #waveData == 0 then
		return
	end
	
	lastX = xOff
	lastY = yOff - waveData[1] + waveHeight
	for i = 2,#waveData do
		local curX = xOff + i -1
		local curY = yOff - waveData[i] + waveHeight
		emu.drawLine(lastX,lastY,curX,curY,waveColor )
		lastX = curX
		lastY = curY
	end
end

--draw with vertical lines
function drawFDSWaveVerticalLines(xOff,yOff,waveData)
	waveData = waveData or waveBuffer
	drawWaveBack(xOff ,yOff)
	lastX = xOff
	for i = 1,#waveData do
		local curX = xOff + i -1
		local curY = yOff -waveData[i] + waveHeight
		emu.drawLine(curX,yOff + waveHeight,curX,curY,waveColor)
	end
end

function addWaveWriteCallback()
	--regester callback to grab writing data to the wave RAM
	emu.addMemoryCallback(writeCallback, emu.callbackType.write,waveStartAddress,waveEndAddress)
	emu.addMemoryCallback(enableWriteCallback, emu.callbackType.write,waveEnableAddress)
end