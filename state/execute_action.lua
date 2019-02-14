local ExecuteAction = new 'state.base' {
  delay = 0,
  attack = new 'model.routine.attack' {},
  support = new 'model.routine.support' {}
}
------------------------------------------- abstract

function ExecuteAction:onEnter(battle, action)
  self.attack.stage = battle.stage -- deve ter um jeito melhor de fazer isso
  self.support.stage = battle.stage -- same

  local name, params = action.name, action.params
  if name == 'attack' then
    local target = params.target
    local damage = self.attack:play(battle:currentCharacter().id, target.id) -- chama a rotina de attack
    battle.graphics:add('fx', new 'graphics.notification' {
      position = new(Vec) { target.avatar.position:get() },
      color = { .9, .9, .2 },
      text = -damage
    })
    self.delay = 1.0
  elseif name == 'item' then
    local itemID
    
    -- acha o id do item que o player selecionou
    -- tudo isso pq por padrão o item tá sendo referenciado apenas pelo nome
    -- * gambiarra *
    for i, item in ipairs(battle.right.items) do
      local item_spec = require ('database.entities.' .. battle.right.items[i].name)
      if params.item == item_spec.name then 
        itemID = battle.right.items[i].id
        table.remove(params.items, 1)
        break
      end
    end

    local effects = self.support:play(itemID, battle:currentCharacter().id)
    local hp,atk,def = unpack(effects)
    text = ""

    if hp > 0 then text = text .. "HP +" .. hp end
    if atk > 0 then text = text .. "\nATK +" .. atk end
    if def > 0 then text = text .. "\nDEF +" .. def end

    battle.graphics:add('fx', new 'graphics.notification' {
      position = new(Vec) { params.target.position:get() },
      color = { .2, .9, .9 },

      text = text 
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

