local health = 1
local healthDisplay = health

local healthGain = 0.0325
local healthLoss = 0.1
local songStarted = false

function lerp(from, to, i)
	return from + (to - from) * i
end

function boundTo(value, min, max)
	return math.max(min, math.min(max, value))
end

function onCreate()
    setProperty('healthGain', 0)
    setProperty('healthLoss', 0)
end

function onUpdateScore(miss)
    if songStarted then
        if not miss then
             health = boundTo(health + healthGain, -0.01, 2)
        else
             health = boundTo(health - healthLoss, -0.01, 2)
        end
    end
end

function onUpdate()
    healthDisplay = lerp(healthDisplay, health, 0.2 / (getPropertyFromClass('backend.ClientPrefs', 'data.framerate') / 60))
    setHealth(healthDisplay)
end

function onEvent(eventName, value1, value2)
    if eventName == 'Change Health Gain/Lose' then
        healthGain = tonumber(value1)
        healthLoss = tonumber(value2)
    end
end

function onSongStart() songStarted = true end