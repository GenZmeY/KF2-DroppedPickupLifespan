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
