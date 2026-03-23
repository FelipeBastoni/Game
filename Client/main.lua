
--Configurações para conectar ao servidor

local enet = require("enet")

local host = enet.host_create()
local server = host:connect("127.0.0.1:6789")





--Messager (envio de dados (cliente --> Servidor))

function messager(sentido, x, y, vida, id)

        local msg = ""..sentido..";"..x..";"..y..";"..vida..";"..id..";"

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
    player.position = "D"
    player.sprite = p_default[1]




    --inimigo

    id = 0

    inimigo = {}

    inimigo[id] = {}
    inimigo[id].x = 200
    inimigo[id].y = 200
    inimigo[id].speed = 450
    inimigo[id].position = ""
    inimigo[id].sprite = p_default[3]
    inimigo[id].id = id

    jogadores = {}



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




            if t[1] == "log" then

                en = true
            
                id = tonumber(t[5])

                inimigo[id] = {}

                inimigo[id].x = 0
                inimigo[id].y = 0
                inimigo[id].speed = 0
                inimigo[id].position = ""
                inimigo[id].sprite = p_default[3]
                inimigo[id].id = id

                print("novo "..id)

            end


            if t[1] == "logp" then

                idp = tonumber(t[5])

                inimigo[idp] = {}

                inimigo[idp].x = 0
                inimigo[idp].y = 0
                inimigo[idp].speed = 0
                inimigo[idp].position = ""
                inimigo[idp].sprite = p_default[3]
                inimigo[idp].id = idp

                table.insert(jogadores, idp)

                print("Carregado: "..idp)


            end


            if t[1] == "newp" then

                idp = tonumber(t[5])

                inimigo[idp] = {}

                inimigo[idp].x = 0
                inimigo[idp].y = 0
                inimigo[idp].speed = 0
                inimigo[idp].position = ""
                inimigo[idp].sprite = p_default[3]
                inimigo[idp].id = idp

                table.insert(jogadores, idp)

                print("Carregado: "..idp)


            end


            if t[1] == "loadp" then

                idp = tonumber(t[5])

                inimigo[idp].x = t[2]
                inimigo[idp].y = t[3]
                inimigo[idp].speed = t[4]
                inimigo[idp].position = ""
                inimigo[idp].sprite = p_default[3]
                inimigo[idp].id = idp


                print("Load: "..idp)


            end




        elseif event.type == "disconnect" then
    
            print("Desconectado")
        

        end
        
    end






 --Posição do Personagem:


    position = "P"


    if player.position == "E" and position == "P" then

        player.sprite = p_default[2]
        player.position = "PE"


    end

    if player.position == "D" and position == "P" then

        player.sprite = p_default[1]
        player.position = "PD"


    end

    if player.position == "U" and position == "P" then

        player.sprite = p_default[4]
        player.position = "PU"


    end

    if player.position == "S" and position == "P" then

        player.sprite = p_default[3]
        player.position = "PS"

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

        player.position = "U"
        position = "M"

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

        player.position = "S"
        position = "M"

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

        player.position = "E"
        position = "M"

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

        player.position = "D"
        position = "M"

    end




    --Envia posição ao Server

    if step >= 0.041 and id ~= 0 then

        messager(player.position, player.x, player.y, player.speed, id)

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




    for n=1, #jogadores, 1 do

        infa = jogadores[n]

        love.graphics.draw(inimigo[infa].sprite, inimigo[infa].x, inimigo[infa].y)


    end



 --Gera Personagem

    love.graphics.draw(player.sprite, player.x, player.y)




 --Executa

    love.graphics.pop()


end
