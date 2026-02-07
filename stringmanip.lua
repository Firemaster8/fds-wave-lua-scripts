function splitString(inString)
	local splitStr = {}
	local buffer = ""
	allowAdd = true
	for c in inString:gmatch(".")  do
		if  c == "," and  buffer ~= ""and allowAdd then
			table.insert(splitStr,buffer)
			buffer =""
		elseif c == '"' then
		allowAdd = not allowAdd
		elseif c ~= " " then
			buffer = buffer .. c
		end
	end
	if  buffer ~= "" then
			table.insert(splitStr,buffer)
	end
	return splitStr
end

function deStringifyData(inString)
	local strArray = splitString(inString)
	local numArray = {}
	for i =1, #strArray do
		local num = tonumber(strArray[i])
		table.insert(numArray ,num)
	end
	return numArray 
end