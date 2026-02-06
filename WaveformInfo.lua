WaveformInfo = {}
WaveformInfo.__index = WaveformInfo


function WaveformInfo:new(id,data,name)
	name = name or "wave".. tostring(id) .. ".bin"
	return setmetatable({
				id = id,
				filename = name,
				waveData = data
	},WaveformInfo)
end



function splitString(inString,splitChar)
	local splitStr = {}
	for str in string.gmatch(inString, "([^"..splitChar.."]+)") do
		local trimStr = string.gsub(str, "^%s*(.-)%s*$", "%1")
        	table.insert(splitStr, trimStr)
    	end
	return splitStr
end


function WaveformInfo:stringToWaveinfo(str)
	local splitStr  = splitString(str,",")
	local _id = tonumber(splitStr[1])
	local _filename = splitStr[2]
	return setmetatable({
				id = _id,
				filename = _filename,
				waveData = {}
	},WaveformInfo)
end



function WaveformInfo:rename(name)
	--check to see if theres already a file already named that
	--check if theres illegal characters in the name
	--if so reject name


	self.filename = name.. ".bin"
end

function WaveformInfo:toString()
	return tostring(self.id) .. "," ..self.filename 
end


function WaveformInfo:loadWaveFile(folder)
	local path = folder .. "/" .. self.filename
	local reader = io.open(path,"rb");
	if not reader then
		emu.displayMessage("Load Status", "File [".. self.filename  ..  "] could not be read!")
		return false
	end
	local fileData =  reader:read("*all") 
	self.waveData = {string.byte(fileData, 1,#fileData)}
	for i =1, #self.waveData do
		if self.waveData[i] == nil then
			emu.displayMessage("Load Status","Data in ".. fileName .." has bad data, index: "
			 .. tostring(i))
			return false
		end
	end
	reader:close()
	return true
end


function WaveformInfo:saveWaveData(folder)
	local path = folder .. "/" .. self.filename
	local writer = io.open(path,"wb");
	if not writer then
		emu.displayMessage("Save Status", "File [".. self.filename   ..  "] could not be writtern!")
		return false
	end
	for i =1, #self.waveData do
		local curByte =	string.char(self.waveData[i])
		writer:write(curByte)
	end
	writer:close();
	return true
end

