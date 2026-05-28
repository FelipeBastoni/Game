local drawed = require("drawed")
local l_mapa = require("l_mapa")


local enet = require("enet")
--Cria Servidor
local host = enet.host_create("*:6789")



--Messager envios de dados (Servidor --> Peer)

function messager(peer, sentido, x, y, speed, id)
    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    peer:send(msg, 0, "unreliable")

end



-- Envio de dados (Servidor --> Clientes) *(Do que é gerado no servidor)

function messager_all(sentido, x, y, speed, id)
    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    for n=1, np, 1 do
        peer = ids[n]

        peer:send(msg, 0, "unreliable")

    end
    
end



-- Envio de dados (Peer --> Servidor --> Clientes)

function messager_all_minus(fonte, sentido, x, y, speed, id)
    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    for n=1, np, 1 do
        peer = ids[n]

        if peer ~= fonte then 

            peer:send(msg, 0, "unreliable")

        end

    end

end



--Captador de resposta

function update(xt)
    for item in string.gmatch(xt, "([^;]+)") do
        table.insert(t, item)
    end
end






function love.load()

 --Operadores

  --Contabilizador de conexões
    np = 0

  --Definidor de ID
    id = 0

  --Array dos ID's
    ids = {}

  --Timer para envio de pacotes
    timer = 0

  --Timer para envio de pacotes dos inimigos
    timer_i = 0

  --Array de dados recebidos
    t = {}

  --Array dos inimigos
    inimigo = {}

  --Array da Party
    party = {}
    party[np] = {}
    party[np].x = 0
    party[np].y = 0
    party[np].vida = 0
    party[np].id = np


  --Array dos inimigos
    item = {}

  --Indexador dos inimigos
    i = 0
    x = 0
    y = 0

  --Indexador de item
    it = 0

  --Time step para uso do servidor
    ruler = 0



    tempo = 0
    vezes = 0



 --Variáveis do cenário

  --Array para procesamento do mapa
    mapa = {}
    soft = {}

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

  --Ponto esquerdo do cenário que será apresentado
    left_corner = 1 

  --Array de colisões do mapa
    co_mun = {}

 --Carrega o Cenário
    mapa, h_tiles, v_tiles = l_mapa.LoadMap("mapa.txt") 

    soft, sh_tiles, sv_tiles = l_mapa.Loadsoft("soft.txt")

end



--Processos por Frame
function love.update(dt)

 
--Gera Cenário e colisão

    drawed.draw(mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner)


--Gera cenário "Soft" e colisão

    drawed.draw_soft(soft, sv_tiles, sh_tiles, 32, 32, left_corner)



--Verifica a colisão

    if #inimigo > 0 then

        for j=1, #co_mun, 1 do

            v_colisao_a = co_mun[j]

            for r=1, #inimigo, 1 do

                if checkCollision(inimigo[r], v_colisao_a) then

                    inimigo[r].x = nvx

                end

                if checkCollision(inimigo[r], v_colisao_a) then

                    inimigo[r].y = nvy

                end

            end

        end


        for t=1, #inimigo, 1 do
            for y=t+1, #inimigo, 1 do

                if checkCollision(inimigo[t], inimigo[y]) then

                    inimigo[t].x = inimigo[t].x + (inimigo[t].x - nvx) * dt

                end

                if checkCollision(inimigo[t], inimigo[y]) then

                    inimigo[t].y = inimigo[t].y + (inimigo[t].y - nvy) * dt

                end

            end

        end

        
    end


    timer = timer + dt
    ruler = ruler + dt
    timer_i = timer_i + dt

 --Roda mais de uma requisição por Frame

    while true do 

        local event = host:service(0)
        if not event then break end


     --Tendo resposta do servidor

        if event then

          --Checa conexão

            if event.type == "connect" then
                    
                print("conectado", event.peer)

            --Atualiza número de Conexões
                np = np + 1

                party[np] = {}
                party[np].x = 0
                party[np].y = 0
                party[np].vida = 0
                party[np].status = "vivo"
                party[np].id = np

            --Notifica peer para criar jogador (seu próprio)
                messager(event.peer, "log", 0, 0, 0, np)                

            --Inclui IP na lista
                table.insert(ids, event.peer)
        
            --Notifica ao peer todos os jogadores que ele precisa criar (outros jogadores)
                for n=1, (np-1), 1 do
                    messager(event.peer, "logp", 0, 0, 0, n)
                end
                
            --Notifica aos clientes já logados que precisa criar novo jogador (nova conexão)

                messager_all_minus(event.peer, "newp", 0, 0, 0, np)
            

     --Se recebeu resposta
            
            elseif event.type == "receive" then
            
              --Resseta Array de dados recebidos
                t = {}

              --Extrai os dados
                update(event.data)

              --Pega o ID da conexão
                id = tonumber(t[5])

                if t[1] == "at_ini" then

                    inimigo[id].vida = inimigo[id].vida - t[2]
                    print("A vida foi para" ..inimigo[id].vida)

                    if inimigo[id].vida <= 0 then

                        inimigo[id].status = "morto"

                    end

                    break

                end


                if t[1] == "death" then

                    party[id].status = "morto"

                end


                if #party > 0 then

                    party[id].x = t[2]
                    party[id].y = t[3]

                end

            end


        elseif event.type == "disconnect" then
            print(event.peer.." caiu mermão")
        end


     --Envia Dados do jogador ao Server

                    --Limita a cerca de 24+ envios por segundo
        if timer >= 0.042 and id ~= 0 then
            messager_all_minus(event.peer, "loadp", t[2], t[3], t[1], id)
            timer = 0

        end


        
    end



--Spawn 

  --Inimigos
    
    if love.keyboard.isDown("n") and ruler >= 0.75 then

        i = i + 1

    --Cria Inimigos

        inimigo[i] = {}
        inimigo[i].x = x
        inimigo[i].y = y
        inimigo[i].w = 145
        inimigo[i].h = 174
        inimigo[i].status = "vivo"
        inimigo[i].position = ""
        inimigo[i].tipo = ""
        inimigo[i].vida = 100
        inimigo[i].segue = sorteia()

        print("Criado" ..i)

        messager_all("newi", x, y, inimigo[i].status, i)

        ruler = 0


    end
    
  --Envia dados dos inimigos

   --Se tem inimigo
    if i > 0 then

        tempo = tempo + dt


        if timer_i >= 0.042 then

            for v=1, i, 1 do

                    -- Inteligência dos inimigos

                    -- posição para colisão

                    nvx = inimigo[v].x
                    nvy = inimigo[v].y

                    alvo = inimigo[v].segue

                    if party[alvo] then

                    dx = party[alvo].x - inimigo[v].x + 64
                    dy = party[alvo].y - inimigo[v].y + 64

                    dist = math.sqrt(dx*dx + dy*dy)

                        if dist > 0 then

                            dx = dx / dist
                            dy = dy / dist

                            inimigo[v].x = inimigo[v].x + dx * 450 * dt
                            inimigo[v].y = inimigo[v].y + dy * 450 * dt

                        end

                    end



                    inimigo[v].x = inimigo[v].x

                    messager_all("loadi", inimigo[v].x, inimigo[v].y, inimigo[v].status, v)

                    timer_i = 0

                    host:flush()


            end

        end










    end










  --Cria item
      
  
    if love.keyboard.isDown("i") and ruler >= 0.75 then

        it = it + 1

        item[it] = {}
        item[it].x = 150 * it
        item[it].y = 100
        item[it].tipo = "vida"
        item[it].id = it

        print("Cridado Item " ..it)

        messager_all("newu", item[it].x, item[it].y, 0, it)

        ruler = 0

    end





end





function checkCollision(a, b)

    return tonumber(a.x) + (tonumber(a.w)/3) - 80 < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) + 75 and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) - 75 > tonumber(b.y)
end





function sorteia()
    n = #party
    sort = math.random(1, n)
    return sort
end


function love.draw()

    if #party > 0 then

        msg1 = tostring(party[id].id)
        msg2 = tostring(party[id].x)
        msg3 = tostring(party[id].y)

        msg = "ID:".. msg1 ..", X:".. msg2 ..", Y:".. msg3

        love.graphics.print(msg, 100, 50 * id)


    end


end
