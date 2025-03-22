-- UI Library Source Code
-- Created by Dexstr08
-- Modified and optimized for GitHub loadstring support

local Library = {}

function Library:validate(defaults, options)
    for i, v in pairs(defaults) do
        if options[i] == nil then
            options[i] = v
        end
    end
    return options
end

function Library:Init(options)
    -- services
    local players = game:GetService("Players")
    local tweenService = game:GetService("TweenService")
    local uis = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local coreGui = game:GetService("CoreGui")

    -- vars
    local lp = players.LocalPlayer
    local mouse = lp:GetMouse()
    local viewport = workspace.CurrentCamera.ViewportSize
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

    -- Clean up existing GUI instances with the same name
    for i = 1, 5 do
        if game:GetService("CoreGui"):FindFirstChild("MyLibrary") then
            game:GetService("CoreGui").MyLibrary:Destroy()
        end
    end

    options = self:validate({
        name = "UI Library Test"
    }, options or {})

    local function MakeDraggable(topbarobject, object)
        local Dragging = nil
        local DragInput = nil
        local DragStart = nil
        local StartPosition = nil

        local function Update(input)
            local Delta = input.Position - DragStart
            local pos =
                UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + Delta.X,
                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + Delta.Y
                )
            object.Position = pos
        end

        topbarobject.InputBegan:Connect(
            function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = input.Position
                    StartPosition = object.Position

                    input.Changed:Connect(
                        function()
                            if input.UserInputState == Enum.UserInputState.End then
                                Dragging = false
                            end
                        end
                    )
                end
            end
        )

        topbarobject.InputChanged:Connect(
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
                then
                    DragInput = input
                end
            end
        )

        uis.InputChanged:Connect(
            function(input)
                if input == DragInput and Dragging then
                    Update(input)
                end
            end
        )
    end

    function self:tween(object, goal, callback)
        local tween = tweenService:Create(object, tweenInfo, goal)
        tween.Completed:Connect(callback or function() end)
        tween:Play()
    end

    local GUI = {
        CurrentTab = nil
    }

    -- Main Frame
    do
        -- Create the ScreenGui
        GUI["1"] = Instance.new("ScreenGui", runService:IsStudio() and players.LocalPlayer:WaitForChild("PlayerGui") or coreGui)
        GUI["1"]["Name"] = [[MyLibrary]]
        GUI["1"]["IgnoreGuiInset"] = true

        -- Main frame
        GUI["2"] = Instance.new("Frame", GUI["1"])
        GUI["2"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41)
        GUI["2"]["AnchorPoint"] = Vector2.new(0, 0)
        GUI["2"]["Size"] = UDim2.new(0, 433, 0, 219)
        GUI["2"]["Position"] = UDim2.fromOffset((viewport.X / 2) - (GUI["2"].Size.X.Offset / 2), (viewport.Y / 2) - (GUI["2"].Size.Y.Offset / 2))
        GUI["2"]["Name"] = [[Main]]

        -- Making the main frame draggable
        MakeDraggable(GUI["2"], GUI["2"])

        -- Corner and shadow effects
        GUI["3"] = Instance.new("UICorner", GUI["2"]);
        GUI["3"]["CornerRadius"] = UDim.new(0, 6);

        GUI["b"] = Instance.new("Frame", GUI["2"]);
        GUI["b"]["ZIndex"] = 0;
        GUI["b"]["BorderSizePixel"] = 0;
        GUI["b"]["BackgroundTransparency"] = 1;
        GUI["b"]["Size"] = UDim2.new(1, 0, 1, 0);
        GUI["b"]["Name"] = [[DropShadowHolder]];

        GUI["c"] = Instance.new("ImageLabel", GUI["b"]);
        GUI["c"]["ZIndex"] = 0;
        GUI["c"]["BorderSizePixel"] = 0;
        GUI["c"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
        GUI["c"]["ScaleType"] = Enum.ScaleType.Slice;
        GUI["c"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
        GUI["c"]["ImageTransparency"] = 0.5;
        GUI["c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
        GUI["c"]["Image"] = [[rbxassetid://6015897843]];
        GUI["c"]["Size"] = UDim2.new(1, 44, 1, 44);
        GUI["c"]["Name"] = [[DropShadow]];
        GUI["c"]["BackgroundTransparency"] = 1;
        GUI["c"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

        -- Top bar
        GUI["4"] = Instance.new("Frame", GUI["2"]);
        GUI["4"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18);
        GUI["4"]["Size"] = UDim2.new(0, 433, 0, 37);
        GUI["4"]["Name"] = [[TopBar]];

        GUI["5"] = Instance.new("UICorner", GUI["4"]);
        GUI["5"]["CornerRadius"] = UDim.new(0, 6);

        GUI["6"] = Instance.new("Frame", GUI["4"]);
        GUI["6"]["BorderSizePixel"] = 0;
        GUI["6"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18);
        GUI["6"]["AnchorPoint"] = Vector2.new(0, 1);
        GUI["6"]["Size"] = UDim2.new(1, 0, 0.5, 0);
        GUI["6"]["Position"] = UDim2.new(0, 0, 1, 0);
        GUI["6"]["Name"] = [[Extension]];

        GUI["7"] = Instance.new("TextLabel", GUI["4"]);
        GUI["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
        GUI["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        GUI["7"]["TextSize"] = 14;
        GUI["7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
        GUI["7"]["Size"] = UDim2.new(0.5, 0, 1, 0);
        GUI["7"]["Text"] = options["name"];
        GUI["7"]["Name"] = options["name"];
        GUI["7"]["Font"] = Enum.Font.Gotham;
        GUI["7"]["BackgroundTransparency"] = 1;

        GUI["8"] = Instance.new("UIPadding", GUI["7"]);
        GUI["8"]["PaddingTop"] = UDim.new(0, 1);
        GUI["8"]["PaddingLeft"] = UDim.new(0, 8);

        GUI["9"] = Instance.new("ImageLabel", GUI["4"]);
        GUI["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
        GUI["9"]["AnchorPoint"] = Vector2.new(1, 0.5);
        GUI["9"]["Image"] = [[rbxassetid://10884453403]];
        GUI["9"]["Size"] = UDim2.new(0, 14, 0, 14);
        GUI["9"]["Name"] = [[Close]];
        GUI["9"]["BackgroundTransparency"] = 1;
        GUI["9"]["Position"] = UDim2.new(1, -8, 0.5, 0);

        -- Close button functionality
        GUI["9"].MouseButton1Click:Connect(function()
            GUI["1"]:Destroy()
        end)

        GUI["a"] = Instance.new("Frame", GUI["4"]);
        GUI["a"]["BorderSizePixel"] = 0;
        GUI["a"]["BackgroundColor3"] = Color3.fromRGB(52, 52, 52);
        GUI["a"]["AnchorPoint"] = Vector2.new(0, 1);
        GUI["a"]["Size"] = UDim2.new(1, 0, 0, 1);
        GUI["a"]["Position"] = UDim2.new(0, 0, 1, 0);
        GUI["a"]["Name"] = [[Line]];

        GUI["b"] = Instance.new("Frame", GUI["4"]);
        GUI["b"]["ZIndex"] = 2;
        GUI["b"]["BorderSizePixel"] = 0;
        GUI["b"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18);
        GUI["b"]["Size"] = UDim2.new(0, 120, 0, 29);
        GUI["b"]["Position"] = UDim2.new(0, 0, 5.1667, 0);
        GUI["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
        GUI["b"]["Name"] = [[Ver]];

        GUI["c"] = Instance.new("Frame", GUI["4"]);
        GUI["c"]["ZIndex"] = 2;
        GUI["c"]["BorderSizePixel"] = 0;
        GUI["c"]["BackgroundColor3"] = Color3.fromRGB(52, 52, 52);
        GUI["c"]["AnchorPoint"] = Vector2.new(0, 1);
        GUI["c"]["Size"] = UDim2.new(0.277, 0, 0.002, -1);
        GUI["c"]["Position"] = UDim2.new(0, 0, 5.16026974, 0);
        GUI["c"]["BorderColor3"] = Color3.fromRGB(255, 255, 255);
        GUI["c"]["Name"] = [[line2]];

        GUI["d"] = Instance.new("ImageButton", GUI["4"]);
        GUI["d"]["BorderSizePixel"] = 0;
        GUI["d"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18);
        GUI["d"]["ZIndex"] = 2;
        GUI["d"]["Image"] = [[rbxassetid://10734950309]];
        GUI["d"]["Size"] = UDim2.new(0, 22, 0, 20);
        GUI["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
        GUI["d"]["Position"] = UDim2.new(0.02155, 0, 5.26046, 0);

        -- Content container
        GUI["1b"] = Instance.new("Frame", GUI["2"]);
        GUI["1b"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
        GUI["1b"]["AnchorPoint"] = Vector2.new(1, 0);
        GUI["1b"]["BackgroundTransparency"] = 1;
        GUI["1b"]["Size"] = UDim2.new(1, -133, 1, -49);
        GUI["1b"]["Position"] = UDim2.new(1, -6, 0, 42);
        GUI["1b"]["Name"] = [[ContentContainer]];
    end

    -- Navigation
    do
        -- Create the Navigation frame
        GUI["d"] = Instance.new("Frame", GUI["2"])
        GUI["d"]["BorderSizePixel"] = 0
        GUI["d"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
        GUI["d"]["Size"] = UDim2.new(0, 120, 0.968, -30)
        GUI["d"]["Position"] = UDim2.new(0, 0, 0, 37)
        GUI["d"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
        GUI["d"]["Name"] = "Navigation"

        GUI["e"] = Instance.new("UICorner", GUI["d"])
        GUI["e"]["CornerRadius"] = UDim.new(0, 6)

        GUI["f"] = Instance.new("Frame", GUI["d"])
        GUI["f"]["BorderSizePixel"] = 0
        GUI["f"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
        GUI["f"]["Size"] = UDim2.new(1, 0, 0, 20)
        GUI["f"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
        GUI["f"]["Name"] = "Hide"

        GUI["10"] = Instance.new("Frame", GUI["d"])
        GUI["10"]["BorderSizePixel"] = 0
        GUI["10"]["BackgroundColor3"] = Color3.fromRGB(18, 18, 18)
        GUI["10"]["AnchorPoint"] = Vector2.new(1, 0)
        GUI["10"]["Size"] = UDim2.new(0, 20, 1, 0)
        GUI["10"]["Position"] = UDim2.new(1, 0, 0, 0)
        GUI["10"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
        GUI["10"]["Name"] = "Hide2"

        GUI["10.1"] = Instance.new("Frame", GUI["d"])
        GUI["10.1"]["BorderSizePixel"] = 0
        GUI["10.1"]["BackgroundColor3"] = Color3.fromRGB(52, 52, 52)
        GUI["10.1"]["Size"] = UDim2.new(0, 1, 1, 0)
        GUI["10.1"]["Position"] = UDim2.new(1, 0, 0, 0)
        GUI["10.1"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
        GUI["10.1"]["Name"] = "Line"

        GUI["11"] = Instance.new("ScrollingFrame", GUI["d"])
        GUI["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
        GUI["11"]["Name"] = "ButtonHolder"
        GUI["11"]["Selectable"] = false
        GUI["11"]["Size"] = UDim2.new(1, 0, 1, 0)
        GUI["11"]["BorderColor3"] = Color3.fromRGB(18, 18, 18)
        GUI["11"]["ScrollBarThickness"] = 0
        GUI["11"]["BackgroundTransparency"] = 1
        GUI["11"]["SelectionGroup"] = false

        GUI["12"] = Instance.new("UIPadding", GUI["11"])
        GUI["12"]["PaddingTop"] = UDim.new(0, 8)
        GUI["12"]["PaddingBottom"] = UDim.new(0, 8)

        GUI["19"] = Instance.new("UIListLayout", GUI["11"])
        GUI["19"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center
        GUI["19"]["Padding"] = UDim.new(0, 4)
        GUI["19"]["SortOrder"] = Enum.SortOrder.LayoutOrder

        -- Auto update canvas size
        GUI["19"]:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            GUI["11"].CanvasSize = UDim2.new(0, 0, 0, GUI["19"].AbsoluteContentSize.Y + 42)
        end)
    end

    -- Tab creation function
    function GUI:Tab(options)
        options = Library:validate({
            name = "Preview Tab",
        }, options or {})

        local Tab = {
            Hover = false,
            Active = false
        }

        -- Create tab UI elements
        do
            Tab["17"] = Instance.new("TextLabel", GUI["11"])
            Tab["17"].BorderSizePixel = 0
            Tab["17"].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Tab["17"].TextSize = 14
            Tab["17"].FontFace = Font.new([[rbxasset://fonts/families/FredokaOne.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            Tab["17"].TextColor3 = Color3.fromRGB(255, 255, 255)
            Tab["17"].BackgroundTransparency = 1
            Tab["17"].Size = UDim2.new(0, 102, 0, 37)
            Tab["17"].BorderColor3 = Color3.fromRGB(28, 43, 54)
            Tab["17"].Text = options.name
            Tab["17"].Name = [[Inactive]]
            Tab["17"].Position = UDim2.new(0.00833, 0, 0.21687, 0)

            Tab["18"] = Instance.new("UICorner", Tab["17"])
            Tab["18"].CornerRadius = UDim.new(0, 7)

            Tab["19"] = Instance.new("Frame", Tab["17"])
            Tab["19"].BorderSizePixel = 0
            Tab["19"].BackgroundColor3 = Color3.fromRGB(61, 61, 61)
            Tab["19"].Size = UDim2.new(0, 102, 0, 37)
            Tab["19"].BorderColor3 = Color3.fromRGB(0, 0, 0)
            Tab["19"].BackgroundTransparency = 1
            Tab["19"].Visible = false

            Tab["20"] = Instance.new("UIStroke", Tab["19"])
            Tab["20"].Color = Color3.fromRGB(68, 68, 68)

            Tab["21"] = Instance.new("UICorner", Tab["19"])
            Tab["21"].CornerRadius = UDim.new(0, 7)

            Tab["1c"] = Instance.new("ScrollingFrame", GUI["1b"])
            Tab["1c"].BorderSizePixel = 0
            Tab["1c"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Tab["1c"].BackgroundTransparency = 1
            Tab["1c"].Size = UDim2.new(1, 0, 1.02, 0)
            Tab["1c"].Selectable = false
            Tab["1c"].ScrollBarThickness = 0
            Tab["1c"].Name = [[HomeTab]]
            Tab["1c"].SelectionGroup = false
            Tab["1c"].Visible = false
            Tab["1c"].CanvasSize = UDim2.new(0, 0, 0, 0)

            Tab["23"] = Instance.new("UIPadding", Tab["1c"])
            Tab["23"].PaddingTop = UDim.new(0, 1)
            Tab["23"].PaddingRight = UDim.new(0, 1)
            Tab["23"].PaddingBottom = UDim.new(0, 1)
            Tab["23"].PaddingLeft = UDim.new(0, 1)

            Tab["2b"] = Instance.new("UIListLayout", Tab["1c"])
            Tab["2b"].Padding = UDim.new(0, 7)
            Tab["2b"].SortOrder = Enum.SortOrder.LayoutOrder
            
            -- Auto-update canvas size
            local function updateCanvasSize()
                Tab["1c"].CanvasSize = UDim2.new(0, 0, 0, Tab["2b"].AbsoluteContentSize.Y + 10)
            end

            Tab["2b"]:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
            updateCanvasSize()
        end

        -- Tab activation/deactivation methods
        function Tab:Activate()
            if not Tab.Active then
                if GUI.CurrentTab ~= nil then
                    GUI.CurrentTab:Deactivate()
                end

                Tab.Active = true
                Library:tween(Tab["17"], {BackgroundTransparency = 0.9})
                Tab["19"].Visible = true
                Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(16, 255, 235)})
                Tab["1c"].Visible = true
                Tab["19"].BackgroundTransparency = 0.8

                GUI.CurrentTab = Tab
            end
        end

        function Tab:Deactivate()
            if Tab.Active then
                Tab.Active = false
                Tab["19"].Visible = false
                Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
                Library:tween(Tab["17"], {BackgroundTransparency = 1})
                Tab["1c"].Visible = false
            end
        end

        -- Tab interaction logic
        do
            Tab["17"].MouseEnter:Connect(function()
                Tab.Hover = true

                if not Tab.Active then
                    Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(16, 255, 235)})
                end
            end)

            Tab["17"].MouseLeave:Connect(function()
                Tab.Hover = false

                if not Tab.Active then
                    Library:tween(Tab["17"], {TextColor3 = Color3.fromRGB(255, 255, 255)})
                end
            end)

            local function onInputBegan(input, gpe)
                if gpe then return end

                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if Tab.Hover then
                        Tab:Activate()
                    end
                end
            end

            Tab["17"].InputBegan:Connect(onInputBegan)
            Tab["17"].TouchTap:Connect(function()
                if not Tab.Active then
                    Tab:Activate()
                end
            end)

            if GUI.CurrentTab == nil then
                Tab:Activate()
            end
        end

        -- Welcome component function
        function Tab:welcome(options)
            options = Library:validate({
                img = "",
                welc = "preview",
                version = "preview",
                playeruser = "Preview ",
                rank = "Preview ",
                playername = "preview",
                callback = function() end
            }, options or {})

            local welcome = {
                Hover = false,
                MouseDown = false,
                State = false
            }

            -- Create welcome component UI
            do
                -- Main welcome frame
                welcome["76"] = Instance.new("Frame", Tab["1c"]);
                welcome["76"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19);
                welcome["76"]["Size"] = UDim2.new(0, 298, 0, 115);
                welcome["76"]["Position"] = UDim2.new(0, 0, 0.06771, 0);
                welcome["76"]["BorderColor3"] = Color3.fromRGB(28, 43, 54);
                welcome["76"]["Name"] = [[welcome]];

                -- Welcome text
                welcome["77"] = Instance.new("TextLabel", welcome["76"]);
                welcome["77"]["BorderSizePixel"] = 0;
                welcome["77"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                welcome["77"]["TextSize"] = 20;
                welcome["77"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                welcome["77"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
                welcome["77"]["BackgroundTransparency"] = 1;
                welcome["77"]["Size"] = UDim2.new(0, 148, 0, 34);
                welcome["77"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                welcome["77"]["Text"] = options.welc;
                welcome["77"]["Position"] = UDim2.new(0.25704, 0, 0.70298, 0);

                -- Username
                welcome["1x1"] = Instance.new("TextLabel", welcome["76"]);
                welcome["1x1"]["BorderSizePixel"] = 0;
                welcome["1x1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                welcome["1x1"]["TextSize"] = 14;
                welcome["1x1"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                welcome["1x1"]["TextColor3"] = Color3.fromRGB(94, 94, 94);
                welcome["1x1"]["BackgroundTransparency"] = 1;
                welcome["1x1"]["Size"] = UDim2.new(0, 148, 0, 34);
                welcome["1x1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                welcome["1x1"]["Text"] = "@" .. options.playeruser;
                welcome["1x1"]["Position"] = UDim2.new(0.38486, 0, 0.35432, 0);

                -- Version frame
                welcome["78"] = Instance.new("Frame", welcome["76"])
                welcome["78"]["BorderSizePixel"] = 0
                welcome["78"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
                welcome["78"]["Size"] = UDim2.new(0, 131, 0, 45)
                welcome["78"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
                welcome["78"]["Position"] = UDim2.new(0.550000012, 0, 1.099, 0)

                -- Version label
                welcome["cs"] = Instance.new("TextLabel", welcome["78"]);
                welcome["cs"]["BorderSizePixel"] = 0;
                welcome["cs"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                welcome["cs"]["TextSize"] = 12;
                welcome["cs"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                welcome["cs"]["TextColor3"] = Color3.fromRGB(124, 124, 124); 
                welcome["cs"]["BackgroundTransparency"] = 1;
                welcome["cs"]["Size"] = UDim2.new(0, 148, 0, 34);
                welcome["cs"]["BorderColor3"] = Color3.fromRGB(124, 124, 124);
                welcome["cs"]["TextXAlignment"] = "Left";
                welcome["cs"]["Text"] = "       version ";

                -- Version number
                welcome["sm"] = Instance.new("TextLabel", welcome["78"]);
                welcome["sm"]["BorderSizePixel"] = 0;
                welcome["sm"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                welcome["sm"]["TextSize"] = 15;
                welcome["sm"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                welcome["sm"]["TextColor3"] = Color3.fromRGB(225, 225, 225); 
                welcome["sm"]["BackgroundTransparency"] = 1;
                welcome["sm"]["Size"] = UDim2.new(0, 148, 0, 34);
                welcome["sm"]["BorderColor3"] = Color3.fromRGB(124, 124, 124);
                welcome["sm"]["Position"] = UDim2.new(0, 0, 0.3, 0);
                welcome["sm"]["Text"] = "       v" .. options.version

                -- Version frame styling
                welcome["x1"] = Instance.new("UICorner", welcome["78"]);
                welcome["x1"]["CornerRadius"] = UDim.new(0, 15);
                
                welcome["14"] = Instance.new("UIStroke", welcome["78"]);
                welcome["14"]["Color"] = Color3.fromRGB(68, 68, 68);

                -- Rank frame
                welcome["rdi"] = Instance.new("Frame", welcome["76"])
                welcome["rdi"]["BorderSizePixel"] = 0
                welcome["rdi"]["BackgroundColor3"] = Color3.fromRGB(19, 19, 19)
                welcome["rdi"]["Size"] = UDim2.new(0, 131, 0, 45)
                welcome["rdi"]["BorderColor3"] = Color3.fromRGB(28, 43, 54)
                welcome["rdi"]["Position"] = UDim2.new(0, 0, 1.09899998, 0)

                -- Rank label
                welcome["4s"] = Instance.new("TextLabel", welcome["rdi"]);
                welcome["4s"]["BorderSizePixel"] = 0;
                welcome["4s"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                welcome["4s"]["TextSize"] = 12;
                welcome["4s"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                welcome["4s"]["TextColor3"] = Color3.fromRGB(124, 124, 124); 
                welcome["4s"]["BackgroundTransparency"] = 1;
                welcome["4s"]["Size"] = UDim2.new(0, 148, 0, 34);
                welcome["4s"]["BorderColor3"] = Color3.fromRGB(124, 124, 124);
                welcome["4s"]["TextXAlignment"] = "Left";
                welcome["4s"]["Text"] = "       rank ";

								-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.TextLabel2
								welcome["4ss"] = Instance.new("TextLabel", welcome["rdi"]);
								welcome["4ss"]["BorderSizePixel"] = 0;
								welcome["4ss"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								welcome["4ss"]["TextSize"] = 15;
								welcome["4ss"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								welcome["4ss"]["TextColor3"] = Color3.fromRGB(225, 225, 225); 
								welcome["4ss"]["BackgroundTransparency"] = 1;
								welcome["4ss"]["Size"] = UDim2.new(0, 148, 0, 34);
								welcome["4ss"]["BorderColor3"] = Color3.fromRGB(124, 124, 124);

								welcome["4ss"]["Position"] = UDim2.new(0, 0, 0.3, 0);
								welcome["4ss"]["Text"] = "       " .. options.rank


                                
							-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.انشاء.UICorner
			welcome["xr1"] = Instance.new("UICorner", welcome["rdi"]);
			welcome["xr1"]["CornerRadius"] = UDim.new(0, 15);
								
				welcome["xr11"] = Instance.new("UIStroke", welcome["rdi"]);
				welcome["xr11"]["Color"] = Color3.fromRGB(68, 68, 68);

----------------------------------------------

				-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.TextLabel
				welcome["79"] = Instance.new("TextLabel", welcome["76"]);
				welcome["79"]["BorderSizePixel"] = 0;
				welcome["79"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				welcome["79"]["TextSize"] = 20;
				welcome["79"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				welcome["79"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				welcome["79"]["BackgroundTransparency"] = 1;
				welcome["79"]["Size"] = UDim2.new(0, 147, 0, 37);
				welcome["79"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				welcome["79"]["Position"] = UDim2.new(0.38486, 0, 0.08432, 0);
				welcome["79"]["Text"] = options.playername;

				-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.TextLabel.UICorner
				welcome["7a"] = Instance.new("UICorner", welcome["79"]);
				welcome["7a"]["CornerRadius"] = UDim.new(0, 15);

				-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.ImageLabel
				welcome["7b"] = Instance.new("ImageLabel", welcome["76"]);
				welcome["7b"]["BorderSizePixel"] = 0;
				welcome["7b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				welcome["7b"]["Image"] = options.img;
				welcome["7b"]["Size"] = UDim2.new(0, 89, 0, 88);
				welcome["7b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				welcome["7b"]["Position"] = UDim2.new(0.0363, 0, 0.08571, 0);

				-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.ImageLabel.UICorner
				welcome["7c"] = Instance.new("UICorner", welcome["7b"]);
				welcome["7c"]["CornerRadius"] = UDim.new(1, 0);

				-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.UICorner
				welcome["7d"] = Instance.new("UICorner", welcome["76"]);


				-- StarterGui.MyLibrary.Main.ContentContainer.HomeTab.welcome.UIStroke
				welcome["7e"] = Instance.new("UIStroke", welcome["76"]);
				welcome["7e"]["Color"] = Color3.fromRGB(68, 68, 68);


			end



		end







		return Tab
	end

	return GUI
end

--------------------------------------------------------

