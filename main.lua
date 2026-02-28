


function love.load()

    p_default = {
        love.graphics.newImage("primeofc.png"), 
        love.graphics.newImage("primeofcesq.png") 

    }

    p_right = {
        love.graphics.newImage("primestp1.png"),
        love.graphics.newImage("primestp2.png")

    }

    p_left = {
        love.graphics.newImage("primestp1esq.png"),
        love.graphics.newImage("primestp2esq.png")
    
    }




    grama = love.graphics.newImage("grama.png")

    player = {}
    player.x = 300
    player.y = 200
    player.speed = 500
    player.sprite = p_default[1]


    love.window.setMode(1920, 1080)

end


local step = 0
local position = ""

function love.update(dt)

    step = step + dt

    if position == "E" then

        player.sprite = p_default[2]

    end

    if position == "D" then

        player.sprite = p_default[1]

    end






    if love.keyboard.isDown("w") then
        
        player.y = player.y - player.speed * dt

    end





    if love.keyboard.isDown("s") then
     
        player.y = player.y + player.speed * dt

    end








    if love.keyboard.isDown("a") then
 
        player.x = player.x - player.speed * dt
        player.sprite = p_left[1]


        if step > 0.25 then
            player.sprite = p_left[2]

            if step > 0.5 then
                step = 0
            end
        end

        position = "E"

    end




    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
        player.sprite = p_right[1]
            
        if step > 0.25 then
            player.sprite = p_right[2]

            if step > 0.5 then
                step = 0
            end
        end

        position = "D"

    end


end





function love.draw()

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    love.graphics.push()
    love.graphics.translate(

        -player.x + screenWidth/ 2,
        -player.y + screenHeight / 2

    )



    for x = 0, 1910, 191 do

        for y = 0, 1146, 191 do 
        
            love.graphics.draw(grama, x, y)

        end

    end




    love.graphics.draw(player.sprite, player.x, player.y)

    love.graphics.pop()


end
