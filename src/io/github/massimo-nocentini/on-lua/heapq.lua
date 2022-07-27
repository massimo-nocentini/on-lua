--[[

Implementation of an heap, based on the Python implementation.
	
--]]

local operator = require 'io.github.massimo-nocentini.on-lua.operator'

local heapq = {}

local function siftdown(heap, startpos, pos)
	--[[
		# 'heap' is a heap at all indices >= startpos, except possibly for pos.  pos
		# is the index of a leaf with a possibly out-of-order value.  Restore the
		# heap invariant.
		def _siftdown(heap, startpos, pos):
		    newitem = heap[pos]
		    # Follow the path to the root, moving parents down until finding a place
		    # newitem fits.
		    while pos > startpos:
		        parentpos = (pos - 1) >> 1
		        parent = heap[parentpos]
		        if newitem < parent:
		            heap[pos] = parent
		            pos = parentpos
		            continue
		        break
		    heap[pos] = newitem
	]]
	
	local newitem = heap[pos]
	
	-- Follow the path to the root, moving parents down until finding a place newitem fits.
	while pos > startpos do
		local parentpos = pos >> 1
		local parent = heap[parentpos]
		if newitem < parent then
            heap[pos] = parent
            pos = parentpos
            goto continue
		end
		break
		::continue::
	end
	heap[pos] = newitem
end


function heapq.push(heap, item, key)

	--[[
		def heappush(heap, item):
		    """Push item onto heap, maintaining the heap invariant."""
		    heap.append(item)
		    _siftdown(heap, 0, len(heap)-1)		
	]]

	table.insert(heap, item)
	siftdown(heap, 1, #heap, key or operator.identity)
	
end

function heapq.pop(heap)

	--[[
		def heappop(heap):
		    """Pop the smallest item off the heap, maintaining the heap invariant."""
		    lastelt = heap.pop()    # raises appropriate IndexError if heap is empty
		    if heap:
		        returnitem = heap[0]
		        heap[0] = lastelt
		        _siftup(heap, 0)
		        return returnitem
		    return lastelt		
	]]
	
	local lastelt = table.remove(heap)
	
	if #heap > 0 then
		local returnitem = heap[1]
		heap[1] = lastelt
		siftup(heap, 1)
		return returnitem
	else
		return lastelt
	end
end

local function siftup(heap, pos)
	--[[
		def _siftup(heap, pos):
		    endpos = len(heap)
		    startpos = pos
		    newitem = heap[pos]
		    # Bubble up the smaller child until hitting a leaf.
		    childpos = 2*pos + 1    # leftmost child position
		    while childpos < endpos:
		        # Set childpos to index of smaller child.
		        rightpos = childpos + 1
		        if rightpos < endpos and not heap[childpos] < heap[rightpos]:
		            childpos = rightpos
		        # Move the smaller child up.
		        heap[pos] = heap[childpos]
		        pos = childpos
		        childpos = 2*pos + 1
		    # The leaf at pos is empty now.  Put newitem there, and bubble it up
		    # to its final resting place (by sifting its parents down).
		    heap[pos] = newitem
		    _siftdown(heap, startpos, pos)
	]]
	local endpos, startpos, newitem, childpos = #heap, pos, heap[pos], 2 * pos
	
	-- Bubble up the smaller child until hitting a leaf.
	while childpos <= endpos do
	
		-- Set childpos to index of smaller child.
		do
			local rightpos = childpos + 1
			if rightpos <= endpos and not (heap[childpos] < heap[rightpos]) then childpos = rightpos end
		end
		
	-- Move the smaller child up.
        heap[pos] = heap[childpos]
        pos = childpos
	childpos = 2 * pos
	end
	
	-- The leaf at pos is empty now.  Put newitem there, and bubble it up
	-- to its final resting place (by sifting its parents down).
	heap[pos] = newitem
	siftdown(heap, startpos, pos)
	
end

function heapq.heapify(heap)
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
	for i = #heap >> 1, 1, -1 do
		siftup(heap, i)
	end
end

return heapq -- finally return the module

