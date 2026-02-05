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
	for i =0, waveByteLength do
		local curByte =	string.char(waveData[i])
		writer:write(curByte)
	end
	writer:close();
	return true
end

function saveAllWaveData()
	if Selector.count ==0 then
		emu.displayMessage("Save Status","No data available!")
		return
	end
	
	local folder = parentFolder.. "/" ..getPathFromRom()
	checkFolder(folder)

	for i =0, #foundWaveTables do
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
	rawData = {string.byte(fileData, 0,#fileData)}
	waveData = {}
	--shift everything to the left because I (dumbly) started at 0
	for i =0, waveByteLength  do
		waveData[i] = rawData[i+1]
	end
	for i =0, #waveData do
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
	
	foundWaveTables ={}
	foundWaveTables[0] = waveBuffer
	resetEverything()
	local i =0
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
		end
		foundWaveTables[i] = curData
		
		i = i +1
		curFile = "wave" .. tostring(i) .. ".bin"
		curPath = folder .. "/" .. curFile
	end
	Selector.count = i
	emu.displayMessage("Load Status","File(s) loaded: " .. tostring(Selector.count))
end



local testFolder = getPathFromRom()
local testFile = "test.txt"
local testPath = testFolder .. "/" .. testFile
function testSaveWaveData() 
	checkFolder(testFolder)
	local writer = io.open(testPath,"w");
	if not writer then
		emu.displayMessage("Save Status", "File [".. testPath   ..  "] could not be writtern!")
		return
	end
	writer:write("yeet")
	writer:close()
	emu.displayMessage("Script", "Data saved!")
end

function testLoadWaveData()
	if pathExists(testPath) == false then
		return
	end
	local reader = io.open(testPath, "r")
	if not reader then
		emu.displayMessage("Save Status", "File [".. testPath   ..  "] could not be read!")
		return
	end
	local str = reader:read("*all")
	emu.displayMessage("Read Status", "File [".. testPath   ..  "] Data: " .. str)
	
end

