Beat = conductor.songPositionInBeats
Step = conductor.songPositionInSteps

function onBeat()
    cameraBump(1.03)
    if Beat == 2 then
        newBullet(10)
        newSaw()
    end
end

function onStep()
    
end