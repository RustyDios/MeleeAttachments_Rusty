//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_GuardImpaired.uc                                    
//
//	File created by Drakten-Huges , Edited by RustyDios	19/06/20	19:00
//	LAST UPDATED	21/06/20	10:00
//
//  ADDS Damage for units hit in melee that are impaired
//
//---------------------------------------------------------------------------------------
class X2Effect_GuardImpaired extends X2Effect_Persistent;

var int Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(TargetDamageable);

	if (
		AbilityState.IsMeleeAbility() &&
		TargetUnit != none &&
        AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef && 
		( 
		TargetUnit.IsUnitAffectedByEffectName('Bound') ||
		TargetUnit.IsUnitAffectedByEffectName('Confused') || 
		TargetUnit.IsUnitAffectedByEffectName('Disoriented') || 
		TargetUnit.IsUnitAffectedByEffectName('Stunned') || 
		TargetUnit.IsUnitAffectedByEffectName('RoboticStunned') || 
 
		TargetUnit.IsUnitAffectedByEffectName('Dazed') )
		//TargetUnit.IsUnitAffectedByEffectName('Shattered') || 
		//TargetUnit.IsUnitAffectedByEffectName('Berserk') ||
		//TargetUnit.IsUnitAffectedByEffectName('Obsessed') || 
		//TargetUnit.IsUnitAffectedByEffectName('Panicked' ) || 

		//TargetUnit.IsUnitAffectedByEffectName('BleedingOut') || 
		//TargetUnit.IsUnitAffectedByEffectName('Unconscious') ||
		 
		//TargetUnit.IsUnitAffectedByEffectName('Freeze') || 
		//TargetUnit.IsUnitAffectedByEffectName('Burning') || 
		//TargetUnit.IsUnitAffectedByEffectName('Acid') || 
		//TargetUnit.IsUnitAffectedByEffectName('Poisoned') || 
		//TargetUnit.IsUnitAffectedByEffectName('Bleeding') ||
		
		)
    { 
         return Bonus;
    }
    return 0;
}
