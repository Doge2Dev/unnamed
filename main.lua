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
        DeathState = require 'src.states.DeathState'
        --EventEditor = require 'src.states.EventEditor'
    }

    -- settings --
    Settings = {
        true,   -- glow
        true,   -- controller
        true,   -- Antialiasing
    }

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

    effect = moonshine(moonshine.effects.glow)
    effect.glow.min_luma = 0.3
    effect.glow.strength = 5 

    gamestate.registerEvents()
    gamestate.switch(states.Logostate)
end

function love.draw() 
end

function love.update(dt)
end
