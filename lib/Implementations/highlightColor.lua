return function()
	return {
		onBeforeRender = function(_, _)
			return true
		end,

		onRender = function(_, worldPart, viewportPart, highlight)
			viewportPart.CFrame = worldPart.CFrame
			viewportPart.Color = highlight.color
		end,

		onAdded = function(_, viewportPart, highlight)
			local function clearTextures(instance)
				if instance:IsA("MeshPart") then
					instance.TextureID = ""
				elseif instance:IsA("UnionOperation") then
					instance.UsePartColor = true
				elseif instance:IsA("SpecialMesh") then
					instance.TextureId = ""
				end
			end

			local function colorObject(instance)
				if instance:IsA("BasePart") then
					instance.Color = highlight.color
				end
			end

			for _, object in pairs(viewportPart:GetDescendants()) do
				clearTextures(object)
				colorObject(object)
			end
			clearTextures(viewportPart)
			colorObject(viewportPart)
		end,
	}
end