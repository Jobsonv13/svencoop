#include "point_checkpoint"

#include "opfor/weapon_knife"
#include "opfor/nvision"

void MapInit()
{
	// Enable SC CheckPoint Support for Survival Mode
	RegisterPointCheckPointEntity();
	// Register original Opposing Force knife weapon
	RegisterKnife();
	// Enable Nightvision Support
	g_nv.MapInit();
	g_nv.SetNVColor( Vector(0, 255, 0) ); // Green Nightvision	
	// Global CVars
	g_EngineFuncs.CVarSetFloat( "mp_hevsuit_voice", 0 );

	if( g_Engine.mapname == "of_utbm_7" || g_Engine.mapname == "of_utbm_8" || g_Engine.mapname == "of_utbm_9" )
		Precache();
}

void Precache()
{
	g_Game.PrecacheModel( "sprites/exit1.spr" );
	g_Game.PrecacheGeneric( "sprites/exit1.spr" );
	g_SoundSystem.PrecacheSound( "weapons/displacer_self.wav" );
}

void MapStart()
{
	g_EngineFuncs.ServerPrint( "Opposing Force: Under the Black Moon Version 1.6 - Download this campaign at scmapdb.com\n" );
	
	if( g_Engine.mapname == "of_utbm_7" || g_Engine.mapname == "of_utbm_8" || g_Engine.mapname == "of_utbm_9" )
		InitXenReturn();
}

void InitXenReturn()
{
	CBaseEntity@ pXenReturnDest, pXenReturnSpawnFx;

	while( ( @pXenReturnDest = g_EntityFuncs.FindEntityByTargetname( pXenReturnDest, "xen_return_dest*") ) !is null )
	{
		if( pXenReturnDest.GetClassname() != "info_teleport_destination" )
			continue;
		if( pXenReturnDest.pev.SpawnFlagBitSet( 32 ) )
			continue;

		pXenReturnDest.pev.spawnflags |= 32;
		pXenReturnDest.pev.target = "xen_return_spawnfx";
	}

	dictionary scrpt =
	{
		{ "targetname", "xen_return_spawnfx" },
		{ "m_iszScriptFunctionName", "XenReturnSpawnFx" },
		{ "m_iMode", "1" }
	};
	@pXenReturnSpawnFx  = g_EntityFuncs.CreateEntity( "trigger_script", scrpt, true );
}

void XenReturnSpawnFx(CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float flValue)
{
	if( pActivator !is null )
	{
		g_SoundSystem.EmitSound( pActivator.edict(), CHAN_ITEM, "weapons/displacer_self.wav", 1.0f, ATTN_NORM );
		g_Scheduler.SetTimeout( "DrawSpr", 0.1f, EHandle( pActivator ) );
	}
}

void DrawSpr(EHandle hActivator)
{
	if( !hActivator )
		return;

	NetworkMessage spr( MSG_BROADCAST, NetworkMessages::SVC_TEMPENTITY );
		spr.WriteByte( TE_SPRITE );

		spr.WriteCoord( hActivator.GetEntity().GetOrigin().x );
		spr.WriteCoord( hActivator.GetEntity().GetOrigin().y );
		spr.WriteCoord( hActivator.GetEntity().GetOrigin().z );

		spr.WriteShort( g_Game.PrecacheModel( "sprites/exit1.spr" ) );

		spr.WriteByte( 10 );
		spr.WriteByte( 200 );
	spr.End();
}
