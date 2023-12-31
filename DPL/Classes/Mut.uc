class Mut extends KFMutator;

var private DPL DPL;

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	Super.PreBeginPlay();

	if (WorldInfo.NetMode == NM_Client) return;

	foreach WorldInfo.DynamicActors(class'DPL', DPL)
	{
		break;
	}

	if (DPL == None)
	{
		DPL = WorldInfo.Spawn(class'DPL');
	}

	if (DPL == None)
	{
		`Log_Base("FATAL: Can't Spawn 'DPL'");
		SafeDestroy();
	}
}

public function AddMutator(Mutator M)
{
	if (M == Self) return;

	if (M.Class == Class)
		Mut(M).SafeDestroy();
	else
		Super.AddMutator(M);
}

public function bool CheckRelevance(Actor A)
{
	local bool Relevance;

	Relevance = Super.CheckRelevance(A);
	if (Relevance)
	{
		DPL.ModifyLifespan(A);
	}

	return Relevance;
}

defaultproperties
{

}
