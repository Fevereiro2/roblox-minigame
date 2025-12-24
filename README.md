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
- `src/ServerScriptService`: scripts do servidor e validacoes.
- `src/ReplicatedStorage`: databases e remotes compartilhados.
- `src/StarterPlayer`: scripts do cliente e HUD.
- `src/StarterGui`: UI inicial, shop, pokedex e selecao de mapas.

## Notas
- Os RemoteEvents sao criados no servidor em `State.GetRemote()`.
- A logica sensivel fica no servidor; o cliente apenas solicita.
- DataStore ativo em `State.lua` (use um jogo publicado e habilite "Enable Studio Access to API Services" para testes).
- MarketplaceService pronto para GamePass e Developer Products (preencha os IDs nas databases).

## Configuracao de monetizacao
- Preencha `gamePassId` em `src/ReplicatedStorage/Modules/MapDatabase.lua` e `src/ReplicatedStorage/Modules/RodDatabase.lua`.
- Preencha `productId` em `src/ReplicatedStorage/Modules/ProductDatabase.lua`.
- Ajuste os pacotes/boosts em `src/ReplicatedStorage/Modules/ProductDatabase.lua`.

## Spawns dos mapas
Crie em `workspace` uma pasta `MapSpawns` com `BasePart` usando o mesmo nome do `mapId`.
Exemplo: `lago_inicial`, `lago_misterioso`, `mar_profundo`, `caribe`, `rio_gelado`.
