
local enet = require("enet")

--Cria Servidor
local host = enet.host_create("*:6789")






--Messager (envios de dados Servidor --> Cliente)

function messager(peer, sentido, x, y, speed)

    local msg = ""..sentido..";"..x..";"..y..";"..speed..";"

    peer:send(msg)

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

en = {}
en.x = 0
en.y = 0
en.s = 0

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
                    
                print("conectado")


     --Se recebeu resposta
            
            elseif event.type == "receive" then
                print(event.data)
            
                --Extrai os dados
                t = {}
                update(event.data)


            end
        
        end



     --Calcula as Movimentações


        if t[1] == "w" then 

            en.x = t[2]
            en.y = t[3]

            messager(event.peer,"en", en.x,en.y,en.s)

        end


        if t[1] == "s" then 

            en.x = t[2]
            en.y = t[3]

            messager(event.peer,"en", en.x,en.y,en.s)

        end



        if t[1] == "a" then 

            en.x = t[2]
            en.y = t[3]

            messager(event.peer,"en", en.x,en.y,en.s)

        end



        if t[1] == "d" then 

            en.x = t[2]
            en.y = t[3]

            messager(event.peer,"en", en.x,en.y,en.s)

        end


    end



end

