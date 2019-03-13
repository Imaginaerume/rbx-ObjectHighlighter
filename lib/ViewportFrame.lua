local Workspace = game:GetService("Workspace")

local ViewportFrame = {}
ViewportFrame.__index = ViewportFrame

function ViewportFrame.withReferences(objectRef)
	local state = {
		objectRef = objectRef,
		rbx = nil,
	}
	local self = setmetatable(state, ViewportFrame)

	local rbx = Instance.new("ViewportFrame")
	rbx.CurrentCamera = Workspace.CurrentCamera
	rbx.BackgroundTransparency = 1
	rbx.Size = UDim2.new(1, 0, 1, 0)
	self.rbx = rbx

	objectRef.rbx.Parent = self.rbx

	return self
end

function ViewportFrame:getReference()
	return self.objectRef
end

function ViewportFrame:requestParent(newParent)
	return pcall(function()
		self.rbx.Parent = newParent
	end)
end

function ViewportFrame:destruct()
	self.rbx:Destroy()
end

return ViewportFrame