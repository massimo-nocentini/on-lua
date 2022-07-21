
function coroutine.const(f)
	return coroutine.create(function (...)
		local v = f(...)
		while true do coroutine.yield(v) end
	end)
end

function identity(...)
	return ...
end

function coroutine.take (co, n)
	return coroutine.create(function () 
		for i = 1, n or math.huge do
			local s, v = coroutine.resume(co)
			coroutine.yield(v)
		end
	end)
end

function recv (s, ...) 
	if s then return ... else return nil end
end

function coroutine.iter (co)
	return function () return recv(coroutine.resume(co)) end 
end

function coroutine.nats(s)
	return coroutine.create(function () 
		local each = s or 0 -- initial value
		while true do
			coroutine.yield(each)
			each = each + 1
		end
	end)
end

function coroutine.map(f)
	return function (co)
		return coroutine.create(
			function ()
				while true do
					local s, v = coroutine.resume(co)
					if s then coroutine.yield(f(v)) else break end
				end
			end)
	end
end

function coroutine.zip(co, another_co)
	return coroutine.create(
		function () 
			while true do
				local s, v = coroutine.resume(co)
				local r, w = coroutine.resume(another_co)
				if s and r then coroutine.yield(v, w) else break end
			end
		end)
end


function table.foldr (tbl, f, init)
	for i = #tbl, 1, -1 do
		init = f(tbl[i], init)
	end
	return init
end

function table.map (tbl, f)
	mapped = {}
	for k, v in pairs(tbl) do mapped[k] = f(v) end
	return mapped
end

fibs = {[0] = 0, [1] = 1}
local fibs_mt = {}

function fibs_mt.__index(tbl, i)
	print('•')
	local f = tbl[i-1] + tbl[i-2]
	tbl[i] = f
	return f
end

setmetatable(fibs, fibs_mt)

co = coroutine.create(function () coroutine.yield(4); return 3 end)

function receive (prod)
	local status, value = coroutine.resume(prod)
    return value
end

function send (x)
	coroutine.yield(x)
end

function producer ()
	return coroutine.create(
		function ()
    		while true do
      			local x = io.read()
      			send(x)
			end
		end)
end

-- produce new value
function filter (prod)
  return coroutine.create(function ()
    for line = 1, math.huge do
      local x = receive(prod)   -- get new value
      x = string.format("%5d %s", line, x)
      send(x)      -- send it to consumer
end end)
end

function consumer (prod)
  while true do
    local x = receive(prod)
    io.write(x, "\n")
  end
end

-- consumer(filter(producer()))