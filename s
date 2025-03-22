-- UI Library Source
local Library = {}

function Library:Init(options)
    local main = {
        name = options.name or "UI Library"
    }
    setmetatable(main, self)
    self.__index = self
    
    -- إنشاء الواجهة الرئيسية
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame with rounded corners
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Apply rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Round corners for title bar
    local titleUICorner = Instance.new("UICorner")
    titleUICorner.CornerRadius = UDim.new(0, 8)
    titleUICorner.Parent = titleBar
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.Text = main.name
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 16
    titleText.Parent = titleBar
    
    -- Left tabs holder (vertical)
    local tabsHolder = Instance.new("Frame")
    tabsHolder.Size = UDim2.new(0, 120, 1, -40)
    tabsHolder.Position = UDim2.new(0, 0, 0, 40)
    tabsHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabsHolder.BorderSizePixel = 0
    tabsHolder.Parent = mainFrame
    
    -- Content holder
    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, -120, 1, -40)
    contentHolder.Position = UDim2.new(0, 120, 0, 40)
    contentHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    contentHolder.BorderSizePixel = 0
    contentHolder.Parent = mainFrame
    
    -- Store references
    main.tabsHolder = tabsHolder
    main.contentHolder = contentHolder
    main.screenGui = screenGui
    main.tabs = {}
    main.tabCount = 0
    
    -- Make UI draggable
    local isDragging = false
    local dragStart
    local startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return main
end

function Library:Tab(options)
    local tab = {
        name = options.name or "Tab"
    }
    
    self.tabCount = self.tabCount + 1
    
    -- إنشاء زر التبويب (vertical layout)
    local tabButton = Instance.new("TextButton")
    tabButton.Text = tab.name
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, (self.tabCount - 1) * 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.tabsHolder
    
    -- Tab button hover effect
    tabButton.MouseEnter:Connect(function()
        if not tab.isActive then
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not tab.isActive then
            tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
    
    -- Tab indicator
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Size = UDim2.new(0, 3, 1, 0)
    tabIndicator.Position = UDim2.new(0, 0, 0, 0)
    tabIndicator.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Visible = false
    tabIndicator.Parent = tabButton
    
    -- إنشاء محتوى التبويب
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.Parent = self.contentHolder
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Create padding for content
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = tabContent
    
    -- Create layout for content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = tabContent
    
    tab.tabContent = tabContent
    tab.tabButton = tabButton
    tab.tabIndicator = tabIndicator
    tab.isActive = false
    
    table.insert(self.tabs, tab)
    
    -- إظهار/إخفاء المحتوى عند النقر على الزر
    tabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.tabs) do
            t.tabContent.Visible = false
            t.tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            t.tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            t.tabIndicator.Visible = false
            t.isActive = false
        end
        
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabIndicator.Visible = true
        tab.isActive = true
    end)
    
    -- إظهار المحتوى الأول افتراضيًا
    if self.tabCount == 1 then
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabIndicator.Visible = true
        tab.isActive = true
    end
    
    return tab
end

function Library:Button(tab, options)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, 0, 0, 40)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = tab.tabContent
    
    local button = Instance.new("TextButton")
    button.Text = options.name or "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = buttonContainer
    
    -- Round the button corners
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Add hover effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    if options.callback then
        button.MouseButton1Click:Connect(options.callback)
    end
    
    return button
end

function Library:Slider(tab, options)
    local min = options.min or 0
    local max = options.max or 100
    local default = options.default or min
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(1, 0, 0, 60)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = tab.tabContent
    
    local sliderTitle = Instance.new("TextLabel")
    sliderTitle.Size = UDim2.new(1, 0, 0, 20)
    sliderTitle.Position = UDim2.new(0, 0, 0, 0)
    sliderTitle.Text = options.name or "Slider"
    sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    sliderTitle.Font = Enum.Font.Gotham
    sliderTitle.TextSize = 14
    sliderTitle.BackgroundTransparency = 1
    sliderTitle.Parent = sliderContainer
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Size = UDim2.new(1, 0, 0, 10)
    sliderBackground.Position = UDim2.new(0, 0, 0, 30)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderContainer
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBackground
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBackground
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 5)
    sliderFillCorner.Parent = sliderFill
    
    local sliderValue = Instance.new("TextLabel")
    sliderValue.Size = UDim2.new(0, 50, 0, 20)
    sliderValue.Position = UDim2.new(1, -50, 0, 0)
    sliderValue.Text = tostring(default)
    sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderValue.TextXAlignment = Enum.TextXAlignment.Right
    sliderValue.Font = Enum.Font.Gotham
    sliderValue.TextSize = 14
    sliderValue.BackgroundTransparency = 1
    sliderValue.Parent = sliderContainer
    
    local value = default
    local isDragging = false
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            updateSlider(input.Position.X)
        end
    end)
    
    sliderBackground.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    function updateSlider(posX)
        local backgroundAbsPos = sliderBackground.AbsolutePosition.X
        local backgroundAbsSize = sliderBackground.AbsoluteSize.X
        local percentage = math.clamp((posX - backgroundAbsPos) / backgroundAbsSize, 0, 1)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        value = min + (max - min) * percentage
        sliderValue.Text = tostring(math.floor(value))
        
        if options.callback then
            options.callback(value)
        end
    end
    
    return {
        getValue = function() return value end,
        setValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local percentage = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderValue.Text = tostring(math.floor(value))
        end
    }
end

function Library:TextBox(tab, options)
    local textBoxContainer = Instance.new("Frame")
    textBoxContainer.Size = UDim2.new(1, 0, 0, 60)
    textBoxContainer.BackgroundTransparency = 1
    textBoxContainer.Parent = tab.tabContent
    
    local textBoxTitle = Instance.new("TextLabel")
    textBoxTitle.Size = UDim2.new(1, 0, 0, 20)
    textBoxTitle.Position = UDim2.new(0, 0, 0, 0)
    textBoxTitle.Text = options.name or "TextBox"
    textBoxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
    textBoxTitle.Font = Enum.Font.Gotham
    textBoxTitle.TextSize = 14
    textBoxTitle.BackgroundTransparency = 1
    textBoxTitle.Parent = textBoxContainer
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, 0, 0, 30)
    textBox.Position = UDim2.new(0, 0, 0, 25)
    textBox.Text = options.default or ""
    textBox.PlaceholderText = options.placeholder or "اكتب هنا..."
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.BorderSizePixel = 0
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.ClearTextOnFocus = options.clearOnFocus ~= false
    textBox.Parent = textBoxContainer
    
    -- Round the textbox corners
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    -- Add padding to text
    local textBoxPadding = Instance.new("UIPadding")
    textBoxPadding.PaddingLeft = UDim.new(0, 10)
    textBoxPadding.PaddingRight = UDim.new(0, 10)
    textBoxPadding.Parent = textBox
    
    if options.callback then
        textBox.FocusLost:Connect(function(enterPressed)
            options.callback(textBox.Text, enterPressed)
        end)
    end
    
    return {
        getText = function() return textBox.Text end,
        setText = function(newText) textBox.Text = newText end
    }
end

function Library:Toggle(tab, options)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(1, 0, 0, 40)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = tab.tabContent
    
    local toggleTitle = Instance.new("TextLabel")
    toggleTitle.Size = UDim2.new(1, -50, 1, 0)
    toggleTitle.Position = UDim2.new(0, 0, 0, 0)
    toggleTitle.Text = options.name or "Toggle"
    toggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    toggleTitle.Font = Enum.Font.Gotham
    toggleTitle.TextSize = 14
    toggleTitle.BackgroundTransparency = 1
    toggleTitle.Parent = toggleContainer
    
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Size = UDim2.new(0, 40, 0, 20)
    toggleBackground.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleBackground.BorderSizePixel = 0
    toggleBackground.Parent = toggleContainer
    
    local toggleBackgroundCorner = Instance.new("UICorner")
    toggleBackgroundCorner.CornerRadius = UDim.new(1, 0)
    toggleBackgroundCorner.Parent = toggleBackground
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBackground
    
    local toggleCircleCorner = Instance.new("UICorner")
    toggleCircleCorner.CornerRadius = UDim.new(1, 0)
    toggleCircleCorner.Parent = toggleCircle
    
    local enabled = options.default or false
    
    local function updateToggle()
        if enabled then
            toggleBackground.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            toggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.2, true)
        else
            toggleBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, 0.2, true)
        end
        
        if options.callback then
            options.callback(enabled)
        end
    end
    
    -- Initial state
    updateToggle()
    
    toggleBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateToggle()
        end
    end)
    
    return {
        getState = function() return enabled end,
        setState = function(state)
            enabled = state
            updateToggle()
        end,
        toggle = function()
            enabled = not enabled
            updateToggle()
        end
    }
end

return Library
