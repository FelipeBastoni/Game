

--Verifica colisão do Cenário


local colide = {}


function checkC(a, b)

    return tonumber(a.x) + (tonumber(a.w)/3) < tonumber(b.x) + tonumber(b.w) and 
           tonumber(a.x) + tonumber(a.w) > tonumber(b.x) and
       
           tonumber(a.y) < tonumber(b.y) + tonumber(b.h) and
           tonumber(a.y) + tonumber(a.h) + 6 > tonumber(b.y)
end


function colide.collision_map(array, player)

    for j=1, #array, 1 do
                
        if checkC(player, array) == true then
            player.x = nvx
        end

        if checkC(player, array) then
            player.y = nvy
        end

    end

end




return colide