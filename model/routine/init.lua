-- provavelmente vai gerenciar os estados do jogo

-- tem 2 metodos abstratos que a ideia é que nos implementemos
local Routine = new(Object) {
  stage = nil,
  log = nil
}


function Routine:getStatus() --ver se o modelo está num estado qué é jogavem usado no caso por exemplo de "ver se a ação pode ser feita na hora" se retornar "ready" pode executar o proximo passo da simulação .. ai usa o play
  return 'ready'
end

-- play do tower defense é diferente do rpg
function Routine:play(...) -- falado no comentario acima
end

return Routine

