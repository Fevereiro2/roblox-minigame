local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemote()
	local folder = ReplicatedStorage:WaitForChild("RemoteFunctions")
	return folder:WaitForChild("GetProfile")
end

return getRemote
