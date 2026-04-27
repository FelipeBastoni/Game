
--Configurações para conectar ao servidor

local enet = require("enet")

local host = enet.host_create()
local server = host:connect("127.0.0.1:6789")





--Messager (envio de dados (cliente --> Servidor))

function messager(sentido, x, y, vida, id)

    if not peer then
        return
    end

    local msg = ""..sentido..";"..x..";"..y..";"..vida..";"..id..";"

    peer:send(msg, 0, "unreliable")
    host:flush()

end






--Captador de resposta

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


  --Cenário

    grama = love.graphics.newImage("grama.png")









 --Operadores

  --Array de dados recebidos do Servidor
    t = {}

  --Status de spawn
    en = false

  --Time step das animações
    step = 0

  --Time step do envio de pacotes
    timer = 0

  --Posição do personagem
    position = ""

  --Posição do mouse
    mx = 0
    my = 0

  --Definidor de ID das conexões/clientes
    id = 0 

  --Definidor de ID dos Inimigos
    idi = 0

  --Array das conexões/clientes
    jogadores = {}

  --Array dos inimigos
    inimigos = {}


 --Executor do jogo
    runner = false

 --Alfa da animação da tela inicial
    alfa = 0.5
    
 --Timer da animação da Tela inicial
    cut_timer = 1
    



 --objetos

  --player

    player = {}
    player.x = 300
    player.y = 200
    player.speed = 450  
    player.position = "D"
    player.sprite = p_default[1]



  --Party (outros jogadores)

    party = {}
    party[id] = {}
    party[id].x = 200
    party[id].y = 200
    party[id].speed = 450
    party[id].position = ""
    party[id].sprite = p_default[3]
    party[id].id = id

  

  --Inimigos

    inimigo = {}
    inimigo[idi] = {}
    inimigo[idi].x = 200
    inimigo[idi].y = 200
    inimigo[idi].speed = 450
    inimigo[idi].position = ""
    inimigo[idi].sprite = p_default[3]
    inimigo[idi].id = idi



 --Configuração da janela


   --Resolução/tamanho da tela
    love.window.setMode(1920, 1080)


end




--Chama a tela inicial

function initial()

  --Define o fundo
    fundo = love.graphics.newImage("AAA.png")
    
  --Define a fonte
    fonte = love.graphics.newFont(25)
    love.graphics.setFont(fonte)
    
  --Printa o fundo
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(fundo)
    text = "PRESSIONE A TECLA ESPAÇO PARA JOGAR"
    love.graphics.setColor(1, 1, 1, alfa)
    love.graphics.print(text, (love.graphics.getWidth() - love.graphics.getFont():getWidth(text))/2, (love.graphics.getHeight()/2)+250)

    love.graphics.setColor(1, 1, 1, 1)

end



--Limpa a tela inicial

function start()
    love.graphics.clear(0, 0, 0)
end







--Processos por frame

function love.update(dt)

  --Animação tela inicial

    if runner == false then
        if alfa < 1 and cut_timer == 1 then
            alfa = alfa + (dt/4)
        end
        if alfa >= 1 then 
            cut_timer = 2
        end
        if cut_timer == 2 then
            alfa = alfa - (dt/4)
        end
        if alfa <= 0.5 then
            cut_timer = 1
        end
        if love.keyboard.isDown("space") then
            alfa = 0
            runner = true
        end
    end





  --Resgatando evento e atualizando variaveis de fluxo

    local event = host:service(0)

    timer = timer + dt
    step = step + dt



--Quando temos resposta do servidor

    if event then


    --checa conexão

        if event.type == "connect" then        
            print("Conectado ao servidor!")

            peer = event.peer


    --Onde a mágica acontece

        elseif event.type == "receive" then



            --forma o array com dados recebidos
            update(event.data)


    


        elseif event.type == "disconnect" then
            print("Desconectado")
        end
        

    end


        
--Quando Resposta:

  --Trata primeira conexão

    if t[1] == "log" then

        en = true
        id = tonumber(t[5])

        party[id] = {}
        party[id].x = 0
        party[id].y = 0
        party[id].speed = 0
        -- party[id].position = "love.graphics.newImage("nome padronizado..t[4]..".png"")"
        party[id].sprite = p_default[3]
        party[id].id = id

        print("novo "..id)
        t = {}


    end


  --Trata carregamento de jogadores

    if t[1] == "logp" then

        idp = tonumber(t[5])

        party[idp] = {}
        party[idp].x = 0
        party[idp].y = 0
        party[idp].speed = 0
        party[idp].position = ""
        party[idp].sprite = p_default[3]
        party[idp].id = idp

        table.insert(jogadores, idp)

        print("Carregado: "..idp)
        t = {}


    end


  --Trata inclusão de jogador

    if t[1] == "newp" then

        idp = tonumber(t[5])

        party[idp] = {}
        party[idp].x = 0
        party[idp].y = 0
        party[idp].speed = 0
        party[idp].position = ""
        party[idp].sprite = p_default[3]
        party[idp].id = idp

        table.insert(jogadores, idp)

        print("Carregado: "..idp)
        t = {}


    end


  --Trata inclusão de inimigos

    if t[1] == "newi" then

        idip = tonumber(t[5])

        inimigo[idip] = {}
        inimigo[idip].x = t[2]
        inimigo[idip].y = 0
        inimigo[idip].speed = 0
        inimigo[idip].position = ""
        inimigo[idip].sprite = p_default[3]
        inimigo[idip].id = idip

        table.insert(inimigos, idip)

        print("Gerado: "..idip)
        t = {}


    end


  --Trata atualização de jogador

    if t[1] == "loadp" then

        idp = tonumber(t[5])

        party[idp].x = t[2]
        party[idp].x = t[2]
        party[idp].y = t[3]
        party[idp].speed = 0
        party[idp].sprite = p_down[1]
        party[idp].position = t[4]
        party[idp].id = idp

        print(t[4])
        t = {}

    
      --Define sprite quando parado

        if t[4] == "PE" then
            party[idp].sprite = p_default[2]
        end

        if t[4] == "PD" then 
            party[idp].sprite = p_default[1]
        end


        if t[4] == "PU" then
            party[idp].sprite = p_default[4]
        end

        if t[4] == "PS" then 
            party[idp].sprite = p_default[3]
        end




      --Define sprite quando andando

        if t[4] == "E" then
            party[idp].sprite = p_left[1]
        end

        if t[4] == "D" then
            party[idp].sprite = p_right[1]
        end

        if t[4] == "U" then
            party[idp].sprite = p_up[1]
        end

        if t[4] == "S" then
            party[idp].sprite = p_down[1]
        end

    
      --Resseta o Array de dados recebidos
        t = {}


    end


  --Trata atualização de inimigo

    if t[1] == "loadi" then

        idip = tonumber(t[5])

        inimigo[idip].x = t[2]
        inimigo[idip].y = 0
        inimigo[idip].speed = 0
        inimigo[idip].position = ""
        inimigo[idip].sprite = p_default[3]
        inimigo[idip].id = idip

        print(t[2])
        t = {}

    end




 --Posição do Personagem:


    position = "P"

  --Define sprite quando parado do cliente da conexão

    if player.position == "PE" then
        player.sprite = p_default[2]
    end

    if player.position == "PD" then
        player.sprite = p_default[1]
    end

    if player.position == "PU" then
        player.sprite = p_default[4]
    end

    if player.position == "PS" then
        player.sprite = p_default[3]
    end




 --Movimentação do Personagem:


  --Define Sprite por posição do mouse


    mx = love.mouse.getX()
    my = love.mouse.getY()


    if mx > 960 then
        player.position = "PD"
    else    
        player.position = "PE"
    end


    if mx >= 864 and mx <= 1056 and my > 540  then
        player.position = "PS"
    elseif mx >= 864 and mx <= 1056 and my < 540  then
        player.position = "PU"
    end






 --Teclado

  --Calcula posição do jogador de acordo com comando

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

    end


  --Correr com Shift

    if love.keyboard.isDown("lshift") then
        player.speed = 750
    else 
        player.speed = 450
    end




 --Envia Dados do jogador ao Server

                --Limita a cerca de 24+ envios por segundo
    if timer >= 0.042 and id ~= 0 then
        messager(player.position, player.x, player.y, player.speed, id)
        timer = 0
    end


end





--Desenha na Tela:

function love.draw()


  --Lógica de exibição tela inicial ---> jogo

    if runner == false then
        initial()
    end

    if runner == true then
        start()
        runner = 7
    end



  --Jogo rodando

    if runner == 7 then


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


    -- Array da party

        for n=1, #jogadores, 1 do
            infa = jogadores[n]
            love.graphics.draw(party[infa].sprite, party[infa].x, party[infa].y)
        end


    --Array dos inimigos
    
    if #inimigos > 0 then

        for n=1, #inimigos, 1 do
            infa = inimigos[n]
            love.graphics.draw(inimigo[infa].sprite, inimigo[infa].x, inimigo[infa].y)
        end

    end

    
    --Gera Personagem

        love.graphics.draw(player.sprite, player.x, player.y, math.rad(0), 1, 1, player.sprite:getWidth()/2, player.sprite:getHeight()/2)



    --Executa

        love.graphics.pop()



    end



end
