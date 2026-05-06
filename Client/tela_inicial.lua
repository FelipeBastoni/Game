
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


--Limpa a tela inicial

function tela_inicial.start()
    love.graphics.clear(0, 0, 0)
    return tela_inical
end


return tela_inicial
