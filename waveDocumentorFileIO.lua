require("waveDocumentorUtil")
require("Selector")
require("pathStuff")

local parentFolder = "waves"

function saveWaveData(fileName,waveData)
	local writer = io.open(fileName,"wb");
	if not writer then
		emu.displayMessage("Save Status", "File [".. fileName   ..  "] could not be writtern!")
		return false
	end
	for i =1, #waveData do
		local curByte =	string.char(waveData[i])
		writer:write(curByte)
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
	checkFolder(folder)

	for i =1, #foundWaveTables do
		local fileName = "wave" .. tostring(i) .. ".bin"
		if saveWaveData(folder.. "/" .. fileName,foundWaveTables[i]) == false then
			return
		end
	end
	emu.displayMessage("Save Status","Data Saved!")
end

function loadWaveFile(fileName)
	local reader = io.open(fileName,"rb");
	if not reader then
		emu.displayMessage("Load Status", "File [".. fileName   ..  "] could not be read!")
		return nil
	end
	local fileData =  reader:read("*all") 
	waveData = {string.byte(fileData, 1,#fileData)}
	for i =1, #waveData do
		if waveData[i] == nil then
			emu.displayMessage("Load Status","Data in ".. fileName .." has bad data, index: "
			 .. tostring(i))
			return nil
		end
	end
	reader:close()
	return waveData
end

function loadWaveAllWaveData()
	local folder = parentFolder .. "/" ..getPathFromRom()
	resetEverything()
	local i = 1
	local curFile = "wave" .. tostring(i) .. ".bin"
	local curPath = folder .. "/" .. curFile
	if pathExists(curPath) == false then
		emu.displayMessage("Load Status","No data available!")
		return
	end
	while pathExists(curPath) do
		-- load file
		local curData =loadWaveFile(curPath);
		if curData == nil then
			resetEverything()
			return
		elseif curData[1] == nil then
			emu.displayMessage("Load Status","An unexpected error occured when loading ".. curPath .."!")
			resetEverything()
			return
		end
		foundWaveTables[i] = curData
		
		i = i +1
		curFile = "wave" .. tostring(i) .. ".bin"
		curPath = folder .. "/" .. curFile
	end
	Selector.count = #foundWaveTables
	Selector.index = 1
	emu.displayMessage("Load Status","File(s) loaded: " .. tostring(#foundWaveTables))
end