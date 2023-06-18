--[[
	Ice Beam
	- Creates a path between the caster and the target, dealing damage in everyone in this path.
]]--

function createPath(pos_a, pos_b, steps)
	local distance = getDistanceBetween(pos_a, pos_b)
	if distance == 0 then
		return {pos_a}
	end
	local path = {}
	for i = 1, steps do
		local new_pos = {x = pos_a.x + math.floor((pos_b.x - pos_a.x) * (i/distance) + 0.5),
		y = pos_a.y + math.floor((pos_b.y - pos_a.y) * (i/distance) + 0.5),
		z = pos_a.z}
		table.insert(path, new_pos)
	end
	return path
end

function canAttackPosition(pos_a, pos_b)
	return Tile(pos_b) and isSightClear(pos_a, pos_b) and not Tile(pos_b):hasFlag(TILESTATE_PROTECTIONZONE)
end

function onCastSpell(cid, var)
	local target = cid:getTarget()
	local target_position = target:getPosition()
	local cid_position = cid:getPosition()
	local path = createPath(cid_position, target_position, 8)
	doSendDistanceShoot(cid_position, path[#path], CONST_ANI_ICE)
	for i = 1, #path do
		if canAttackPosition(cid_position, path[i]) then
			doAreaCombat(cid, COMBAT_ICEDAMAGE, path[i], nil, -400, -800, CONST_ME_ICEATTACK)
		end
	end
	return true
end