local mod = get_mod("mastergriller")

local menu = {
	name = "Master Griller",
	description = "Adds in a Master Griller's Toque Blanche and Golden Pan.\nGiving the option to replace Battlewizard's hat, Aqshy's Torchgate, with  the Toque Blanche and and Sienna's illusions for 1H Sword and Crowbill with the Golden Pan",
	is_togglable = false,
}

menu.options_widgets = {
	{
		["setting_name"] = "hat",
		["widget_type"] = "checkbox",
		["text"] = "Aqshy's Torchgate",
		["tooltip"] = "Replace Aqshy's Torchgate with Toque Blanche",
		["default_value"] = true,
		
	},
	{
		["setting_name"] = "1",
		["widget_type"] = "checkbox",
		["text"] = "Master's Crowbill",
		["tooltip"] = "Replace Master's Crowbill with Golden Pan",
		["default_value"] = true,
		
	},
	{
		["setting_name"] = "2",
		["widget_type"] = "checkbox",
		["text"] = "Master's Sword",
		["tooltip"] = "Replace Master's Sword with Golden Pan",
		["default_value"] = true,
		
	}
}

return menu