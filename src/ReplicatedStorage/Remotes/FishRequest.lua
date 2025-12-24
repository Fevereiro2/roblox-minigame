local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemote()
	local folder = ReplicatedStorage:WaitForChild("RemoteEvents")
	return folder:WaitForChild("FishRequest")
end

return getRemote
