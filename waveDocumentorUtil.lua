require("fdsWavetUtils")
require("TextBox")
foundWaveTables ={}

function wavesMatched(wave1,wave2)
	for i = 1,#wave1 do
		if wave1[i] ~= wave2[i] then
			return false
		end
	end
	return true
end

function getWaveCopy()
	copyBuffer = {}
	for i =1, #waveBuffer do
		copyBuffer[i] = waveBuffer[i]
	end
	return copyBuffer
end

function getWaveIndex(waveData)
	if #waveData == 0 or #foundWaveTables == 0 then
		return -1
	end
	for i = 1,#foundWaveTables do
		if wavesMatched(foundWaveTables[i].waveData,waveData) then
			return i
		end
	end
	return -1
end

function checkWaveBuffer()
	if waveWrittenSinceLastCheck() == false then
		return
	end
	local index = getWaveIndex(waveBuffer)
	--if wave not in list add it
	if index ==-1 then
		foundWaveTables[#foundWaveTables+1] = WaveformInfo:new(#foundWaveTables+1,getWaveCopy())
		Selector.count = #foundWaveTables
		index = Selector.count
	end
	if Selector.autoIndexChange and TextBox.captured == false then
		Selector:changeIndex(index)
	end
end

function resetEverything()
	resetWaveUtil()
	Selector:reset()
	foundWaveTables ={}
	TextBox:reset()
end
