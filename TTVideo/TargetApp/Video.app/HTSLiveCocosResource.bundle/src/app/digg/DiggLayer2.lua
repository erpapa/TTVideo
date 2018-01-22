live = live or {}

require("app.digg.DiggSprite2")

local DiggLayer = class("DiggLayer", function()
    return display.newLayer()
end)

function DiggLayer:ctor()
    self._position = live.getPositionFromConfig(LIVE_DIGG_COORDINATE)
    self:enableNodeEvents()
end

function DiggLayer:tryPlayAnimation(msg)
    local digg = live.DiggSprite:create(msg, self._position.x, self._position.y)
    digg:setVisible(false)
    self:addChild(digg)
    digg:runAction(digg:getRandomAction())
    return true
end

function DiggLayer:onExit()
    self:removeAllChildren(true)
end

live.DiggLayer = DiggLayer
return DiggLayer
