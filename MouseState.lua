MouseState = {
	state = emu.getMouseState(),
	lastClick = false
}

function MouseState:update()
		self.lastClick = self.state.left
		self.state = emu.getMouseState()
end
function MouseState:leftDown()
		return self.state.left
end

function MouseState:leftClick()
		return self:leftDown() and self.lastClick == false
end

function MouseState:boxClicked(box) 
	local boxRight = box.x  + box.width
	local boxBottom = box.y  + box.height
	local inHorizontal = self.state.x >= box.x and self.state.x <= boxRight
	local inVertical = self.state.y >= box.y and self.state.y <= boxBottom
	return inHorizontal and inVertical and self:leftClick()
end

function MouseState:boxOutClicked(box) 
	local boxRight = box.x  + box.width
	local boxBottom = box.y  + box.height
	local inHorizontal = self.state.x >= box.x and self.state.x <= boxRight
	local inVertical = self.state.y >= box.y and self.state.y <= boxBottom
	local outOfRange = not (inHorizontal and inVertical)
	return outOfRange and self:leftClick()
end