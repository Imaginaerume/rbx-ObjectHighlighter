local Raynew 		= Ray.new
local TableInsert 	= table.insert
local Workspace 	= game.Workspace

function Raycast(Origin, Direction, Distance, Evaluator)
	local Cast = Raynew(Origin, Direction*Distance)
	local IgnoreList = {}

	while true do
		local Hit, Position, Normal, Material = Workspace:FindPartOnRayWithIgnoreList(Cast, IgnoreList, true)

		if Hit and not Evaluator(Hit) then
			TableInsert(IgnoreList, Hit)

		else
			return Hit, Position, Normal, Material

		end
	end
end

return Raycast