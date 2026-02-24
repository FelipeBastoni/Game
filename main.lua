


function love.load()

    p_right = love.graphics.newImage("player.jpg")
    p_left = love.graphics.newImage("player2.png")

    player = {}
    player.x = 300
    player.y = 200
    player.speed = 200
    player.sprite = p_right


    love.window.setMode(1800, 900)

end

function love.update(dt)

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed * dt

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
    love.graphics.draw(player.sprite, player.x, player.y)


end