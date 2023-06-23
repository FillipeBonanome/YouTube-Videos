--[[
	Chain Lightning
	- Cria um raio que quica de criatura para criatura.
	Requer: createPath(pos_a, pos_b, steps)
	v1.1 --> Não atravessa mais paredes.
]]--

function ricochet(cid, target, last_position, bounces, animation, distance, f)
	if bounces == 0 then
		return true
	end
	
	local spectators = Game.getSpectators(last_position, false, false, distance, distance, distance, distance)
	local creatures = {}
	for i = 1, #spectators do
		if spectators[i] ~= cid and spectators[i] ~= target then
			local spectator_position = spectators[i]:getPosition()
			if isSightClear(last_position, spectator_position) then
				table.insert(creatures, spectators[i])
			end
		end
	end
	
	if #creatures > 0 then
		local random_creature = creatures[math.random(#creatures)]
		local random_creature_position = random_creature:getPosition()
		doSendDistanceShoot(last_position, random_creature_position, animation)
		f(cid, random_creature_position)
		bounces = bounces - 1
		last_position = random_creature_position
		addEvent(function(creature_id)
			if Creature(creature_id) then
				local cid = Creature(creature_id)
				ricochet(cid, random_creature, last_position, bounces, animation, distance, f)
			end
		end, 150, cid:getId())
	end
end

local function ricochetOnHit(cid, pos)
	doAreaCombat(cid, COMBAT_ENERGYDAMAGE, pos, nil, -150, -300, CONST_ME_ENERGYHIT)
end

function onCastSpell(cid, var)
	local target = cid:getTarget()
	local last_position = target:getPosition()
	doSendDistanceShoot(cid:getPosition(), last_position, CONST_ANI_ENERGYBALL)
	doTargetCombat(cid, target, COMBAT_ENERGYDAMAGE, -150, -300)
	addEvent(function(creature_id)
		if Creature(creature_id) then
			local cid = Creature(creature_id)
			ricochet(cid, target, last_position, 6, CONST_ANI_ENERGYBALL, 4, ricochetOnHit)
		end
	end, 150, cid:getId())
	
	return true
end