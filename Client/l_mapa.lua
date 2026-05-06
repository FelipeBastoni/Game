
local l_mapa = {}


mapa = {}

--Numero de imagens (tiles) na horizontal
local h_tiles       

--Numero de imagens (tiles) na vertical
local v_tiles      


--Função para carregar o mapa

function l_mapa.LoadMap(filename)       -- Carrega o arquivo com o mapa de padrões
  local file = io.open(filename) -- Abre o arquivo 
  local i = 1                    -- Prepara para carregar a 1a. linha
  for line in file:lines() do    -- Para cada linha do arquivo do Mapa
    mapa[i] = {}                 -- Cria um vetor horizontal para uma linha
    for j = 1, #line, 1 do       -- Carrega a linha
      mapa[i][j] = line:sub(j,j) -- Carrega cada elemento da linha
    end
    i = i + 1                    -- Passa para a próxima linha
    h_tiles = #line  -- determina o número de padrões na horizontal
    v_tiles = i - 1  -- determina o número de padrões na vertical
    -- determina o número de padrões visíveis
  end
  file:close()   -- Fecha o arquivo

  return mapa, h_tiles, v_tiles

end

return l_mapa

