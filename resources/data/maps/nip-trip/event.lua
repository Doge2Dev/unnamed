Beat = conductor.songPositionInBeats
Step = conductor.songPositionInSteps

--- this function is called avery beat
function onBeat()
    cameraBump(1.03)

    if Beat > 5 and Beat < 10 then
        newMeteorite(love.math.random(64, love.graphics.getHeight() - 64), love.math.random(100, 200), 3)
    end
    
    --newLaser(0.05)
    if Beat == 115 then
        levelEnd()
    end
end

--- this function is called every step
function onStep()
    if Step > 10 and Step < 18 then
        newLaser(love.math.random(64, love.graphics.getHeight() - 64), 0.02)
    end
end

function levelEnd()
    --songlist[2] = true
    achievement.unlock("niptrip")
end