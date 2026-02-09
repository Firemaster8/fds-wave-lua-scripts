require("MouseState")
require("Selector")
require("WaveformInfo")
require("KeyboardHandler")
TextBox = {

				x =123,
				y=1,
				maxCharacter = 15,
				height = 9,
				captured=false,
				frameCount =0,
				showCursor = false,
				cursor = 1,
				charOffset = 6,
				lastIndex = -1

}

function TextBox:drawCursor()
	self.frameCount= self.frameCount +1
	
	if self.frameCount == 30 then
		self.showCursor = not self.showCursor
		self.frameCount =0
	end
	if self.showCursor and self.captured then
		local boxWidth = 1
		local boxX = self.x + (self.cursor -1) *self.charOffset
		emu.drawRectangle(boxX ,self.y +1 ,boxWidth,self.height -2,0xFF0000,true)
		
	end
end

function TextBox:drawText()
	local text = self:getText() 
	if text == "" then
		return
	end
	for i =1, #text do
		emu.drawString(self.x + ((i -1)*self.charOffset),self.y+1,text:sub(i,i),0xFF0000,0xFFFFFFFF)
	end
	self:drawCursor()
	
end

function TextBox:draw()
	local box =self:getBox()
	emu.drawRectangle(box.x,box.y,box.width,box.height,0x302060FF,true)
	self:drawText()
end

function TextBox:getBox()
	return {x = self.x, y = self.y,width = (self.maxCharacter * self.charOffset) +2,height = self.height}
end

function TextBox:checkCursor()
	local curIndex = Selector.index
	local curTextWidth  = #self:getText()
	if self.lastIndex ~= curIndex then
		self.cursor = curTextWidth +1
	end
	if self.cursor < 1 then
		self.cursor = 1
	elseif self.cursor >  curTextWidth then
		self.cursor = curTextWidth +1
	end

	self.lastIndex = curIndex
end

function TextBox:checkClick()
	if #foundWaveTables ==0 then
		return
	end
	local box = self:getBox()
	if MouseState:boxClicked(box) then
		self.captured = true
	elseif MouseState:boxOutClicked(box) then
		self.captured = false
	end
end

function TextBox:insertCharacter(character)
	local curName = self:getText()
	local left = curName:sub(1,self.cursor-1)
	local right = curName:sub(self.cursor)
	foundWaveTables[Selector.index].filename =left .. character .. right
	self.cursor = self.cursor +1
	
end


function TextBox:removeCharacter()
	if self.cursor == 1 then
		return
	end
	local curName = self:getText()
	if self.cursor == #curName +1 then
		local endPos = #curName -1
		foundWaveTables[Selector.index].filename = curName:sub(1,endPos)
		self.cursor = endPos +1
	else
		local left = curName:sub(1,self.cursor-2)
		local right = curName:sub(self.cursor)
		foundWaveTables[Selector.index].filename =left .. right
		self.cursor = self.cursor - 1
	end
	if self.cursor < 1 then
		self.cursor = 1
	end
end

function keyboardCallback(self,key)
	if  key == "Backspace" then
		self:removeCharacter()
	elseif  key == "Left" then
		self.cursor = self.cursor  - 1
		if self.cursor < 1 then
			self.cursor = 1
		end
	elseif  key == "Right" then
		self.cursor = self.cursor  + 1
		if self.cursor >   #self:getText() +1 then
			self.cursor =  #self:getText() +1
		end
	elseif key ~= nil and  #self:getText() < self.maxCharacter  then
		self:insertCharacter(key)
	end
end

function TextBox:update()
	self:checkCursor()
	if self.captured == false then
		return
	elseif  emu.isKeyPressed("Enter") then
		self.captured = false
		return
	end
	KeyboardHandler:handleKeypress(self,keyboardCallback)
	
end

function TextBox:getText()
	if #foundWaveTables == 0 then
		return ""
	end
	return foundWaveTables[Selector.index].filename
end



function TextBox:reset()
	self.captured=false
	self.frameCount =0
	self.showCursor = false
	self.cursor = 1
	self.lastIndex = -1
end