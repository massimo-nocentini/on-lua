
local op = {}

function op.identity(...)
	return ...	-- returns whatever I consume
end

function op.eternity(...)
	return op.eternity(...)	-- infinite recursion
end

function op.noop()
	-- simply do nothing
end

function op.forever(f, ...)
	while true do f(...) end
end

function op.recv (...) 
	return op.frecv(op.identity, op.noop, ...)
end

function op.frecv (f, g, s, ...)
	if not g then g = function () end end
	if s then return f(...) else return g(...) end
end

function op.add(a, b)
	return a + b
end
	

return op