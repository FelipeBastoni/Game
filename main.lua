


function love.load()

    p_up = love.graphics.newImage("primeofc.png") 
    p_right = love.graphics.newImage("primeofc.jpg")
    p_left = love.graphics.newImage("primeofc.png")

    grama = love.graphics.newImage("grama.png")

    player = {}
    player.x = 300
    player.y = 200
    player.speed = 200
    player.sprite = p_right


    love.window.setMode(1920, 1080)

end

function love.update(dt)

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt
        player.sprite = p_up

    end

    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed * dt

    end

    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
        player.sprite = p_left

    end

    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
        player.sprite = p_right
            
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
