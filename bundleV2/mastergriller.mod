return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`mastergriller` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("mastergriller", {
			mod_script       = "scripts/mods/mastergriller/mastergriller",
			mod_data         = "scripts/mods/mastergriller/mastergriller_data",
			mod_localization = "scripts/mods/mastergriller/mastergriller_localization",
		})
	end,
	packages = {
		"resource_packages/mastergriller/mastergriller",
	},
}
