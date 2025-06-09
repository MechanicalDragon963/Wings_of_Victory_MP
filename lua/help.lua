local _ = wesnoth.textdomain 'wesnoth-wov'
local dialog = wml.load "~add-ons/Wings_of_Victory/gui/help_dialog.cfg"

local function make_caption(text)
	return ("<big><b>%s</b></big>"):format(text)
end

local function help_page_text(caption, description)
	return caption, ("%s\n\n%s"):format(make_caption(caption), description)
end

function wesnoth.wml_actions.show_drakepedia(cfg)
	local show_help_mechanics = cfg.show_mechanics ~= false
	local show_help_training = cfg.show_training ~= false
	local show_help_factions = cfg.show_factions ~= false
	local show_help_artifacts = cfg.show_artifacts ~= false
	local show_help_settings = cfg.show_settings ~= false
	-- maps the treeview rows to pagenumber in the help page.
	local index_map = {}

	local current_side = wesnoth.interface.get_viewing_side()
	local preshow = function(dialog)
		local str_cat_mechnics = _ "Game Mechanics"
		local str_des_mechnics =
			make_caption( _ "Game Mechanics") .. "\n\n" ..
			_ "<b>Gold</b>\n" ..
			_ "Carryover rate is 15% and split evenly among players. Negative amounts will not carry over. Early finish bonus is superior to village control, but it is not directly related to the carryover amount.\n\n" ..
			_ "<b>Autorecall</b>\n" ..
			_ "Units with the <b>heroic</b> trait are recalled at the start of each scenario with no cost (up to castle size).\n\n" ..
			_ "<b>Recall Cost</b>\n" ..
			_ "Units costing less than 17 gold are cheaper to recall.\n\n" ..
			_ "<b>Training</b>\n" ..
			_ "Every time you recruit a new unit, your training levels will be applied. If a unit gains training benefits, you can see them with the trait \"trained\". Each unit’s chance of gaining training benefits is independent of another’s.\n\n" ..
			_ "<b>Upkeep</b>\n" ..
			_ "Units with the <b>heroic</b> trait or holding any magic <b>item</b> have free upkeep.\n\n" ..
			_ "<b>Bonus Points</b>\n" ..
			_ "In every scenario the game generates as many bonus points on the map as there are players in the game, the bonus points can be picked up by player units and either contain artifacts, loyal units, or training.\n\n" ..
			_ "<b>Army discipline</b>\n" ..
			_ "At scenarios 1 to 3, for each training level players already own, trainers found have 2% to 4% chance to become advanced trainers (provide 2 levels). Becomes irrelevant from scenario 4 onwards because all trainers will always be advanced.\n\n" ..
			""
		local str_cat_training, str_des_training = help_page_text( _ "Training", _ "Training improves newly recruited units, it has no effect on already recruited units. The following list shows all available training, the training you currently have is marked in green.")
		local str_cat_items, str_des_items = help_page_text( _ "Items", _ "Items can be given to units to make them stronger. You can get items in three ways: 1) By choosing an item as your starting bonus; 2) By finding it on a map in a bonus point; 3) By dropping from enemies in later scenarios. Note, however, that not all units can pick up all items.")
		local str_cat_era, str_des_era = help_page_text( _ "Factions" , _ "The World Conquest II era consists of factions that are built from pairs of mainline factions. One faction will have a healer available (Drakes, Rebels and Loyalists) and one will not (Orcs, Dwarves and Undead). The recruit list is also organized in pairs so that sometimes you will have to recruit a different unit before you can recruit the units that you want. The available heroes, deserters, and random leaders also depend on your factions; the items you can get do not depend on the faction you choose.")
		local str_cat_settings = _ "Settings"

		local root_node = dialog:find("treeview_topics")
		local details = dialog:find("details")

		function gui.widget.add_help_page(parent_node, args)
			local node_type = args.node_type or "category"
			local page_type = args.page_type or "simple"

			local node = parent_node:add_item_of_type(node_type)
			local details_page = details:add_item_of_type(page_type)
			if args.title then
				node.label_topic.label = args.title
				node.unfolded = true
			end
			index_map[table.concat(node.path, "_")] = details.item_count
			return node, details_page
		end
		
		local add_page = function(caption, text)
			local node, page = root_node:add_help_page {
				title = caption
			}
			page.label_content.marked_up_text = make_caption(caption) .. "\n\n" .. text
		end
		
		local form_section = function(secname, text)
			return "<b>" .. secname .. "</b>\n" .. text .. "\n\n"
		end

		add_page(_ "CHARACTERS", 
			form_section(_ "Galun, Drake", _ "The drake @Dominant who led the drakes to the @Great Continent.") ..
			form_section(_ "Vank, Drake", _ "The most outstanding @Intendant in the @Swarm of Galun that discovered the @Great Continent.") ..
			form_section(_ "Kerath, Drake", _ "Dominant of his @Flight.") ..
			form_section(_ "Reshan'lo, Drake", _ "Recorder in the Flight of Kerath. He is a member and also the Recorder of the @spiral path.") ..
			form_section(_ "erkon, Drake", _ "Dominant of his @Flight. In this flight @Galun was bred.")
		)
		add_page(_ "GEOGRAPHY", 
			form_section(_ "Great Ocean", _ "The Great Ocean is the name of the open seas that surround the archipelago of Morogor. The drakes believe it to end at the Abyss, a vast and deadly waterfall.") ..
			form_section(_ "Great Continent", _"The great continent to the east of Morogor. Its existence is unknown to the drakes until the flight of Galun.") ..
			form_section(_ "Morogor", _ "Archipelago, located somewhere in the @'Great Ocean' east of the Green Isle and west of the Great Continent.") ..
			form_section(_ "Mount Morogor", _ "Volcanic mountain on the central island of the archipelago.")
		)
		add_page(_ "TIME",
			form_section(_ "Vulcaniad", _ "The (irregular) period between consecutive eruptions of @Mount Morogor. The drake calendar is based upon it.") ..
			form_section(_ "Long Count", _ "The drake calendar based on @Vulcaniad and @Breeding cycles.") ..
			form_section(_ "Breeding cycle", _ "The time that passes between one egg laying to the next.") ..
			form_section(_ "Laying", _ "a period in the @'breeding cycle'.") ..
			form_section(_ "Hatching", _ "a period in the @'breeding cycle'.")
		)
		add_page(_ "SOCIETY",
			form_section(_ "Drake s.,Drakes p.", _ "A race of dragonlike creatures.") ..
			form_section(_ "drakish, adjective", _ "something that belongs to drakes.") ..
			form_section(_ "Drakish, language", _ "the language spoken by the drakes.") ..
			form_section(_ "Drakish, script", _ "the scripted language of the drakes. Stored on ceramic tablets by members of the @Recorder vocation") ..
			form_section(_ "Egg, Drake", _ "The caste the hatchling will belongs to is determined by the time it is laid.") ..
			form_section(_ "Hatchling", _ "A young drake that hasn't seen another generation hatch. The younger of the current generation of @hatchlings are the most aggressive is the behavior of the tribe.") ..
			form_section(_ "Fledgling", _ "A young drake that has seen another generation hatch. If the @flight can afford the loss of a generation they start the @Swarming.") ..
			form_section(_ "Breeder", _ "The female drake. They are rare since eggs that become breeders have to be handled with extra care. The number of breeders is also limited by the amounts of non-breeders around, since breeders can't take care of their food for themselves when laying. Drake breeders become fertile after the next hatching.") ..
			form_section(_ "Aspirant", _ "Male @Drake that has passed through a hormonal metamorphosis that makes him able to mate with the breeders. The secretion of the hormone is caused by hunt and combat actions in which the drake is involved.") ..
			form_section(_ "Intendant", _ "one of the Aspirant lieutenants of a Dominant. Traditionally he has one of each caste other than his own.  Additional Intendants are sometimes designated for special duties.  Intendants have some mating privileges.") ..
			form_section(_ "Dominant", _ "The @Aspirant that established as the drake leader, who has the final say on leading the tribe and has the most mating privileges with the breeders. Rarely, he may confer breeding privileges upon non-intendants for exceptional service.") ..
			form_section(_ "Flight", _ "Group of Drakes, lives in an @Eyrie, controlling a hunting range. Each tribe has one @Dominant, who confers mating privileges.") ..
			form_section(_ "Swarm", _ "The @Swarmlings that have left the @eyrie to found a new one.") ..
			form_section(_ "Swarmlings", _ "The flight for a new drake @eyrie that recurs every breeding cycle.") ..
			form_section(_ "Spiral Path", _ "A quasi-secret organization among the Drakes devoted to somehow avoiding a Malthusian final war.") .. 
			form_section(_ "Straight Path", _ "'Those who follow the straight path' or short 'The Straight Path' as a single word for drakish traditions of perpetual expansion and conquest.")..
			form_section(_ "Recorder", _ "Drakish scroll-keeper. The recorders are the only caste of Drake not determined by biology, they recruit their members from all of the other castes.") ..
		)
		add_page(_ "MISC",
			form_section(_ "Ceramics", _ "The drakes work metal, but are are masters in the craftsmanship of making ceramics. Only the burners can generate the amount of heat to cure the pieces to full strength.") ..
			form_section(_ "Eyrie", _ "A drake home building, fortified. It contains the @breeding chambers") ..
			form_section(_ "Breeding Chambers", _ "Where the Breeders live under the Dominant's eye.") ..
			form_section(_ "Long Prey", _ "rake term for bipedal game (e.g., humans). Derived from 'long pig', which is South Seas pidgin for human meat.") 
		)

		root_node:focus()

		function root_node.on_modified()
			local selected_index = index_map[table.concat(root_node.selected_item_path, '_')]
			if selected_index ~= nil then
				details.selected_index = selected_index
			end
		end
	end

	local dialog_wml = wml.get_child(dialog, 'resolution')
	gui.show_dialog(dialog_wml, preshow)
end
