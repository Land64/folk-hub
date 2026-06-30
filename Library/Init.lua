local Library = {}

Library.REPO = "https://raw.githubusercontent.com/Land64/folk-hub/main/"

Library.UI = {
    Window = nil,
    Tabs = {}
}

Library.UI.Rayfield = loadstring(game:HttpGet(
    "https://sirius.menu/rayfield"
))()

Library.Games = {}
Library.GameModules = {}

function Library.UI:SetupWindow()
    if not self.Window then
        self.Window = self.Rayfield:CreateWindow({
            Name = "folk hub",
            LoadingTitle = "looking into the future buds",
            Theme = "DarkBlue",

            ConfigurationSaving = {
                Enabled = true,
                FolderName = "folk settings",
                FileName = "Settings"
            },
        })
    end

    return self.Window
end

function Library.UI:CreateTab(name)
    if not self.Window then
        self:SetupWindow()
    end

    local tab = self.Window:CreateTab(name)
    self.Tabs[name] = tab
    return tab
end

function Library.UI:SendNotification(title, content, duration)
    self.Rayfield:Notify({
        Title = title,
        Content = content,
        duration = duration
    })
end

Library.Utils = {}

function Library.Utils:fastLoadstring(file)
    local source = game:HttpGet(self.REPO .. file)
    return loadstring(source)()
end

function Library:SetupWindow()
    return self.UI:SetupWindow()
end

function Library:CreateTab(name)
    return self.UI:CreateTab(name)
end

function Library:SendNotification(title, content, duration)
    return self.UI:SendNotification(title, content, duration)
end

function Library:GetWindow()
    return self.UI.Window
end

function Library:GetTab(name)
    return self.UI.Tabs[name]
end

function Library:RegisterGame(gameData)
    if type(gameData) ~= "table" then
        return false
    end

    self.Games[#self.Games + 1] = {
        Name = gameData.Name or "Unnamed Game",
        PlaceIds = gameData.PlaceIds or {},
        Category = gameData.Category or "Misc",
        File = gameData.File,
        Icon = gameData.Icon or "gamepad",
        Setup = gameData.Setup
    }

    return self.Games[#self.Games]
end

function Library:IsSupportedGame(gameData)
    if not gameData then
        return false
    end

    if not gameData.PlaceIds or #gameData.PlaceIds == 0 then
        return true
    end

    local placeId = tostring(game.PlaceId)
    for _, id in ipairs(gameData.PlaceIds) do
        if tostring(id) == placeId then
            return true
        end
    end

    return false
end

function Library:LoadGame(gameData)
    if type(gameData) ~= "table" then
        return false
    end

    if not self:IsSupportedGame(gameData) then
        return false
    end

    if not gameData.File then
        return false
    end

    local ok, module = pcall(function()
        return self.Utils:fastLoadstring(gameData.File)
    end)

    if not ok then
        warn(("Failed to load game module %s: %s"):format(gameData.Name or gameData.File, tostring(module)))
        return false
    end

    if type(module) == "function" then
        module(self)
        self.GameModules[gameData.Name or gameData.File] = module
        return true
    end

    if type(module) == "table" and type(module.Init) == "function" then
        module.Init(self)
        self.GameModules[gameData.Name or gameData.File] = module
        return true
    end

    return false
end

function Library:LoadGames()
    local ok, games = pcall(function()
        return self.Utils:fastLoadstring("games.lua")
    end)

    if not ok then
        warn("Could not load game list: " .. tostring(games))
        return false
    end

    if type(games) ~= "table" then
        return false
    end

    for _, gameData in ipairs(games) do
        self:LoadGame(gameData)
    end

    return true
end

function Library:CreateSection(tab, name)
    if tab and tab.CreateSection then
        return tab:CreateSection(name)
    end

    return nil
end

function Library:CreateButton(tab, options)
    if tab and tab.CreateButton then
        return tab:CreateButton(options)
    end

    return nil
end

function Library:CreateToggle(tab, options)
    if tab and tab.CreateToggle then
        return tab:CreateToggle(options)
    end

    return nil
end

function Library:CreateSlider(tab, options)
    if tab and tab.CreateSlider then
        return tab:CreateSlider(options)
    end

    return nil
end

return Library