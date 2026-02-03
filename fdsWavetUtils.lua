--use this if you want to use require()
-- wave table addresses 0x4040,0x407F
waveStartAddress = 0x4040
waveEndAddress = 0x407F
waveEnableAddress = 0x0000
local waveByteLength = waveEndAddress -waveStartAddress +1
local waveHeight = 63
--color
local backColor = 0x302060FF
local waveColor = 0xFF0000
waveUpdated = false
--init array buffer
waveBuffer = {}
--seriously, how does array works in lua?
for i =0,waveByteLength do
waveBuffer[i] =0
end

--capture written data to table
function writeCallback(address, value)
	waveBuffer[address - waveStartAddress] = value
	waveUpdated = true
end

function enableWriteCallback(address, value)
	
end

--display raw byte values
function printFDSWaveValues(startX,startY,waveData)
	waveData = waveData or waveBuffer
	local yOff = startY
	local xOff = startX
	for i = 0,#waveData do
		 strHexValue = string.format("%x", waveData[i] )
		 emu.drawString(xOff, yOff, strHexValue, 0x000000FF, backColor)
		 xOff = xOff + 13
		 if xOff >= 244 then 
		 	xOff =startX
		 	yOff = yOff + 10
		 end
	end
end

--drawbackground of wave
function drawWaveBack(xOff,yOff)
	emu.drawRectangle(xOff , yOff, waveByteLength+1, waveHeight+1, backColor, true, 1)
end

--draw dots of wave table
function drawFDSWaveDots(xOff,yOff,waveData)
	waveData = waveData or waveBuffer
	drawWaveBack(xOff ,yOff)
	for i = 0,#waveData do
		emu.drawPixel(xOff + i,yOff -waveData[i] + waveHeight,waveColor);
	end
end

--draw connected dots as lines
function drawFDSWaveConnectedLines(xOff,yOff,waveData)
	waveData = waveData or waveBuffer
	drawWaveBack(xOff ,yOff)
	lastX = xOff
	lastY = yOff - waveData[0] + waveHeight
	for i = 1,#waveData do
		local curX = xOff + i
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
	for i = 0,#waveData do
		local curX = xOff + i
		local curY = yOff -waveData[i] + waveHeight
		emu.drawLine(curX,yOff + waveHeight,curX,curY,waveColor)
	end
end

function addWaveWriteCallback()
	--regester callback to grab writing data to the wave RAM
	emu.addMemoryCallback(writeCallback, emu.callbackType.write,waveStartAddress,waveEndAddress)
end