#pragma once

typedef enum //# team_e
{
	NPCTEAM_FREE,			// also FACTION_FREE - caution, some code checks a team_t via "if (!team_t_varname)" so I guess this should stay as entry 0, great or what? -slc
	NPCTEAM_ENEMY,			// also FACTION_EMPIRE
	NPCTEAM_PLAYER,			// also FACTION_REBEL
	NPCTEAM_MANDALORIANS,
	NPCTEAM_MERCS,
	NPCTEAM_PIRATES,
	NPCTEAM_WILDLIFE,
	NPCTEAM_NEUTRAL,		// also FACTION_SPECTATOR - most droids are team_neutral, there are some exceptions like Probe,Seeker,Interrogator

	//# #eol
	NPCFACTION_NUM_FACTIONS
} npcteam_t;

// This list is made up from the model directories, this MUST be in the same order as the ClassNames array in NPC_stats.cpp
typedef enum
{
	CLASS_NONE,				// hopefully this will never be used by an npc, just covering all bases
	CLASS_ATST_OLD,				// technically droid...
	CLASS_BARTENDER,
	CLASS_BESPIN_COP,
	CLASS_CLAW,
	CLASS_COMMANDO,
	CLASS_DEATHTROOPER,
	CLASS_DESANN,
	CLASS_FISH,
	CLASS_FLIER2,
	CLASS_GALAK,
	CLASS_GLIDER,
	CLASS_GONK,				// droid
	CLASS_GRAN,
	CLASS_HOWLER,
	CLASS_IMPERIAL,
	CLASS_IMPWORKER,
	CLASS_INTERROGATOR,		// droid
	CLASS_JAN,
	CLASS_JEDI,
	CLASS_PADAWAN,
	CLASS_HK51,
	CLASS_K2SO,
	CLASS_NATIVE,
	CLASS_NATIVE_GUNNER,
	CLASS_KYLE,
	CLASS_LANDO,
	CLASS_LIZARD,
	CLASS_LUKE,
	CLASS_MARK1,			// droid
	CLASS_MARK2,			// droid
	CLASS_GALAKMECH,		// droid
	CLASS_MINEMONSTER,
	CLASS_MONMOTHA,
	CLASS_MORGANKATARN,
	CLASS_MOUSE,			// droid
	CLASS_MURJJ,
	CLASS_PRISONER,
	CLASS_PROBE,			// droid
	CLASS_PROTOCOL,			// droid
	CLASS_R2D2,				// droid
	CLASS_R5D2,				// droid
	CLASS_PURGETROOPER,
	CLASS_REBEL,
	CLASS_REBORN,
	CLASS_INQUISITOR,
	CLASS_REELO,
	CLASS_REMOTE,
	CLASS_RODIAN,
	CLASS_SEEKER,			// droid
	CLASS_SENTRY,
	CLASS_SHADOWTROOPER,
	CLASS_STORMTROOPER,
	CLASS_STORMTROOPER_ADVANCED,
	CLASS_STORMTROOPER_ATST_PILOT,
	CLASS_STORMTROOPER_ATAT_PILOT,
	CLASS_SWAMP,
	CLASS_SWAMPTROOPER,
	CLASS_TAVION,
	CLASS_TRANDOSHAN,
	CLASS_UGNAUGHT,
	CLASS_JAWA,
	CLASS_WEEQUAY,
	CLASS_BOBAFETT,
	CLASS_VEHICLE,
	CLASS_RANCOR,
	CLASS_WAMPA,

	CLASS_REEK,
	CLASS_NEXU,
	CLASS_ACKLAY,

	CLASS_ATST,
	CLASS_ATAT,

	// UQ1: Extras from SP...
	CLASS_SAND_CREATURE,
	CLASS_SABOTEUR,
	CLASS_NOGHRI,
	CLASS_ALORA,
	CLASS_TUSKEN,
	CLASS_ROCKETTROOPER,
	CLASS_SABER_DROID,
	CLASS_ASSASSIN_DROID,
	CLASS_HAZARD_TROOPER,
	CLASS_MERC,

	// UQ1: Civilians...
	CLASS_CIVILIAN,
	CLASS_CIVILIAN_R2D2,
	CLASS_CIVILIAN_R5D2,
	CLASS_CIVILIAN_PROTOCOL,
	CLASS_CIVILIAN_WEEQUAY,
	CLASS_GENERAL_VENDOR,
	CLASS_WEAPONS_VENDOR,
	CLASS_ARMOR_VENDOR,
	CLASS_SUPPLIES_VENDOR,
	CLASS_FOOD_VENDOR,
	CLASS_MEDICAL_VENDOR,
	CLASS_GAMBLER_VENDOR,
	CLASS_TRADE_VENDOR,
	CLASS_ODDITIES_VENDOR,
	CLASS_DRUG_VENDOR,
	CLASS_TRAVELLING_VENDOR,

	CLASS_PLAYER,

	CLASS_NUM_CLASSES
} class_t;
