require "variables";
require "functions";

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, {resizable = false})
    love.window.setTitle(TITLE..NUMERO_METEOROS_OBJETIVO.."")

    math.randomseed(os.time())
    geraImagensAudios();
   
end

function love.update(dt)
    if not FIM_JOGO and not VENCEDOR then
        if love.keyboard.isDown('w', 'a', 's', 'd','up','down','right','left') then
            move14bis()
        end

        removeMeteoros()
        if #meteoros < MAX_METEOROS then
            criaMeteoro()
        end
        moveMeteoros()
        moveTiros()
        checaColisoes()
        checaObjetivoConcluido()
    end
end

function love.keypressed(tecla)
    if tecla == "escape" then 
    	love.event.quit()
    elseif tecla == "space" then 
    	daTiro()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(aviao_14bis.imagem, aviao_14bis.x, aviao_14bis.y)
    love.graphics.print("Meteoros restantes "..NUMERO_METEOROS_OBJETIVO - METEOROS_ATINGIDOS, 0, 0)
    
    for k, meteoro in pairs(meteoros) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y) 
    end

    for k, tiro in pairs(aviao_14bis.tiros) do
        love.graphics.draw(tiro_img, tiro.x, tiro.y) 
    end

    if FIM_JOGO then
        love.graphics.draw(gameover_img, LARGURA_TELA/2 - gameover_img:getWidth()/2, 
            ALTURA_TELA/2 - gameover_img:getHeight()/2) 
    end

    if VENCEDOR then
        love.graphics.draw(vencedor_img, LARGURA_TELA/2 - vencedor_img:getWidth()/2, 
            ALTURA_TELA/2 - vencedor_img:getHeight()/2) 
    end
end