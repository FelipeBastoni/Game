
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
en.s = ""

player1 = {}
player1.con = ""
player1.x = 0
player1.y = 0
player1.hp = 0




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


        if t[1] == en.s and en.s == "U" and t[2] == en.x and t[3] == en.y then
            messager(event.peer,"en", en.x,en.y,"PU")


        elseif t[1] == en.s and en.s == "S" and t[2] == en.x and t[3] == en.y then
            messager(event.peer,"en", en.x,en.y,"PS")


        elseif t[1] == en.s and en.s == "E" and t[2] == en.x and t[3] == en.y then
            messager(event.peer,"en", en.x,en.y,"PE")


        elseif t[1] == en.s and en.s == "D" and t[2] == en.x and t[3] == en.y then
            messager(event.peer,"en", en.x,en.y,"PD")

       

            
        elseif t[1] == "U" then 

            en.x = t[2]
            en.y = t[3]
            en.s = t[1]

            messager(event.peer,"en", en.x,en.y,en.s)

       

        elseif t[1] == "S" then 

            en.x = t[2]
            en.y = t[3]
            en.s = t[1]


            messager(event.peer,"en", en.x,en.y,en.s)

        



        elseif t[1] == "E" then 

            en.x = t[2]
            en.y = t[3]
            en.s = t[1]

            messager(event.peer,"en", en.x,en.y,en.s)

      



        elseif t[1] == "D" then 

            en.x = t[2]
            en.y = t[3]
            en.s = t[1]

            messager(event.peer,"en", en.x,en.y,en.s)

        end




    end



end
