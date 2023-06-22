--[[
	Frozen Orb
	- Cria uma orbe de gelo que segue o inimigo. Ao entrar em contato ela explode.
	Requer: createPath(pos_a, pos_b, steps)
]]--

function followTarget(cid, position, target, steps, interval, animation, distance, f)
	local events = {}
	for i = 1, steps do
		table.insert(events,
		addEvent(function(c, t) 
			if Creature(c) and Creature(t) then
				local cid = Creature(c)
				local target = Creature(t)
				local target_position = target:getPosition()
				local path = createPath(position, target_position, 1)
				if path[1].x == position.x and path[1].y == position.y then
					f(cid, target_position)
					for j = 1, #events do
						stopEvent(events[j])
					end
					return true
				end
				doSendDistanceShoot(position, path[1], distance)
				position = path[1]
				doSendMagicEffect(position, animation)
			end
		end, (i - 1) * interval, cid:getId(), target:getId())
		)
	end
end

local area = createCombatArea(AREA_CIRCLE2X2)

local function frozenOrbOnHit(cid, position)
	doAreaCombat(cid, COMBAT_ICEDAMAGE, position, area, -400, -600, CONST_ME_GIANTICE)
end

function onCastSpell(cid, var)
	local target = cid
	local position = cid:getTarget():getPosition()
	followTarget(cid, position, target, 12, 150, CONST_ME_ICEATTACK, CONST_ANI_ICE, frozenOrbOnHit)
	return true
end