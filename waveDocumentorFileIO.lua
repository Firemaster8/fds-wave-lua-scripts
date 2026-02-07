require("waveDocumentorUtil")
require("Selector")
require("pathStuff")

local parentFolder = "waves"
local metadataFileName = "metadata.csv"

function saveMetadata(path)
	local writer = io.open(path,"w");
	if not writer then
		emu.displayMessage("Save Status", "File [".. path   ..  "] could not be writtern!")
		return false
	end
	for i = 1, #foundWaveTables do
		writer:write(foundWaveTables[i]:toString() .. "\n")
	end
	writer:close();
	return true
end

function saveAllWaveData()
	if #foundWaveTables ==0 then
		emu.displayMessage("Save Status","No data available!")
		return
	end
	local folder = parentFolder.. "/" ..getPathFromRom()
	local metadataFilePath = folder.. "/" .. metadataFileName
	checkFolder(folder)
	saveMetadata(metadataFilePath)
	emu.displayMessage("Save Status","Data Saved!")
end


function loadWaveformInfoFromMeta(path,folder)
	local reader = io.open(path,"rb");
	waveInfos = {}
	if not reader then
		emu.displayMessage("Load Status", "File [".. fileName   ..  "] could not be read!")
		return nil
	end
	for line in reader:lines() do
		local curInfo = WaveformInfo:stringToWaveinfo(line)
		waveInfos[curInfo.id] = curInfo
    	end
	reader:close()
	return waveInfos
end

function loadWaveAllWaveData()
	resetEverything()
	local folder = parentFolder .. "/" ..getPathFromRom()
	local curMetaPath = folder .. "/" .. metadataFileName
	if pathExists(curMetaPath) == false then
		emu.displayMessage("Load Status","No data available!")
		return
	end
	local loadedInfos =loadWaveformInfoFromMeta(curMetaPath,folder)
	if loadedInfos == nil then
		resetEverything()
		return
	end
	foundWaveTables = loadedInfos
	Selector.count = #foundWaveTables
	Selector.index = 1
	emu.displayMessage("Load Status","File(s) loaded: " .. tostring(#foundWaveTables))
end

function exportWaveDatas()
	local folder = parentFolder .. "/" ..getPathFromRom()
	checkFolder(folder)
	for i = 1, #foundWaveTables do
		foundWaveTables[i]:exportWaveData(folder)
	end
	emu.displayMessage("Export Status","File(s) Exported!")
end
