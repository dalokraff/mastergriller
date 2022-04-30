local mod = get_mod("mastergriller")

local menu = {
	name = "Master Griller Cosmetic Upgrade",
	description = "We may never get the Songbook but now we at least have the Master Griller!\nThis mod adds in a Master Griller's Toque Blanche and Golden Pan. With the options to replace Battlewizard's hat, Aqshy's Torchgate, with  the Toque Blanche and and Sienna's \"Master's\" illusions for 1H Sword and Crowbill with the Golden Pan. This mod is client side so it is compatible with hosts or clients that do not have the mod.\n\nIf you don't already have the \"Master's Sword\" or \"Master's Crowbill\" illusions you can use [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1425249043&searchtext=give+weapon]Give Weapon[/url] to make yourself a weapon with one of the skins.",
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