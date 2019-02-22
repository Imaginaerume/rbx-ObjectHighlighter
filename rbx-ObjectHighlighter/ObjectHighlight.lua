--Config
local TransparencyVisibilityCutoff = 0.1; --How transparent something has to be to not count as an 'obstruction' if 'HideIfVisible' is true
-----------------------------------------------------------
--Make sure this module isn't running on the server
if game:GetService("RunService"):IsServer() then
	print("Can't require ObjectHighlight module on the server")
	return false
end
-----------------------------------------------------------
local ObjectHighlight 		= {};
local Highlights 			= {};
local TransparencyFrames	= {};

--Objects
local Camera				= workspace.CurrentCamera;
local PlayerGui				= game.Players.LocalPlayer:WaitForChild("PlayerGui");

--Services
local TweenService			= game:GetService("TweenService")
local RunService			= game:GetService("RunService")

--Resources
local RaycastWithCondition	= require(script.Resources.RaycastWithCondition)

--Set up UI
local HighlightScreenGui = Instance.new("ScreenGui", PlayerGui)
HighlightScreenGui.Name = "Highlights"
HighlightScreenGui.IgnoreGuiInset = true

function CreateView(Transparency)
	local Index = tostring(Transparency)
	
	if TransparencyFrames[Index] then
		return TransparencyFrames[Index]
	end
	
	local ViewFrame = Instance.new("ViewportFrame", HighlightScreenGui)
	ViewFrame.Name = "View-"..Transparency;
	ViewFrame.CurrentCamera = game.Workspace.CurrentCamera;
	ViewFrame.BackgroundTransparency = 1;
	ViewFrame.Size = UDim2.new(1,0,1,0);
	ViewFrame.ImageTransparency = Transparency
	TransparencyFrames[Index] = ViewFrame;
	
	return ViewFrame
end


function ObjectHighlight.new(Object, Color, HideIfVisible, MaxRenderDistance, Transparency)
	
	--Construct object
	local HighlightObject = {
		OriginObject		= Object;
		Color 				= Color;
		HideIfVisible 		= HideIfVisible;
		MaxRenderDistance 	= MaxRenderDistance;
		
		View				= CreateView(Transparency or 0);
		Transparency		= Transparency or 0;
		
		Enabled 			= false;
		
		Objects = {
			--[OriginalObject] = Highlight
		}
	};
	
	setmetatable(HighlightObject, {__index = ObjectHighlight})
	----------------------------------------------------------
	--Initialize the given Object if there is one
	if Object then
		if Object:IsA("BasePart") then
			HighlightObject:AddPart(Object)
		else
			for _, ChildObject in pairs(Object:GetDescendants()) do
				if ChildObject:IsA("BasePart") then
					HighlightObject:AddPart(ChildObject)
				end
			end		
		end
	end
	
	return HighlightObject
end

function ObjectHighlight.AddPart(HighlightObject, Part)
	local Highlight 		= Part:Clone()
	Highlight.CanCollide 	= false
	Highlight.Color 		= HighlightObject.Color or Part.Color;
	Highlight.Size 			= Highlight.Size
	Highlight.CFrame 		= Part.CFrame
	
	--Force UsePartColor on CSG parts
	if Highlight.className == "UnionOperation" then
		Highlight.UsePartColor = true
	end
	
	--Scrape textures off of meshes
	if Highlight:IsA("MeshPart") then
		Highlight.TextureID = "";
	end
	
	local Mesh = Highlight:FindFirstChildOfClass("SpecialMesh");
	if Mesh then
		Mesh.TextureId = "";
	end
	
	--Add part to HighlightObject
	HighlightObject.Objects[Part] = Highlight
	
	return Highlight
end

function ObjectHighlight.Enable(HighlightObject)
	
	--Already enabled so don't enable it again
	if HighlightObject.Enabled then
		return
	end
	
	for OriginPart, HighlightPart in pairs(HighlightObject.Objects) do
		HighlightPart.Parent = HighlightObject.View
	end
	
	HighlightObject.Enabled = true
	Highlights[HighlightObject] = true
end

function ObjectHighlight.Disable(HighlightObject)
	
	--Already disabled so don't enable it again
	if not HighlightObject.Enabled then
		return
	end
	
	for OriginPart, HighlightPart in pairs(HighlightObject.Objects) do
		HighlightPart.Parent = nil
	end
	
	HighlightObject.Enabled = false
	Highlights[HighlightObject] = nil
end

function ObjectHighlight.Destroy(HighlightObject)
	for OriginPart, HighlightPart in pairs(HighlightObject.Objects) do
		HighlightPart:Destroy()
		Highlights[HighlightObject] = nil
	end
end

--Transparency manipulation
function ObjectHighlight.ChangeTransparency(HighlightObject, Transparency)
	
	--Transparency is the same
	if HighlightObject.Transparency == Transparency then
		return
	end
	
	HighlightObject.Transparency = Transparency;
	HighlightObject.View = CreateView(Transparency)
	
	--Reparent children
	for _, Highlight in pairs(HighlightObject.Objects) do
		Highlight.Parent = HighlightObject.View;
	end
end

--Color manipulation
function ObjectHighlight.ChangeColor(HighlightObject, NewColor)
	HighlightObject.Color = NewColor;
	
	for OriginalPart, Highlight in pairs(HighlightObject.Objects) do
		if NewColor then
			Highlight.Material = "SmoothPlastic";
			Highlight.Color = NewColor;
		else
			Highlight.Material = OriginalPart.Material
			Highlight.Color = OriginalPart.Color
		end
	end
end

function ObjectHighlight.TweenColor(HighlightObject, NewColor, Tween)
	HighlightObject.Color = NewColor;
	
	for OriginalPart, Highlight in pairs(HighlightObject.Objects) do
		if NewColor then
			Highlight.Material = "SmoothPlastic"
			TweenService:Create(Highlight, Tween or TweenInfo.new(), {Color = NewColor}):Play();
		else
			Highlight.Material = OriginalPart.Material
			TweenService:Create(Highlight, Tween or TweenInfo.new(), {Color = OriginalPart.Color}):Play();
		end
	end
end

--Update loop
Spawn(function()
	RunService.Heartbeat:connect(function()
		for HighlightObject, _ in pairs(Highlights) do
			if HighlightObject.Enabled then
				for OriginPart, Highlight in pairs(HighlightObject.Objects) do
					
					--hide if visible logic
					local Hide = false;
					
					if HighlightObject.HideIfVisible then
						local Difference = (OriginPart.CFrame.p-Camera.CFrame.p)
						local Hit = RaycastWithCondition(Camera.CFrame.p, Difference.unit, Difference.magnitude, function(Hit)
							if Hit ~= OriginPart and 
								(
									Hit.Transparency > TransparencyVisibilityCutoff
									or 
									Hit.CanCollide == false 
									or
									Hit.Name == "Handle"
									or 
									Hit.Parent:FindFirstChildOfClass("Humanoid")
								)
							then
								return false
							else
								return true
							end
						end)
						
						if Hit and Hit == OriginPart then
							Highlight.Parent = nil
							Hide = true;
						else
							Hide = false;
							Highlight.Parent = HighlightObject.View
						end
					end
					
					--hide if the object has a max render distance (distance from camera to OriginObject)
					if HighlightObject.MaxRenderDistance and not Hide then
						if (Camera.CFrame.p-OriginPart.CFrame.p).magnitude <= HighlightObject.MaxRenderDistance then
							Highlight.Parent = HighlightObject.View
						else
							Highlight.Parent = nil
						end
					end
					
					--update cframe, don't update if the object has no parent
					if Highlight.Parent then
						Highlight.CFrame = OriginPart.CFrame;
					end
				end
			end
		end
	end)
end)

return ObjectHighlight