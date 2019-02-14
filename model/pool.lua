-- estrutura de dados mais dinamica que table
-- diante de remoção ele nao reajusta tudo e se
-- mandar outra coisa vai pro mesmo lugar

local Pool = new(Object) {
  elements = nil,
  id2index = nil, --id é o nome e nao o numero
  free_indices = nil,
  removed = nil
}

function Pool:init()
  self.elements = {}
  self.id2index = {}
  self.free_indices = {}
  self.removed = {}
end

function Pool:_nextIndex()
  if #self.free_indices > 0 then
    return table.remove(self.free_indices, 1)
  else
    return #self.elements + 1
  end
end

function Pool:insert(id, element)
  local index = self:_nextIndex()
  self.elements[index] = element
  self.id2index[id] = index
end

function Pool:find(id)
  local index = self.id2index[id]
  if index then
    return self.elements[index]
  end
end

local function _generator(self)
  for id, index in pairs(self.id2index) do
    if not self.removed[id] then
      coroutine.yield(id, self.elements[index])
    end
  end
end

function Pool:each()
  return coroutine.wrap(_generator), self
end

function Pool:remove(id)
  self.removed[id] = self.id2index[id] and true
end

function Pool:flush()
  for id in pairs(self.removed) do
    local index = self.id2index[id]
    self.elements[index] = false
    self.id2index[id] = nil
    table.insert(self.free_indices, index)
  end
  self.removed = {}
end

return Pool

