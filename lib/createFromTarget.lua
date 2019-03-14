local Highlight = require(script.Parent.Highlight)

return function(targetModel)
	return Highlight.fromTarget(targetModel)
end