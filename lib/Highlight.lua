local DEFAULT_PROPS = {
	target = nil,
	color = Color3.fromRGB(255, 255, 255),
	transparency = 0,
}

local Highlight = {}

function Highlight.new(props)
	assert(type(props) == "table", "Highlight.new expects a table of props.")
	assert(props.target, "Highlight requires a target to be set!")
	assert(props.target:IsA("Model"), "Highlight requires target to be a Model!")

	local state = {
		target = props.target,
		color = props.color or DEFAULT_PROPS.color,
		transparency = props.transparency or DEFAULT_PROPS.transparency,
	}

	return setmetatable(state, Highlight)
end

function Highlight.fromTarget(target)
	assert(target and target:IsA("Model"), "Highlight.fromTarget requires a Model target to be set!")

	return Highlight.new({
		target = target,
	})
end

return Highlight