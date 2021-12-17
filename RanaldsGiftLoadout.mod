return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`RanaldsGiftLoadout` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("RanaldsGiftLoadout", {
			mod_script       = "scripts/mods/RanaldsGiftLoadout/RanaldsGiftLoadout",
			mod_data         = "scripts/mods/RanaldsGiftLoadout/RanaldsGiftLoadout_data",
			mod_localization = "scripts/mods/RanaldsGiftLoadout/RanaldsGiftLoadout_localization",
		})
	end,
	packages = {
		"resource_packages/RanaldsGiftLoadout/RanaldsGiftLoadout",
	},
}
