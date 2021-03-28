//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_RapierPierce.uc                                    
//
//	File created by Drakten-Huges 	19/06/20	19:00
//	LAST UPDATED					21/06/20	10:00
//
//  ADDS Pierce Damage to melee weapons
//
//---------------------------------------------------------------------------------------
class X2Effect_RapierPierce extends X2Effect_Persistent;

var int Pierce;

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData) 
{
	// Attack must come from correct SourceWeapon
		if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
			{
				return 0;
			}
	return Pierce;
	
}

DefaultProperties
{
	bDisplayInSpecialDamageMessageUI = true
}