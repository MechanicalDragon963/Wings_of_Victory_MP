local income_factor = 5

function side_score(side_data)
	local income = side_data.total_income * income_factor
	local units_arr = wesnoth.units.find_on_map( { side = side_data.side } )
	if #units_arr == 0 then
		return 0
	end
	local units = 0
	-- Calc the total unit-score here
	for i, unit in ipairs( units_arr ) do
		if not unit.__cfg.canrecruit then
			wml.fire.unit_worth{ id = unit.id }
			units = units + wml.variables["unit_worth"]
		end
	end
	return units + side_data.gold + income
end

function all_sides()
		local function f(s, i)
			i = i + 1
			local t = wesnoth.sides[i]
			return t and i, t
		end
		return f, nil, 0
end

team_results = {}
for side, side_data in all_sides() do
	if not side_data.__cfg.hidden then
		local side_res = side_score(side_data)
		if side_res > 0 then
			local team_name = side_data.team_name
			if team_results[team_name] == nil then
				team_results[team_name] = side_res
			else
				team_results[team_name] = team_results[team_name] + side_res
			end
		end	
	end
end
