local ExecuteAction = new 'state.base' {
  delay = 0,
  attack = new 'model.routine.attack' {}
}
------------------------------------------- abstract

function ExecuteAction:onEnter(battle, action)
  self.attack.stage = battle.stage -- deve ter um jeito melhor de fazer isso
  local name, params = action.name, action.params
  if name == 'attack' then
    local target = params.target
    local damage = self.attack:play(battle:currentCharacter().id, target.id) -- chama a rotina de attack
    battle.graphics:add('fx', new 'graphics.notification' {
      position = new(Vec) { target.avatar.position:get() },
      color = { .9, .9, .2 },
      text = damage
    })
    self.delay = 1.0
  elseif name == 'item' then
    print(params.item, params.target)
    battle.graphics:add('fx', new 'graphics.notification' {
      position = new(Vec) { params.target.position:get() },
      color = { .2, .9, .9 },
      text = params.item
    })
  end
end

-- onLeave()
-- onSuspend()
-- onResume()

function ExecuteAction:onUpdate(dt)
  self.delay = self.delay - dt
  if self.delay <= 0 then
    self.stack:pop()
  end
end

return ExecuteAction

