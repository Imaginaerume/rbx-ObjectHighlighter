-- myCustomRenderImpl.lua

-- (We can pretend this is in it's own module.)
-- You can create your own render implementation as well.
-- This can be used to tailor the Renderer to your game's specific usecases.
local myCustomRenderImpl = (function()
	-- This will check for any obstruction between the user's
	-- Camera and the PrimaryPart of the highlighted model.
	local Workspace = game:GetService("Workspace")

	return function()
		local camera = Workspace.CurrentCamera

		-- Return our render functions.
		-- Unused functions do not need to be declared.
		return {
			onBeforeRender = function(_, worldModel)
				-- Assumption: We have a valid PrimaryPart for our highlighted model
				local worldModelPosition = worldModel.PrimaryPart.Position

				-- This could be made much tighter in a real scenario.
				-- The important takeaway here is that you can cast this ray
				-- using IgnoreLists and rules most appropriate for your project.
				local myRay = Ray.new(camera.CFrame.p, (worldModelPosition - camera.CFrame.p))
				local hit = Workspace:FindPartOnRay(myRay, worldModel)
				local shouldRender = not not hit

				-- Returning false will not render the viewports the current frame.
				return shouldRender
			end,

			onRender = function(_, worldPart, viewportPart, _)
				viewportPart.CFrame = worldPart.CFrame
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

-- Apply our highlight object to our Renderer stack.
-- We can add as many highlight objects to a renderer as we need
myRenderer:addToStack(myHighlight)

RunService.RenderStepped:Connect(function(dt)
	-- Our renderer will not render until it steps
	myRenderer:step(dt)
end)

