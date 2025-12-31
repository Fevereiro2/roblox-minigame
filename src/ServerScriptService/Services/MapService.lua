local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))
local MapDatabase = State.Databases.Maps

local selectEvent = State.GetRemote("SelectMap")

local function ensureCharacter(player)
	if not player.Character or not player.Character.Parent then
		player:LoadCharacter()
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
	if root and not character.PrimaryPart then
		character.PrimaryPart = root
	end

	return character
end

local function teleportToMap(player, mapId)
	local spawnFolder = workspace:FindFirstChild("MapSpawns")
	if not spawnFolder then
		return
	end

	local spawnPart = spawnFolder:FindFirstChild(mapId)
	if not spawnPart or not spawnPart:IsA("BasePart") then
		return
	end

	local character = ensureCharacter(player)
	if not character or not character.PrimaryPart then
		return
	end

	character:SetPrimaryPartCFrame(spawnPart.CFrame + Vector3.new(0, 3, 0))
end

selectEvent.OnServerEvent:Connect(function(player, mapId)
	if type(mapId) ~= "string" then
		return
	end

	local data = State.GetData(player)
	if not data then
		return
	end

	local map = MapDatabase.GetById(mapId)
	if not map then
		selectEvent:FireClient(player, { ok = false, reason = "INVALID_MAP" })
		return
	end

	if not data.UnlockedMaps[mapId] then
		selectEvent:FireClient(player, { ok = false, reason = "LOCKED" })
		return
	end

	if data.Level < map.minLevel then
		selectEvent:FireClient(player, { ok = false, reason = "LOW_LEVEL" })
		return
	end

	data.SelectedMap = mapId
	State.SetAttributes(player, data)
	teleportToMap(player, mapId)

	selectEvent:FireClient(player, { ok = true, mapId = mapId })
end)
