
local ChooseAction = new 'state.base' {
  cont = 1,
  items = {}
}

function ChooseAction:fight()
  self.action = 'attack'
  self.targets = { unpack(self.battle.left.characters) }
  self.stack:push('choose_target', self.battle, self.targets)
end

function ChooseAction:item()
  self.action = 'item'
  -- Pega os itens disponíveis no inventário da party
  if self.cont == 1 then
    self.cont = 0
    for i, item in ipairs(self.battle.right.items) do
    
      local item_spec = require ('database.entities.' .. self.battle.right.items[i].name)
      table.insert(self.items, item_spec.name)
    end
  end

  if #self.items == 0 then return 0 end

  self.stack:push('choose_option', self.battle, self.items)
end

function ChooseAction:run()
  love.event.quit()
end

------------------------------------ abstract

function ChooseAction:onEnter(battle)
  self.graphics = battle.graphics
  self.battle = battle

  -- Cria menu de combate
  local W, H = love.graphics.getDimensions()
  local width, height = 120, 160
  local menu = new 'graphics.menu' {
    position = new(Vec) {W/2, 2*H/3},
    box = new(Box) {-width/2, width/2, -height/2, height/2}
  }

  menu:add("Fight", function() self:fight() end)
  menu:add("Item", function() self:item() end)
  menu:add("Run", function() self:run() end)

  self.graphics:add('gui', menu)
  self.menu = menu

  self.graphics:focus(menu)
end

function ChooseAction:onLeave()
  self.menu:destroy()
end

-- onSuspend()

function ChooseAction:onResume()
  if self.action == 'attack' and self.targets.chosen then
    self.battle:setNextAction(self.action, { target = self.targets.chosen, attacker = nil })
    self.stack:pop()
    self.action = nil
    self.targets = nil
  elseif self.action == 'item' and self.items.chosen then
    self.battle:setNextAction(self.action, {
      target = self.battle:currentCharacter().avatar,
      item = self.items.chosen,
      items = self.items
    })
    self.stack:pop()
    self.action = nil
    self.items = nil
  else
    self.graphics:focus(self.menu)
  end
end

-- onUpdate()

return ChooseAction

