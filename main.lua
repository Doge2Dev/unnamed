function love.load()
    gamestate = require 'libraries.gamestate'
    gui = require 'libraries.gspot'
    json = require 'libraries.json'
    camera = require 'libraries.camera'
    require 'libraries.json-beautify'
    lovefs = require 'libraries.nativefs'
    Controls = require 'src.components.Controls'
    Switch = require 'libraries.switch'
    Console = require 'libraries.console'
    moonshine = require 'libraries.moonshine'
    debugcomponent = require 'src.components.Debug'
    discordrpc = require 'libraries.discordRPC'
    transition = require 'libraries.TransitionMgr'

    GameVersion = "0.0.1"

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 20)
    love.graphics.setFont(quicksand)

    states = {
        Logostate = require 'src.states.LogoState',
        Menu = require 'src.states.MenuState',
        LevelEditor = require 'src.states.LevelEditorState',
        LevelSelect = require 'src.states.LevelSelectState',
        Playstate = require 'src.states.Playstate',
        OptionsState = require 'src.states.OptionsState',
        Playlist = require 'src.states.PlaylistState',
        Credits = require 'src.states.CreditsState',
        DeathState = require 'src.states.DeathState',
        LevelWinState = require 'src.states.LevelWinState',
        --EventEditor = require 'src.states.EventEditor'
    }

    -- settings --
    Settings = {
        true,   -- glow
        true,   -- controller
        true,   -- Antialiasing
        10     -- Volume
    }

    -- songlist --
    Songs = {
        {title = "nip-trip", isLocked = false},
    }

    local raw = {
        version = GameVersion,
        content = Songs
    }
    local saveinfo = love.filesystem.getInfo("save.dat")
    if saveinfo == nil then
        local savefile = love.filesystem.newFile("save.dat", "w")
        savefile:write(json.encode(raw))
        savefile:close()
        print("[SAVE] : No save detected, created new one")
    else
        local jsonraw = love.filesystem.read("save.dat")
        local savedata = json.decode(jsonraw)
        if savedata.version ~= GameVersion then
            local savefile = love.filesystem.newFile("save.dat", "w")
            savefile:write(json.encode(raw))
            savefile:close()
            print("[SAVE] : Savefile updated")
        else
            print("[SAVE] : Save is equals")
        end
    end

    -- if not exist create the file --
    optionsdata = love.filesystem.getInfo("options.json")
    if optionsdata == nil then
        file = love.filesystem.newFile("options.json", "w")
        file:write(json.encode(Settings))
        file:close()
    end

    -- load the file --
    data = love.filesystem.read("options.json")
    Settings = json.decode(data)

    -- allowing joysticks and gamepads --
    if Settings[2] then
        local joysticks = love.joystick.getJoysticks()
        joystick = joysticks[1]
    end
    if Settings[3] then
        love.graphics.setDefaultFilter("linear", "linear")
    else
        love.graphics.setDefaultFilter("nearest", "nearest")
    end

    effect = moonshine(moonshine.effects.glow)
    effect.glow.min_luma = 0.3
    effect.glow.strength = 5
    
    if Settings[1] then
        effect.enable("glow")
    else
        effect.disable("glow")
    end

    gamestate.registerEvents()
    gamestate.switch(states.Logostate)
end

function love.update(elapsed)
    math.randomseed(os.clock())
    -- set the volume --
    love.audio.setVolume(0.1 * Settings[4])
end

function updateSave(data)
    local savefile = love.filesystem.newFile("save.dat", "w")
    savefile:write(json.encode(data))
    savefile:close()
    print("[SAVE] : Savefile updated")
end
