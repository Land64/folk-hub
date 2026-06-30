return function(Library)
    local tab = Library:CreateTab("Universal")
    if not tab then
        return
    end

    Library:CreateSection(tab, "General")
    Library:SendNotification("Universal", "Universal module loaded", 3)
end
