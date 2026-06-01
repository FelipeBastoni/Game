

--Gera Cenário e parte da colisão do Cenário


local drawed = {}


function drawed.draw(mapa, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (mapa[i][j] == "X") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})

            elseif (mapa[i][j] == "M") then           
                
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})


            elseif (mapa[i][j] == "m") then           
                
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})


            elseif (mapa[i][j] == "P") then           
                
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})



            end
        end
    end

    return was_draw

end



function drawed.draw_soft(soft, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (soft[i][j] == "T") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 32,
                h = 32})

            end
        end
    end

    return was_draw

end


function drawed.draw_brut_enf(enf_brut, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do
            if (enf_brut[i][j] == "O") then


                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 192})


            elseif (enf_brut[i][j] == "M") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 10})


            elseif (enf_brut[i][j] == "G") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 10})

            elseif (enf_brut[i][j] == "P") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 10})

            elseif (enf_brut[i][j] == "D") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = i*tile_height,
                w = 192,
                h = 10})


            end
        end
    end

    return was_draw

end


function drawed.draw_brut_atr(enf_atr, v_tiles, h_tiles, tile_width, tile_height, left_corner, conversor)

    for i = 1, v_tiles, 1 do
        for j = 1, h_tiles, 1 do

            if (enf_atr[i][j] == "G") then
            
                table.insert(co_mun, {

                x = j*tile_width,
                y = 0,
                w = 192,
                h = 192*2})

            end

        end

    end

    return was_draw

end

return drawed
