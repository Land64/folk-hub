return function(Library)
    local tab = Library:CreateTab("Universal", "globe")
    if not tab then
        warn("Universal tab was not created")
        return
    end

    Library:CreateSection(tab, "General")
    Library:SendNotification("Universal", "Universal module loaded", 3)
end
