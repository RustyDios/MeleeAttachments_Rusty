//---------------------------------------------------------------------------------------
//  FILE:   X2Item_MeleeAttachments.uc                                    
//
//	File created by Drakten-Huges , Edited by RustyDios	19/06/20	19:00
//	LAST UPDATED	21/06/20	10:00
//
//  ADDS Attachments for melee weapons, code help given by RustyDios
//
//---------------------------------------------------------------------------------------
class X2Item_MeleeAttachments extends X2Item_DefaultUpgrades config(MeleeAttachmentsSetup);

var config array<name> AllowedTypes;
var config int BSC_SELLVALUE;
var config int ADV_SELLVALUE;
var config int SUP_SELLVALUE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	//Create upgrades ... name, ability, sell value, tier
	Items.AddItem(CreateFrameUpgrade('Frame_Bsc','FrameBscMob', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateFrameUpgrade('Frame_Adv','FrameAdvMob', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateFrameUpgrade('Frame_Sup','FrameSupMob', default.SUP_SELLVALUE,2));

	Items.AddItem(CreateSheathUpgrade('Sheath_Bsc','SheathBscDet', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateSheathUpgrade('Sheath_Adv','SheathAdvDet', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateSheathUpgrade('Sheath_Sup','SheathSupDet', default.SUP_SELLVALUE,2));

	Items.AddItem(CreateRapierUpgrade('Rapier_Bsc','RapierBscPierce', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateRapierUpgrade('Rapier_Adv','RapierAdvPierce', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateRapierUpgrade('Rapier_Sup','RapierSupPierce', default.SUP_SELLVALUE,2));

	Items.AddItem(CreatePommelUpgrade('Pommel_Bsc','PommelBscAbility', default.BSC_SELLVALUE,0));
	Items.AddItem(CreatePommelUpgrade('Pommel_Adv','PommelAdvAbility', default.ADV_SELLVALUE,1));
	Items.AddItem(CreatePommelUpgrade('Pommel_Sup','PommelSupAbility', default.SUP_SELLVALUE,2));

	Items.AddItem(CreateXGuardUpgrade('XGuard_Bsc','GuardBscAbility', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateXGuardUpgrade('XGuard_Adv','GuardAdvAbility', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateXGuardUpgrade('XGuard_Sup','GuardSupAbility', default.SUP_SELLVALUE,2));

	Items.AddItem(CreateCoatingUpgrade('Coating_Bsc','CoatingBscAbility', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateCoatingUpgrade('Coating_Adv','CoatingAdvAbility', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateCoatingUpgrade('Coating_Sup','CoatingSupAbility', default.SUP_SELLVALUE,2));

	Items.AddItem(CreateReflectorUpgrade('Reflector_Bsc','ReflectorBscAbility', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateReflectorUpgrade('Reflector_Adv','ReflectorAdvAbility', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateReflectorUpgrade('Reflector_Sup','ReflectorSupAbility', default.SUP_SELLVALUE,2));

	Items.AddItem(CreateHiltUpgrade('Hilt_Bsc','BscHiltFlourish', default.BSC_SELLVALUE,0));
	Items.AddItem(CreateHiltUpgrade('Hilt_Adv','AdvHiltFlourish', default.ADV_SELLVALUE,1));
	Items.AddItem(CreateHiltUpgrade('Hilt_Sup','SupHiltFlourish', default.SUP_SELLVALUE,2));

	return Items;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////Frames +mobility attachments//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreateFrameUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	//image and gold mesh when dropped on the ground as loot
	Template.strImage = "img:///MeleeAttachMKII.Inventory.frame";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	//ensure they can't be equipped with 'themselves' in different slots
	Template.MutuallyExclusiveUpgrades.AddItem('Frame_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Frame_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Frame_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	//Add a default - not required!
	//Template.AddUpgradeAttachment('', '', "", "", '', , "", "img:///MeleeAttachMKII.Inventory.frame", "img:///MeleeAttachMKII.Icons.frame");

	//Add the setups - moved to config! ... for future compatibility ... kept here for history
	//SetupUpgradeAttachments(Template, "img:///MeleeAttachMKII.Inventory.frame", "img:///MeleeAttachMKII.Icons.frame");

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////sheaths, makes detection radius smaller/////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreateSheathUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.Sheath";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.MutuallyExclusiveUpgrades.AddItem('Sheath_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Sheath_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Sheath_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////rapiers blade point ignores increasing amounts of armor///////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreateRapierUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.rapier";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.MutuallyExclusiveUpgrades.AddItem('Rapier_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Rapier_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Rapier_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////pommel buffs bladestorm/////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreatePommelUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.pommel";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.MutuallyExclusiveUpgrades.AddItem('Pommel_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Pommel_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Pommel_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
////crossguards: +dmg to confused, disoriented, stunned, robotstunned, bound, frozen and dazed////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreateXGuardUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.guard";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.MutuallyExclusiveUpgrades.AddItem('XGuard_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('XGuard_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('XGuard_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////coatings: +dmg to burning, acid, poisoned and bleeding/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreateCoatingUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.coating";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
	Template.MutuallyExclusiveUpgrades.AddItem('Coating_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Coating_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Coating_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////reflectors return a small amount of dmg back to attacker in a defined range////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function X2DataTemplate CreateReflectorUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.reflector";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
	Template.MutuallyExclusiveUpgrades.AddItem('Reflector_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Reflector_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Reflector_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
////////////hilt flourishes motivate allies for +aim on the same turn you get a kill//////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
static function X2DataTemplate CreateHiltUpgrade(name TemplateName, name BonusAbilityName, int SellValue, int ItemTier)
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, TemplateName);

	Template.strImage = "img:///MeleeAttachMKII.Inventory.hilt";
	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.WeapFragmentA';

	Template.CanBeBuilt = false;
	Template.TradingPostValue = SellValue;
	Template.Tier = ItemTier;
	Template.MaxQuantity = 1;
	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
	Template.MutuallyExclusiveUpgrades.AddItem('Hilt_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('Hilt_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('Hilt_Sup');

	Template.BonusAbilities.AddItem(BonusAbilityName);

	Template.CanApplyUpgradeToWeaponFn = CanApplyToSword;

	return Template;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////this function to only apply these attachments to weaponcat sword////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

static function bool CanApplyToSword(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
    local X2WeaponTemplate WeaponTemplate;

    WeaponTemplate = X2WeaponTemplate(Weapon.GetMyTemplate());

  if (WeaponTemplate != none && (default.AllowedTypes.Find(WeaponTemplate.WeaponCat) != INDEX_NONE) )
  {
    return class'X2Item_DefaultUpgrades'.static.CanApplyUpgradeToWeapon(UpgradeTemplate, Weapon, SlotIndex);
  }

  return false;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////this function to make sure incompatible upgrades are not equipped///////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
/*
static function bool CanApplyUpgradeToWeapon(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.DataName) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}
*/
/*
static function X2DataTemplate SetupUpgradeAttachments(out X2WeaponUpgradeTemplate Template, string InventoryIconName, string InventoryCategoryIcon)
{
	//AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	//Base Game Sword, TLE, DLC
	Template.AddUpgradeAttachment('', '', "", "", 'Sword_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Sword_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Sword_BM', , "", InventoryIconName, InventoryCategoryIcon);

	Template.AddUpgradeAttachment('', '', "", "", 'TLE_Sword_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'TLE_Sword_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'TLE_Sword_BM', , "", InventoryIconName, InventoryCategoryIcon);

	Template.AddUpgradeAttachment('', '', "", "", 'AlienHunterAxe_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'AlienHunterAxe_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'AlienHunterAxe_BM', , "", InventoryIconName, InventoryCategoryIcon);

	Template.AddUpgradeAttachment('', '', "", "", 'AlienHunterAxeThrown_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'AlienHunterAxeThrown_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'AlienHunterAxeThrown_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//The Axe Mod
	Template.AddUpgradeAttachment('', '', "", "", 'Axe_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Axe_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Axe_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'ThrowingAxe_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'ThrowingAxe_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'ThrowingAxe_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//Scimitar from Celatid Alien mod
	Template.AddUpgradeAttachment('', '', "", "", 'Scimitar_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Scimitar_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Scimitar_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//Armored Viper mod's Vorpal Blade
	Template.AddUpgradeAttachment('', '', "", "", 'XCOM_VorpalBlade', , "", InventoryIconName, InventoryCategoryIcon);

	//glaive mod
	Template.AddUpgradeAttachment('', '', "", "", 'Glaive_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Glaive_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Glaive_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//LW2 Combat Knives. Why not?
	Template.AddUpgradeAttachment('', '', "", "", 'CombatKnife_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'CombatKnife_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'CombatKnife_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//Katanas from Musashi
	Template.AddUpgradeAttachment('', '', "", "", 'Katana_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Katana_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Katana_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Wakizashi_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Wakizashi_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Wakizashi_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Ninjato_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Ninjato_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Ninjato_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'VortexNinjato_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'VortexWakizashi_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'VortexKatana_BM', , "", InventoryIconName, InventoryCategoryIcon);
	
	//Genji weapons
	Template.AddUpgradeAttachment('', '', "", "", 'GenjiKunai_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'GenjiKunai_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'GenjiKunai_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'RM_Wakizashi_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'RM_Wakizashi_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'RM_Wakizashi_BM', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Odachi_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Odachi_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Odachi_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//NieR: Automata - 2B's Outfit mod
	Template.AddUpgradeAttachment('', '', "", "", 'NierSwords_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'NierSwords_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'NierSwords_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//Metal Gear Raiden Customization Pack
	Template.AddUpgradeAttachment('', '', "", "", 'HFBlade_CV', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'HFBlade_MG', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'HFBlade_BM', , "", InventoryIconName, InventoryCategoryIcon);

	//MGR Jetstream Sam Squadmate swords
	Template.AddUpgradeAttachment('', '', "", "", 'Murasama_Conv', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Murasama_Mag', , "", InventoryIconName, InventoryCategoryIcon);
	Template.AddUpgradeAttachment('', '', "", "", 'Murasama_Beam', , "", InventoryIconName, InventoryCategoryIcon);

}
*/
