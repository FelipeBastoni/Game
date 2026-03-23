
local enet = require("enet")

--Cria Servidor
local host = enet.host_create("*:6789")






--Messager (envios de dados Servidor --> Cliente)

function messager(peer, sentido, x, y, speed, id)

    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    peer:send(msg)

end




-- Envio de dados Servidor --> Clientes

function messager_all(sentido, x, y, speed, id)

    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    for n=1, np, 1 do

        peer = ids[n]

        peer:send(msg)

    end
    
end




-- Envio de dados Cliente --> Servidor --> Clientes

function messager_all_minus(fonte, sentido, x, y, speed, id)

    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"..id..";"

    print("\n")

    print("fonte "..tostring(fonte))


    for n=1, np, 1 do

        peer = ids[n]

        if peer ~= fonte then 

            print("mandou para "..tostring(peer))

            peer:send(msg)

        end

    end

end







--Captador de resposta

local t = {}
function update(xt)


    for item in string.gmatch(xt, "([^;]+)") do
        table.insert(t, item)
    end


end






--Objetos 

function love.load()

    np = 0

    en = {}
    en.x = 0
    en.y = 0
    en.s = 0
    en.id = 0


    id = 0

    ids = {}

    en[np] = {}
    en[np].x = 0
    en[np].y = 0
    en[np].s = 0


end






--Processos por Frame

--Operadores

local timer = 0
function love.update(dt)


    timer = timer + dt


 --Roda mais de uma requisição por Frame

    while true do 

        local event = host:service(0)

        
        if not event then break end


     --Tendo resposta do servidor

        if event then

            --checa conexão

            if event.type == "connect" then
                    
                print("conectado", event.peer)

            --incrementa id

                np = np + 1

            --notifica cliente
                messager(event.peer, "log", 0, 0, 0, np)                



            --inclui objeto no servidor

                en[np] = {}

                en[np].x = 0
                en[np].y = 0
                en[np].s = 0
                en[np].id = np


            --inclui ip na lista

                table.insert(ids, event.peer)
        

                for n=1, (np-1), 1 do

                    messager(event.peer, "logp", 0, 0, 0, n)
                
                end
                


            -- novo jogador

                messager_all_minus(event.peer, "newp", 0, 0, 0, np)
            

     --Se recebeu resposta
            
            elseif event.type == "receive" then
               -- print(event.data)
            
                --Extrai os dados
                t = {}
                update(event.data)

                id = tonumber(t[5])

                messager_all_minus(event.peer, "loadp", t[2], t[3], t[1], id)


            end
        
        end







     --Calcula as Movimentações

        --define movimento
            
        --com id


        if t[1] == "U" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]


       

        elseif t[1] == "S" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]




        



        elseif t[1] == "E" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]



      



        elseif t[1] == "D" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]







        elseif t[1] == "PU" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]







        elseif t[1] == "PS" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]







        elseif t[1] == "PE" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]







        elseif t[1] == "PD" then 

            en[id].x = t[2]
            en[id].y = t[3]
            en[id].s = t[1]




        end


    end




end
