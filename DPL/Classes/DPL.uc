class DPL extends Info
	config(DPL);

const LatestVersion = 1;

const CfgLifespan = class'Lifespan';

enum E_PickupType
{
	PT_NotPickup,
	PT_Weapon,
	PT_Dosh,
	PT_Carryable
};

var private config int        Version;
var private config E_LogLevel LogLevel;

public simulated function bool SafeDestroy()
{
	`Log_Trace();
	
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	`Log_Trace();
	
	if (WorldInfo.NetMode == NM_Client)
	{
		`Log_Fatal("NetMode:" @ WorldInfo.NetMode);
		SafeDestroy();
		return;
	}
	
	Super.PreBeginPlay();
	
	Init();
}

private function Init()
{
	`Log_Trace();
	
	if (Version == `NO_CONFIG)
	{
		LogLevel = LL_Info;
		SaveConfig();
	}
	
	CfgLifespan.static.InitConfig(Version, LatestVersion, LogLevel);
	
	switch (Version)
	{
		case `NO_CONFIG:
			`Log_Info("Config created");
			
		case MaxInt:
			`Log_Info("Config updated to version" @ LatestVersion);
			break;
			
		case LatestVersion:
			`Log_Info("Config is up-to-date");
			break;
			
		default:
			`Log_Warn("The config version is higher than the current version (are you using an old mutator?)");
			`Log_Warn("Config version is" @ Version @ "but current version is" @ LatestVersion);
			`Log_Warn("The config version will be changed to" @ LatestVersion);
			break;
	}
	
	if (LatestVersion != Version)
	{
		Version = LatestVersion;
		SaveConfig();
	}

	if (LogLevel == LL_WrongLevel)
	{
		LogLevel = LL_Info;
		`Log_Warn("Wrong 'LogLevel', return to default value");
		SaveConfig();
	}
	`Log_Base("LogLevel:" @ LogLevel);
	
	CfgLifespan.static.Load(LogLevel);
	
	`Log_Info("Initialized");
}

public function ModifyLifespan(Actor A)
{
	`Log_Trace();
	
	switch (PickupType(A))
	{
		case PT_Dosh:
			if (CfgLifespan.default.Dosh > 0)
			{
				`Log_Debug("Modify dosh lifespan:" @ int(A.Lifespan) @ "->" @ CfgLifespan.default.Dosh);
				A.Lifespan = float(CfgLifespan.default.Dosh);
			}
			else
			{
				`Log_Debug("Skip modify dosh lifespan");
			}
			break;
			
		case PT_Weapon:
			if (CfgLifespan.default.Weap > 0)
			{
				`Log_Debug("Modify weapon lifespan:" @ int(A.Lifespan) @ "->" @ CfgLifespan.default.Weap);
				A.Lifespan = float(CfgLifespan.default.Weap);
			}
			else
			{
				`Log_Debug("Skip modify weapon lifespan");
			}
			break;
		
		case PT_Carryable:
		case PT_NotPickup:
		default:
			break;
	}
}

private function E_PickupType PickupType(Actor A)
{
	`Log_Trace();
	
	if (KFDroppedPickup_Cash(A) != None)
	{
		return PT_Dosh;
	}
	else if (KFDroppedPickup_Carryable(A) != None)
	{
		return PT_Carryable;
	}
	else if (KFDroppedPickup(A) != None)
	{
		return PT_Weapon;
	}
	
	return PT_NotPickup;
}

defaultproperties
{

}
