function pathExists(path)
	local tester = io.open(path,"r");
	if tester then
		tester:close()
		return true
	end
	return false
end


function checkFolder(folder)
	local success, reason, code =os.execute('mkdir "'..folder .. '"') 
	if success then
		emu.displayMessage("IO Info", "Folder [".. folder   ..  "] Has been created!")
	end
end

function getPathFromRom()
	local romStr = emu.getRomInfo().name
	local dotStart,dotEnd = string.find(romStr,".",1,true)
	local removedDotStr =string.sub(romStr,1,dotStart-1)
	local replacedSpace = string.gsub(removedDotStr," ","_")
	return  replacedSpace
end