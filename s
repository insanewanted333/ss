local UILibrary = {}

function UILibrary:CreateWindow(title)
    local window = Instance.new("Frame")
    window.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    window.Size = UDim2.new(0, 300, 0, 200)
    window.Position = UDim2.new(0.5, -150, 0.5, -100)
    window.Name = title

    local titleLabel = Instance.new("TextLabel", window)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1

    return window
end

return UILibrary
