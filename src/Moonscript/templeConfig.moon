-- TempleConfig.moon

CONFIG = {
	DESERT_TEMPLE:{
		POSITIONS:{

		}
		BOUNTY:{
			FIRST_DISCOVERY:{
				ITEMS:{
					Items.Camel_Eye!
					Items.Blood_Sand!
					Items.Sun_Stone!
				}
				EXPERIENCE:{
					MIN: 1000
					MID: 2500
					MAX: 3500
				}
			}
			FULL_LOOT:{
				ITEMS:{
					Items.Camel_Eye!
					Items.Blood_Sand!
					Items.Sun_Stone!
					Items.Cobra_Venom!
					Items.Glass_Vial!
					Items.Golden_Scepter!
					Items.Charms.Scarab_Charm!
					Items.Eye_of_Ra!
					Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
					Items.Charms.Isis_Curse_Charm!
					Items.Oil_of_Balsa!
				}
				EXPERIENCE:{
					MIN: 5000
					MID: 7500
					MAX: 10000
				}
			}
		}
	}
	JUNGLE_TEMPLE:{
		POSITIONS:{

		}
		BOUNTY:{
			FIRST_DISCOVERY:{
				ITEMS:{
					Item.Snake_Skin!
					Item.Spanish_Moss!
					Item.Chloral! -- Sedative used for Hypnosis
					Item.Jasper_Stone!
					Items.Charms.Amethyst_Luck_Amulet! -- Increases chance of High-tier BOUNTY
					Items.Charms.Sun_Stone_Utere_Fexix_Luck_Charm!
				}
				EXPERIENCE:{
					MIN: 4000
					MID: 5000
					MAX: 6500
				}
			}
			FULL_LOOT:{
				ITEMS:{
					Items.Oil_of_Vitriol!
					Items.Charms.Wedjat_Eye_Amulet! -- EXTREME-tier Amulet
					Items.Charms.Evil_Eye_Amulet! -- Brings Bad luck to attackers.
					Item.Snake_Skin!
					Item.Spanish_Moss!
					Item.Chloral! -- Sedative used for Hypnosis
					Item.Jasper_Stone!
					Items.Charms.Amethyst_Luck_Amulet! -- Increases chance of High-tier BOUNTY
					Items.Charms.Sun_Stone_Utere_Fexix_Luck_Charm!
				}
				EXPERIENCE:{
					MIN: 5000
					MID: 6500
					MAX: 8000
				}
			}
		}
	}
	PHAROAHS_TABERNACLE:{
		POSITIONS:{

		}
		FIRST_DISCOVERY:{
			ITEMS:{
				Items.Golden_Scepter!
				Items.Charms.Scarab_Charm!
				Items.Eye_of_Ra!
				Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
				Items.Charms.Wedjat_Eye_Amulet!
				Items.Jasper_Stone!
				Items.Charms.Amethyst_Luck_Amulet! -- Increases chance of High-tier BOUNTY
				Items.Sun_Stone!
			}
			EXPERIENCE:{
				MIN: 7500
				MID: 8000
				MAX: 8500
			}
		}
		FULL_LOOT:{
			ITEMS:{
				Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
				Items.Charms.Wedjat_Eye_Amulet! -- Brings health to the bearer.
				Items.Jasper_Stone! -- the blood of Pharoah.
				Items.Chloral! -- Allows the user to enter a phsyco-active state.
				Items.Charms.Amethyst_Luck_Amulet! -- Increases chance of High-tier BOUNTY
				Items.Charms.Sun_Stone_Utere_Fexix_Luck_Charm! -- Brings extreme luck to the owner
				Items.Sun_Stone! -- A solidified ray of Sunlight.
				Items.Golden_Scepter! -- Gives the beholder jurisdiction over the undead.
				Items.Charms.Scarab_Charm! -- Allows the beholder to keep items after death.
				Items.Eye_of_Ra! -- Allows control ofthe Sun's position (once per login)
				Items.Charms.Lapiz_Lazuli_Amulet! -- Brings slight luck to the owner.
				Items.Vulture_Crown_Feather! -- Allows the owner to eat rotten meat and replenish hunger.
				Items.Sekhmets_Sun_Disk! -- Allows the beholder to channel the sun's energy.
				Items.Bastets_Claw! -- Protects the user from snakes and birds
				Items.Tefnuts_Lapis_Iris! -- Brings rain.
				Items.Breath_of_Shu! -- gives the user ability to blow items.
				Items.Skin_of_Geb! -- Give the user the ability to control Earth
				Items.Breath_of_Nut! -- Give the user the ability to fly short distances
			}
			EXPERIENCE:{
				MIN: 8000
				MID: 8500
				MAX: 9500
			}
		}
	}
	PHAROAHS_TOMB:{
		POSITIONS:{

		}
		FIRST_DISCOVERY:{
			ITEMS:{
				Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
				Items.Jasper_Stone! -- the blood of Pharoah.
				Items.Sun_Stone! -- A solidified ray of Sunlight.
				Items.Golden_Scepter! -- Gives the beholder jurisdiction over the undead.
				Items.Charms.Scarab_Charm! -- Allows the beholder to keep items after death.
				Items.Eye_of_Ra! -- Allows control ofthe Sun's position (once per login)
				Items.Charms.Isis_Knot! -- Protects wearer from direct attacks.
				Items.Charms.Plummet_Amulet! -- Prevents some fall damage.
				Items.Sekhem_Rune! -- shows authority of owner
				Items.Charms.Sesen_Charm! -- Symbol of Rebirth
			}
			EXPERIENCE:{
				MIN: 10000
				MID: 12500
				MAX: 14000
			}
		}
		FULL_LOOT:{
			ITEMS:{
				Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
				Items.Charms.Wedjat_Eye_Amulet! -- Brings health to the bearer.
				Items.Jasper_Stone! -- the blood of Pharoah.
				Items.Chloral! -- Allows the user to enter a phsyco-active state.
				Items.Charms.Amethyst_Luck_Amulet! -- Increases chance of High-tier BOUNTY
				Items.Charms.Sun_Stone_Utere_Fexix_Luck_Charm! -- Brings extreme luck to the owner
				Items.Sun_Stone! -- A solidified ray of Sunlight.
				Items.Golden_Scepter! -- Gives the beholder jurisdiction over the undead.
				Items.Charms.Scarab_Charm! -- Allows the beholder to keep items after death.
				Items.Eye_of_Ra! -- Allows control ofthe Sun's position (once per login)
				Items.Charms.Lapiz_Lazuli_Amulet! -- Brings slight luck to the owner.
				Items.Vulture_Crown_Feather! -- Allows the owner to eat rotten meat and replenish hunger.
				Items.Sekhmets_Sun_Disk! -- Allows the beholder to channel the sun's energy.
				Items.Bastets_Claw! -- Protects the user from snakes and birds
				Items.Tefnuts_Lapis_Iris! -- Brings rain.
				Items.Breath_of_Shu! -- gives the user ability to blow items.
				Items.Skin_of_Geb! -- Give the user the ability to control Earth
				Items.Breath_of_Nut! -- Give the user the ability to fly short distances
				Items.Charms.Double_Plume_Feathers_Amulet! -- Provides the owner with 2x jump height.
				Items.Blank_Cartouche_Rune! -- Blank rune
				Items.Sacred_Cartouche! -- Unusable by non-owner
				Items.Sekhem_Rune! -- shows authority of owner
				Items.Charms.Sesen_Charm! -- Symbol of Rebirth
				Items.Charms.Shen_Amulet! -- Gives 2.5x Health
			}
			EXPERIENCE:{
				MIN: 15000
				MID: 17500
				MAX: 18000
			}
		}
	}
	SUN_TEMPLE:{
		POSITIONS:{

		}
		FIRST_DISCOVERY:{
			ITEMS:{
				Items.Akhet_Rune! -- Allows creation of spells (more powerful @ sun(rise/set))
				Items.Ankh! -- Gives mana regeneration buff.
				Items.Ba_Rune! -- Used in crafting `Sacred_Cartouche`
				Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
				Items.Charms.Djew_Charm! -- Gives a stamina buff
				Items.Feather_of_Maat! -- Restores peace at the end of the game
				Items.Charms.Ieb_Charm! -- Gives a health regen buff
				Items.Charms.Imenet_Charm! -- Heals owner at dusk
				Items.Charms.Ka_Charm! -- Heals owner at dawn
				Items.Charms.Menhed_Charm! -- Allows crafting of tablets for less mana
				Items.Charms.Nebu_Charm! -- Allows the transmutation of gold
				Items.Charms.Pet_Charm! -- gives regen buff at high altitudes
				Items.Charms.Shen_Amulet! -- Gives 2.5x Health
			}
			EXPERIENCE:{
				MIN: 17500
				MID: 20000
				MAX: 22500
			}
		}
		FULL_LOOT:{
			ITEMS:{
				Items.Akhet_Rune! -- Allows creation of spells (more powerful @ sun(rise/set))
				Items.Ankh! -- Gives mana regeneration buff.
				Items.Ba_Rune! -- Used in crafting `Sacred_Cartouche`
				Items.Charms.Djed_Charm! -- Gives the owner resistance to fall damage
				Items.Charms.Djew_Charm! -- Gives a stamina buff
				Items.Feather_of_Maat! -- Restores peace at the end of the game
				Items.Charms.Ieb_Charm! -- Gives a health regen buff
				Items.Charms.Imenet_Charm! -- Heals owner at dusk
				Items.Charms.Ka_Charm! -- Heals owner at dawn
				Items.Charms.Menhed_Charm! -- Allows crafting of tablets for less mana
				Items.Charms.Nebu_Charm! -- Allows the transmutation of gold
				Items.Charms.Pet_Charm! -- gives regen buff at high altitudes
				Items.charms.Shen_Amulet! -- Gives 2.5x Health
			}
			EXPERIENCE:{
				MIN: 20000
				MID: 22500
				MAX: 25000
			}
		}
	}
	LUNAR_TEMPLE:{
		POSITIONS:{

		}
		FIRST_DISCOVERY:{
			ITEMS:{
				Items.Charms.Ushabtis_Amulet! -- Allows special items to be crafted
				Items.Charms.Was_Amulet! -- Increases max mana
				Items.Charms.Menta_Rune! -- Allows crafting of farming runes
			}
			EXPERIENCE:{
				MIN: 15000
				MID: 17500
				MAX: 20000
			}
		}
		FULL_LOOT:{
			ITEMS:{
				Items.Charms.Ushabtis_Amulet! -- Allows special items to be crafted
				Items.Charms.Was_Amulet! -- Increases max mana
				Items.Charms.Winged_Solar_Disk! -- Allows flying
				Items.Amenta_Rune! -- Allows crafting of evil runes
				Items.Maat_Rune! -- Allows crafting of truth/justice/balanced runes
				Items.Menta_Rune! -- Allows crafting of farming runes
			}
			EXPERIENCE:{
				MIN: 17500
				MID: 20000
				MAX: 22500
			}
		}
	}
	ANCIENT_LIBRARY:{
		POSITIONS:{

		}
		FIRST_DISCOVERY:{
			ITEMS:{
				Items.Naos_Tablet! -- Map to shrine
				Items.Charms.Nebu_Charm! -- Allows the transmutation of gold
				Items.Charms.Palm_Branch_Charm! -- changes with time
				Items.Charms.Sa_Amulet! -- Protects against poison
				Items.Charms.Scarab_Charm! -- Allows the beholder to keep items after death.
			}
			EXPERIENCE:{
				MIN: 6000
				MID: 9000
				MAX: 12000
			}
		}
		FULL_LOOT:{
			ITEMS:{
				Items.Naos_Tablet! -- Map to shrine
				Items.Charms.Nebu_Charm! -- Allows the transmutation of gold
				Items.Charms.Palm_Branch_Charm! -- changes with time
				Items.Charms.Sa_Amulet! -- Protects against poison
				Items.Charms.Scarab_Charm! -- Allows the beholder to keep items after death.
				Items.Sekhem_Rune! -- shows authority of owner
				Items.Sema_Rune! -- Strengthens owner when in anohter land
				Items.Charms.Sesen_Charm! -- Symbol of Rebirth
				Items.Charms.Shen_Amulet! -- Gives 2.5x Health
			}
			EXPERIENCE:{
				MIN: 9000
				MID: 12000
				MAX: 15000
			}
		}
	}
}