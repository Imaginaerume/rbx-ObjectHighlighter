local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ObjectHighlighter = require(ReplicatedStorage:FindFirstChild("ObjectHighlighter"))

local LocalPlayer = Players.LocalPlayer

local myScreenGui = Instance.new("ScreenGui")
myScreenGui.Name = "ObjectHighlighter"
myScreenGui.Parent = LocalPlayer.PlayerGui

local myHighlight = ObjectHighlighter.Highlight.fromTarget(workspace.Model)
local myRenderer = ObjectHighlighter.Renderer.new(myScreenGui)
	:withRenderImpl(ObjectHighlighter.Renderer.Implementations.tagged)

myRenderer:addToStack(myHighlight)

RunService.Heartbeat:Connect(function(dt)
	myRenderer:step(dt)
end)