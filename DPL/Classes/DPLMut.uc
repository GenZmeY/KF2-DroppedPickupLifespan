class DPLMut extends KFMutator;

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

public function AddMutator(Mutator Mut)
{
	if (Mut == Self) return;
	
	if (Mut.Class == Class)
		Mut.Destroy();
	else
		Super.AddMutator(Mut);
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
