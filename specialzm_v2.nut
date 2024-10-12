// Special Zombies by Ky1 + zeThijs

printcl(255,255,0,"Special Zombies VSCRIPT [version 1.8] enabled")

if ("specialzm" in getroottable())
	return;

//-----------------------------------------------------------------------------

local ContextFuckingZombies = "[Special Zombie VSCRIPT] by Ky1 + zeThijs";
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
Convars.RegisterConvar("sv_specialzm_burn_freq", "20", "Set how often special Burn ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_dog", "1", "Enable special Dog ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_dog_hp", "650", "Set health of special Dog ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_dog_freq", "25", "Set how often special Dog ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_bomb", "1", "Enable special Bomb ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_bomb_hp", "800", "Set health of special Bomb ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
Convars.RegisterConvar("sv_specialzm_bomb_freq", "15", "Set how often special Bomb ZM spawns", FCVAR_GAMEDLL + FCVAR_NOTIFY);

Convars.RegisterConvar("sv_specialzm_chainsaw", "1", "Enable special Chainsaw ZM", FCVAR_GAMEDLL + FCVAR_NOTIFY);
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
::health_dogC <- 650;
::health_bombC <- 800;
::health_sawC <- 4200;

::sv_specialzm_poisonC <- 1;
::sv_specialzm_fastC <- 1;
::sv_specialzm_burnC <- 1;
::sv_specialzm_dogC <- 1;
::sv_specialzm_bombC <- 1;
::sv_specialzm_sawC <- 1;
::SOUNDEFFECT_BMB <- "Weapon_TNT.Ignite" 
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


// Create a damage filter to negate fire damage for "BURN" zombies
local DMGFILTER_Fire = SpawnEntityFromTable("filter_damage_type",
{ 
    targetname  = "ANTIBURN",
    damagetype  = 8,
    Negated     = 1,
});


//-----------------------------------------------------------------------------

function ConvertFuckingZombies(entity)
{

    if (!Convars.GetBool("sv_specialzm"))
        return;

    //Is right class?
    if (!entity.IsNPC() || entity.GetClassname().slice(4,7) != "nmr") //npc_nmrih_
        return;
    
    // fucking skip bosses or important for objective or custom mfs
    // check name, modelname
    local modelname = entity.GetModelName()
    if ( entity.GetName() != "" || modelname == null || modelname.slice(7,10) != "nmr") //models/nmr_zombie/
        return; //not valid




    // Fucking Chances
    local chance_poison = RandomInt(1, 1000);
    local chance_fast = RandomInt(1, 1000);
    local chance_burn = RandomInt(1, 1000);
    local chance_dog = RandomInt(1, 1000);
    local chance_bomb = RandomInt(1, 1000);
    local chance_saw = RandomInt(1, 2000);


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

            AddThinkToEnt(entity, "ThinkFixGrab_poison");

            entity.ValidateScriptScope()
            local scope_poison = entity.GetScriptScope()

            scope_poison.ThinkFixGrab_poison <- function()
            { 
                // Schedule manipulation
                local schedule_poison = self.GetSchedule();

                if (schedule_poison == "SCHED_ZOMBIE_EAT_ENEMY")
                {

                    // Transform animation from grab to attack because the grab one is bugged (TO DO LIST: fix the actual model)
                    self.SetSchedule("SCHED_ZOMBIE_MELEE_ATTACK2");
                    printl("changing schedule to attack")
                }

                else if (schedule_poison == "SCHED_IDLE_STAND")
                {
                    // Switch to chase enemy schedule
                    self.SetSchedule("SCHED_ZOMBIE_CHASE_ENEMY");
                    printl("changing schedule to chase enemy");
                }
            }
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
            AddThinkToEnt(entity, "ThinkFixGrab_fast");

            entity.ValidateScriptScope()
            local scope_fast = entity.GetScriptScope()

            scope_fast.ThinkFixGrab_fast <- function()
            { 
                // Schedule manipulation
                local schedule_fastzm = self.GetSchedule();

                if (schedule_fastzm == "SCHED_ZOMBIE_EAT_ENEMY" || schedule_fastzm == "SCHED_ZOMBIE_GRAB_ENEMY")
                {

                    // Transform animation from grab to attack because the grab one is bugged (TO DO LIST: fix the actual model)
                    self.SetSchedule("SCHED_ZOMBIE_MELEE_ATTACK1");
                    printl("changing schedule to attack")
                }

                else if (schedule_fastzm == "SCHED_IDLE_STAND")
                {
                    // Switch to chase enemy schedule
                    self.SetSchedule("SCHED_ZOMBIE_CHASE_ENEMY");
                    printl("changing schedule to chase enemy");
                }
            }

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
            // 16896 spawnflag = fade corpse + immune to push
            //entity.__KeyValueFromInt("spawnflags", 16896);

            // Remove fucking tp to ground flag (512 = just fade corpse)
            entity.__KeyValueFromInt("spawnflags", 512);
            NetProps.SetPropInt(entity, "m_iHealth", ::health_bombC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_bombC);
            entity.KeyValueFromString("targetname", "bomberman")
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

                if (Entities.FindByClassnameNearest("player", self.GetOrigin(), 65) != null) 
                {
                    fuselit = fuselit + 0.5

                    // If first detection, set fuselit to 1.3 and play the bomb sound
                    if (fuselit == 0.5) {
                        fuselit = 1.3
                        self.EmitSound("Weapon_TNT.Ignite" )
                    }

                    if (fuselit >= 3)
                        Explode()
                } 
                else // Player exited range, reset fuselit and stop bomb sound
                    fuselit = 0

                return 0.5
            }

            scope.Explode <- function()
            {
                // Print for debugging
                // printl("Explosion triggered")

                local entOrigin = self.GetOrigin();
                entOrigin.z = (entOrigin.z + 20);

                // Trigger the explosion effects
                //Note: env_explosion will remove it self after 0.3s if  Repeatable  : [2] flag is not set
                local explode_ent_tntzm = SpawnEntityFromTable("env_explosion",                { 
                    origin          = entOrigin,
                    iMagnitude      = 6000, 
                    iRadiusOverride = 350
                });       
                EntFireByHandle(explode_ent_tntzm, "Explode", "", 0.00, null, null)


                local env_shake_tntzm = SpawnEntityFromTable("env_shake",                { 
                    origin      = entOrigin,
                    radius      = 1250,
                    amplitude   = 16,
                    duration    = 1,
                    frequency   = 3,
                    spawnflags  = 24
                });           

                // Apply screen shake or other effects
                EntFireByHandle(env_shake_tntzm, "StartShake", "", 0.00, null, null);
                EntFireByHandle(env_shake_tntzm, "Kill", "", 1.00, null, null);    
     
                EntFireByHandle(self, "Kill", "", 0.0, null, null)
            }

            return;
        }
    }

    if (Convars.GetBool("sv_specialzm_chainsaw"))
    {
        if (chance_saw <= ::specialzm_saw_freqC) 
        {
            
            // 16896 spawnflag = fade corpse + immune to push

            // Remove fucking tp to ground flag
            entity.__KeyValueFromInt("spawnflags", 512);
            NetProps.SetPropInt(entity, "m_iHealth", ::health_sawC);
            NetProps.SetPropInt(entity, "m_iMaxHealth", ::health_sawC);
            entity.KeyValueFromString("targetname", "chainsawman")
            entity.SetModelOverride(chainsaw);
            // Fix fucking zombie fall through floor
            local origin = entity.GetOrigin();
            origin.z = origin.z + z_fixup;
            entity.SetOrigin(origin);

            entity.PrecacheSoundScript(SOUNDEFFECT_SAWLOL)
            NameRND(entity)
            AddThinkToEnt(entity, "TurboKillThink");

            entity.ValidateScriptScope()
            local scope_saw = entity.GetScriptScope()

            scope_saw.soundEnabled <- false

            scope_saw.chainsound_ent <- null
            scope_saw.StartChainSound <- function()
            {
                local entOrigin = self.GetOrigin();
                entOrigin.z = (entOrigin.z + 20);

                chainsound_ent = Entities.CreateByClassname("ambient_fmod");
                chainsound_ent.SetOrigin(entOrigin);
                chainsound_ent.KeyValueFromString("parentname", "chainsawman")
                chainsound_ent.KeyValueFromInt("radius", 5000);
                chainsound_ent.KeyValueFromInt("spawnflags", 16);
                chainsound_ent.KeyValueFromInt("volume", 8);
                chainsound_ent.KeyValueFromString("SourceEntityName", self.GetName());  //sound automatically gets cleaned up if parent deds
                chainsound_ent.KeyValueFromString("message", ::SOUNDEFFECT_SAWLOL);
                EntFireByHandle(chainsound_ent, "PlaySound", "", 0.00, null, null);
            }

            scope_saw.StopChainSound <- function()
            {
                EntFireByHandle(chainsound_ent, "Kill", "", 0.00, null, null);    
            }

            scope_saw.TurboKillThink <- function()
            { 
                if (!soundEnabled) {
                    printl("attempting to enable sound")
                    soundEnabled = true
                    StartChainSound()
                }
                
                local schedule = self.GetSchedule();
                
                // Check if the current schedule is SCHED_SHOVE_REACT or SCHED_BIG_FLINCH
                if (schedule == "SCHED_SHOVE_REACT" || schedule == "SCHED_BIG_FLINCH") {

                    // Make zombie immune to flinch/push
                    self.SetSchedule("SCHED_ZOMBIE_CHASE_ENEMY");
                }

                // Check if the zombie has passed away (lol)
                if (!self.IsAlive()) {
                    StopChainSound(); // Stop the sound if the zombie is not alive
                    return 1.0; // Exit if the zombie is not alive
                }
                
                if (schedule != "SCHED_ZOMBIE_MELEE_ATTACK1") {
                    return 1.0;
                }

                local player = self.GetEnemy();
                
                if (!player.IsPlayer() || !player.IsAlive()) {
                    return 1.0;
                }

                // Create damage info for player hit by turbo zombie
                local forceVec = player.GetEyeForward();
                forceVec.x = forceVec.x * IMPULSEFORCE;
                forceVec.y = forceVec.y * IMPULSEFORCE;
                forceVec.z = forceVec.z * IMPULSEFORCE;

                // Inflictor, damager, force applied, dunno, damage, dunno
                local damage = CreateDamageInfo(self, self, forceVec, Vector(0,0,0), 100000000000, 0);
                player.TakeDamage(damage);

                return 1.0;
            }

            return;
        }
    }
}

/*
    Some features require names to function
    Sets a random name
*/
function NameRND(entityhandle)
{
    local name = entityhandle.GetName()

    //set random name:
    local ent = null
    local rnd = RandomInt(0, 30000)
    //keep trying until name not exists
    while( (ent = Entities.FindByName(null, name + rnd.tostring() ) ) != null )
        rnd = RandomInt(0, 30000)

    name = name + rnd.tostring()
    entityhandle.SetName(name)
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