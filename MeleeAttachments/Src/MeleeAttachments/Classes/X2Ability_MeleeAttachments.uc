//---------------------------------------------------------------------------------------
//  FILE:   X2Ability_MeleeAttachments.uc                                    
//
//	File created by Drakten-Huges , Edited by RustyDios	19/06/20	19:00
//	LAST UPDATED	21/06/20	10:00
//
//  ADDS Abilities for all attachments 
//
//---------------------------------------------------------------------------------------
class X2Ability_MeleeAttachments extends X2Ability config(MeleeAttachmentsSetup);

//Mobility bonus for having a light blade frame
var config int FRAME_BSC_BONUS;
var config int FRAME_ADV_BONUS;
var config int FRAME_SUP_BONUS;

//Smaller detection radius when concealed by having a "silencing" sheath
var config float SHEATH_BSC_DETECT;
var config float SHEATH_ADV_DETECT;
var config float SHEATH_SUP_DETECT;

//ignores increasing amounts of armor
var config int RAPIER_BSC_PIERCE;
var config int RAPIER_ADV_PIERCE;
var config int RAPIER_SUP_PIERCE;

//crossguards: +dmg to confused, disoriented, stunned, robotstunned, bound, frozen and dazed
var config int BSC_XG_DMG;
var config int ADV_XG_DMG;
var config int SUP_XG_DMG;

//coatings: +dmg to burning, acid, poisoned and bleeding
var config int BSC_COAT_BONUS;
var config int ADV_COAT_BONUS;
var config int SUP_COAT_BONUS;

//hilt flourishes motivate allies for +aim on the same turn you get a kill
var config float BSC_HILT_RADIUS;
var config int BSC_HILT_AIM_BONUS;
var config int BSC_HILT_USES;
var config float ADV_HILT_RADIUS;
var config int ADV_HILT_AIM_BONUS;
var config int ADV_HILT_USES;
var config float SUP_HILT_RADIUS;
var config int SUP_HILT_AIM_BONUS;
var config int SUP_HILT_USES;

//reflectors return a small amount of dmg back to attacker in a defined range
var config int BSC_REFLECTOR_RANGE;
var config int ADV_REFLECTOR_RANGE;
var config int SUP_REFLECTOR_RANGE;
var config int BSC_REF_DMG;
var config int ADV_REF_DMG;
var config int SUP_REF_DMG;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(FrameUpgrade('FrameBscMob', default.FRAME_BSC_BONUS));
	Templates.AddItem(FrameUpgrade('FrameAdvMob', default.FRAME_ADV_BONUS));
	Templates.AddItem(FrameUpgrade('FrameSupMob', default.FRAME_SUP_BONUS));

	Templates.AddItem(SheathUpgrade('SheathBscDet', default.SHEATH_BSC_DETECT));
	Templates.AddItem(SheathUpgrade('SheathAdvDet', default.SHEATH_ADV_DETECT));
	Templates.AddItem(SheathUpgrade('SheathSupDet', default.SHEATH_SUP_DETECT));

	Templates.AddItem(RapierUpgrade('RapierBscPierce', default.RAPIER_BSC_PIERCE));
	Templates.AddItem(RapierUpgrade('RapierAdvPierce', default.RAPIER_ADV_PIERCE));
	Templates.AddItem(RapierUpgrade('RapierSupPierce', default.RAPIER_SUP_PIERCE));

	Templates.AddItem(PommelUpgrade('PommelBscAbility'));
	Templates.AddItem(PommelUpgrade('PommelAdvAbility'));
	Templates.AddItem(PommelUpgrade('PommelSupAbility'));

	Templates.AddItem(GuardUpgrade('GuardBscAbility', default.BSC_XG_DMG));
	Templates.AddItem(GuardUpgrade('GuardAdvAbility', default.ADV_XG_DMG));
	Templates.AddItem(GuardUpgrade('GuardSupAbility', default.SUP_XG_DMG));

	Templates.AddItem(CoatingUpgrade('CoatingBscAbility', default.BSC_COAT_BONUS));
	Templates.AddItem(CoatingUpgrade('CoatingAdvAbility', default.ADV_COAT_BONUS));
	Templates.AddItem(CoatingUpgrade('CoatingSupAbility', default.SUP_COAT_BONUS));

	Templates.AddItem(HiltUpgrade('BscHiltFlourish', default.BSC_HILT_RADIUS, default.BSC_HILT_AIM_BONUS, default.BSC_HILT_USES));
	Templates.AddItem(HiltUpgrade('AdvHiltFlourish', default.ADV_HILT_RADIUS, default.ADV_HILT_AIM_BONUS, default.ADV_HILT_USES));
	Templates.AddItem(HiltUpgrade('SupHiltFlourish', default.SUP_HILT_RADIUS, default.SUP_HILT_AIM_BONUS, default.SUP_HILT_USES));

	Templates.AddItem(ReflectorUpgrade('ReflectorBscAbility', 'BasicReflectorAttack'));
	Templates.AddItem(ReflectorUpgrade('ReflectorAdvAbility', 'AdvancedReflectorAttack'));
	Templates.AddItem(ReflectorUpgrade('ReflectorSupAbility', 'SuperiorReflectorAttack'));
		Templates.AddItem(MeleeReflectorAttack('BasicReflectorAttack', default.BSC_REFLECTOR_RANGE, default.BSC_REF_DMG));
		Templates.AddItem(MeleeReflectorAttack('AdvancedReflectorAttack', default.ADV_REFLECTOR_RANGE, default.ADV_REF_DMG));
		Templates.AddItem(MeleeReflectorAttack('SuperiorReflectorAttack', default.SUP_REFLECTOR_RANGE, default.SUP_REF_DMG));
	
	return Templates;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate FrameUpgrade(name TemplateName, int iBonus)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Battlelord";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, iBonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, iBonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SheathUpgrade(name TemplateName, float fBonus)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Battlelord";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, fBonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate RapierUpgrade(name TemplateName, int iBonus)
{
	local X2AbilityTemplate             Template;
	local X2Effect_RapierPierce         Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.bDisplayInUITacticalText = false;

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_RapierPierce';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.Pierce = iBonus;
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate PommelUpgrade(name TemplateName)
{
    local X2AbilityTemplate                 Template;
    local X2Effect_PommelBladestorm		    Effect;

    `CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
    Template.Hostility = eHostility_Neutral;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    
    Effect = new class'X2Effect_PommelBladestorm';
    Effect.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate GuardUpgrade(name TemplateName, int iBonus)
{
	local X2AbilityTemplate				Template;
	local X2Effect_GuardImpaired		DamageEffect;

	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
		
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_GuardImpaired';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = iBonus;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	

	return Template;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate CoatingUpgrade(name TemplateName, int iBonus)
{
	local X2AbilityTemplate				Template;
	local X2Effect_CoatingImpaired		DamageEffect;

	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
		
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_CoatingImpaired';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.Bonus = iBonus;
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	

	return Template;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate HiltUpgrade(name TemplateName, float fRadius, int iBonus, int iUses)
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_PersistentStatChange		StatChangeEffect;
	local X2Condition_UnitProperty			FriendCondition;
	local X2Condition_UnitValue				ValueCondition;
	local X2Effect_IncrementUnitValue		IncrementEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	//UI stuff (don't show anything except buff in F1 on receiving allies)
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///MeleeAttachMKII.warrior";
	//AddIconPassive(Template);
	
	//always "hits" but only activates on kills
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	//range of ability
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = fRadius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//ability activates on kills by the soldier using a melee weapon with the correct attachment		
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'KillMail';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = DraktenMeleeListener;
	EventListener.ListenerData.Priority = 40;
	Template.AbilityTriggers.AddItem(EventListener);

	//don't give a boost to enemy (duh) or to robots (they seem unimpressed by panache)
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FriendCondition.ExcludeRobotic = true;

	//apply the effect: +aim until the end of XCom's turn, can stack
	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	//BuildPersistentEffect(int _iNumTurns, optional bool _bInfiniteDuration=false, optional bool _bRemoveWhenSourceDies=true, optional bool _bIgnorePlayerCheckOnTick=false, optional GameRuleStateChange _WatchRule=eGameRule_TacticalGameStart )
	StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, iBonus);
	//StatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, 1); //using this to debug for now
	//(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, TemplateIconImage, bDisplayInUI,, Template.AbilitySourceName);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	StatChangeEffect.EffectName = 'HiltFlourish';
	StatChangeEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect( StatChangeEffect );
	Template.AddMultiTargetEffect( StatChangeEffect );
	
	//Limited number of uses per mission
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('Hilt_Uses', iUses, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    // Create an effect that will increment the unit value
	IncrementEffect = new class'X2Effect_IncrementUnitValue';
	IncrementEffect.UnitName = 'Hilt_Uses';
	IncrementEffect.NewValueToSet = 1; 
	IncrementEffect.CleanupType = eCleanup_BeginTactical;
    Template.AddTargetEffect(IncrementEffect);

	//next line is supposed to show a flyover, don't think it works
	Template.bShowActivation = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization; // NO Visibility on purpose! the attack already happened!
	
	Template.FrameAbilityCameraType = eCameraFraming_Never;

	return Template;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate ReflectorUpgrade(name TemplateName, name BonusAbilityName)
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive(TemplateName, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ReflectShot", , 'eAbilitySource_Item');
	Template.AdditionalAbilities.AddItem(BonusAbilityName);
	Template.CustomFireAnim = 'HL_Reflect';

	return Template;
}

static function X2AbilityTemplate MeleeReflectorAttack(name TemplateName, int iRange, int iDamage)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_UnitProperty			TargetCondition;
	local X2AbilityTrigger_EventListener	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.MergeVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.ReflectShotMergeVisualization;
	Template.CustomFireAnim = 'HL_ReflectFire';
	Template.CustomFireKillAnim = 'HL_ReflectFire';
    
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;
    Template.bDontDisplayInAbilitySummary = true;
    
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bReactionFire = false;
	StandardMelee.bGuaranteedHit = true;
	StandardMelee.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardMelee;

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = DraktenReflectorListener;
	Template.AbilityTriggers.AddItem(Trigger);

	// Target Conditions
	
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.RequireWithinMinRange = true;
	TargetCondition.WithinMinRange = 2 * class'XComWorldData'.const.WORLD_StepSize;
	TargetCondition.RequireWithinRange = true;
	TargetCondition.WithinRange = iRange * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Shooter Conditions
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bBypassSustainEffects=true;
	WeaponDamageEffect.bIgnoreBaseDamage=true;
	Template.bAllowBonusWeaponEffects = false;
	WeaponDamageEffect.EffectDamageValue.Damage = iDamage;
	WeaponDamageEffect.EffectDamageValue.PlusOne = 50;
	WeaponDamageEffect.EffectDamageValue.Pierce = 99;
	WeaponDamageEffect.EffectDamageValue.DamageType = 'Melee';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.bSkipMoveStop = true;
	
	// Voice events
	
	Template.SourceMissSpeech = 'SwordMiss';

	// Misc

	Template.SuperConcealmentLoss = 0;
	Template.ChosenActivationIncreasePerUse = 0;
	Template.LostSpawnIncreasePerUse = 0;
	Template.ConcealmentRule = eConceal_Always;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//	LISTENERS
/////////////////////////////////////////////////////////////////////////////////////////////////////

static function EventListenerReturn DraktenReflectorListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState						NewGameState;
	local XComGameState_Unit				UnitState, SourceUnit; //UnitState is the dude being shot at, SourceUnit is the shooter
	//local bool								IsAdventProjectile;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	UnitState = XComGameState_Unit(EventSource);

	//IsAdventProjectile = (UnitState.DamageResults[UnitState.DamageResults.Length - 1].DamageTypes.Find('Projectile_MagAdvent') != INDEX_NONE);
	//`LOG("did advent fire at me: " $ IsAdventProjectile);

	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		//the following condition is to make sure we only reflect projectile damage types
		if (UnitState.DamageResults[UnitState.DamageResults.Length - 1].DamageTypes.Find('Projectile_MagAdvent') != INDEX_NONE || UnitState.DamageResults[UnitState.DamageResults.Length - 1].DamageTypes.Find('Projectile_BeamAlien') != INDEX_NONE || UnitState.DamageResults[UnitState.DamageResults.Length - 1].DamageTypes.Find('Projectile_BeamAvatar') != INDEX_NONE)
	
		{
			SourceUnit = XComGameState_Unit(EventSource);
		
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Drakten Reflect Data");
		
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceUnit.ObjectID));
		
			UnitState.ReflectedAbilityContext = AbilityContext;
		
			`TACTICALRULES.SubmitGameState(NewGameState);

			class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'BasicReflectorAttack', AbilityContext.InputContext.SourceObject);
			class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'AdvancedReflectorAttack', AbilityContext.InputContext.SourceObject);
			class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(SourceUnit.GetReference(), 'SuperiorReflectorAttack', AbilityContext.InputContext.SourceObject);
		}
	}

	return ELR_NoInterrupt;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

//killmail 	EventManager.TriggerEvent('KillMail', self, Killer, NewGameState);
static function EventListenerReturn DraktenMeleeListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{	
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState_Ability				AbilityState;
	local XComGameState_Item				SourceWeapon;
	local array<name>						AllowedTypes;
	local array<name>						AttachedWeaponUpgrades;
	local XComGameState_Unit				KilledUnit;
	//local bool								correctkiller;
	//local bool								correctupgrade;
	//local bool								correctweaponcat;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());	
	AbilityState = XComGameState_Ability(CallbackData);
	SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
	AttachedWeaponUpgrades = SourceWeapon.GetMyWeaponUpgradeTemplateNames();
	KilledUnit = XComGameState_Unit(EventData);

	AllowedTypes = class'X2Item_MeleeAttachments'.default.AllowedTypes; //function added by RUSTYDIOS

	/*correctkiller = (AbilityState.OwnerStateObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID);
	`LOG("is the killer the only one: " $ correctkiller);
	correctupgrade = (AttachedWeaponUpgrades.Find('Hilt_Bsc') != INDEX_NONE);
	`LOG("is the upgrade installed: " $ correctupgrade);
	correctweaponcat = (SourceWeapon != None && default.AllowedWeaponCategories.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE);
	`LOG("is the weaponcat allowed: " $ correctweaponcat);*/
	if (KilledUnit.GetTeam() != eTeam_TheLost) //won't fire on Lost kills
	{
		if (AbilityState.OwnerStateObject == AbilityContext.InputContext.SourceObject) //making sure the ability only fires when the killer kills
		{
			if (AttachedWeaponUpgrades.Find('Hilt_Bsc') != INDEX_NONE || AttachedWeaponUpgrades.Find('Hilt_Adv') != INDEX_NONE || AttachedWeaponUpgrades.Find('Hilt_Sup') != INDEX_NONE) // making sure the correct attachments are installed
			{
				if (SourceWeapon != None && AllowedTypes.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE) //making sure the kill comes from the correct type weapon
				{
					AbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.SourceObject, false); //if all conditions pass, ability fires
				}
			}
		}
	}
	return ELR_NoInterrupt;
}
