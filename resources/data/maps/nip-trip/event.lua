Beat = conductor.songPositionInBeats
Step = conductor.songPositionInSteps

--- this function is called avery beat
function onBeat()
    cameraBump(1.03)
    --newBullet()
    newLaser(0.05)

end

--- this function is called every step
function onStep()

end