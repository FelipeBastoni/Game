
local tela_inicial = {}

--Chama a tela inicial

function tela_inicial.initial(alfa, x, y)

  --Define o fundo
    fundo = love.graphics.newImage("telas/AAA.png")

  --Define a fonte

  --Printa o fundo

    love.graphics.setBackgroundColor(1, 0, 0.2)

    love.graphics.setColor(1, 1, 1, 1)

    fonte = love.graphics.newFont(75)
    love.graphics.setFont(fonte)

    titulo = "O QUE DEU NA TV"
    love.graphics.print(titulo, (x - love.graphics.getFont():getWidth(titulo))/2, (y/3))



    fonte = love.graphics.newFont(25)
    love.graphics.setFont(fonte)

    text = "PRESSIONE A TECLA ESPAÇO PARA JOGAR"
    love.graphics.setColor(1, 1, 1, alfa)
    love.graphics.print(text, (x - love.graphics.getFont():getWidth(text))/2, ((y/2)+(y/5)))

    love.graphics.setColor(1, 1, 1, 1)

    return tela_inical

end



function tela_inicial.anim(dt, alfa, cut_timer, x ,y)

    local runner = 0

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
        runner = 1
    end

    return alfa, cut_timer, runner

end






--Limpa a tela inicial

function tela_inicial.start()
    love.graphics.clear(0, 0, 0)
    return tela_inical
end


return tela_inicial
