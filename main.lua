io.stdout:setvbuf('no')

require("nodes")
require("paths")
require("angles")
require("couleurs")

function love.load()
  
  love.window.setTitle("[space] Restart blue ball path - [r] Restart all paths - [p] Pause dot letter G path")
  
  Ecran = {}
  Ecran.largeur = love.graphics.getWidth()
  Ecran.hauteur = love.graphics.getHeight()
  Ecran.midX = Ecran.largeur / 2
  Ecran.midY = Ecran.hauteur / 2
  
  img1 = love.graphics.newImage("assets/duck.png")
  pathImg1 = paths.add(150, 150, 5)
  paths.setMode(pathImg1, "goAndBack")
  paths.addSegment(pathImg1, Ecran.midX, 200)
  paths.addSegment(pathImg1, Ecran.largeur - 150, 150)
  paths.addSegment(pathImg1, Ecran.largeur - 200, Ecran.midY)
  paths.addSegment(pathImg1, Ecran.largeur - 150, Ecran.hauteur - 150)
  paths.addSegment(pathImg1, Ecran.midX, Ecran.hauteur - 200)
  paths.addSegment(pathImg1, 150, Ecran.hauteur - 150)
  paths.addSegment(pathImg1, 200, Ecran.midY)
  paths.addSegment(pathImg1, 150, 150)
  
  img2 = love.graphics.newImage("assets/ball.png")
  pathImg2 = paths.add(250, 250, 5)
  paths.setMode(pathImg2, "oneTime")
  paths.addSegment(pathImg2, Ecran.largeur - 250, 250)
  paths.addSegment(pathImg2, 250, Ecran.hauteur - 250)
  paths.addSegment(pathImg2, Ecran.largeur - 250, Ecran.hauteur - 250)
  
  img3 = love.graphics.newImage("assets/tile.png")
  pathImg3 = paths.add(32, Ecran.midY, 5)
  paths.addSegment(pathImg3, Ecran.hauteur - 32, Ecran.midY)
  paths.addSegment(pathImg3, 32, Ecran.midY)
  
  nodeImg3 = nodes.add(32, Ecran.midY, 32, 32)
  local mapImg3X = 2
  local mapImg3Y = 2
  local mapImg3 = 
    { 
      {1,1,1},
      {1,1,1},
      {1,1,1}
    }
  for l=1,#mapImg3 do
    for c=1,#mapImg3[l] do
      if mapImg3[l][c] == 1 then
        nodes.nodeAddPosition(nodeImg3, c-mapImg3X, l-mapImg3Y)
      end
    end
  end
  
  img4 = love.graphics.newImage("assets/ship.png")
  pathImg4 = paths.add(Ecran.midX, 20, 5)
  paths.addSegment(pathImg4, Ecran.midX, Ecran.hauteur - 20)
  paths.addSegment(pathImg4, Ecran.midX, 20)
  
  nodeImg4 = nodes.add(Ecran.midX, 20, 20, 20)
  local mapImg4X = 4
  local mapImg4Y = 3
  local mapImg4 = 
    { 
      {1,1,1,1,1,1,1},
      {1,0,0,0,0,0,1},
      {1,0,1,0,1,0,1},
      {1,0,0,0,0,0,1},
      {1,1,1,1,1,1,1}
    }
  for l=1,#mapImg4 do
    for c=1,#mapImg4[l] do
      if mapImg4[l][c] == 1 then
        nodes.nodeAddPosition(nodeImg4, c-mapImg4X, l-mapImg4Y)
      end
    end
  end
  
  pathLettreG = paths.add(50, 50, 2)
  paths.addSegment(pathLettreG, Ecran.largeur - 50, 50)
  paths.addSegment(pathLettreG, Ecran.largeur - 50, Ecran.hauteur - 50)
  paths.addSegment(pathLettreG, 50, Ecran.hauteur - 50)
  paths.addSegment(pathLettreG, 50, 50)
  
  lettreG = nodes.add(20, 20, 16, 16)
  local mapGX = 3
  local mapGY = 3
  local mapG = 
    { --   3
      {1,1,1,1,1},
      {1,0,0,0,0},
      {1,0,0,1,1}, -- 3
      {1,0,0,0,1},
      {1,1,1,1,1}
    }
  for l=1,5 do
    for c=1,5 do
      if mapG[l][c] == 1 then
        nodes.nodeAddPosition(lettreG, c-mapGX, l-mapGY)
      end
    end
  end
end

function love.update(dt)
  for i=1,#nodes.liste do
    local node = nodes.liste[i]
    node.angle = node.angle + Angle45 * dt
    if node.angle > Angle360 then
      node.angle = 0
    end
  end
  
  paths.updateTimer(pathLettreG, dt)
  paths.updateTimer(pathImg1, dt)
  paths.updateTimer(pathImg2, dt)
  paths.updateTimer(pathImg3, dt)
  paths.updateTimer(pathImg4, dt)
 
  lettreG.x, lettreG.y = paths.getPosition(pathLettreG)
  nodeImg3.x, nodeImg3.y = paths.getPosition(pathImg3)
  nodeImg4.x, nodeImg4.y = paths.getPosition(pathImg4)
 
  nodes.update()
end

function love.draw()
  
  local X,Y,A = paths.getPosition(pathImg1)
  for i=1,nodeImg4.count do
    local pX,pY = nodes.GetPosition(nodeImg4,i)
    love.graphics.draw(img4, pX, pY, Angle180 - math.atan2(X - pX, Y - pY), 1, 1, 12, 9)
  end
  
  for i=1,nodeImg3.count do
    local pX,pY = nodes.GetPosition(nodeImg3,i)
    love.graphics.draw(img3, pX, pY, Angle90 - nodeImg3.angle, 0.5, 0.5, 32, 32)
  end
  love.graphics.setColor(colors.blue)
  for i=1,lettreG.count do
    local pX,pY = nodes.GetPosition(lettreG,i)
    love.graphics.circle("fill", pX, pY, 5)
  end
  love.graphics.setColor(colors.white)
  if pathImg1.timerPositif then
    love.graphics.draw(img1, X, Y, Angle90 - A, 1, 1, 32, 30)
  else
    love.graphics.draw(img1, X, Y, Angle90 - A, -1, 1, 32, 30)
  end
  X,Y,A = paths.getPosition(pathImg2)
  love.graphics.draw(img2, X, Y, 0, 1, 1, 32, 32)
end

function love.keypressed(key, scancode)
  if key == "space" or key == " " then
    paths.restart(pathImg2)
  end
  if key == "r" then
    paths.restart(pathLettreG)
    paths.restart(pathImg1)
    paths.restart(pathImg2)
  end
  if key == "p" then
    if pathLettreG.run then
      paths.stop(pathLettreG)
    else
      paths.start(pathLettreG)
    end
  end
end
