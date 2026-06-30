return function(Library)
    local tab = Library:CreateTab("Universal", "globe")
    if not tab then
        warn("Universal tab was not created")
        return
    end

    Library:CreateSection(tab, "Useful tools")

    Library:CreateButton(tab, {
        Name = "Run Cobalt",
        Callback = function()
            loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
        end
    })

    Library:CreateButton(tab, {
        Name = "Run Dex",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end
    })
end
