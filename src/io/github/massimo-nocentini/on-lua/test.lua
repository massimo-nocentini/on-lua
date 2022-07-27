
local heapq = require 'io.github.massimo-nocentini.on-lua.heapq'

local heap = {}

heapq.push(heap, 1)
heapq.push(heap, 2)
heapq.push(heap, -4)
heapq.push(heap, 5)

assert (heap[1] == -4)

heap = {}

for i=10,1,-1 do
	heapq.push(heap, i)
	print(table.concat(heap, ', '))
end

print('')


heap = {}

for i=10,1,-1 do
	table.insert(heap, i)
end

print(table.concat(heap, ', '))
	
heapq.heapify(heap)

print(table.concat(heap, ', '))


heap = {}

for i=11,1,-1 do
	table.insert(heap, i)
end

print(table.concat(heap, ', '))
	
heapq.heapify(heap)

print(table.concat(heap, ', '))

heapq.push(heap, 12)

print(table.concat(heap, ', '))

heapq.push(heap, -12)

print(table.concat(heap, ', '))

heapq.sort(heap)

print(table.concat(heap, ', '))
