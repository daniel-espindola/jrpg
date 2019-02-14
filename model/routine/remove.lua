local Remove = new 'model.routine' {
  stage = nil
}

function Remove:play(id)
  self.stage.remove(id)
end

return Remove
