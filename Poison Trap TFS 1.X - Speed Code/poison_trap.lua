--[[
	Poison Trap
	- Deals poison damage when a creature steps in.
]]--

function createTrap(cid, params)
	local checks = 12
	local events = {}
	for i = 1, checks * params.duration do
		table.insert(events,
		addEvent(function(c)
			if Creature(c) then
				local cid = Creature(c)
				if i % 3 == 0 then
					doSendMagicEffect(params.pos, params.anim)
				end
				if Tile(params.pos):getCreatureCount() > 0 then
					params.f(cid, params.pos)
					for j = 1, #events do
						stopEvent(events[j])
					end
				end
			end
		end, (i - 1) * 1000 / checks, cid:getId())
		)
	end
end

local area = createCombatArea(AREA_CIRCLE2X2)

local function trapActivate(cid, pos)
	doAreaCombat(cid, COMBAT_POISONDAMAGE, pos, area, -400, -800, CONST_ME_GREENSMOKE)
end

function onCastSpell(cid, var)
	local pos = cid:getPosition()
	local random_pos = {x = pos.x + math.random(-1, 1), y = pos.y + math.random(-1,1), z = pos.z}
	doSendDistanceShoot(pos, random_pos, CONST_ANI_POISON)
	local params = {duration = 6, f = trapActivate, anim = CONST_ME_POISONAREA, pos = random_pos}
	createTrap(cid, params)
	return true
end