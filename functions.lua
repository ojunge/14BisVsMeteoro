function geraImagensAudios()

    -- Imagens do jogo
    background = love.graphics.newImage("imagens/background.png")
    gameover_img = love.graphics.newImage("imagens/gameover.png")
    vencedor_img = love.graphics.newImage("imagens/vencedor.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img = love.graphics.newImage("imagens/tiro.png")

    -- Audios 
    destruicao = love.audio.newSource("audios/destruicao.wav", "static")
    game_over = love.audio.newSource("audios/game_over.wav", "static")
    vencedor_som = love.audio.newSource("audios/winner.wav", "static")
    disparo = love.audio.newSource("audios/disparo.wav", "static")

    musica_ambiente = love.audio.newSource("audios/ambiente.wav", "static")
    musica_ambiente:setLooping(true)
    musica_ambiente:play()

end

function daTiro()
    disparo:play()
    local tiro = {
        x = aviao_14bis.x + aviao_14bis.largura/2,
        y = aviao_14bis.y,
        largura = 16,
        altura = 16
    }
    table.insert(aviao_14bis.tiros, tiro)
end

function moveTiros()
    for i = #aviao_14bis.tiros, 1, -1 do
        if aviao_14bis.tiros[i].y > 0 then
            aviao_14bis.tiros[i].y = aviao_14bis.tiros[i].y - 1
        else
            table.remove(aviao_14bis.tiros, i)
        end
    end
end

function destroiAviao()
    destruicao:play()

    aviao_14bis.src = "imagens/explosao_nave.png"
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
    aviao_14bis.largura = 67
    aviao_14bis.altura = 77
end

function temColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return X2 < X1 + L1 and
           X1 < X2 + L2 and
           Y1 < Y2 + A2 and
           Y2 < Y1 + A1
end

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if meteoros[i].y > ALTURA_TELA then
            table.remove(meteoros, i)
        end
    end
end

function criaMeteoro()
    meteoro = {
        x = math.random(LARGURA_TELA),
        y = -70,
        largura = 50,
        altura = 44,
        peso = math.random(PESO),
        deslocamento_horizontal = math.random(-1, 1)
    }
    table.insert(meteoros, meteoro)
end

function moveMeteoros()
    for k, meteoro in pairs(meteoros) do
        meteoro.y = meteoro.y + meteoro.peso
        meteoro.x = meteoro.x + meteoro.deslocamento_horizontal
    end
end

function move14bis()
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        aviao_14bis.y = aviao_14bis.y - 1
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        aviao_14bis.y = aviao_14bis.y + 1
    end
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        aviao_14bis.x = aviao_14bis.x - 1
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        aviao_14bis.x = aviao_14bis.x + 1
    end
end

function trocaMusicaDeFundo()
    musica_ambiente:stop()
    game_over:play()
end

function checaColisaoComAviao()
    for k, meteoro in pairs(meteoros) do
        if temColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, 
                        aviao_14bis.x, aviao_14bis.y, aviao_14bis.largura, aviao_14bis.altura) then
            trocaMusicaDeFundo()
            destroiAviao()
            FIM_JOGO = true
        end
    end
end


-------- Funções de checagem ----------------------------

function checaColisaoComTiros()
    for i = #aviao_14bis.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            if temColisao(aviao_14bis.tiros[i].x, aviao_14bis.tiros[i].y, aviao_14bis.tiros[i].largura, aviao_14bis.tiros[i].altura, 
                            meteoros[j].x, meteoros[j].y, meteoros[j].largura, meteoros[j].altura) then
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
                table.remove(aviao_14bis.tiros, i)
                table.remove(meteoros, j)
                break
            end
        end
    end
end

function checaColisoes()
    checaColisaoComAviao()
    checaColisaoComTiros()
end

function checaObjetivoConcluido()
    if METEOROS_ATINGIDOS >= NUMERO_METEOROS_OBJETIVO then
        VENCEDOR = true
        musica_ambiente:stop()
        vencedor_som:play()
    end
end