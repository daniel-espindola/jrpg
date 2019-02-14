
# Módulo da arquitetura experimental

Aqui vou fazer ume breve descrição da API do módulo

## Stage

O protótipo `Stage` em `model/stage.lua` contém todas as entidades do modelo/simulação do jogo, e é
responsável por sua criação, remoção, composição e consulta.

### **:create()**

Cria uma entidade nova e coloca ela no palco.

```lua
local id = stage:create(entity_name)
```

A entidade é criada segundo o arquivo encontrado em
`database/entities/<entity_name>.lua`, segundo este formato:

```lua
-- database/entities/example.lua
return {
  -- Usado para definir o ID da entidade
  name = "Example",
  properties = {
    -- Aqui as chaves são os *typenames* das propriedades
    body = {
      speed = 200,
      weight = 50
    },
    damageable = {
      max_hp = 100,
      resistence = 20
    }
  }
}
```

Onde cada propriedade será instanciada usando

```lua
local property = new 'model.properties.<typename>' { ... }
```

Com os atributos fornecidos pela tabela correspondente no arquivo do banco de
dados. No exemplo acima, `stage:create()` vai fazer mais ou menos o equivalente
a:

```lua
local entity_data = require 'database.entities.example'
-- Cria propriedade body
local body_data = entity_data.properties.body
local body = new 'model.property.body' (body_data)
-- Cria propriedade damageable
local damageable_data = entity_data.properties.damageable
local damageable = new 'model.property.damageable' (damageable_data)
```

O id devolvido por `stage:create()` é o identificador da entidade criada. Ela
vai conter todas as propriedades descritas no seu registro no banco de dados.
Você pode usar esse id para consultar as propriedades da entidade através do
método `stage:find(id)`.

### **:add()**

Adiciona uma propriedade a uma entidade (possivelmente criando ela).

```lua
stage:add(id, property)
```

O objeto propriedade já deve estar devidamente instanciado. Isso normalmente é
usado quando uma propriedade precisa ser criada manualmente no código e
adicionada a uma entidade em tempo de execução. Por exemplo, se uma torre fica
infectada por um zumbi e agora tem uma propriedade `explodable`.

### **:find()**

Consulta a propriedade do tipo específicado na entidade com o ID procidenciado.
Caso ela não tenha tal propriedade, devolve nulo.

```lua
local property = stage:find(id, typename)
```

### **:remove()**

Remove a entidade com este ID do palco. Ou seja, remove todas suas propriedades.

```lua
stage:remove(id)
```

### **:updateDomains()**

Chama `onUpdate(dt)` em todas as propriedades de todos os tipos.

```lua
stage:updateDomains(dt)
```

## Property
