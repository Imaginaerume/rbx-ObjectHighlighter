local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ObjectHighlighter = require(ReplicatedStorage:FindFirstChild("ObjectHighlighter"))

local LocalPlayer = Players.LocalPlayer

local myScreenGui = Instance.new("ScreenGui")
myScreenGui.Name = "ObjectHighlighter"
myScreenGui.Parent = LocalPlayer.PlayerGui

local myHighlight = ObjectHighlighter.Highlight.fromTarget(workspace.Model)
myHighlight.color = Color3.fromRGB(255, 255, 0)

local myRenderer = ObjectHighlighter.Renderer.new(myScreenGui)
	:withRenderImpl(ObjectHighlighter.Implementations.highlightColor)

myRenderer:addToStack(myHighlight)

RunService.RenderStepped:Connect(function(dt)
	myRenderer:step(dt)
end)