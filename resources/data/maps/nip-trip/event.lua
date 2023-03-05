Beat = conductor.songPositionInBeats
Step = conductor.songPositionInSteps

--- this function is called avery beat
function onBeat()
    cameraBump(1.03)
    if Beat < 5 then
        newBullet(3)
    end
    --newLaser(0.05)
    if Beat == 115 then
        levelEnd()
    end
end

--- this function is called every step
function onStep()
    if Step > 10 and Step < 18 then
        newLaser(0.01)
    end
end

function levelEnd()
    --songlist[2] = true
end