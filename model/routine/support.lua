local Support = new 'model.routine' {
  stage = nil
}

function Support:play(effectID, targetID)
  local effect = self.stage:find(effectID, 'support')
  local target = self.stage:find(targetID, 'character')
  
  local heal = effect.hp or 0 
  local def = effect.defense or 0 
  local atk = effect.attack or 0
  
  target.hp = math.min(target.hp + heal, target.max_hp)
  target.def = math.min(target.def + def, .99) -- def máxima é de 99% de redução
  target.power = target.power + atk
  
  return heal
end

return Support
