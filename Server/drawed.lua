

--Gera Cenário e parte da colisão do Cenário


local drawed = {}


function drawed.draw(mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (mapa[i][j] == "T") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})



            elseif (mapa[i][j] == "G") then
            elseif (mapa[i][j] == "P") then
            end
        end
    end

    return was_draw

end



function drawed.draw_soft(soft, v_tiles, h_tiles, tile_width, tile_height, left_corner)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (soft[i][j] == "T") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 32,
                h = 32})



            elseif (soft[i][j] == "G") then
            elseif (soft[i][j] == "P") then
            end
        end
    end

    return was_draw

end






return drawed