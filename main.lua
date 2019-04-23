LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEORO = 12

aviao_14bis = {
	src = "imagens/14bis.png",
	largura = 55,
	altura = 63,
	x = LARGURA_TELA/2 - 64/2,
	y = ALTURA_TELA - 64/2
}


function destroiAviao()
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

meteoros = {}


function removeMeteoros()
	for i = #meteoros, 1, -1 do
		if(meteoros[i].y > ALTURA_TELA) then
			table.remove(meteoros,i)
		end
	end
end

function criaMeteoro()

	meteoro = { 
	 x = math.random(320),
	 y = -70,
	 largura = 50,
	 altura = 44,
	 peso = math.random(3),
	 deslocamento = math.random(-1,1)
	}
	table.insert(meteoros, meteoro)

end


function moveMeteoros()

for k,meteoro in pairs(meteoros) do
		meteoro.y = meteoro.y + meteoro.peso
		meteoro.x = meteoro.x + meteoro.deslocamento
    end

end

function move14bis()

if love.keyboard.isDown('w') then
	aviao_14bis.y = aviao_14bis.y - 1
end

if love.keyboard.isDown('s') then
	aviao_14bis.y = aviao_14bis.y + 1
end

if love.keyboard.isDown('a') then
	aviao_14bis.x = aviao_14bis.x - 1
end

if love.keyboard.isDown('d') then
	aviao_14bis.x = aviao_14bis.x + 1
end
	-- body
end



function  checaColisoes()
	for k,meteoro in pairs(meteoros) do
		if temColisao(meteoro.x, meteoro.y, meteoro.largura, meteoro.altura, aviao_14bis.x, aviao_14bis.y, aviao_14bis.largura, aviao_14bis.altura) then
    		destroiAviao()
    		FIM_JOGO = true
    	end

    end
end


-- Load some default values for our rectangle.
function love.load()
	love.window.setMode(LARGURA_TELA,ALTURA_TELA , {resizable = false})
	love.window.setTitle("14Bis vs Meteoros")
    
    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    aviao_14bis.imagem = love.graphics.newImage(aviao_14bis.src)
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)

	if not FIM_JOGO then
		if love.keyboard.isDown('w','s','a','d') then
			move14bis()
		end

		removeMeteoros()

		if #meteoros < MAX_METEORO then
			criaMeteoro()
		end
		moveMeteoros()
		checaColisoes()
	end
end
 
function love.draw()
	love.graphics.draw(background,0,0)
	love.graphics.draw(aviao_14bis.imagem,aviao_14bis.x,aviao_14bis.y)
	
	for k,meteoro in pairs(meteoros) do
		love.graphics.draw(meteoro_img,meteoro.x,meteoro.y)
    end
end