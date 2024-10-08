// Special Zombies by Ky1

printcl(255,255,0,"Special Zombies VSCRIPT [version 1.6] enabled")

if ("specialzm" in getroottable())
	return;

//-----------------------------------------------------------------------------

local ContextFuckingZombies = "[Special Zombie VSCRIPT] by Ky1";
::Entities.EnableEntityListening()

Convars.RegisterConvar("sv_specialzm", "1", "Enable special ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_poison", "1", "Enable special Poison ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_poison_hp", "1400", "Set health of special Poison ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_poison_freq", "25", "Set how often special Poison ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_fast", "1", "Enable special Fast ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_fast_hp", "1400", "Set health of special ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_fast_freq", "15", "Set how often special Fast ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_burn", "1", "Enable special Burn ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_burn_hp", "1400", "Set health of special Burn ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_burn_freq", "25", "Set how often special Burn ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_dog", "1", "Enable special Dog ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_dog_hp", "650", "Set health of special Dog ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_dog_freq", "25", "Set how often special Dog ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_bomb", "1", "Enable special Bomb ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_bomb_hp", "800", "Set health of special Bomb ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_bomb_freq", "15", "Set how often special Bomb ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_chainsaw", "1", "Enable special Bomb ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_chainsaw_hp", "4200", "Set health of special Chainsaw ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_chainsaw_freq", "1", "Set how often special Chainsaw ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

// Convars.RegisterConvar("sv_specialzm_color", "", "Set the color of special ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);


::specialzm_poison_freqC <- 25;
::specialzm_fast_freqC <- 15;
::specialzm_burn_freqC <- 20;
::specialzm_dog_freqC <- 25;
::specialzm_bomb_freqC <- 15;
::specialzm_saw_freqC <- 1;

::health_poisonC <- 1400;
::health_fastC <- 1400;
::health_burnC <- 1400;
::health_dogC <- 900;
::health_bombC <- 800;
::health_sawC <- 4200;

::sv_specialzm_poisonC <- 1;
::sv_specialzm_fastC <- 1;
::sv_specialzm_burnC <- 1;
::sv_specialzm_dogC <- 1;
::sv_specialzm_bombC <- 1;
::sv_specialzm_sawC <- 1;
::SOUNDEFFECT_BMB <- "PropaneTank.Burst"
::SOUNDEFFECT_SAWLOL <- "Weapon_Chainsaw.IdleLoop"

const z_fixup = 10
const IMPULSEFORCE = 250000

PrecacheModel("models/zombie/poison.mdl", true)
PrecacheModel("models/zombie/fast.mdl", true)
PrecacheModel("models/nmr_zombie/burned/burn1.mdl", true)
PrecacheModel("models/dewobedil/zombies/doggy.mdl", true)
PrecacheModel("models/dewobedil/zombies/security_bomb2024.mdl", true)
PrecacheModel("models/zombies/chainsaw_man.mdl", true)

//-----------------------------------------------------------------------------

function CacheConvarsSPECIALZM(event)
{
    // CVARS Special ZM health
    ::health_poisonC = Convars.GetInt("sv_specialzm_poison_hp")
    ::health_fastC = Convars.GetInt("sv_specialzm_fast_hp")
    ::health_burnC = Convars.GetInt("sv_specialzm_burn_hp")
    ::health_dogC = Convars.GetInt("sv_specialzm_dog_hp")
    ::health_bombC = Convars.GetInt("sv_specialzm_bomb_hp")
    ::health_sawC = Convars.GetInt("sv_specialzm_chainsaw_hp")

    // CVARS Special ZM frequencies
    ::specialzm_poison_freqC = Convars.GetInt("sv_specialzm_poison_freq")
    ::specialzm_fast_freqC = Convars.GetInt("sv_specialzm_fast_freq")
    ::specialzm_burn_freqC = Convars.GetInt("sv_specialzm_burn_freq")
    ::specialzm_dog_freqC = Convars.GetInt("sv_specialzm_dog_freq")
    ::specialzm_bomb_freqC = Convars.GetInt("sv_specialzm_bomb_freq")
    ::specialzm_saw_freqC = Convars.GetInt("sv_specialzm_chainsaw_freq")

    //CVARS Special ZM On/Off
    ::sv_specialzm_poisonC = Convars.GetInt("sv_specialzm_poison")
    ::sv_specialzm_fastC = Convars.GetInt("sv_specialzm_fast")
    ::sv_specialzm_burnC = Convars.GetInt("sv_specialzm_burn")
    ::sv_specialzm_dogC = Convars.GetInt("sv_specialzm_dog")
    ::sv_specialzm_bombC = Convars.GetInt("sv_specialzm_bomb")
    ::sv_specialzm_sawC = Convars.GetInt("sv_specialzm_chainsaw")

}

local eventlistener_cvars_specialzm = ListenToGameEvent("nmrih_reset_map", CacheConvarsSPECIALZM, "")

CacheConvarsSPECIALZM(0)

// Special ZM declarations
local poison = "models/zombie/poison.mdl";
local fast = "models/zombie/fast.mdl";
local burn = "models/nmr_zombie/burned/burn1.mdl";
local dog = "models/dewobedil/zombies/doggy.mdl";
local bomb = "models/dewobedil/zombies/security_bomb2024.mdl";
local chainsaw = "models/zombies/chainsaw_man.mdl";

// Make a fucking damage filter for fucking negating fire damage for fucking burned zombies
local DMGFILTER_Fire = SpawnEntityFromTable("filter_damage_type",
{ 
    targetname  = "ANTIBURN",
    damagetype  = 8,
    Negated     = 1,
});


//-----------------------------------------------------------------------------

function ConvertFuckingZombies(entity)
{
    // Fucking Chances
    local chance_poison = RandomInt(1, 1000);
    local chance_fast = RandomInt(1, 1000);
    local chance_burn = RandomInt(1, 1000);
    local chance_dog = RandomInt(1, 1000);
    local chance_bomb = RandomInt(1, 1000);
    local chance_saw = RandomInt(1, 1000);

    if (!Convars.GetBool("sv_specialzm"))
        return;

    if (entity.GetClassname().find("npc_nmrih_", 0) == null)
        return;

    if (Convars.GetBool("sv_specialzm_poison"))
    {
        if (chance_poison <= ::specialzm_poison_freqC) 
        {
            // Remove fucking tp to ground flag
            entity.__KeyValueFromInt("spawnflags", 512);
            NetProps.SetPropInt(entity, "m_iHealth", ::health_poisonC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_poisonC);
            entity.SetModelOverride(poison);
            // Fix fucking zombie fall through floor
            local origin = entity.GetOrigin();
            origin.z = origin.z + z_fixup;
            entity.SetOrigin(origin);

            return;
        }
        
    }

    if (Convars.GetBool("sv_specialzm_fast"))
    {
        if (chance_fast <= ::specialzm_fast_freqC) 
        {
            // Remove fucking tp to ground flag
            entity.__KeyValueFromInt("spawnflags", 512);
            NetProps.SetPropInt(entity, "m_iHealth", ::health_fastC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_fastC);
            entity.SetModelOverride(fast);
            // Fix fucking zombie fall through floor
            local origin = entity.GetOrigin();
            origin.z = origin.z + z_fixup;
            entity.SetOrigin(origin);

            return;
        }
        
    }

    if (Convars.GetBool("sv_specialzm_burn"))
    {
        if (chance_burn <= ::specialzm_burn_freqC) 
        {
        
            NetProps.SetPropInt(entity, "m_iHealth", ::health_burnC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_burnC);
            NetProps.SetPropString(entity, "m_hDamageFilter", "ANTIBURN");
            entity.SetModelOverride(burn);

            // The following filters out burn and crush damage.
            local rName = RandomInt(0,9999999).tostring(); // Random int for unique ID
            entity.SetName(rName);

            local hFilter_Script = SpawnEntityFromTable("filter_script", { targetname = "tankfilter" + rName } );
            EntFireByHandle(entity, "setdamagefilter", "tankfilter" + rName, 0.0, null, null);

            hFilter_Script.ValidateScriptScope();
            local scope = hFilter_Script.GetScriptScope();
            scope.prevHealth <- ::health_burnC;
            scope.tankent <- entity;

            hFilter_Script.GetOrCreatePrivateScriptScope().PassesDamageFilter <- function (...)
            {
                if (info.GetDamageType() & 9)    // crush (1), burn (8)
                {
                    // Ignite always sets health to 55, applying workaround
                    tankent.SetHealth(prevHealth - 230);
                    return false;
                }
                else
                {
                    prevHealth = tankent.GetHealth();
                    return true;
                }
            }

            return;
        }
        
    }

    if (Convars.GetBool("sv_specialzm_dog"))
    {
        if (chance_dog <= ::specialzm_dog_freqC) 
        {
            // Remove fucking tp to ground flag
            entity.__KeyValueFromInt("spawnflags", 512);
            NetProps.SetPropInt(entity, "m_iHealth", ::health_dogC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_dogC);
            entity.SetModelOverride(dog);
            // Fix fucking zombie fall through floor
            local origin = entity.GetOrigin();
            origin.z = origin.z + z_fixup;
            entity.SetOrigin(origin);

            return;
        }
    }

    if (Convars.GetBool("sv_specialzm_bomb"))
    {
        if (chance_bomb <= ::specialzm_bomb_freqC) 
        {
            // Remove fucking tp to ground flag
            // 16896 = fade corpse + immune to push
            //entity.__KeyValueFromInt("spawnflags", 16896);
            NetProps.SetPropInt(entity, "m_iHealth", ::health_bombC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_bombC);
            entity.SetModelOverride(bomb);
            // Fix fucking zombie fall through floor
            local origin = entity.GetOrigin();
            origin.z = origin.z + z_fixup;
            entity.SetOrigin(origin);

            entity.PrecacheSoundScript(SOUNDEFFECT_BMB)
            AddThinkToEnt(entity, "ThinkNPC");

            entity.ValidateScriptScope()
            local scope = entity.GetScriptScope()
 
            scope.fuselit <- 0
            scope.ThinkNPC <- function()
            {
                //print("think")
                local nearby = Entities.FindByClassnameNearest("player", self.GetOrigin(), 50) 
                if ( nearby!= null){
                    fuselit = fuselit + 0.5
 
                    if (fuselit >= 3)
                    {
                        fuselit = 0
                        Explode()
                    }
                }
                else
                    fuselit = 0
 
                return 0.5
            }
 
            scope.Explode <- function()
            {
                //print("exploding")
                ENVExplosion()
                SoundEffectFMOD()
                Shake()
                entity.SetHealth(0);
            }
 
            scope.ENVExplosion <- function()
            {
                local entOrigin = self.GetOrigin();
                entOrigin.z = (entOrigin.z + 20);
 
                local explode = Entities.CreateByClassname("env_explosion");
                explode.SetOrigin(entOrigin);
 
                explode.KeyValueFromInt("iMagnitude", 500);
                explode.KeyValueFromInt("iRadiusOverride", 350);
                EntFireByHandle(explode, "Explode", "", 0.00, null, null);
                EntFireByHandle(explode, "Kill", "", 0.00, null, null); 
            }
 
            scope.SoundEffectFMOD <- function()
            {
 
                local entOrigin = self.GetOrigin();
                entOrigin.z = (entOrigin.z + 20);
 
                local ambient_fmod = Entities.CreateByClassname("ambient_fmod");
                ambient_fmod.SetOrigin(entOrigin);
                ambient_fmod.KeyValueFromInt("radius", 2000);
                ambient_fmod.KeyValueFromInt("spawnflags", 49);
                ambient_fmod.KeyValueFromInt("volume", 10);
                ambient_fmod.KeyValueFromString("message", SOUNDEFFECT_BMB);
                EntFireByHandle(ambient_fmod, "PlaySound", "", 0.00, null, null);
                EntFireByHandle(ambient_fmod, "Kill", "", 5.00, null, null);    
            }

            scope.Shake <- function()
            {
 
                local entOrigin = self.GetOrigin();
                entOrigin.z = (entOrigin.z + 20);
 
                local env_shake = Entities.CreateByClassname("env_shake");
                env_shake.SetOrigin(entOrigin);
                env_shake.KeyValueFromInt("radius", 1250);
                env_shake.KeyValueFromInt("amplitude", 16);
                env_shake.KeyValueFromInt("duration", 1);
                env_shake.KeyValueFromInt("frequency", 3);
                env_shake.KeyValueFromInt("spawnflags", 24);
                EntFireByHandle(env_shake, "StartShake", "", 0.00, null, null);
                EntFireByHandle(env_shake, "Kill", "", 5.00, null, null);    
            }

            return;
        }
    }

    if (Convars.GetBool("sv_specialzm_chainsaw"))
    {
        if (chance_saw <= ::specialzm_saw_freqC) 
        {
            // Remove fucking tp to ground flag
            // 16896 = fade corpse + immune to push
            NetProps.SetPropInt(entity, "m_iHealth", ::health_sawC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_sawC);
            entity.SetModelOverride(chainsaw);
            // Fix fucking zombie fall through floor
            local origin = entity.GetOrigin();
            origin.z = origin.z + z_fixup;
            entity.SetOrigin(origin);

            entity.PrecacheSoundScript(SOUNDEFFECT_SAWLOL)

            entity.ValidateScriptScope()
            local scope_saw = entity.GetScriptScope()


            /*
            scope_saw.StartChainSound <- function()
            {
                local entOrigin = self.GetOrigin();
                entOrigin.z = (entOrigin.z + 20);

                chainsound_ent = Entities.CreateByClassname("ambient_fmod");
                chainsound_ent.SetOrigin(entOrigin);
                chainsound_ent.KeyValueFromInt("radius", 2000);
                chainsound_ent.KeyValueFromInt("spawnflags", 17);
                chainsound_ent.KeyValueFromInt("volume", 7);
                chainsound_ent.KeyValueFromString("message", SOUNDEFFECT_SAWLOL);
                EntFireByHandle(chainsound_ent, "PlaySound", "", 0.00, null, null);
                print("playing shit")
            } 
            */

            scope_saw.OnPostSpawn <- function()
            {
                AddThinkToEnt(self, "TurboKillThink");
            }

            scope_saw.TurboKillThink <- function()
            { 
                local schedule = self.GetSchedule();
                if (schedule != "SCHED_ZOMBIE_MELEE_ATTACK1")
                {
                    return 1.0;
                }
                local player =  self.GetEnemy()

                if ( !player.IsPlayer() || !player.IsAlive() )
                    return 1.0

                //create damage info for playerhit by turbo zombie
                local forceVec = player.GetEyeForward()
                forceVec.x = forceVec.x * IMPULSEFORCE
                forceVec.y = forceVec.y * IMPULSEFORCE
                forceVec.z = forceVec.z * IMPULSEFORCE
                //inflictor, damager, force applied, dunno, damage, dunno

                local damage = CreateDamageInfo(self, self, forceVec, Vector(0,0,0), 100000000000, 0)
                player.TakeDamage(damage)
            } 

            return;
        }
    }
}

//-----------------------------------------------------------------------------
::Hooks.Add( getroottable(), "OnEntitySpawned", ConvertFuckingZombies, ContextFuckingZombies)

::specialzm <- true;

/************************************
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣏⡦⠤⣤⠽⠤⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠤⠣⢈⠇⠀⠁⣠⡿⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠂⠉⠀⠀⠀⠀⠀⢀⡀⠈⠀⠀⠈
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠀⠀⠀⠀⠀⡀⠀⡰⣯⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⡹⠂⢽⠎⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣀⠠⠄⠃⣴⠀⠀⢀⡠⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠈⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠈⠧⣢⠌⣁⠐⠋⠂⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
*////////////////////////////////////