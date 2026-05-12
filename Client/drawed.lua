

--Gera Cenário e colisão do Cenário


local drawed = {}


function drawed.draw(grama, mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (mapa[i][j] == "T") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})



                love.graphics.draw(coli, (j*tile_height), (i*tile_width))
            elseif (mapa[i][j] == "G") then
                love.graphics.draw(grama, (j*tile_height), (i*tile_width))
            elseif (mapa[i][j] == "P") then
                love.graphics.draw(stone, (j*tile_height), (i*tile_width))
            end
        end
    end

    return was_draw

end






return drawed
