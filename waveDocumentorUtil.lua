require("fdsWavetUtils")
require("Selector")
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
	waveUpdated = false
end

function resetEverything()
	waveUpdated=false
	Selector:reset()
	foundWaveTables ={}
	foundWaveTables[0] = waveBuffer
	for i =0,waveByteLength do
		waveBuffer[i] =0
	end
end
