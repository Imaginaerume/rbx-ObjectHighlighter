return function(basePart)
	assert(basePart:IsA("BasePart"), "createBasePartCopy must only receive a basePart!")

	local result
	if basePart:IsA("MeshPart") or basePart:IsA("UnionOperation") then
		result = basePart:Clone()
	else
		-- TODO: Manually clone simple BaseParts
		result = basePart:Clone()
	end

	-- TODO: Consider whitelisting children applicable to rendering instead
	for _, object in pairs(result:GetDescendants()) do
		if object:IsA("BasePart") then
			object:Destroy()
		end
	end

	return result
end