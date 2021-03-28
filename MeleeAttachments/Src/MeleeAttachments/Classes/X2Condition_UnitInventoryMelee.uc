//---------------------------------------------------------------------------------------
//  FILE:   X2Condition_UnitInvetoryMelee.uc                                    
//
//	File created by Drakten-Huges , Edited by RustyDios	19/06/20	19:00
//	LAST UPDATED	21/06/20	10:00
//
//  Like UnitInventory, but checks for melee weapons
//
//---------------------------------------------------------------------------------------
class X2Condition_UnitInventoryMelee extends X2Condition;

var() array<EInventorySlot> RelevantSlots;
var() name ExcludeWeaponCategory;
var() name RequireWeaponCategory;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item RelevantItem;
	local XComGameState_Unit UnitState;
	local X2WeaponTemplate WeaponTemplate;
	local EInventorySlot Slot;
	local bool bFoundRequiredCategory;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	foreach RelevantSlots(Slot)
	{
		RelevantItem = UnitState.GetItemInSlot(Slot);
		if (RelevantItem != none)
			WeaponTemplate = X2WeaponTemplate(RelevantItem.GetMyTemplate());

		if (ExcludeWeaponCategory != '')
		{		
			if (WeaponTemplate != none && WeaponTemplate.WeaponCat == ExcludeWeaponCategory)
				return 'AA_WeaponIncompatible';
		}
		if (RequireWeaponCategory != '')
		{
			if (RelevantItem != none || X2WeaponTemplate(RelevantItem.GetMyTemplate()).WeaponCat == RequireWeaponCategory)
				bFoundRequiredCategory = true;
		}
	}
	if (!bFoundRequiredCategory)
	{
		return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}