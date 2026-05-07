

--Gera Cenário e colisão do Cenário


local drawed = {}


function drawed.draw(grama, mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner)

    for i = 1, v_tiles, 1 do
        for j = left_corner, h_tiles, 1 do
            if (mapa[i][j] == "T") then


                table.insert(co_mun, {

                x = (j-left_corner)*tile_height,
                y = (i-1)*tile_width})



                love.graphics.draw(grama, ((j-left_corner)*tile_height), ((i-1)*tile_width))
            elseif (mapa[i][j] == "G") then
                love.graphics.draw(grama, ((j-left_corner)*tile_height), ((i-1)*tile_width))
            elseif (mapa[i][j] == "P") then
                love.graphics.draw(stone, ((j-left_corner)*tile_height), ((i-1)*tile_width))
            end
        end
    end

    return was_draw

end






return drawed