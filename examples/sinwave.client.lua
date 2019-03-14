-- sinwave.client.lua

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
local myRenderer = ObjectHighlighter.Renderer.new(myScreenGui)
	:withRenderImpl(ObjectHighlighter.Implementations.highlightColor)

-- Assume we have a Model as a direct child of Workspace
local myHighlight = ObjectHighlighter.Highlight.fromTarget(Workspace.Model)
myHighlight.color = Color3.fromRGB(255, 255, 0)

-- Apply our highlight object to our Renderer stack.
-- We can add as many highlight objects to a renderer as we need
myRenderer:addToStack(myHighlight)


RunService.RenderStepped:Connect(function(dt)
	-- Since our highlight object contains it's own state,
	-- we have the option to update it before stepping here.
	myHighlight.color = Color3.new(math.sin(time()), 0, 0)

	-- Our renderer will not render until it steps
	myRenderer:step(dt)
end)