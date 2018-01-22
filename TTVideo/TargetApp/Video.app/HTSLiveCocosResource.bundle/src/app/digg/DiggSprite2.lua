cc.exports.DIGGSPRITE2_KEY = "app.sprites.DiggSprite2"

display.loadSpriteFrames("digg_xg.plist", "digg_xg.png")--这里加入图片缓冲库

live = live or {}

local DiggSprite = class("DiggSprite", function()
    return cc.Node:create()
end)

function DiggSprite:ctor(msg, SX, SY)
    --点赞图标
    self._icons = {}
    self._icons[tonumber("00EAFF", 16)] = "digg_xg_blue.png"
    self._icons[tonumber("00F58A", 16)] = "digg_xg_green.png"
    self._icons[tonumber("FE772E", 16)] = "digg_xg_orange.png"
    self._icons[tonumber("CB56FC", 16)] = "digg_xg_purple.png"
    self._icons[tonumber("FD2731", 16)] = "digg_xg_red.png"
    self._icons[tonumber("FEE32E", 16)] = "digg_xg_yellow.png"

    self._content = display.newSprite()
    local diggImage = self._icons[msg.color] or "digg_xg_red.png"
    self._content:setSpriteFrame(diggImage)
    self._content:setAnchorPoint(cc.p(0.5, 0.5))
    self:setCascadeOpacityEnabled(true)
    self:addChild(self._content,1)

    self.VW = display.width
    self.VH = display.height
    self.SX = SX
    self.SY = SY
    self.EX = math.random(self.SX - 50, self.SX + 50)
    self.EY = 0.3 * self.VH
    self.MX = self.EX + (self.SX - self.EX) / 2
    if self.EX > self.SX then
        self.MX = self.SX + (self.EX - self.SX) / 2
    end
    self.MY = (self.EY - self.SY) / 2
    self._action = cc.Sequence:create({
        cc.CallFunc:create(function(el)
            el:setPosition(self.SX, self.SY);
            el:setVisible(true);
            el:setScale(0);
            el:setOpacity(255);
        end),

        cc.Spawn:create({
            cc.BezierTo:create(1.3, {cc.p(self.SX,self.SY + 30), cc.p(self.MX,self.MY), cc.p(self.EX,self.EY)}),
            cc.Sequence:create({
                cc.DelayTime:create(1),
                cc.FadeTo:create(0.3, 0)
            }),
            cc.ScaleTo:create(0.5, 1)
        }),

        cc.CallFunc:create(function(el)
            live.Pool.putInPool(el, DIGGSPRITE_KEY)
            el:removeFromParent()
        end)
    })
    self._action:retain()
end

function DiggSprite:unuse()
    self:setVisible(false)
end

function DiggSprite:reuse(msg)
    self._content:setSpriteFrame(self._icons[msg.color])
    self:setVisible(true)
end

function DiggSprite:create(msg, SX, SY)
    if live.Pool.hasObject(DIGGSPRITE2_KEY) then
        return live.Pool.getFromPool(DIGGSPRITE2_KEY, msg)
    else
        return self.new(msg,SX,SY)
    end
end

function DiggSprite:getRandomAction()
    self.EX = math.random(self.SX - 100, self.SX + 100)
    return self._action
end

live.DiggSprite = DiggSprite

return DiggSprite

