local Lighting = game:GetService("Lighting")
Lighting:ClearAllChildren()

-- Настройка освещения
Lighting.Ambient = Color3.fromRGB(120, 100, 160)
Lighting.OutdoorAmbient = Color3.fromRGB(140, 120, 180)
Lighting.Brightness = 3.0
Lighting.ClockTime = 11
Lighting.EnvironmentDiffuseScale = 0.2
Lighting.EnvironmentSpecularScale = 0.2
Lighting.GlobalShadows = false

Lighting.FogColor = Color3.fromRGB(180, 160, 220)
Lighting.FogStart = 1500
Lighting.FogEnd = 5000

local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
colorCorrection.TintColor = Color3.fromRGB(160, 140, 255) -- светлый фиолет
colorCorrection.Brightness = 0.1
colorCorrection.Contrast = 0
colorCorrection.Saturation = -0.1

local bloom = Instance.new("BloomEffect", Lighting)
bloom.Intensity = 0.03
bloom.Size = 18
bloom.Threshold = 1

-- Теперь добавляем уведомления
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "UltimateNotifUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local container = Instance.new("Frame", gui)
container.Name = "NotifStack"
container.Position = UDim2.new(1, -440, 0.05, 0)
container.Size = UDim2.new(0, 400, 1, -100)
container.BackgroundTransparency = 1

local themeColors = {
	success = Color3.fromRGB(0, 200, 80),
	danger = Color3.fromRGB(255, 60, 60),
	info = Color3.fromRGB(50, 150, 255),
	warning = Color3.fromRGB(255, 185, 0)
}

-- Параметры градиента
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 180))
})

local function createNotif(titleText, messageText, theme, iconId, soundId, duration)
	duration = duration or 8
	theme = theme or "info"
	local color = themeColors[theme] or themeColors.info

	local frame = Instance.new("Frame", container)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame.Size = UDim2.new(0, 400, 0, 100)
	frame.Position = UDim2.new(0, 0, 0, -120)
	frame.BackgroundTransparency = 0.05
	frame.ZIndex = 10
	frame.ClipsDescendants = true

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 14)

	-- Задаём UIGradient
	gradient.Parent = frame

	-- Glow эффект
	local glow = Instance.new("UIStroke", frame)
	glow.Thickness = 2
	glow.Color = color
	glow.Transparency = 0.25

	-- Иконка
	local icon = Instance.new("ImageLabel", frame)
	icon.Size = UDim2.new(0, 64, 0, 64)
	icon.Position = UDim2.new(0, 16, 0.5, -32)
	icon.BackgroundTransparency = 1
	icon.Image = iconId or "rbxassetid://603109100" -- Default icon (change with any ID)
	icon.ZIndex = 11

	-- Title
	local title = Instance.new("TextLabel", frame)
	title.Text = titleText
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = color
	title.TextScaled = true
	title.Size = UDim2.new(1, -100, 0.35, 0)
	title.Position = UDim2.new(0, 90, 0, 15)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 11

	-- Body text
	local body = Instance.new("TextLabel", frame)
	body.Text = messageText
	body.Font = Enum.Font.Gotham
	body.TextColor3 = Color3.fromRGB(240, 240, 240)
	body.TextScaled = true
	body.Size = UDim2.new(1, -100, 0.45, 0)
	body.Position = UDim2.new(0, 90, 0.4, 0)
	body.BackgroundTransparency = 1
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.ZIndex = 11

	-- Смещение других уведомлений
	for _, notif in ipairs(container:GetChildren()) do
		if notif:IsA("Frame") and notif ~= frame then
			notif:TweenPosition(
				notif.Position + UDim2.new(0, 0, 0, 110),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.3,
				true
			)
		end
	end

	-- Звук
	if soundId then
		local sfx = Instance.new("Sound", frame)
		sfx.SoundId = "rbxassetid://" .. tostring(soundId)
		sfx.Volume = 1
		sfx:Play()
		game:GetService("Debris"):AddItem(sfx, 3)
	end

	-- Появление с анимацией
	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()

	-- Исчезновение с анимацией
	task.delay(duration, function()
		local disappear = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
			Position = UDim2.new(0, 0, 0, -120);
			BackgroundTransparency = 1
		})
		disappear:Play()
		disappear.Completed:Wait()
		frame:Destroy()
	end)
end

-- Тестовое уведомление
createNotif(
	"✨Delta Boost✨",
	"",
	"Blue",
	"rbxassetid://7733964646", -- иконка
	9118823102, -- кастомный звук
	10
)
