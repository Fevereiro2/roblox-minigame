# Roblox Fishing Game Base

Base profissional para um Fishing Game em Roblox, preparado para Rojo e escalavel.

## Requisitos
- Roblox Studio + plugin Rojo
- Rojo CLI

## Como executar
1) No terminal, a partir da raiz do projeto:
   rojo serve
2) No Roblox Studio, abra o plugin Rojo e conecte ao servidor.
3) Clique em Play.

## Estrutura
- `src/ServerScriptService/Services`: servicos do servidor (dados, pesca, loja, rewards).
- `src/ServerScriptService/Game.server.lua`: orquestrador dos servicos.
- `src/ReplicatedStorage/Modules`: databases + configuracao visual.
- `src/ReplicatedStorage/Remotes`: wrappers de RemoteEvents/Functions.
- `src/StarterPlayer/StarterPlayerScripts`: bootstrap, HUD, menus e sistemas do cliente.
- `src/StarterGui/UI`: tema e componentes reutilizaveis de UI.

## Notas
- Os RemoteEvents sao criados no servidor em `PlayerDataService.GetRemote()`.
- A logica sensivel fica no servidor; o cliente apenas solicita.
- DataStore ativo em `Services/PlayerDataService.lua` (use um jogo publicado e habilite "Enable Studio Access to API Services" para testes).
- MarketplaceService pronto para GamePass e Developer Products (preencha os IDs nas databases).

## Configuracao de monetizacao
- Preencha `gamePassId` em `src/ReplicatedStorage/Modules/MapDatabase.lua` e `src/ReplicatedStorage/Modules/RodDatabase.lua`.
- Preencha `productId` em `src/ReplicatedStorage/Modules/ProductDatabase.lua`.
- Ajuste os pacotes/boosts em `src/ReplicatedStorage/Modules/ProductDatabase.lua`.

## Spawns dos mapas
Crie em `workspace` uma pasta `MapSpawns` com `BasePart` usando o mesmo nome do `mapId`.
Exemplo: `lago_inicial`, `lago_misterioso`, `mar_profundo`, `caribe`, `rio_gelado`.
