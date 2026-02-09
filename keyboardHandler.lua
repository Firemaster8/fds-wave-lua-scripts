KeyboardHandler = {
	curKey = nil,
	lastKey = nil,
	cooldownTimer =0,
	delayTimer =0

}

local lookupTxt = 	 "ABCDEFGHIJKLMNOPQRSTUVWXYZ-1234567890"
local lookupTxtUnshift = "abcdefghijklmnopqrstuvwxyz-1234567890"
local lookupTxtShift =   "ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890"
function KeyboardHandler:getKeyPressedLookup()
	for i = 1, #lookupTxt do
		local chr = lookupTxt:sub(i,i)
		if emu.isKeyPressed(chr) then
			if  emu.isKeyPressed("Left Shift") or emu.isKeyPressed("Right Shift") then
				return lookupTxtShift:sub(i,i)
			end
			return lookupTxtUnshift:sub(i,i)
		end
	end
	return nil
end

function KeyboardHandler:getKeyPressed()
	local keyPress = nil
	if  emu.isKeyPressed("Space") then
		keyPress = " "
	elseif  emu.isKeyPressed("Backspace") then
		keyPress = "Backspace"
	elseif emu.isKeyPressed("Left Arrow") then
		keyPress = "Left"
	elseif emu.isKeyPressed("Right Arrow") then
		keyPress = "Right"
	else
		keyPress =self:getKeyPressedLookup()
	end
	return 	keyPress
end

function KeyboardHandler:handleKeypress(textBox,callback)
	self.lastKey = self.curKey
	self.curKey = self:getKeyPressed()
	if self.curKey == nil then
		self.delayTimer =0
		return
	elseif self.lastKey ~= self.curKey and self.curKey ~= nil then
		callback(textBox,self.curKey)
		return
	end
	self.cooldownTimer = self.cooldownTimer + 1
	self.delayTimer = self.delayTimer + 1
	if self.lastKey == self.curKey and self.cooldownTimer >= 5 and self.delayTimer >= 20 then
		callback(textBox,self.curKey)
		self.cooldownTimer = 0
	end
end