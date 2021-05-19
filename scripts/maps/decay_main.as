#include "point_checkpoint"
#include "cubemath/trigger_once_mp"
#include "cubemath/func_wall_custom"
#include "cubemath/player_respawn_zone_as"
// #include "cubemath/weapon_debug"
#include "cubemath/polling_check_players"
#include "decay/monster_alienflyer"
#include "decay/item_recharge"
#include "decay/item_healthcharger"
#include "decay/item_eyescanner"
#include "decay/trigger_condition_alone"
#include "decay/info_cheathelper"
#include "decay/weapon_slave"

void MapInit()
{
	RegisterItemRechargeCustomEntity();
	RegisterItemHealthCustomEntity();
	RegisterPointCheckPointEntity();
	RegisterTriggerOnceMpEntity();
	RegisterFuncWallCustomEntity();
	RegisterPlayerRespawnZoneASEntity();
	// RegisterWeaponDebug();
	RegisterAlienflyer();
	RegisterTriggerAloneCustomEntity();
	RegisterInfoCheathelperCustomEntity();
	RegisterWeaponIslave();
    g_CustomEntityFuncs.RegisterCustomEntity("Decay::CRetinalScanner", "item_eyescanner");

	g_EngineFuncs.CVarSetFloat( "mp_npckill", 2 );

	if (g_Engine.mapname == "dy_alien")
	{
		g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 0 );
	}
	else
	{
		g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 1 );
	}
	
	poll_check();
}
