local ViewportFrame = require(script.Parent.ViewportFrame)
local ObjectRefMap = require(script.Parent.ObjectRefMap)

local DEFAULT_IMPLEMENTATION = require(script.Parent.Implementations.worldColor)

local Renderer = {}
Renderer.__index = Renderer

local function onAddedToStack(self, highlight)
	local objectRef = ObjectRefMap.fromModel(highlight.target)
	local viewport = ViewportFrame.withReferences(objectRef)

	if self.onAddedImpl then
		for worldPart, viewportPart in pairs(objectRef.map) do
			self.onAddedImpl(worldPart, viewportPart, highlight)
		end
	end

	viewport:requestParent(self.targetScreenGui)
	self._viewportMap[highlight] = viewport
end

local function onRemovedFromStack(self, highlight)
	if self.onRemovedImpl then
		local viewport = self._viewportMap[highlight]
		local objectRef = viewport:getReference()
		for worldPart, viewportPart in pairs(objectRef.map) do
			self.onRemovedImpl(worldPart, viewportPart, highlight)
		end
	end

	local viewport = self._viewportMap[highlight]
	viewport:requestParent(nil)
	viewport:destruct()
	self._viewportMap[highlight] = nil
end

function Renderer.new(targetScreenGui)
	assert(targetScreenGui, "Renderer.new must be provided with a targetScreenGui.")

	local state = {
		_stack = {},
		_viewportMap = {},
		targetScreenGui = targetScreenGui,
	}
	setmetatable(state, Renderer)

	targetScreenGui.IgnoreGuiInset = true

	return state:withRenderImpl(DEFAULT_IMPLEMENTATION)
end

function Renderer:withRenderImpl(implementationFunc)
	local resultImpl = implementationFunc()

	self.onAddedImpl = resultImpl.onAdded
	self.onRemovedImpl = resultImpl.onRemoved
	self.onBeforeRenderImpl = resultImpl.onBeforeRender
	self.onRenderImpl = resultImpl.onRender

	return self
end

function Renderer:addToStack(highlight)
	if self._viewportMap[highlight] then
		return
	end

	table.insert(self._stack, highlight)
	onAddedToStack(self, highlight)
end

function Renderer:removeFromStack(highlight)
	local wasRemovedSuccessfully = false

	for index = #self._stack, 1, -1 do
		if highlight == self._stack[index] then
			table.remove(self._stack, index)
			wasRemovedSuccessfully = true
			break
		end
	end

	if wasRemovedSuccessfully then
		onRemovedFromStack(self, highlight)
	end
end

function Renderer:step(dt)
	if not self.onRenderImpl then
		return
	end

	for index = #self._stack, 1, -1 do
		local highlight = self._stack[index]
		local viewport = self._viewportMap[highlight]
		local objectRef = viewport:getReference()

		local beforeRenderResult
		if self.onBeforeRenderImpl then
			beforeRenderResult = self.onBeforeRenderImpl(dt, objectRef.worldModel)
			if beforeRenderResult == false then
				viewport.rbx.Visible = false
			end
		end

		if beforeRenderResult ~= false then
			for worldPart, viewportPart in pairs(objectRef.map) do
				self.onRenderImpl(dt, worldPart, viewportPart, highlight)
			end
			viewport.rbx.Visible = true
		end
	end
end

return Renderer
