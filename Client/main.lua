
--Configurações para conectar ao servidor

local enet = require("enet")

local host = enet.host_create()
local server = host:connect("127.0.0.1:6789")


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







 --Operadores


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

  --Versor de movimento do player
    vx = 0
    vy = 0

  --Definidor de ID das conexões/clientes
    id = 0 

  --Definidor de ID dos Inimigos
    idi = 0

  --Array das conexões/clientes
    jogadores = {}

  --Array dos inimigos
    inimigos = {}

  --Array dos itens
    itens = {}

 --Executor do jogo
    runner = false

 --Alfa da animação da tela inicial
    alfa = 0.5
    
 --Timer da animação da Tela inicial
    cut_timer = 1
    
 --Timer dos tiros
    shoots = 0
    a = 0
    t_bullet = false
    shoot = {}

 --Barras

   --Timer de Regeneração
    reg_timer = 0

   --Barra de Stamina
    tamanho_s = 243
    braltura_s = 14
    brx_s = 36
    bry_s = 16
    board_s = 2

  --Barra de Vida
    tamanho_v = 3
    braltura_v = 14
    brx_v = 36
    bry_v = 16
    board_v = 2

  --Barra de Defesa
    tamanho_d = 0
    braltura_d = 14
    brx_d = 36
    bry_d = 16
    board_d = 2


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


  --Itens

    item = {}
    item[idi] = {}
    item[idi].x = 0
    item[idi].y = 0
    item[idi].tipo = ""
    item[idi].sprite = tiro
    item[idi].id = idi



 --Configuração da janela

   --Resolução/tamanho da tela
    love.window.setMode(1920, 1080)








 --Variáveis do cenário

    mapa = {}    
  --Altura da imagem (tile)
    tile_height = 192
  --Largura da imagem (tile)
    tile_width  = 192 
    
  --Numero de imagens (tiles) na horizontal
    local h_tiles       

  --Numero de imagens (tiles) na vertical
    local v_tiles      

  -- ponto esquerdo do cenário que será apresentado
    left_corner = 1 



  --Imagens do Cenário

    grama = love.graphics.newImage("grama.png")

    stone = love.graphics.newImage("grama.png")
    sky = love.graphics.newImage("grama.png")

    tiro = love.graphics.newImage("zumbi.png")

 --Carrega o Cenário

    LoadMap("mapa.txt") 


end


--Função para carregar o mapa

function LoadMap(filename)       -- Carrega o arquivo com o mapa de padrões
  local file = io.open(filename) -- Abre o arquivo 
  local i = 1                    -- Prepara para carregar a 1a. linha
  for line in file:lines() do    -- Para cada linha do arquivo do Mapa
    mapa[i] = {}                 -- Cria um vetor horizontal para uma linha
    for j = 1, #line, 1 do       -- Carrega a linha
      mapa[i][j] = line:sub(j,j) -- Carrega cada elemento da linha
    end
    i = i + 1                    -- Passa para a próxima linha
    h_tiles = #line  -- determina o número de padrões na horizontal
    v_tiles = i - 1  -- determina o número de padrões na vertical
    -- determina o número de padrões visíveis
  end
  file:close()   -- Fecha o arquivo
end












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
    for packet in string.gmatch(xt, "[^%c]+") do
        t = {}

        for item in string.gmatch(packet, "([^;]+)") do
            table.insert(t, item)
        end

        processPacket(t)
    end
end


function processPacket(t)

--Quando Resposta:

  --Trata primeira conexão

    if not t[1] then return end

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


    end


  --Trata inclusão de inimigos

    if t[1] == "newi" then

        idip = tonumber(t[5])

        inimigo[idip] = {}
        inimigo[idip].x = t[2]
        inimigo[idip].y = 0
        inimigo[idip].speed = 0
        inimigo[idip].position = ""
        inimigo[idip].sprite = tiro
        inimigo[idip].id = idip

        table.insert(inimigos, idip)

        print("Gerado: "..idip)


    end


  --Trata inclusão de itens

    if t[1] == "newu" then

        idip = tonumber(t[5])

        item[idip] = {}
        item[idip].x = t[2]
        item[idip].y = t[3]
        item[idip].tipo = ""
        item[idip].id = idip
        item[idip].sprite = tiro

        table.insert(itens, idip)

        print("Gerado: "..idip)


    end


  --Trata atualização de jogador

    if t[1] == "loadp" then

        idp = tonumber(t[5])

        party[idp].x = t[2]
        party[idp].y = t[3]
        party[idp].speed = 0
        party[idp].sprite = p_down[1]
        party[idp].position = t[4]
        party[idp].id = idp


    
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

    


    end


  --Trata atualização de inimigo

    if t[1] == "loadi" then

        idip = tonumber(t[5])

        if not inimigo[idip] then
            inimigo[idip] = {
                x = 0,
                y = 0,
                speed = 0,
                position = "",
                sprite = tiro,
                id = idip
            }

        end

        inimigo[idip].x = t[2]
        inimigo[idip].y = 0
        inimigo[idip].speed = 0
        inimigo[idip].position = ""
        inimigo[idip].sprite = tiro
        inimigo[idip].id = idip


    end

end










function conn()


    while true do
        
        local event = host:service(0)

        if not event then break end


     --Quando temos resposta do servidor

        if event then


         --checa conexão

            if event.type == "connect" then        
                print("Conectado ao servidor!")

                peer = event.peer


            elseif event.type == "receive" then

                --forma o array com dados recebidos
                update(event.data)


            elseif event.type == "disconnect" then
                print("Desconectado")
            end


        end

    end

end














--Processos por frame

function love.update(dt)
    
    conn()

    timer = timer + dt
    step = step + dt
    reg_timer = reg_timer + dt


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

        vy = 1

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

        vy = -1


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

        vx = 1


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

        vx = -1


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
        braltura_s = 14
        brx_s = 36
        bry_s = 16
        board_s = 2

        if tamanho_s >= 1 then

            tamanho_s = tamanho_s - 1 

        else 
            player.speed = 450

            braltura_s = 0
            brx_s = 0
            bry_s = 0
            board_s = 0
        end
    
    else 
        
        player.speed = 450

        if tamanho_s <= 243 then

            tamanho_s = tamanho_s + 1
            braltura_s = 14
            brx_s = 36
            bry_s = 16
            board_s = 2

        end

    end

    
  --Regenração do Escudo

    if reg_timer > 1.75 and tamanho_d <= 4 then

        reg_timer = 0
        tamanho_d = tamanho_d + 1

        print(tamanho_d)

    end 

    if tamanho_d == 1 then 

        braltura_d = 14
        brx_d = 36
        bry_d = 16
        board_d = 2

    end

    if tamanho_d == 0 then

        braltura_d = 0
        brx_d = 0
        bry_d = 0
        board_d = 0

    end




  --Mouse 

    if t_bullet == true then

        shoots = shoots + dt

        if shoots > 0.1 then

            t_bullet = false
            shoots = 0

        end

    end


    if love.mouse.isDown(1) and t_bullet == false then

        t_bullet = true

        a = a + 1

        tx = mx
        ty = my

        ger_tiro(tx, ty, a)


    end



  --Disparos

    function ger_tiro(tx, ty, a)

        shoot[a] = {}
        shoot[a].x = tx
        shoot[a].y = ty
        shoot[a].id = a

        print(shoot[a].id)

        drawtiro(a)

    end

    function drawtiro(a)


        love.graphics.draw(tiro, shoot[a].x, shoot[a].y)

    end



 --Envia Dados do jogador ao Server

                --Limita a cerca de 24+ envios por segundo
    if timer >= 0.042 and id ~= 0 then
        messager(player.position, player.x, player.y, player.speed, id)
        timer = 0
    end



    if love.keyboard.isDown("z") then

        player.x = 100
        player.y =100

    end




    if runner == 7 then


        if player.x <= 100 and player.y  >= -1000 then

            player.x = 100

            player.y = player.y


        end

    end


    
--Colisão

    if runner == 7 and #inimigo > 0 then

        for p=1, #inimigo, 1 do
            
            v_colisao_a = inimigo[p]

            print(p)


            if checkCollision(player, v_colisao_a) == true then

                player.x = nvx
            
            end

            if checkCollision(player, v_colisao_a) == false then

                nvx = player.x
                nvy = player.y

            end


            if checkCollision(player, v_colisao_a) then

                player.y = nvy

            end




        end

    end








end
















function checkCollision(a, b)

    return tonumber(a.x) < tonumber(b.x) + 96 and 
           tonumber(a.x) + 96 > tonumber(b.x) and
       
           tonumber(a.y) < tonumber(b.y) + 96 and
           tonumber(a.y) + 96 > tonumber(b.y)

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

    for i = 1, v_tiles, 1 do
        for j = left_corner, h_tiles, 1 do
            if (mapa[i][j] == "C") then
                love.graphics.draw(sky, ((j-left_corner)*tile_height), ((i-1)*tile_width))
            elseif (mapa[i][j] == "G") then
                love.graphics.draw(grama, ((j-left_corner)*tile_height), ((i-1)*tile_width))
            elseif (mapa[i][j] == "P") then
                love.graphics.draw(stone, ((j-left_corner)*tile_height), ((i-1)*tile_width))
            end
        end
    end



    -- Array da party

    for n=1, #jogadores, 1 do
        infa = jogadores[n]
        love.graphics.draw(party[infa].sprite, party[infa].x, party[infa].y, 0, 1, 1, party[infa].sprite:getWidth()/2, party[infa].sprite:getHeight()/2)
    end


    --Array dos inimigos

    if #inimigos > 0 then

        for n=1, #inimigos, 1 do
            infa = inimigos[n]
            love.graphics.draw(inimigo[infa].sprite, inimigo[infa].x, inimigo[infa].y, 0, 1, 1, inimigo[infa].sprite:getWidth()/2, inimigo[infa].sprite:getHeight()/2)
        end

    end


    --Desenha item

    if #itens > 0 then

        for n=1, #itens, 1 do

            ite = itens[n]

            love.graphics.setColor(1,1,1)
            love.graphics.draw(item[ite].sprite, item[ite].x, item[ite].y)

        end

    end




    if a > 0 then

        for u=1, a ,1 do

            drawtiro(u)

        end

    end

    
    --Gera Personagem

        love.graphics.draw(player.sprite, player.x, player.y, math.rad(0), 1, 1, player.sprite:getWidth()/2, player.sprite:getHeight()/2)



    --Executa

        love.graphics.pop()


    --HUDs

     --Barras de status

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 10, 10, 276, 70, 6, 6)


      --Barra de vida
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 35, 15, 246, 17, 2)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", brx_v, bry_v, (tamanho_v*81), braltura_v, board_v, board_v)


      --Barra de Escudo
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 35, 36, 246, 17, 2)

        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", brx_d, bry_d+21, (tamanho_d*48.6), braltura_d, board_d, board_d)


      --Barra de stamina
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 35, 57, 246, 17, 2)

        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", brx_s, bry_s+42, tamanho_s, braltura_s, board_s, board_s)




     --Slot de arma

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 50, 800, 150, 150, 6, 6)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 54, 804, 142, 142, 6, 6)




     --Slots de itens

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 1420, 10, 480, 86, 6, 6)

        love.graphics.setColor(0, 0, 0)

      --Slot 1  
        love.graphics.rectangle("fill", 1423, 13, 80, 80, 6, 6)
     
      --Slot 2    
        love.graphics.rectangle("fill", 1506, 13, 80, 80, 6, 6)

      --Slot 3
        love.graphics.rectangle("fill", 1589, 13, 80, 80, 6, 6)

      --Slot 4    
        love.graphics.rectangle("fill", 1672, 13, 80, 80, 6, 6)

      --Slot 5 
        love.graphics.rectangle("fill", 1755, 13, 80, 80, 6, 6)






      --Reseta cores
        love.graphics.setColor(1,1,1)

    end



end

nvx = 0
nvy = 0
