local _ = wesnoth.textdomain 'wesnoth-wov'
local dialog = wml.load "~add-ons/Wings_of_Victory/gui/help_dialog.cfg"

local function make_caption(text)
	return ("<big><b>%s</b></big>"):format(text)
end

local function help_page_text(caption, description)
	return caption, ("%s\n\n%s"):format(make_caption(caption), description)
end

function wesnoth.wml_actions.show_drakepedia(cfg)
	-- maps the treeview rows to pagenumber in the help page.
	local index_map = {}

	local current_side = wesnoth.interface.get_viewing_side()
	local preshow = function(dialog)
		local root_node = dialog:find("treeview_topics")
		local details = dialog:find("details")

		function gui.widget.add_help_page(parent_node, args)
			local node_type = "category"
			local page_type = "simple"

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
			form_section(_ "Verkon, Drake", _ "Dominant of his @Flight. In this flight @Galun was bred.")
		)
		add_page(_ "GEOGRAPHY", 
			form_section(_ "Morogor", _ "Archipelago, located somewhere in the @'Great Ocean' east of the Green Isle and west of the Great Continent.") ..
			form_section(_ "Mount Morogor", _ "Volcanic mountain on the central island of the archipelago.") ..
			form_section(_ "Great Ocean", _ "The Great Ocean is the name of the open seas that surround the archipelago of Morogor. The drakes believe it to end at the Abyss, a vast and deadly waterfall.") ..
			form_section(_ "Great Continent", _"The great continent to the east of Morogor. Its existence is unknown to the drakes until the flight of Galun.") 
		)
		add_page(_ "TIME",
			form_section(_ "Vulcaniad", _ "The (irregular) period between consecutive eruptions of @Mount Morogor. The drake calendar is based upon it.") ..
			form_section(_ "Long Count", _ "The drake calendar based on @Vulcaniad and @Breeding cycles.") ..
			form_section(_ "Breeding cycle", _ "The time that passes between one egg laying to the next.") ..
			form_section(_ "Laying", _ "A period in the @'breeding cycle'.") ..
			form_section(_ "Hatching", _ "A period in the @'breeding cycle'.")
		)	
		add_page(_ "LANGUAGE",
			form_section(_ "Drake s.,Drakes p.", _ "A race of dragonlike creatures.") ..
			form_section(_ "drakish, adjective", _ "Something that belongs to drakes.") ..
			form_section(_ "Drakish, language", _ "The language spoken by the drakes.") ..
			form_section(_ "Drakish, script", _ "The scripted language of the drakes. Stored on ceramic tablets by members of the @Recorder vocation") 
		)
		add_page(_ "BIOLOGY",
			form_section(_ "Egg, Drake", _ "The caste the hatchling will belongs to is determined by the time it is laid.") ..
			form_section(_ "Hatchling", _ "A young drake that hasn't seen another generation hatch. The younger of the current generation of @hatchlings are the most aggressive is the behavior of the tribe.") ..
			form_section(_ "Fledgling", _ "A young drake that has seen another generation hatch. If the @flight can afford the loss of a generation they start the @Swarming.") ..
			form_section(_ "Breeder", _ "The female drake. They are rare since eggs that become breeders have to be handled with extra care. The number of breeders is also limited by the amounts of non-breeders around, since breeders can't take care of their food for themselves when laying. Drake breeders become fertile after the next hatching.") 
		)
		add_page(_ "HIERARCHY",
			form_section(_ "Aspirant", _ "Male @Drake that has passed through a hormonal metamorphosis that makes him able to mate with the breeders. The secretion of the hormone is caused by hunt and combat actions in which the drake is involved.") ..
			form_section(_ "Intendant", _ "One of the Aspirant lieutenants of a Dominant. Traditionally he has one of each caste other than his own.  Additional Intendants are sometimes designated for special duties.  Intendants have some mating privileges.") ..
			form_section(_ "Dominant", _ "The @Aspirant that established as the drake leader, who has the final say on leading the tribe and has the most mating privileges with the breeders. Rarely, he may confer breeding privileges upon non-intendants for exceptional service.") ..
			form_section(_ "Recorder", _ "Drakish scroll-keeper. The recorders are the only caste of Drake not determined by biology, they recruit their members from all of the other castes.") 
		)
		add_page(_ "SOCIETY",
			form_section(_ "Flight", _ "Group of Drakes, lives in an @Eyrie, controlling a hunting range. Each tribe has one @Dominant, who confers mating privileges.") ..
			form_section(_ "Swarm", _ "The @Swarmlings that have left the @eyrie to found a new one.") ..
			form_section(_ "Swarmlings", _ "The flight for a new drake @eyrie that recurs every breeding cycle.") 	
		)
		add_page(_ "DRAKE PATHS",
			form_section(_ "Spiral Path", _ "A quasi-secret organization among the Drakes devoted to somehow avoiding a Malthusian final war.") .. 
			form_section(_ "Straight Path", _ "'Those who follow the straight path' or short 'The Straight Path' as a single word for drakish traditions of perpetual expansion and conquest.")
		)
		add_page(_ "MISC",
			form_section(_ "Ceramics", _ "The drakes work metal, but are are masters in the craftsmanship of making ceramics. Only the burners can generate the amount of heat to cure the pieces to full strength.") ..
			form_section(_ "Eyrie", _ "A drake home building, fortified. It contains the @breeding chambers") ..
			form_section(_ "Breeding Chambers", _ "Where the Breeders live under the Dominant's eye.") ..
			form_section(_ "Long Prey", _ "Drake term for bipedal game (e.g., humans). Derived from 'long pig', which is South Seas pidgin for human meat.") ..
			form_section(_ "Lurkers", _ "Drake name for saurians. Drakes value saurian servants for their talents of healing and scouting. Because of the lurkers' light weight, drakes can take them with them even on aerial treks, holding them in their paws or on their backs.") 
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
