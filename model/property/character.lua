local Character = new 'model.property' {
  typename = 'character',
	max_hp = 0,
	hp = 0,
  speed = 0,
  max_energy = 0,
  energy = 0
}

function Character:init() 
  self.hp = self.max_hp
  self.energy = self.max_energy
end

function Character:onUpdate(dt, turn, battle)
  if self.hp <= 0 then
    local side = self.avatar.side
    for i, entity in ipairs(battle[side].characters) do
      if self.id == entity.id then
        table.remove(battle[side].characters,i)
      end
    end
    self.avatar:destroy()
    self.stage:remove(self.id)
  end
  self.avatar.lifebar.value = math.max(self.hp/self.max_hp, 0) --atualiza a barra de hp, garante que nunca fique abaixo de
  self.avatar.energybar.value = math.max(self.energy/self.max_energy, 0) 
end

return Character
