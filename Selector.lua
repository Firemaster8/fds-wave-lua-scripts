Selector = {
index =0,
count = 0,
x =0,
y =0,
numBackColor = 0x302060FF,
btnBackColor = 0x3020FFFF,
waveColor = 0xFF0000,
transparentColor = 0xFFFFFFFF,
indexChanged = false
}
function Selector:test()
		emu.displayMessage("test", self.index)
end
function Selector:next()
		if self.count == 0 then
			return
		end
		self.index= (self.index + 1) % self.count
	self.indexChanged = true
end

function Selector:changeIndex(value)
		self.index= value
		self.indexChanged = true
end

function Selector:prev()
		if self.count == 0 then
			return
		end
		self.index= (self.index - 1)
		if self.index < 0 then
		self.index= self.count -1
		end
	self.indexChanged = true
end
function Selector:getLeftBtnBox()
		return {x = self.x, y = self.y,width = 4,height = 17}
end
function Selector:getNumberBox()
		return {x = self.x + 4, y = self.y,width = 19,height = 17}
end

function Selector:getRightBtnBox()
		return {x = self.x + 23, y = self.y,width = 4,height = 17}
end

function drawBox(box,backColor)
	emu.drawRectangle(box.x,box.y,box.width,box.height,backColor,true); 
end

lastClick = false
mouseState = emu.getMouseState()
function boxClicked(box) 
	local boxRight = box.x  + box.width
	local boxBottom = box.y  + box.height
	local inHorizontal = mouseState.x >= box.x and mouseState.x <= boxRight
	local inVertical = mouseState.y >= box.y and mouseState.y <= boxBottom
	return inHorizontal and inVertical and mouseState.left and lastClick == false
end

function Selector:checkButtons()
	self.indexChanged = false
	local leftBtnBox = self:getLeftBtnBox()
	local rightBtnBox = self:getRightBtnBox()
	if boxClicked(leftBtnBox) then
		self:prev()
	end
	if boxClicked(rightBtnBox) then
		self:next()
	end
end

function Selector:draw()
		local frmt = "%03d"
		local indexStr =  string.format(frmt,self.index)
		local countStr =  string.format(frmt,self.count)
		local leftBtnBox = self:getLeftBtnBox()
		local numBox =self:getNumberBox()
		local rightBtnBox = self:getRightBtnBox()
		drawBox(leftBtnBox,self.btnBackColor)
		drawBox(numBox,self.numBackColor)
		drawBox(rightBtnBox,self.btnBackColor)
		emu.drawString(leftBtnBox.x,leftBtnBox.y+5,"<",0xFF0000, self.transparentColor,(3*8)) 
		emu.drawString(numBox.x+1,numBox.y,indexStr,0xFF0000, self.transparentColor,(3*8))
		emu.drawString(numBox.x+1,numBox.y+5,"---",0xFF0000, self.transparentColor)
		emu.drawString(numBox.x+1,numBox.y+10,countStr,0xFF0000, self.transparentColor,(3*8))
		emu.drawString(rightBtnBox.x+1,rightBtnBox.y+5,">",0xFF0000,self.transparentColor,(3*8)) 
end
