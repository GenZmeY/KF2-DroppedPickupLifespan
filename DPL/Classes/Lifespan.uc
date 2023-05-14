class Lifespan extends Object
	config(DPL)
	abstract;

var public config int Weap;
var public config int Dosh;

public static function InitConfig(int Version, int LatestVersion, E_LogLevel LogLevel)
{
	`Log_TraceStatic();

	switch (Version)
	{
		case `NO_CONFIG:
			ApplyDefault(LogLevel);

		default: break;
	}

	if (LatestVersion != Version)
	{
		StaticSaveConfig();
	}
}

public static function Load(E_LogLevel LogLevel)
{
	`Log_TraceStatic();
}

protected static function ApplyDefault(E_LogLevel LogLevel)
{
	`Log_TraceStatic();

	default.Weap = int(class'KFDroppedPickup'.default.Lifespan);
	default.Dosh = int(class'KFDroppedPickup_Cash'.default.Lifespan);
}

defaultproperties
{

}
