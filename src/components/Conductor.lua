conductor = {}

local bpm = 0.0
conductor.secPerBeat = 0
conductor.songPosition = 0
conductor.songPositionInBeats = 0
conductor.crochet = 0
conductor.stepCrochet = 0
conductor.firstBeatOffset = 0
conductor.dspSongTime = 0
conductor.songPositionInSteps = 0


function conductor.load(filename)
    audio = love.audio.newSource(filename .. ".ogg", "static")

    conductor.secPerBeat = 60.0 / bpm
    conductor.crochet = ((60 / bpm) * 1000)
    conductor.stepCrochet = conductor.crochet / 4
    conductor.dspSongTime = audio:tell("seconds")
end

function conductor.getAudio()
    return audio
end

function conductor.setPosition(seconds)
    if conductor.audio ~= nil then
        conductor.audio:seek(seconds, "seconds")
        return true
    else
        return false
    end
end

function conductor.play()
    if audio ~= nil then
        audio:play()
        return true
    else
        return false
    end
end

function conductor.pause()
    if audio ~= nil then
        audio:pause()
        return true
    else
        return false
    end
end

function conductor.stop()
    if audio ~= nil then
        audio:stop()
        return true
    else
        return false
    end
end

function conductor.render()
    love.graphics.print(tostring(conductor.songPosition), 10, 500)
    love.graphics.print(tostring(conductor.songPositionInBeats), 10, 530)
    love.graphics.print(tostring(conductor.songPositionInSteps), 10, 560)
end

function conductor.update(dt)
    if audio ~= nil then
        conductor.songPosition = audio:tell("seconds") - conductor.dspSongTime - conductor.firstBeatOffset
        conductor.songPositionInBeats = math.floor(conductor.songPosition / conductor.secPerBeat)
        conductor.songPositionInSteps = math.floor(audio:tell("seconds") - conductor.dspSongTime / conductor.stepCrochet)
    end
end

function conductor.setBPM(amount)
    print("BPM Changed")
    bpm = amount
    conductor.secPerBeat = 60.0 / bpm
    conductor.crochet = ((60 / bpm) * 1000)
end

return conductor