credits = {}

function credits:init()
    -- sloow esteve por aqui --
    Controls = require 'src.components.Controls'

    -- chocolate esteve por aqui --


    creditss = {
        guys = {
            {role = "CODERS", guy = "Doge2Dev", pic = love.graphics.newImage('resources/images/credits/doge.png'),desc = "Main coder", link = "https://github.com/Doge2Dev"},
            {role = "CODERS", guy = "Sloow", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Other dumb coder", link = "https://github.com/sloow001"},
            {role = "ARTISTS", guy = "Ploxy", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Artist", link = "https://twitter.com/Ploxycamente2 "},
            {role = "ARTISTS", guy = "Funfas", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Artist", link = "PENIS"},
            {role = "ARTISTS", guy = "Tommix", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Artist", link = "PENIS"},
            {role = "ARTISTS", guy = "Agostiniano", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Artist", link = "https://twitter.com/Agostinoj123"},
            {role = "MUSICIANS", guy = "DavidePlays", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Musician", link = "https://twitter.com/DavidePlays"},
            {role = "MUSICIANS", guy = "TurrTheSmall", pic = love.graphics.newImage('resources/images/credits/sloow.png'),desc = "Musician", link = "https://twitter.com/Turmoiol"},
            {role = "DESIGNER", guy = "Mark", pic = love.graphics.newImage('resources/images/credits/mark.png'),desc = "Promotional Art", link = "https://www.instagram.com/mar.kdawnn/"},
        },
        massagg = {
            'LEFT - RIGHT change the category',
            'UP - DOWN change the current person'
        }
    }

    cur = 1
    roleee = 1

    studioLogo = love.graphics.newImage("resources/images/logoTransparent.png")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")

    rolee = love.graphics.newFont("resources/fonts/quicksand-bold.ttf", 70)
    info = love.graphics.newFont("resources/fonts/quicksand-regular.ttf", 20)
end

function credits:draw()
    -- bg --
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)

    -- fucking banger texts --
    love.graphics.setFont(rolee)
    love.graphics.print(creditss.guys[roleee].role, love.graphics.getWidth() / 2 - rolee:getWidth(creditss.guys[roleee].role) / 2, 60)
    love.graphics.print(creditss.guys[cur].guy, love.graphics.getWidth() / 2 - rolee:getWidth(creditss.guys[cur].guy) / 2, 600)
    for i,m in ipairs(creditss.massagg) do 
        love.graphics.setFont(info)
        love.graphics.print(creditss.massagg[i],0, 660 + i * 40)
    end

    -- images --
    love.graphics.draw(creditss.guys[cur].pic, love.graphics.getWidth() / 2 - creditss.guys[cur].pic:getWidth() / 2, 200)
    love.graphics.draw(studioLogo, 1060, 580, 0, 0.2, 0.2)

end

function credits:update(elapsed)

    -- VAI TOMA NO CU PIRANHAAAAAAAA --

    if creditss.guys[roleee].role == 'CODERS' then 
        if cur > 2 then 
            cur = 2
        elseif cur < 1 then 
            cur = 1
        end
    end
    if creditss.guys[roleee].role == 'ARTISTS' then 
        if cur > 6 then 
            cur = 6
        elseif cur < 3 then 
            cur = 3
        end
    end
    if creditss.guys[roleee].role == 'MUSICIANS' then 
        if cur > 8 then 
            cur = 8 
        elseif cur < 7 then 
            cur = 7
        end
    end
    if creditss.guys[roleee].role == 'DESIGNER' then 
        if cur > 9 then 
            cur = 9
        elseif cur < 9 then 
            cur = 9
        end
    end

    -- print("CUR ROLE:" .. roleee)
end

function credits:keypressed(k)
    if k == Controls.Keyboard.SELECT_LEFT then 
        roleee = roleee - 1
        if roleee < 1 then 
            roleee = 1
        end
        if creditss.guys[roleee].role == 'ARTISTS' then 
            if roleee == 3 then 
                roleee = 1
            end
        elseif creditss.guys[roleee].role == 'MUSICIANS' then 
            if roleee == 7 then 
                roleee = 3
            end
        elseif creditss.guys[roleee].role == 'DESIGNER' then 
            if roleee == 9 then 
                roleee = 7
            end
        end
    end
    if k == Controls.Keyboard.SELECT_RIGHT then 
        roleee = roleee + 1
        if roleee > 9 then 
            roleee = 9
        end
        if creditss.guys[roleee].role == 'CODERS' then
            if roleee > 1 then
                roleee = 3 
            end
        elseif creditss.guys[roleee].role == 'ARTISTS' then 
            if roleee > 3 then 
                roleee = 7
            end
        elseif creditss.guys[roleee].role == 'MUSICIANS' then 
            if roleee > 7 then 
                roleee = 9
            end
        elseif creditss.guys[roleee].role == 'DESIGNER' then 
            if roleee > 9 then 
                roleee = 9
            end
        end
    end
    if k == Controls.Keyboard.SELECT_UP then 
        cur = cur - 1
    end
    if k == Controls.Keyboard.SELECT_DOWN then 
        cur = cur + 1
    end

    if k == Controls.Keyboard.ACCEPT then 
        love.system.openURL(creditss.guys[cur].link)
    end

    if k == Controls.Keyboard.BACK then 
        gamestate.switch(states.Menu)
    end
end

return credits