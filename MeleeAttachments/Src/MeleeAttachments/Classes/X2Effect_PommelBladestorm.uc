//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_PommelBladestorm.uc                                    
//
//	File created by Drakten-Huges , Edited by RustyDios	19/06/20	19:00
//	LAST UPDATED	21/06/20	10:00
//
//  ADDS Damage for bladestorm based on pommel attachments
//
//---------------------------------------------------------------------------------------
class X2Effect_PommelBladestorm extends X2Effect_Persistent config(MeleeAttachmentsSetup);

//pommels increase bladestorm damage
var config int POMMEL_BSC_DMG;
var config int POMMEL_ADV_DMG;
var config int POMMEL_SUP_DMG;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
    local X2AbilityTemplate                    Template;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local name TemplateName;

    Template = AbilityState.GetMyTemplate();
	TemplateName = Template.DataName;

    if (Template != none)
    {
        StandardAim = X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc);

        if (StandardAim != none && StandardAim.bReactionFire && StandardAim.bMeleeAttack)
        {
			switch(TemplateName)
			{
				case 'PommelBscAbility':
					return default.POMMEL_BSC_DMG; 

				case 'PommelAdvAbility':
					return default.POMMEL_ADV_DMG; 

				case 'PommelSupAbility':
					return default.POMMEL_SUP_DMG;

				default:
					return 0;
					break; 
			}
        }
    }
    return 0; 
}