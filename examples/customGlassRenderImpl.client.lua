-- myCustomRenderImpl.lua

-- (We can pretend this is in it's own module.)
-- You can create your own render implementation as well.
-- This can be used to tailor the Renderer to your game's specific usecases.
local myCustomRenderImpl = (function()
	-- This is a simple implementation that sets the highlight
	-- material to Glass as a visual effect.

	return function()
		-- Return our render functions.
		-- Unused functions do not need to be declared.
		return {
			onRender = function(_, worldPart, viewportPart, highlight)
				viewportPart.CFrame = worldPart.CFrame
				viewportPart.Color = highlight.color
				viewportPart.Material = Enum.Material.Glass
			end,
		}
	end
end)()

-- customGlassRenderImpl.client.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ObjectHighlighter = require(ReplicatedStorage:FindFirstChild("ObjectHighlighter"))

-- This screen gui will contain our ViewportFrames
local myScreenGui = Instance.new("ScreenGui")
myScreenGui.Name = "ObjectHighlighter"
myScreenGui.Parent = Players.LocalPlayer.PlayerGui

-- Create a Renderer object with an alternative render implementation.
-- `hightlightColor` will override the original model's colors and textures
-- with the `color` field provided from `myHighlight`'s state.
local myRenderer = ObjectHighlighter.createRenderer(myScreenGui)
	:withRenderImpl(myCustomRenderImpl)

-- Assume we have a Model as a direct child of Workspace
local myHighlight = ObjectHighlighter.createFromTarget(Workspace.Model)
myHighlight.color = Color3.fromRGB(255, 255, 0)

-- Apply our highlight object to our Renderer stack.
-- We can add as many highlight objects to a renderer as we need
myRenderer:addToStack(myHighlight)

RunService.RenderStepped:Connect(function(dt)
	-- Our renderer will not render until it steps
	myRenderer:step(dt)
end)

