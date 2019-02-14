local Support = new 'model.routine' {
  stage = nil
}

function Support:play(effectID, targetID)
  local effect = self.stage:find(effectID, 'support')
  local target = self.stage:find(targetID, 'character')

  local heal = effect.hp or 0 
  local def = effect.defense or 0 
  local atk = effect.attack or 0
  
  local effects = {heal,atk,def} -- para mostrar na tela o fx dps

  target.hp = math.min(target.hp + heal, target.max_hp)
  target.power = target.power + atk
  
  if target:as('defense') then -- caso o personagem tenha a propriedade defense
    local defense = target:as('defense')
    defense.def = math.min(defense.def + def, .99) -- def máxima é de 99% de redução
  end

  return effects
end

return Support
