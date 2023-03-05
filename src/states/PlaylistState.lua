playlist = {}

function playlist:enter()
    conductor = require 'src.components.Conductor'
    
    currentSelection = 1
    songlist = {}

    jsonData = json.decode(love.filesystem.read("save.dat"))
    playlist.songlist = jsonData.content

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 40)
    love.graphics.setFont(quicksand)

    cursor = love.graphics.newImage("resources/images/menu/cursor.png")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    locker = love.graphics.newImage("resources/images/GUI/locker.png")
    cursor_y = 40
    maxY = 0
end

function playlist:draw()
    local y = 160

    effect(
        function()
            love.graphics.draw(bg, 0, 0, 0, 1.2, 1.2)
            love.graphics.draw(cursor, 10, cursor_y + 7)
            for i = 1, #playlist.songlist, 1 do
                if playlist.songlist[i].isLocked then
                    love.graphics.draw(locker, 55, y, 0, 0.2, 0.2)
                end
                love.graphics.print(playlist.songlist[i].title, 100, y)
                y = y + 50
            end
        maxY = y - 50
        end
    )
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
    if currentSelection > #playlist.songlist then
        currentSelection = #playlist.songlist
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
        if not playlist.songlist[currentSelection].isLocked then
            conductor.stop()
            playstate.levelToLoad = playlist.songlist[currentSelection].title
            --playstate:init()
            gamestate.switch(states.Playstate)
        end
    end
    if k == Controls.Keyboard.BACK then
        gamestate.switch(states.Menu)
    end
end

function playlist:gamepadpressed(jstk, button)
    if joystick ~= nil then
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_UP) then
            cursor_y = cursor_y - 50
            currentSelection = currentSelection - 1
        end
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_DOWN) then
            cursor_y = cursor_y + 50
            currentSelection = currentSelection + 1
        end
        if joystick:isGamepadDown(Controls.Gamepad.ACCEPT) then
            if not playlist.songlist[currentSelection].isLocked then
                conductor.stop()
                playstate.levelToLoad = playlist.songlist[currentSelection].title
                --playstate:init()
                gamestate.switch(states.Playstate)
            end
        end
        if joystick:isGamepadDown(Controls.Gamepad.BACK) then
            gamestate.switch(states.Menu)
        end
    end
end

function playlist:gamepadaxis(joystick, axis, value)
	if axis == "lefty" then
		if value == -1 then
            cursor_y = cursor_y - 50
            currentSelection = currentSelection - 1
        end
        if value == 1 then
            cursor_y = cursor_y + 50
            currentSelection = currentSelection + 1
        end
	end
end

return playlist