
local enet = require("enet")
--Cria Servidor
local host = enet.host_create("*:6789")



--Messager envios de dados (Servidor --> Peer)

function messager(peer, sentido, x, y, speed, id)
    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    peer:send(msg, 0, "unreliable")
    host:flush()

end



-- Envio de dados (Servidor --> Clientes) *(Do que é gerado no servidor)

function messager_all(sentido, x, y, speed, id)
    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    for n=1, np, 1 do
        peer = ids[n]

        peer:send(msg, 0, "unreliable")
        host:flush()

    end
    
end



-- Envio de dados (Peer --> Servidor --> Clientes)

function messager_all_minus(fonte, sentido, x, y, speed, id)
    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    for n=1, np, 1 do
        peer = ids[n]

        if peer ~= fonte then 

            peer:send(msg, 0, "unreliable")
            host:flush()

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

  --Indexador dos inimigos
    i = 0
    x = 0
    y = 0

  --Time step para uso do servidor
    ruler = 0


end




--Processos por Frame

function love.update(dt)

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

            end


        elseif event.type == "disconnect" then
            print(event.peer.." caiu mermão")
        end


     --Envia Dados do jogador ao Server

                    --Limita a cerca de 24+ envios por segundo
        if timer >= 0.042 and id ~= 0 then

            messager_all_minus(event.peer, "loadp", t[2], t[3], t[1], id)
            timer = 0

            print("mandei")

        end


        
    end



--Spawn 

 
    
    if love.keyboard.isDown("n") and ruler >= 0.75 then

        i = i + 1
        x = x + 50
        y = y + 10 




    --Cria Inimigos

        inimigo[i] = {}
        inimigo[i].x = x
        inimigo[i].y = y
        inimigo[i].position = ""
        inimigo[i].tipo = ""
        inimigo[i].vida = 0

        print("Criado" ..i)

        messager_all("newi", x, y, 0, i)

        ruler = 0


    end


    
  --Envia dados dos inimigos

   --Se tem inimigo
    if i > 0 then

        if timer_i >= 0.042 then

            for v=1, i, 1 do
                --Desloca o inimigo
                inimigo[v].x = inimigo[v].x + 10

                messager_all("loadi", inimigo[v].x, inimigo[v].y, 0, v)
                print(v.." no x: "..inimigo[v].x)

                timer_i = 0

            end

        end

    end


end
