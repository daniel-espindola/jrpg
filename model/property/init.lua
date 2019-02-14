
local Property = new(Object) {
  typename = 'none',
  signals = nil,
  stage = nil, -- injetada quando a propriedade é registrada
}

function Property:onRegister() --chamada na primeira vez que a chamada é inserida no palco
  -- abstract
end

function Property:onRemove() --mesmo do acima so q remove ... nem deve ser usado
  -- abstract
end

function Property:as(typename) --atalho
  -- body.as("tower")
  -- onde o body é uma propriedade
  -- vê se no stage/palco de tower tem a propriedade body que colocou
  return self.stage:find(self.id, typename)
end

-- exemplo de uso de sinal = "levei dano"
-- desacoplar quem emite o codigo de quem recebe o codigo
-- pode ter alguem observando aquele sinal ou nao
-- forma de comunicação entre as propriedades
-- nem sei se vai usar coisa de sinal
function Property:addSignal(name) -- sinais = eventos = mensagens 
  self.signals = self.signals or {}
  self.signals[name] = {}
end

-- nem sei se vai usar coisa de sinal 2
function Property:connectSignal(name, object, method, oneshot)
  self.signals[name][object] = self.signals[name][object] or {}
  self.signals[name][object][method] = { oneshot = oneshot }
end

-- nem sei se vai usar coisa de sinal3
function Property:disconnectSignal(name, object, method)
  self.signals[name][object][method] = nil
end

-- tem que chamar esse metodo na mao quando for ser usado no codigo
-- nem sei se vai usar coisa de sinal 4
function Property:emitSignal(name, ...)
  for object,connections in pairs(self.signals[name]) do
    for method,connection in pairs(connections) do
      object[method](object, ...)
      if connection.oneshot then
        object[method] = nil
      end
    end
  end
end

function Property:destroy() --gudi
  self.stage:getDomain(self.typename):remove(self.id)
end

function Property:onUpdate(dt) --se for precisar para chamar o update de todas entidades
  -- abstract
end

return Property

