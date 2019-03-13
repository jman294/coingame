local HC = require "HC"
local game = {}

--game.width = 400
--game.height = 700

game.width = 500
game.height = 500

game.coinWidth = 25
game.coinHeight = 128

game.coinX = game.width / 2 - game.coinWidth / 2
game.coinY = game.height - game.coinHeight - 20

game.coinAngle = .01

game.backgroundSpeed = 500

ty = 0

function love.load()
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
  love.window.setMode(game.width, game.height, {resizable=false})
  animation = newAnimation(love.graphics.newImage("coinspritesheet.png"), 25, 128, .3)
end

function love.update(dt)
  animation.currentTime = animation.currentTime + dt
  if animation.currentTime >= animation.duration then
    animation.currentTime = animation.currentTime - animation.duration
  end

  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    game.coinAngle = game.coinAngle + .03
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    game.coinAngle = game.coinAngle - .03
  end

  game.coinX = game.coinX - 1 * (game.backgroundSpeed * dt / math.tan(game.coinAngle + math.pi / 2))

  print(game.coinAngle)

  ty = ty + game.backgroundSpeed * dt

  if ty >= game.height then
    ty = 0
  end
end

function love.draw()
  love.graphics.rectangle('fill', 50, ty, 100, 100)
  local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
  love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], game.coinX, game.coinY, game.coinAngle, 1, 1, game.coinWidth/2, game.coinHeight/2)
end

function newAnimation(image, width, height, duration)
  local animation = {}
  animation.spriteSheet = image;
  animation.quads = {};

  for y = 0, image:getHeight() - height, height do
    for x = 0, image:getWidth() - width, width do
      table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
    end
  end

  animation.duration = duration or 1
  animation.currentTime = 0

  return animation
end
