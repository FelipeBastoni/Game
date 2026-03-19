
--Configurações para conectar ao servidor

local enet = require("enet")

local host = enet.host_create()
local server = host:connect("127.0.1.0:6789")






--Messager (envio de dados (cliente --> Servidor))

function messager(a, b, c, d)

        local msg = ""..a..";"..b..";"..c..";"..d..";"

        server:send(msg)

end






--Captador de resposta

local t = {}
function update(xt)

    
    for item in string.gmatch(xt, "([^;]+)") do
        table.insert(t, item)
    end


end






function love.load()


 --sprites:


    --player

    p_default = {
        love.graphics.newImage("primeofc.png"), 
        love.graphics.newImage("primeofcesq.png"),
        love.graphics.newImage("primedownf.png"),
        love.graphics.newImage("primeup.png")

    }

    p_right = {
        love.graphics.newImage("primestp1.png"),
        love.graphics.newImage("primestp2.png")

    }

    p_left = {
        love.graphics.newImage("primestp1esq.png"),
        love.graphics.newImage("primestp2esq.png")
    
    }

    p_up = {

        love.graphics.newImage("primeupstep1.png"), 
        love.graphics.newImage("primeupstep2.png") 

    }


    p_down = {

        love.graphics.newImage("primedownstep1.png"), 
        love.graphics.newImage("primedownstep2.png"), 


    }






    --cenário

    grama = love.graphics.newImage("grama.png")






 --objetos

    --player

    player = {}
    player.x = 300
    player.y = 200
    player.speed = 450  
    player.sprite = p_default[1]




    --inimigo

    inimigo = {}
    inimigo.x = 200
    inimigo.y = 200
    inimigo.speed = 450  
    inimigo.sprite = p_default[3]






    --configuração da janela

    love.window.setMode(1920, 1080)

end






--Processos por frame

--Operadores

local en = false
local step = 0
local position = ""

function love.update(dt)


    local event = host:service(0)


    step = step + dt


--Quando temos resposta do servidor

    if event then


    --checa conexão

        if event.type == "connect" then        
            print("Conectado ao servidor!")


    --Onde a mágica acontece

        elseif event.type == "receive" then
            print("Servidor respondeu:", event.data)


            --reseta array
            t = {}
            update(event.data)



        --Quando Resposta:



            if t[1] == "en" then

                en = true

            end














        elseif event.type == "disconnect" then
    
            print("Desconectado")
        

        end
        
    end






 --Posição do Personagem:

    if position == "E" then

        player.sprite = p_default[2]

    end

    if position == "D" then

        player.sprite = p_default[1]

    end

    if position == "U" then

        player.sprite = p_default[4]

    end

    if position == "S" then

        player.sprite = p_default[3]

    end






 --Movimentação do Personagem:

    if love.keyboard.isDown("w") then
        
        player.y = player.y - player.speed * dt
        player.sprite = p_up[1]


        --Animação do Personagem
        if step > 0.25 then
            player.sprite = p_up[2]

            if step > 0.5 then
                step = 0
            end
        end

        position = "U"

    end





    if love.keyboard.isDown("s") then
    
        player.y = player.y + player.speed * dt
        player.sprite = p_down[1]


        if step > 0.25 then
            player.sprite = p_down[2]

            if step > 0.5 then
                step = 0
            end
        end

        position = "S"

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



    --Envia posição ao Server

    if step >= 0.041 then

        messager(position, player.x, player.y, player.speed)

    end



    --Informação Inimigo


    if en == true then

        inimigo.x = t[2]
        inimigo.y = t[3]
        
        if t[4] == "U" then

            inimigo.sprite = p_up[1]

            if step > 0.25 then
                inimigo.sprite = p_up[2]

                if step > 0.5 then
                    step = 0
                end

            end

        end


        if t[4] == "S" then

            inimigo.sprite = p_down[1]

            if step > 0.25 then
                inimigo.sprite = p_down[2]
            
                if step > 0.5 then
                    step = 0
                end

            end

        end


        if t[4] == "E" then

            inimigo.sprite = p_left[1]

            if step > 0.25 then
                inimigo.sprite = p_left[2]

                if step > 0.5 then
                    step = 0
                end

            end
        
        end


        if t[4] == "D" then

            inimigo.sprite = p_right[1]

            if step > 0.25 then
                inimigo.sprite = p_right[2]

                if step > 0.5 then
                    step = 0
                end
            
            end

        end


        if t[4] == "PU" then

            inimigo.sprite = p_default[4]

        end


        if t[4] == "PS" then

            inimigo.sprite = p_default[3]

        end


        if t[4] == "PE" then

            inimigo.sprite = p_default[2]

        end


        if t[4] == "PD" then

            inimigo.sprite = p_default[1]

        end


    end



end






--Joga na Tela:

function love.draw()


 --Tamanho da tela

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()


 --Camera

    love.graphics.push()
    love.graphics.translate(

        -player.x + screenWidth/ 2,
        -player.y + screenHeight / 2

    )




 --Gerador de Cenário

    for x = 0, 1910, 191 do

        for y = 0, 1146, 191 do 
        
            love.graphics.draw(grama, x, y)

        end

    end




 --Gerador de Inimigo

    love.graphics.draw(inimigo.sprite, inimigo.x, inimigo.y)




 --Gera Personagem

    love.graphics.draw(player.sprite, player.x, player.y)




 --Executa

    love.graphics.pop()


end
