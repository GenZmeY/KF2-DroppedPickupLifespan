// This file is part of Dropped Pickup Lifespan.
// Dropped Pickup Lifespan - a mutator for Killing Floor 2.
//
// Copyright (C) 2022, 2024 GenZmeY (mailto: genzmey@gmail.com)
//
// Dropped Pickup Lifespan is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Dropped Pickup Lifespan is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with Dropped Pickup Lifespan. If not, see <https://www.gnu.org/licenses/>.

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
