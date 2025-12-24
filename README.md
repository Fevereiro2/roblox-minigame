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
- Preparado para integrar DataStore e MarketplaceService.
