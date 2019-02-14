
local Defense = new 'model.property' {
  typename = 'defense',
	def = 0, -- diminui o dano recebido de ataques em %
	mdef = 0, -- diminui o dano recebido de spells em %
  regen = 0, -- regenera hp no final de turnos
}

function Defense:init() 
  --
end

function Defense:onUpdate(dt, turn)
  if (turn == 1 and self.regen > 0) then
    local character = self:as('character')
    
    character.hp = math.min(character.hp + self.regen, character.max_hp) -- regenera hp se for o caso
    character.graphics:add('fx', new 'graphics.notification' {
      position = new(Vec) { character.avatar.position:get() },
      color = { .6, 1, .6 },
      text = "HP+" .. self.regen
    })
  end
end

return Defense
