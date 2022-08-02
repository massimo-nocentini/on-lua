--[[

Implementation of an heap, based on the Python implementation.
	
--]]

local operator = require 'io.github.massimo-nocentini.on-lua.operator'

local heapq = {}

local mt = { __index = heapq }

function isheapq(obj)
	return getmetatable(obj) == mt
end

function heapq.new(lst, key)
	
	H = {position = {}, 
		 key = key or operator.identity}
	
	setmetatable(H, mt)
	
	for i, v in ipairs(lst) do
		H[i] = v
		H.position[v] = i
	end
	
	return H
end

local function swap(heap, position, i, j)
	local J, I = heap[j], heap[i]
	heap[i], heap[j] = J, I
	position[J], position[I] = i, j
end

local function heapifyup(heap, i, position, key)
	-- I'm a recursive definition of siftdown
	if i < 2 then return end
	local j = i >> 1
	if key(heap[i]) < key(heap[j]) then
		swap(heap, position, i, j)
		return heapifyup(heap, j, position, key)
	end	
end

local function heapifydown(heap, i, position, key)
	local n, ii = #heap, i << 1
	if ii > n then return end
	
	local j
	if ii < n then
		local r = ii + 1
		if key(heap[ii]) < key(heap[r]) then j = ii else j = r end
	else j = ii end
	
	if key(heap[j]) < key(heap[i]) then
		swap(heap, position, i, j)
		return heapifydown(heap, j, position, key)
	end
end

function heapq.key(heap, i)
	return heap.key(heap[i])
end

function heapq.delete(heap, i)
	swap(heap, heap.position, i, #heap)
	local elt = table.remove(heap)
	heap.position[elt] = nil
	
	if heap:key(i) < heap:key(i >> 1)
	then error('some error'); heapifyup(heap, i, heap.position, heap.key)
	else heapifydown(heap, i, heap.position, heap.key) end

	return elt
end

function heapq.pop(heap, elt)
	return heap:delete(heap.position[elt] or 1)
end

function heapq.push(heap, item)

	--[[
		def heappush(heap, item):
		    """Push item onto heap, maintaining the heap invariant."""
		    heap.append(item)
		    _siftdown(heap, 0, len(heap)-1)		
	]]

	if heap.position[item] then error('Duplicated item')
	else
		table.insert(heap, item)
		len = #heap
		heap.position[item] = len
		return heapifyup(heap, 1, heap.position, heap.key)
	end
end

function heapq.heapify(heap, position, key)
	--[[
		def heapify(x):
		    """Transform list into a heap, in-place, in O(len(x)) time."""
		    n = len(x)
		    # Transform bottom-up.  The largest index there's any point to looking at
		    # is the largest with a child index in-range, so must have 2*i + 1 < n,
		    # or i < (n-1)/2.  If n is even = 2*j, this is (2*j-1)/2 = j-1/2 so
		    # j-1 is the largest, which is n//2 - 1.  If n is odd = 2*j+1, this is
		    # (2*j+1-1)/2 = j so j-1 is the largest, and that's again n//2-1.
		    for i in reversed(range(n//2)):
		        _siftup(x, i)
	]]
	
	position = position or heap.position or {}
	key = key or heap.key or operator.identity
	
	for i = #heap >> 1, 1, -1 do
		heapifydown(heap, i, position, key)
	end
	
	return heap
end

function heapq.sort(heap)

	local sorted = {}
	
	while #heap > 0 do table.insert(sorted, heap:pop()) end

	return sorted
end

return heapq -- finally return the module

