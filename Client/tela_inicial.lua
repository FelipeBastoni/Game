
local tela_inicial = {}

--Chama a tela inicial

function tela_inicial.initial(alfa)

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

    return tela_inical

end



function tela_inicial.anim(dt, alfa, cut_timer)

    local runner = false

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

    return alfa, cut_timer, runner

end






--Limpa a tela inicial

function tela_inicial.start()
    love.graphics.clear(0, 0, 0)
    return tela_inical
end


return tela_inicial
