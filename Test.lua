repeat
    task.wait()
until game:IsLoaded()

_G.Settings = {
    Main = tostring(""), -- Main Name
    Prefix = tostring("!"), -- Prefix Goes Here
}


local commands , prefix = {} , _G.Settings.Prefix

local function AddCommand(name, cmd)
   cmd = cmd or function () end
   commands[name] = cmd
end

game:GetService("Players")[_G.Settings.Main].Chatted:Connect(function(msg)
   if msg:sub(1,1) == prefix then
       if commands[msg:split(" ")[1]:gsub(prefix, "")] then
           local commandArguments = msg:split(" ")
           table.remove(commandArguments, 1) -- remove the !command
           commands[msg:split(" ")[1]:gsub(prefix, "")](table.unpack(commandArguments)) -- run the command with its arguments
       end
   end
end)


AddCommand("print", function(...)
    print(...)
 end)


 AddCommand("Chat" , function(...)
    game:GetService("Players"):Chat(...)
 end)
