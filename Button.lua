require("MouseState")
Button = {}
Button.__index = Button


function Button:draw()
	emu.drawRectangle(self.x,self.y,self.width,self.height,0x302060FF,true)
	emu.drawString(self.x,self.y+1,self.text,0xFF0000,0xFFFFFFFF)
end


function Button:new(x,y,width,text,onClick)
	return setmetatable({
				x =x,
				y=y,
				text =text,
				width =width,
				height = 9,
			onClick = onClick
			},Button)
end

function Button:checkClick()
	if MouseState:boxClicked(self) then
		self.onClick(self)
	end
end