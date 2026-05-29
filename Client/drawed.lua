

--Gera Cenário e parte da colisão do Cenário


local drawed = {}


function drawed.draw(coli ,calcada, rua, rua_esq, rua_c, rua_b, gramagrande, mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (mapa[i][j] == "X") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})



                love.graphics.draw(coli, (j*tile_height), (i*tile_width))
            elseif (mapa[i][j] == "E") then
                love.graphics.draw(rua, (j*tile_height), (i*tile_width))
            
            elseif (mapa[i][j] == "D") then
                love.graphics.draw(rua_esq, (j*tile_height), (i*tile_width))
            
            elseif (mapa[i][j] == "T") then
                love.graphics.draw(rua_c, (j*tile_height), (i*tile_width))
            
            elseif (mapa[i][j] == "B") then
                love.graphics.draw(rua_b, (j*tile_height), (i*tile_width))
            
            
            elseif (mapa[i][j] == "C") then           
                love.graphics.draw(calcada, (j*tile_height), (i*tile_width))            


            elseif (mapa[i][j] == "G") then           
                love.graphics.draw(gramagrande, (j*tile_height), (i*tile_width))
            
            end
        end
    end

    return was_draw

end



function drawed.draw_soft(noth, parede, soft, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (soft[i][j] == "T") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 32,
                h = 32})



                love.graphics.draw(parede, (j*tile_height), (i*tile_width))
            elseif (soft[i][j] == "G") then
                love.graphics.draw(noth, (j*tile_height), (i*tile_width))
            elseif (soft[i][j] == "P") then
                love.graphics.draw(stone, (j*tile_height), (i*tile_width))
            end
        end
    end

    return was_draw

end


function drawed.draw_brut_enf(noth, ponto_onibus, muro, grade, enf_brut, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (enf_brut[i][j] == "P") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})



                love.graphics.draw(ponto_onibus, (j*tile_height), (i*tile_width))
            
            elseif (enf_brut[i][j] == "N") then
                love.graphics.draw(noth, (j*tile_height), (i*tile_width))
    



            elseif (enf_brut[i][j] == "M") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 10})

                            
                love.graphics.draw(muro, (j*tile_height), (i*tile_width))
    


            elseif (enf_brut[i][j] == "G") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 10})

                            
                love.graphics.draw(grade, (j*tile_height), (i*tile_width))





            end
        end
    end

    return was_draw

end




return drawed
