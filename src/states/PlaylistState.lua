playlist = {}

function playlist:init()
    transition = require 'src.Transition'
    conductor = require 'src.components.Conductor'
    currentSelection = 1
    songlist = {
        "dubnix",
        "neon-code",
        "nip-trip",
    }
    songlistBpm = {
        85,
        87,
        87,
    }

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 40)
    love.graphics.setFont(quicksand)

    cursor = love.graphics.newImage("resources/images/menu/cursor.png")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    cursor_y = 40
    maxY = 0
end

function playlist:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.2, 1.2)
    local y = 160

    effect(function()
        love.graphics.draw(cursor, 10, cursor_y + 5)
        for i = 1, #songlist, 1 do
                love.graphics.print(songlist[i], 80, y)
            
            y = y + 50
        end
        maxY = y - 50
    end)
end

function playlist:update(elapsed)
    if cursor_y < 160 then
        cursor_y = 160
    end
    if cursor_y > maxY then
        cursor_y = maxY
    end
    if currentSelection < 1 then
        currentSelection = 1
    end
    if currentSelection > #songlist then
        currentSelection = #songlist
    end

end

function playlist:keypressed(k)
    if k == Controls.Keyboard.SELECT_UP then
        cursor_y = cursor_y - 50
        currentSelection = currentSelection - 1
    end
    if k == Controls.Keyboard.SELECT_DOWN then
        cursor_y = cursor_y + 50
        currentSelection = currentSelection + 1
    end
    if k == Controls.Keyboard.ACCEPT then
        conductor.stop()
        playstate.levelToLoad = songlist[currentSelection]
        playstate.bpm = songlistBpm[currentSelection]
        gamestate.switch(states.Playstate)
    end
    if k == Controls.Keyboard.BACK then
        gamestate.switch(states.Menu)
    end
    
end

return playlist