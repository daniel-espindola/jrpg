
local Stage = new(Object) {
  next_id = 1
}

function Stage:init()
  self.domains = {}
end

function Stage:getDomain(name)
  local domain = self.domains[name] or new 'model.pool' {}
  self.domains[name] = domain
  return domain
end

function Stage:makeID(name)
  local id = name .. '#' .. self.next_id
  self.next_id = self.next_id + 1
  return id
end

function Stage:create(specname) -- olhar no database
  local spec = require('database.entities.' .. specname)
  local id = self:makeID(spec.name)
  for property_name, property_spec in pairs(spec.properties) do
    local property = {}
    for k,v in pairs(property_spec) do
      property[k] = v
    end
    property = new('model.property.' .. property_name) (property)
    self:add(id, property)
  end
  return id
end

function Stage:add(id, property) -- para adicionar propriedades tem q usar o id da entidade e o objeto da propriedade
  local domain = self:getDomain(property.typename)
  property.stage = self
  property.id = id
  domain:insert(id, property)
  property:onRegister()
  return id
end

function Stage:find(id, typename)
  return self:getDomain(typename):find(id)
end

function Stage:remove(id) -- remove as propriedades daquela entidade
  for name, domain in pairs(self.domains) do
    local property = domain:find(id) if property then
      domain:remove(id)
      property:onRemove()
      property.id = nil
      property.state = nil
    end
  end
end

-- criar talvez remover um metodo so da propriedade
-- ou usar getDomain(typename) -- o metodo da pool que pode remover a propriedade daquela pool
function Stage:updateDomains(dt, turn, battle)
  for _, domain in pairs(self.domains) do
    for id, property in domain:each() do
      property:onUpdate(dt, turn, battle)
    end
  end
  self:flush()
end

function Stage:flush() -- é usado internamente. nos nao usamos.
  for _, domain in pairs(self.domains) do
    domain:flush()
  end
end

return Stage

