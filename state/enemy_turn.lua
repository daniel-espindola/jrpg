local Enemy_turn = new 'state.base' {
  battle = nil,
  attack = new 'model.routine.attack' {},
  
}

function Enemy_turn:onEnter(battle)
  self.attack.stage = battle.stage
  targets = battle.right
  enemies = battle.left
  
  for i, enemy in ipairs(enemies.characters) do
    choosen = love.math.random(1,#targets.characters)
    self.attack:play(enemy.id, targets.characters[choosen].id)
  end
  
  battle.current_party = 'right'
  battle.current_char = 1
  battle.voltou = 1
end

function Enemy_turn:onUpdate(dt)

end

function Enemy_turn:onLeave()

end

return Enemy_turn
