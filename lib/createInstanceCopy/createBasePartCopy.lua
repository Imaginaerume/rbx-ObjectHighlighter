return function(basePart)
	assert(basePart:IsA("BasePart"), "createBasePartCopy must only receive a basePart!")

	local result
	if basePart:IsA("MeshPart") or basePart:IsA("UnionOperation") then
		return basePart:Clone()
	else
		-- TODO: Manually clone simple BaseParts
		result = basePart:Clone()
	end

	return result
end