eventhandler = {}

conductor = require 'src.components.Conductor'
utilities = require 'src.Utilities'

local songLastBeat = conductor.songPositionInBeats
local songLastStep = conductor.songPositionInSteps

function eventhandler.load(filename)
    code, error = love.filesystem.load("resources/data/maps/" .. filename .. "/event.lua")
    if error ~= nil then
        print("[ERROR] : " .. error)
    end
end

function eventhandler.update(elapsed)
    if error == nil then
        conductor.update(elapsed)
        if conductor.songPositionInBeats ~= songLastBeat then
            songLastBeat = conductor.songPositionInBeats
            print("[EVENT] : On beat")
            pcall(code(), onBeat())
        elseif conductor.songPositionInSteps ~= songLastStep then
            songLastStep = conductor.songPositionInSteps
            print("[EVENT] : On step")
            pcall(code(), onStep())
        end
    end
end

function eventhandler.levelEnds()
    print("[EVENT] : Level Ends]")
    pcall(code(), levelEnd())
end

return eventhandler