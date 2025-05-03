-- tive uma ideia muito mirabolante ent vo fzr ela kk
local data = {
    combo = 0, -- combo (reseta toda vez que pega 30, e ele nn conta qnd os poderes estão ativos)
    comboMeter = 0, -- medidor
    unlockComboPowers = 30, -- desbloquear poderes em x combos
    comboMeterDisplay = 0, -- coiso do lerp
    isPowersActive = false, -- ver se os poderes estão ativos
    songSpeed = 2,

    timeGain = 0, -- o quanto que você ganha por hit de nota (qnd o poder ativa, e por padrão, isso vem zerado)
    timeLoss = 0.0025, -- o quanto que você perde por tempo (qnd o poder ativa)

    allowCombo = false,

    alreadyChoosenPower = false,
    choosenPower = 'none',
    powers = { -- nome, chance
        {'botplay', 16.745}, -- ativa o botplay enquanto o poder estiver ativo
        {'gainhealth', 28.65}, -- o player ganha vida
        {'gainscore', 49.043}, -- o player ganha 3400 de score
        {'resetmiss', 46.21}, -- reseta os erros do player
        {'invincibility', 23.16}, -- o player não pode morrer enquanto o poder estiver ativo
        {'reducescrollspeed', 34.96} -- a velocidade das notas reduz enquanto o poder estiver ativo
    }
}

function onCreatePost()
    setProperty('timeTxt.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false) -- oculta a timebar

    data.songSpeed = getProperty('songSpeed')

    makeLuaSprite('comboMeterBG', nil, 0, getProperty('timeBar.y') - 2)
    makeGraphic('comboMeterBG', 730, 20, '000000')
    setObjectCamera('comboMeterBG', 'hud')
    addLuaSprite('comboMeterBG')
    screenCenter('comboMeterBG', 'x') -- bg do medidor

    makeLuaSprite('comboMeter', nil, 0, getProperty('comboMeterBG.y') + 4)
    makeGraphic('comboMeter', 720, 10, 'FFFFFF')
    setObjectCamera('comboMeter', 'hud')
    addLuaSprite('comboMeter')
    screenCenter('comboMeter', 'x') -- medidor (vai de 0 a 1)

    makeLuaText('power', 'none', 500, 20, getProperty('comboMeterBG.y') + 4)
    setTextAlignment('power', 'left')
    setTextSize('power', 16)
    addLuaText('power')

    setProperty('comboMeter.origin.x', 0)
end

function onUpdate()
    setTextString('power', data.choosenPower)
    if not data.isPowersActive then data.comboMeter = data.combo * (1 / data.unlockComboPowers) end
    data.comboMeterDisplay = lerp(data.comboMeterDisplay, data.comboMeter, 0.2 / (getPropertyFromClass('backend.ClientPrefs', 'data.framerate') / 60))
    setProperty('comboMeter.scale.x', data.comboMeterDisplay)

    if data.isPowersActive then
        data.comboMeter = boundTo(data.comboMeter - (data.timeLoss * ((bpm / 100) / 2)), -0.01, 1)

        setProperty('cpuControlled', (data.choosenPower == 'botplay' and data.alreadyChoosenPower))
        setProperty('practiceMode', (data.choosenPower == 'invincibility' and data.alreadyChoosenPower))

        if data.comboMeter <= -0.01 then
            data.isPowersActive = false
            data.combo = 0
            if data.choosenPower == 'botplay' then setProperty('cpuControlled', false) end
            if data.choosenPower == 'invincibility' then
                setProperty('practiceMode', false)
                if getHealth() <= 0.1 then
                    setHealth(0.15)
                end
            end
            data.unlockComboPowers = getRandomInt(30, 70)
            data.choosenPower = 'none'
            data.alreadyChoosenPower = false
            setProperty('songSpeed', data.songSpeed)
        end
    end
end

function onSongStart()
    allowCombo = true
end

function onUpdateScore(miss)
    if data.combo == data.unlockComboPowers - 1 and not data.alreadyChoosenPower then
        data.isPowersActive = true
        data.choosenPower = choosePower()
        data.alreadyChoosenPower = true
        if data.choosenPower == 'gainscore' then
            addScore(10000)
        elseif data.choosenPower == 'gainhealth' then
            setHealth(boundTo(getHealth() + 1, 2, 1))
        elseif data.choosenPower == 'resetmiss' then
            setMisses(0)
        elseif data.choosenPower == 'reducescrollspeed' then
            setProperty('songSpeed', data.songSpeed / 1.375)
        end
    end

    if allowCombo then
        if not data.isPowersActive then
            if not miss then data.combo = data.combo + 1
            else data.combo = 0 end
        else
            if not miss then data.comboMeter = boundTo(data.comboMeter + data.timeGain, -0.01, 1)
            else
                if data.choosenPower ~= 'invincibility' then
                    data.comboMeter = boundTo(data.comboMeter - (data.timeLoss * ((bpm / 10) * 2)), -0.01, 1)
                end
            end
        end
    end
end

function choosePower()
    local power = data.powers[3][1];
    for pwr in ipairs(data.powers) do
        if getRandomBool(data.powers[pwr][2]) then power = data.powers[pwr][1] end
        break
    end
    return power
end

function lerp(from, to, i)
    return from + (to - from) * i
end

function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end