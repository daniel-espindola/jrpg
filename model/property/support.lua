local Support = new 'model.property' {
  typename = 'support',
  hp = 0,
  defense = 0, -- qt aumenta defesa
  attack = 0, -- qt aumenta ataque
}

function Support:init()
  --abstract
end

function Support:onUpdate()


end

return Support
