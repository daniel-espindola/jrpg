local Battle = new 'state.base' {
  current_party = 'right', --<
  current_char = 1, --<
  next_action = nil, --<
  delay = 0, --<
  voltou = 0,
  --acesso a outros diretorios
  graphics = nil, --< 
  stage = new 'model.stage' {}, --<
  entities = {}
}

function Battle:loadParty(side, name)
  -- exitem : charname, charnames, charactername
  local W, H = love.graphics.getDimensions() --<
  local charnames = require('database.parties.' .. name)
  local itemNames = charnames.items
  charnames = charnames.members

  local party = { --<
    characters = {}, --<
    items = {}
  }

  for i, itemName in ipairs(itemNames) do
    local item = { id = self.stage:create(itemName), name = itemName }
    table.insert(party.items, item)
  end

  for i, charname in ipairs(charnames) do --<
    local x --<
    if side == 'right' then x = W - 480 + 80 * i
    elseif side == 'left' then x = 480 - 80 * i end
    party.characters[i] = {
      avatar = new 'graphics.avatar' { --<
        charactername = charname, --<
        side = side, --<< +-
        position = new(Vec) { x, i * 120 }, --<
        drawables = {}, --<
      }
    }
    self.graphics:add('entities', party.characters[i].avatar)
    --
    local id = self.stage:create(charname)
    local entity = self.stage:find(id,'character')
    entity.avatar = party.characters[i].avatar
    entity.graphics = self.graphics
    entity.battle = self
    entity.stage = self.stage
    party.characters[i].id = id
    table.insert(self.entities, id)
  end
  self[side] = party --@ nao sei o q essa linha significa
end

function Battle:currentCharacter()
  return self[self.current_party].characters[self.current_char]
end

function Battle:setNextAction(name, params)
  self.next_action = {
    name = name, --<
    params = params --<
  }
end

---------------------------------------------- abstract

function Battle:onEnter(graphics)
  self.graphics = graphics
  graphics:add('bg', new 'graphics.arena' {})
  self:loadParty('right', 'heroes')
  self:loadParty('left', 'evil-dms01')
end

-- onleave()
-- onsuspend()

function Battle:onResume(a)
  if self.next_action then
    -- state/stack no init state/base
    self.stack:push('execute_action', self, self.next_action) --< POO
    self.next_action = nil
  else
    self:currentCharacter().avatar:hideCursor()
    if (self.current_char == #self.right.characters) then
      self.current_party = 'left'
      self.current_char = 0
      self.stack:push('enemy_turn', self)
    else
      if(self.voltou == 0) then
        self.current_char = self.current_char + 1
      end
      self.voltou = 0
    end
  end
end

function Battle:onUpdate(dt)
  local turn = self.current_char 
  self.stage:updateDomains(dt, turn, self) --atualiza o hp por enqnt
  
  self:currentCharacter().avatar:showCursor()
  -- state/stack no init state/base
  self.stack:push('choose_action', self) --< POO
end

return Battle

