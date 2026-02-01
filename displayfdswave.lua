--use this as a template if you dont want to use require(), probably going to be outdated
-- wave table addresses 0x4040,0x407F
waveStartAddress = 0x4040
waveEndAddress = 0x407F
waveByteLength = waveEndAddress -waveStartAddress +1
waveHeight = 63
--color
backColor = 0x302060FF
waveColor = 0xFF0000

--init array buffer
waveArray = {}
--seriously, how does array works in lua?
for i =0,waveByteLength do
waveArray[i] =0
end

--capture written data to table
function writeCallback(address, value)
	waveArray[address - waveStartAddress] = value
end

--display raw byte values
function printFDSWaveValues(startX,startY)
	local yOff = startY
	local xOff = startX
	for i = 0,#waveArray do
		 strHexValue = string.format("%x", waveArray[i] )
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
	emu.drawRectangle(xOff , yOff, #waveArray+1, waveHeight+1, backColor, true, 1)
end

--draw dots of wave table
function drawFDSWaveDots(xOff,yOff)
	drawWaveBack(xOff ,yOff)
	for i = 0,#waveArray do
		emu.drawPixel(xOff + i,yOff -waveArray[i] + waveHeight,waveColor);
	end
end

--draw connected dots as lines
function drawFDSWaveConnectedLines(xOff,yOff)
	drawWaveBack(xOff ,yOff)
	lastX = xOff
	lastY = yOff - waveArray[0] + waveHeight
	for i = 1,#waveArray do
		local curX = xOff + i
		local curY = yOff -waveArray[i] + waveHeight
		emu.drawLine(lastX,lastY,curX,curY,waveColor )
		lastX = curX
		lastY = curY
	end
end

--draw with vertical lines
function drawFDSWaveVerticalLines(xOff,yOff)
	drawWaveBack(xOff ,yOff)
	lastX = xOff
	for i = 0,#waveArray do
		local curX = xOff + i
		local curY = yOff -waveArray[i] + waveHeight
		emu.drawLine(curX,yOff + waveHeight,curX,curY,waveColor)
	end
end

--display the wave table with dots
function displayFDSCallback()
	local xOff = 1
	local yOff = 1
	
	drawFDSWaveDots(xOff,yOff)
	xOff = xOff + 70
	drawFDSWaveConnectedLines(xOff,yOff)
	xOff = xOff + 70
	drawFDSWaveVerticalLines(xOff,yOff)
end
--regester callback to grab writing data to the wave RAM
emu.addMemoryCallback(writeCallback, emu.callbackType.write,waveStartAddress,waveEndAddress)
--add misc callbacks
emu.addEventCallback(displayFDSCallback, emu.eventType.endFrame)
--Display a startup message
emu.displayMessage("Script", "LET'S FREAKING GOOOOOO!!!!!")