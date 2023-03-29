local FindMain = function(Name)
    for _, Lower in pairs(game:GetService("Players"):GetPlayers()) do
        if string.find(string.lower(Lower.Name), string.lower(Name)) then
            return Lower
        end
    end
end

local TargetSystem = function(Name)
    for _ , Find in pairs(game:GetService("Players"):GetPlayers()) do
        if string.find(string.lower(Find.Name) , string.lower(Name)) or string.find(string.lower(Find.DisplayName) , string.lower(Name)) then
            return Find
        end



    end
end

local TaskWait = function(Num)
    local Current = tick()
    Num = Num or 0
    repeat
        game:GetService("RunService").Heartbeat:Wait()
    until tick() - Current >= Num
    return tick() - Current
end

local commands , prefix , M , Connections  = {} , getgenv().Settings.Prefix:lower() , FindMain(getgenv().Settings.Main) , {}
getgenv().Stop = true

local AddCommand = function(name , cmd)
    cmd = cmd or function () end
    commands[name] = cmd
end

local Chat = function(...)
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(...,"All")
end

game:GetService("Players")[tostring(M)].Chatted:Connect(function(msg)
   if msg:sub(1,1) == prefix then
       if commands[msg:split(" ")[1]:gsub(prefix, "")] then
           local commandArguments = msg:split(" ")
           table.remove(commandArguments, 1) -- remove the !command
           commands[msg:split(" ")[1]:gsub(prefix, "")](table.unpack(commandArguments)) -- run the command with its arguments
       end
   end
end)


-- \\ Target // --

AddCommand("find" , function(...)
    local Target = TargetSystem(...)
    print(Target)
end)

AddCommand("behind" , function(...)
    local Target = TargetSystem(...)
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Target.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0 , 0 , -1)
end)

AddCommand("fling" , function(...)
    local Target = TargetSystem(...)

    local CFrame = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
    local Fling_Duration = 3
    if not Target.Character:FindFirstChild("Humanoid") or not Target.Character then
        return
    end
    local bodyVelocity =
        Instance.new("BodyVelocity", game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").RootPart)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local Heart =
        game:GetService("RunService").RenderStepped:Connect(
        function()
            game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").RootPart.CFrame =
                Target.Character:FindFirstChild("HumanoidRootPart").CFrame
            bodyVelocity.Velocity = Vector3.new(0, 0, 1000)
            TaskWait(0.2)
            bodyVelocity.Velocity = Vector3.new(1000, 0, 0)
        end
    )
    TaskWait(Fling_Duration)
    Heart:Disconnect()
    bodyVelocity:Destroy()
    while TaskWait() do
        if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new()
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").RotVelocity = Vector3.new()
        break
    end
end)

AddCommand("findrandom" , function()
    local Random = game:GetService("Players")[math.random(1 , #game:GetService("Players"):GetPlayers())]
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Random.Character:FindFirstChild("HumanoidRootPart").CFrame
end)


-- \\ Basic Commands // --


AddCommand("print", function(...)
    print(...)
 end)


AddCommand("chat" , function(...)
    Chat(...)
end)

AddCommand("bring" , function()
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game:GetService("Players")[M].Character:FindFirstChild("HumanoidRootPart").CFrame
end)

AddCommand("prefix" , function() 
    Chat(tostring(prefix))
    print("Hello")
end)

AddCommand("main" , function()
    Chat(M)
end)

AddCommand("seat" , function()
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Sit = true
    TaskWait(0.1/0.1)
    game:GetService("Workspace"):FindFirstChildWhichIsA("Seat").CFrame = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
end)

AddCommand("noclip" , function()
    table.insert(Connections , game:GetService("RunService").RenderStepped:Connect(function()
        for _ , Playas in next , game:GetService("Players"):GetPlayers() do
            if Playas and Playas ~= game:GetService("Players").LocalPlayer and Playas.Character then
                task.spawn(function()
                    for _ , Characters in next , Playas.Character:GetChildren() do
                        if Characters:IsA("BasePart") or Characters:IsA("Meshpart") and Characters.CanCollide then
                            Characters.CanCollide = false
                            Characters.Velocity = Vector3.new()
                            Characters.RotVelocity = Vector3.new()
                            TaskWait()
                        end
                    end
                end)
            end
        end
    end))
end)

AddCommand("unclip" , function()
    for _ , Connection in pairs(Connections) do
        Connection:Disconnect()
    end
end)

AddCommand("Spamchat" , function(...)
    getgenv().Stop = true
    repeat
        Chat(...)
        TaskWait(2.25)
    until Stop == false
end)

AddCommand("unspam" , function()
    getgenv().Stop = false
end)
