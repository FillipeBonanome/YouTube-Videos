--[[
	Flame Burst
	- Carrega um ataque por 2s e depois causa dano de fogo no alvo
]]--

function handleChannelingSpell(cid, params)
	local checks = 12
	local events = {}
	local pos = cid:getPosition()
	for i = 1, checks * params.duration do
		table.insert(events,
		addEvent(function(c)
			if Creature(c) then
				local cid = Creature(c)
				local cid_position = cid:getPosition()
				if not params.allow_movement then
					if pos.x ~= cid_position.x or pos.y ~= cid_position.y or pos.z ~= cid_position.z then
						for j = 1, #events do
							stopEvent(events[j])
						end
						return true
					end
				end
				if i % 4 == 0 then
					doSendMagicEffect(cid_position, params.anim)
				end
				if i == checks * params.duration then
					params.f(cid)
				end
			end
		end, (i - 1) * 1000 / checks, cid:getId())
		)
	end
end

function castFlameBurst(cid)
	local target = cid:getTarget()
	if target then
		local cid_position = cid:getPosition()
		local target_position = target:getPosition()
		doSendDistanceShoot(cid_position, target_position, CONST_ANI_FIRE)
		doTargetCombat(cid, target, COMBAT_FIREDAMAGE, -400, -800)
	end
end

function onCastSpell(cid, var)
	local params = {duration = 2, allow_movement = true, anim = CONST_ME_HITBYFIRE, f = castFlameBurst}
	handleChannelingSpell(cid, params)
	return true
end