local Attack = new 'model.routine' {
  stage = nil
}

function Attack:play(attackerID, targetID)
  local attacker = self.stage:find(attackerID, 'character')
  local target = self.stage:find(targetID, 'character')
  local damage = attacker.power -- dano sem redução
  
  local defense = target:as('defense')
  if defense then
    def = defense.def
  else
    def = 0
  end

  local damage_reduction = def
  
  damage = math.floor(damage * (1 - damage_reduction)) -- reduz o dano baseado na def do alvo
  
  target.hp = target.hp - damage
  return damage
end

return Attack
