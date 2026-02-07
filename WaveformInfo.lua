require("stringmanip")

WaveformInfo = {}
WaveformInfo.__index = WaveformInfo


function WaveformInfo:new(id,data,name)
	name = name or "wave".. tostring(id)
	return setmetatable({
				id = id,
				filename = name,
				waveData = data
	},WaveformInfo)
end

function WaveformInfo:stringifyData()
	if(#self.waveData ==0) then
		return ""
	end
	local outString = "0x" .. string.format("%X", self.waveData[1])
	for i =2,#self.waveData do
		 outString = outString .. ",".. "0x" .. string.format("%X", self.waveData[i])
	end
	return '"' .. outString  .. '"'
end


function WaveformInfo:stringToWaveinfo(str)
	local splitStr  = splitString(str)
	return setmetatable({
				id = tonumber(splitStr[1]),
				filename = splitStr[2],
				waveData = deStringifyData(splitStr[3])
	},WaveformInfo)
end



function WaveformInfo:toString()
	return tostring(self.id) .. "," ..self.filename .. "," ..self:stringifyData()
end


function WaveformInfo:exportWaveData(folder)
	local path = folder .. "/" .. self.filename .. ".bin"
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

