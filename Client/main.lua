
local l_mapa = require("l_mapa")
local tela_inicial = require("tela_inicial")
local drawed = require("drawed")

--Configurações para conectar ao servidor

local enet = require("enet")

local host = enet.host_create()
local server = host:connect("127.0.0.1:6789")


function love.load()

 --sprites:

  --player

    p_default = {
        love.graphics.newImage("jogador/primeofc.png"), 
        love.graphics.newImage("jogador/primeofcesq.png"),
        love.graphics.newImage("jogador/primedownf.png"),
        love.graphics.newImage("jogador/primeup.png")

    }

    p_right = {
        love.graphics.newImage("jogador/primestp1.png"),
        love.graphics.newImage("jogador/primestp2.png")

    }

    p_left = {
        love.graphics.newImage("jogador/primestp1esq.png"),
        love.graphics.newImage("jogador/primestp2esq.png")
    
    }

    p_up = {
        love.graphics.newImage("jogador/primeupstep1.png"), 
        love.graphics.newImage("jogador/primeupstep2.png") 

    }

    p_down = {
        love.graphics.newImage("jogador/primedownstep1.png"), 
        love.graphics.newImage("jogador/primedownstep2.png"), 

    }


  --Imagens do Cenário

    calcada = love.graphics.newImage("cenario/calcada.png")
    coli = love.graphics.newImage("cenario/coli.png")
    rua = love.graphics.newImage("cenario/ruaed.png")
    rua_esq = love.graphics.newImage("cenario/ruaedesq.png")
    rua_b = love.graphics.newImage("cenario/ruaed_horb.png") 
    rua_c = love.graphics.newImage("cenario/ruaed_horc.png")
    gramagrande = love.graphics.newImage("cenario/gramagrande.png")




    --enfeite soft (32)

    noth = love.graphics.newImage("cenario/noth.png")
    parede = love.graphics.newImage("cenario/parede.png")
    

    --enfeite bruto (192)

    nada = love.graphics.newImage("cenario/nada.png")
    ponto_onibus = love.graphics.newImage("cenario/ponto_de_onibus.png")
    muro = love.graphics.newImage("cenario/muro.png")
    grade = love.graphics.newImage("cenario/grade.png")


    --icones

    vida = love.graphics.newImage("telas/vida.png")
    escudo = love.graphics.newImage("telas/escudo.png") 
    stamina = love.graphics.newImage("telas/stamina.png")
    invent = love.graphics.newImage("telas/inventario.png")


    glock = love.graphics.newImage("inimigos/glock.png") 
    tiro = love.graphics.newImage("inimigos/tiro.png")
    zumbi = love.graphics.newImage("inimigos/zumbi.png")



    damage_timer = 0



 --Array's

  --Array de colisões do mapa
    co_mun = {}

  --Array das conexões/clientes
    jogadores = {}

  --Array dos inimigos
    inimigos = {}

  --Array dos itens
    itens = {}

    

 --Indexadores

  --Definidor de ID das conexões/clientes
    id = 0 

  --Definidor de ID dos Inimigos
    idi = 0



 --Objetos

  --player

    player = {}
    player.x = 300
    player.y = 200
    player.w = 145
    player.h = 170
    player.speed = 1500  
    player.position = "D"
    player.sprite = p_default[1]
    player.alive = true


  --Party (outros jogadores)

    party = {}
    party[id] = {}
    party[id].x = 200
    party[id].y = 200
    party[id].status = 450
    party[id].position = ""
    party[id].sprite = p_default[3]
    party[id].id = id
  

  --Inimigos

    inimigo = {}
    inimigo[idi] = {}
    inimigo[idi].x = 200
    inimigo[idi].y = 200
    inimigo[idi].w = 96
    inimigo[idi].h = 96
    inimigo[idi].status = 450
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

  --Inventário

    inventario_arma = {}
    inventario_vida = {}


 --Executor do jogo
    runner = 0

 --Time step do envio de pacotes
    timer = 0



 --Variavés de Animações

  --Time step das animações
    step = 0

  --Posição do mouse
    mx = 0
    my = 0

  --Posição do personagem
    position = ""

  --Alfa da tela inicial
    alfa = 0.5

  --Timer da animação da tela incial
    cut_timer = 1



 --Colisão

  --Versor de movimento do player
    vx = 0
    vy = 0

  --Ultima posição confirmada
    nvx = 0
    nvy = 0



 --Tiros

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



 --Configuração da janela
    win_x, win_y = love.window.getDesktopDimensions()

 --Resolução/tamanho da tela
    love.window.setMode(win_x, win_y)



 --Variáveis do cenário

  --Array para procesamento do mapa
    mapa = {}
    soft = {}
    enf_brut = {}

  --Altura da imagem (tile)
    tile_height = 192

  --Largura da imagem (tile)
    tile_width  = 192 

  --Numero de imagens (tiles) na horizontal
    h_tiles = 0  
    sh_tiles = 0     

  --Numero de imagens (tiles) na vertical
    v_tiles = 0      
    sv_tiles = 0 


    brut_h_tiles = 0
    brut_v_tiles = 0


  --Ponto esquerdo do cenário que será apresentado
    left_corner = 1 



 --Carrega o Cenário
    mapa, h_tiles, v_tiles = l_mapa.LoadMap("mapa.txt") 

    enf_brut, brut_h_tiles, brut_v_tiles = l_mapa.LoadMapEnf("enf_brut.txt") 
    
    soft, sh_tiles, sv_tiles = l_mapa.Loadsoft("soft.txt")

end



--Função de conexão

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



--Função de processamento de pacote

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
        party[id].status = 0
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
        party[idp].status = 0
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
        party[idp].status = 0
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
        inimigo[idip].w = 96
        inimigo[idip].h = 96
        inimigo[idip].speed = "vivo"
        inimigo[idip].position = ""
        inimigo[idip].sprite = zumbi
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
        item[idip].w = 120
        item[idip].h = 120
        item[idip].tipo = "vida"
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
        party[idp].status = 0
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


  --Trata mote de amigo


    if t[1] == "death" then

        idp = tonumber(t[5])

        party[idp].x = t[2]
        party[idp].y = t[3]
        party[idp].status = 0
        party[idp].sprite = p_down[1]
        party[idp].position = t[4]
        party[idp].id = idp


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
                sprite = zumbi,
                id = idip
            }

        end

        inimigo[idip].x = t[2]
        inimigo[idip].y = t[3]
        inimigo[idip].status = t[4]
        inimigo[idip].position = ""
        inimigo[idip].sprite = zumbi
        inimigo[idip].id = idip

    end

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



--Processos por frame

function love.update(dt)
    
    conn()

    timer = timer + dt
    step = step + dt
    reg_timer = reg_timer + dt
    damage_timer = damage_timer + dt

    mira_x = (mx + player.x + player.w/2) - love.graphics.getWidth()/2
    mira_y = (my + player.y + player.w) - love.graphics.getHeight()/2

    mira_ang = math.atan2((mira_y - (player.y + player.h/2)), (mira_x - player.x))
    
    print(mira_ang)

    if mira_ang < 1.4 and mira_ang > -1.4 then
        glock = love.graphics.newImage("cenario/noth.png")
        
    end

    if mira_ang > 1.6 or mira_ang < -1.6 then
        glock = love.graphics.newImage("inimigos/glock2.png")
        mira_arma = mira_ang
    
    else
        glock = love.graphics.newImage("inimigos/glock.png")
        mira_arma = mira_ang
    
    end

    

  --Animação tela inicial

    if runner == 0 then
        alfa, cut_timer, runner = tela_inicial.anim(dt, alfa, cut_timer, win_x, win_y)
    end


    if player.alive then



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


        if mx > (win_x/2)+20 then
            player.position = "PD"
        else    
            player.position = "PE"
        end


        if mx >= (win_x/2)-(win_x/14) and mx <= (win_x/2)+(win_x/14) and my > (win_y/2)+(win_y/12)  then
            player.position = "PS"
        elseif mx >= (win_x/2)-(win_x/14) and mx <= (win_x/2)+(win_x/14) and my < (win_y/2)-(win_y/12)  then
            player.position = "PU"
        end



    --Teclado

    --Calcula posição do jogador de acordo com comando
        if love.keyboard.isDown("w") then        
            player.y = player.y - player.speed * dt
            player.sprite = p_up[1]

            vy = 1

            wait(p_up[2])

            player.position = "U"

        end

        if love.keyboard.isDown("s") then

            player.y = player.y + player.speed * dt
            player.sprite = p_down[1]
            vy = -1

            wait(p_down[2])

            player.position = "S"

        end

        if love.keyboard.isDown("a") then

            player.x = player.x - player.speed * dt
            player.sprite = p_left[1]
            vx = 1

            wait(p_left[2])

            player.position = "E"

        end

        if love.keyboard.isDown("d") then

            player.x = player.x + player.speed * dt
            player.sprite = p_right[1]
            vx = -1

            wait(p_right[2])

            player.position = "D"

        end



        function wait(sprite)

            if step > 0.25 then
                player.sprite = sprite

                if step > 0.5 then
                    step = 0
                end
            end
        end



    --Correr com Shift
        if love.keyboard.isDown("lshift") then

            player.speed = 2000
            braltura_s = 14
            brx_s = 36
            bry_s = 16
            board_s = 2

            if tamanho_s >= 1 then

                tamanho_s = tamanho_s - 1 
        
            else 

                player.speed = 1500
                braltura_s = 0
                brx_s = 0
                bry_s = 0
                board_s = 0

            end
        
        else 
            
            player.speed = 1500

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

        elseif tamanho_d == 1 then

            braltura_d = 14
            brx_d = 36
            bry_d = 16
            board_d = 2

        elseif tamanho_d == 0 then

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

            tx = mira_x
            ty = mira_y

            ger_tiro(tx, ty, mira_ang, a)

        end



    --Disparos

        function ger_tiro(tx, ty, mira_ang, a)

            shoot[a] = {}
            shoot[a].x = player.x + 100
            shoot[a].y = player.y + (player.h/2)
            shoot[a].w = 5
            shoot[a].h = 5
            shoot[a].ang = mira_ang
            shoot[a].id = a

            drawtiro(a)

        end

        function drawtiro(a)

            shoot[a].x = shoot[a].x + math.cos(shoot[a].ang) * 45
            shoot[a].y = shoot[a].y + math.sin(shoot[a].ang) * 45

            love.graphics.draw(tiro, shoot[a].x, shoot[a].y, shoot[a].ang, 1, 1, tiro:getWidth()/2, tiro:getHeight()/2)

        end



    --Envia Dados do jogador ao Server

                    --Limita a cerca de 24+ envios por segundo
        if timer >= 0.042 and id ~= 0 then
            messager(player.position, player.x, player.y, player.speed, id)
            timer = 0
        end



    end



    if runner == 2 then

        if player.x <= 1152 then

            player.x = 1152

        end

        if player.x >= 7680 then

            player.x = 7680

        end
        
        if player.y <= 590 then

            player.y = 590

        end

        if player.y >= 4416 then

            player.y = 4416

        end



        for j=1, #co_mun, 1 do
            
            v_colisao_a = co_mun[j]


            if win_x <= 1366 then    


                if checkCorr(player, v_colisao_a) == true then

                    player.x = nvx
                
                end

                if checkCorr(player, v_colisao_a) then

                    player.y = nvy

                end


            else 

                if checkCollision(player, v_colisao_a) == true then

                    player.x = nvx
                
                end

                if checkCollision(player, v_colisao_a) then

                    player.y = nvy

                end

            end

        end



        
    --Colisão

        if runner == 2 and #inimigo > 0 then

            for j=1, #inimigo, 1 do
                
                if inimigo[j].status == "vivo" then
                    
                    v_colisao_a = inimigo[j]

                    if checkCollision(player, v_colisao_a) == true then

                        player.x = nvx
                    
                    end

                    if checkCollision(player, v_colisao_a) then

                        player.y = nvy

                    end

                end


            end


    --Colisão do dano

            for j=1, #inimigo, 1 do
                
                if damage_timer >= 2 then

                    v_colisao_a = inimigo[j]

                    if checkDamage(player, v_colisao_a) then
                        
                        if player.alive then

                            if tamanho_d <= 0 then
                                tamanho_v = tamanho_v - 3
                                damage_timer = 0

                                if tamanho_v <= 0 then
                                    player.alive = false

                                    messager("death", 0, 0, 0, id)

                                end

                            end

                            if tamanho_d > 0 then
                                tamanho_d = tamanho_d - 5 
                                damage_timer = 0

                            end

                        end

                    end

                end

            end

            
            if #shoot > 0 and #inimigo > 0 then

                for r=1, #shoot, 1 do
                    for t=1, #inimigo, 1 do 

                        if checkTiro(inimigo[t], shoot[r]) then

                            
                            messager("at_ini",10,0,0, inimigo[t].id)
                            
                            
                            tamanho_s = 0



                        end

                    end            
                end

            end



        


        end

        nvx = player.x
        nvy = player.y



    --Checa interação com item


        
        if runner == 2 and #item > 0 then

            for pi=1, #item, 1 do
                
                v_colisao_a = item[pi]


                if checkItem(player, v_colisao_a) == true then
                    if checkItem(player, v_colisao_a) then

                        if love.keyboard.isDown("e") then 

                            if item[pi].tipo == "vida" and #inventario_vida < 5 then

                                table.insert(inventario_vida, item[pi])

                                print("pegou o item"..item[pi].id)            
                                

                            elseif item[pi].tipo == "arma" and #inventario_arma < 1 then
                            
                                table.insert(inventario_arma, item[pi])

                                print("pegou o item"..item[pi].id)            


                            end


                        end

                    end


                end

            end
        
            

        end


    end


    if runner == 3 then





    end


    if runner == 4 then





    end



    if runner == 5 then





    end







end



function checkCollision(a, b)

    return tonumber(a.x) + (tonumber(a.w)/3) < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) + 6 > tonumber(b.y)
end


function checkCorr(a, b)

    return tonumber(a.x) + (tonumber(a.w)/3) < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) + 40 and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) + 15 > tonumber(b.y) + 40
end


function checkItem(a, b)

    return tonumber(a.x) + tonumber(a.w/3) < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) > tonumber(b.y)
end


function checkDamage(a, b)

    return tonumber(a.x) + tonumber(a.w/3) < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) > tonumber(b.y)
end


function checkTiro(a, b)

    return tonumber(a.x) + tonumber(a.w/3) < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) > tonumber(b.y)
end




--Desenha na Tela:

function love.draw()

  --Lógica de exibição tela inicial ---> jogo
    if runner == 0 then
        tela_inicial.initial(alfa, win_x, win_y)
    end

    if runner == 1 then
        tela_inicial.start()
        runner = 2
    end


  --Jogo rodando

    if runner == 2 and player.alive == true then


    --Tamanho da tela

        local screenWidth = win_x
        local screenHeight = win_y


    --Camera

        love.graphics.push()
        love.graphics.translate(

            -(player.x + player.w/2) + screenWidth/ 2,
            -(player.y + player.w) + screenHeight / 2

        )

    



        if win_x <= 1366 then

            conversor = 0.75

        else

            conversor = 1

        end

    --Gera Cenário e colisão

        drawed.draw(coli ,calcada, rua, rua_esq, rua_c, rua_b, gramagrande, mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)


    --Gera cenário de enfeite bruto
    
        drawed.draw_brut_enf(nada, ponto_onibus, muro, grade, enf_brut, brut_v_tiles, brut_h_tiles, tile_width, tile_height, left_corner, conversor)


    --Gera cenário "Soft" e colisão

        drawed.draw_soft(noth, parede, soft, sv_tiles, sh_tiles, 32, 32, left_corner, conversor)

    
    

    -- Array da party

        for n=1, #jogadores, 1 do
            infa = jogadores[n]
            love.graphics.draw(party[infa].sprite, party[infa].x, party[infa].y, 0, conversor, conversor)
        end


    --Array dos inimigos

        if #inimigos > 0 then

            for n=1, #inimigos, 1 do

                if inimigo[n].status == "vivo" then
        
                    infa = inimigos[n]
                    love.graphics.draw(inimigo[infa].sprite, inimigo[infa].x, inimigo[infa].y, 0, conversor, conversor, inimigo[infa].sprite:getWidth()/2, inimigo[infa].sprite:getHeight()/2)
        
                end
            
            end

        end


    --Desenha item

        if #itens > 0 then

            for n=1, #itens, 1 do

                ite = itens[n]

                love.graphics.setColor(1,1,1)
                love.graphics.draw(item[ite].sprite, item[ite].x, item[ite].y, 0, conversor, conversor)

            end

        end



        if a > 0 then

            for u=1, a ,1 do
                drawtiro(u)
            end

        end




    --Gera Personagem

        love.graphics.draw(player.sprite, player.x, player.y)
        love.graphics.draw(glock, player.x+player.w-45, player.y+player.h-55, mira_arma)

    --Executa

        love.graphics.pop()


    --HUDs

        --Barras de status

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 10, 10, 276, 70, 6, 6)


        --Barra de vida
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(vida, 18, 16)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 35, 15, 246, 17, 2)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", brx_v, bry_v, (tamanho_v*81), braltura_v, board_v, board_v)


        --Barra de Escudo
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(escudo, 18, 37)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 35, 36, 246, 17, 2)

        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", brx_d, bry_d+21, (tamanho_d*48.6), braltura_d, board_d, board_d)


        --Barra de stamina
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(stamina, 18, 58)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 35, 57, 246, 17, 2)

        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", brx_s, bry_s+42, tamanho_s, braltura_s, board_s, board_s)



        --Slot de arma

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 50, win_y - 300, 150, 150, 6, 6)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 54, win_y - 296, 142, 142, 6, 6)



        --Slots de itens


        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", win_x - 500, 10, 480, 86, 6, 6)

        love.graphics.setColor(0, 0, 0)

        --Slot 1  
        love.graphics.rectangle("fill", win_x - 497, 13, 80, 80, 6, 6)
        
        --Slot 2    
        love.graphics.rectangle("fill", win_x - 414, 13, 80, 80, 6, 6)

        --Slot 3
        love.graphics.rectangle("fill", win_x - 331, 13, 80, 80, 6, 6)

        --Slot 4    
        love.graphics.rectangle("fill", win_x - 248, 13, 80, 80, 6, 6)

        --Slot 5 
        love.graphics.rectangle("fill", win_x - 165, 13, 80, 80, 6, 6)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(invent, win_x-70, 35)

        --Reseta cores
        love.graphics.setColor(1,1,1)


    end
    


    if player.alive == false then

        fundo = love.graphics.newImage("telas/AAA.png")

        love.graphics.draw(fundo)


    end






end
