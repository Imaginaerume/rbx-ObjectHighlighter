return function()
	local connections = {}

	return {
		onBeforeRender = function(_, _)
			return true
		end,

		onRender = function(_, worldPart, viewportPart, _)
			viewportPart.CFrame = worldPart.CFrame
		end,

		onAdded = function(worldPart, viewportPart, _)
			viewportPart.Color = worldPart.Color

			connections[worldPart] = worldPart:GetPropertyChangedSignal("Color"):Connect(function()
				viewportPart.Color = worldPart.Color
			end)
		end,

		onRemoved = function(worldPart, _, _)
			if connections[worldPart] then
				connections[worldPart]:Disconnect()
				connections[worldPart] = nil
			end
		end,
	}
end