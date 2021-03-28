//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_MeleeAttachments.uc                                    
//
//	File created by Drakten-Huges , Edited by RustyDios	19/06/20	19:00
//	LAST UPDATED	21/06/20	10:00
//
//  ADDS Attachments for melee weapons, code help given by RustyDios
//
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_MeleeAttachments extends X2DownloadableContentInfo config (MeleeAttachments);

//define a new structure type for configuring images for weapons
//taken from MERC/ EU Plasma weapons
struct WeaponAttachment 
{
	var string Type;
	var name AttachSocket;
	var name UIArmoryCameraPointTag;
	var string MeshName;
	var string ProjectileName;
	var name MatchWeaponTemplate;
	var bool AttachToPawn;
	var string IconName;
	var string InventoryIconName;
	var string InventoryCategoryIcon;
	var name AttachmentFn;
};

//grab some config stuffs 
var config array<WeaponAttachment> NewAttachmentsSetups;
var config bool bEnableLogging;

var config array<LootTable> LootTables, LootEntry;

//base game stuff to get the mod to 'work'
static event OnLoadedSavedGame(){}
static event InstallNewCampaign(XComGameState StartState){}

//OPTC functions
static event OnPostTemplatesCreated()
{
	AddNewAttachmentsSetups();

	AddLootTables();
}

//Cycle all created item templates from X2Item_MeleeAttachments and add the setups from the config files
static function AddNewAttachmentsSetups()
{
	local array<name> AttachmentTypes;
	local name AttachmentType;
	
	//Frames
	AttachmentTypes.AddItem('Frame_Bsc');
	AttachmentTypes.AddItem('Frame_Adv');
	AttachmentTypes.AddItem('Frame_Sup');

	//Sheaths
	AttachmentTypes.AddItem('Sheath_Bsc');
	AttachmentTypes.AddItem('Sheath_Adv');
	AttachmentTypes.AddItem('Sheath_Sup');

	//Rapiers
	AttachmentTypes.AddItem('Rapier_Bsc');
	AttachmentTypes.AddItem('Rapier_Adv');
	AttachmentTypes.AddItem('Rapier_Sup');

	//Pommels
	AttachmentTypes.AddItem('Pommel_Bsc');
	AttachmentTypes.AddItem('Pommel_Adv');
	AttachmentTypes.AddItem('Pommel_Sup');

	//Guards
	AttachmentTypes.AddItem('XGuard_Bsc');
	AttachmentTypes.AddItem('XGuard_Adv');
	AttachmentTypes.AddItem('XGuard_Sup');

	//Coatings
	AttachmentTypes.AddItem('Coating_Bsc');
	AttachmentTypes.AddItem('Coating_Adv');
	AttachmentTypes.AddItem('Coating_Sup');

	//Reflectors
	AttachmentTypes.AddItem('Reflector_Bsc');
	AttachmentTypes.AddItem('Reflector_Adv');
	AttachmentTypes.AddItem('Reflector_Sup');

	//Hilts
	AttachmentTypes.AddItem('Hilt_Bsc');
	AttachmentTypes.AddItem('Hilt_Adv');
	AttachmentTypes.AddItem('Hilt_Sup');

	//cycle through them all and add the correct interactions
	foreach AttachmentTypes(AttachmentType)
	{
		AddNewAttachmentsSetup(AttachmentType, default.NewAttachmentsSetups); //ArrayToAdd);
	}
}

//create the unique attachment interactions
//also stolen from MERC / EU Plasma
static function AddNewAttachmentsSetup(name TemplateName, array<WeaponAttachment> Attachments) 
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponUpgradeTemplate Template;
	local WeaponAttachment Attachment;
	local delegate<X2TacticalGameRulesetDataStructures.CheckUpgradeStatus> CheckFN;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	
	foreach Attachments(Attachment)
	{
		if (InStr(string(TemplateName), Attachment.Type) != INDEX_NONE)
		{
			switch(Attachment.AttachmentFn) 
			{
				default:
					CheckFN = none;
					break;
			}
			Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.MeshName, Attachment.ProjectileName, Attachment.MatchWeaponTemplate, Attachment.AttachToPawn, Attachment.IconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, CheckFN);
			`LOG("AttachmentUpgradeAdded" @TemplateName @Attachment.AttachSocket @Attachment.UIArmoryCameraPointTag @Attachment.MeshName @Attachment.ProjectileName @Attachment.MatchWeaponTemplate @Attachment.AttachToPawn @Attachment.IconName @Attachment.InventoryIconName @Attachment.InventoryCategoryIcon @CheckFN,default.bEnableLogging,'MeleeAttachments');
		}
	}
}

//Add items to Loot Tables
static function AddLootTables()
{
	local X2LootTableManager	LootManager;
	local LootTable				LootBag;
	local LootTableEntry		Entry;
	
	LootManager = X2LootTableManager(class'Engine'.static.FindClassDefaultObject("X2LootTableManager"));

	Foreach default.LootEntry(LootBag)
	{
		if ( LootManager.default.LootTables.Find('TableName', LootBag.TableName) != INDEX_NONE )
		{
			foreach LootBag.Loots(Entry)
			{
				class'X2LootTableManager'.static.AddEntryStatic(LootBag.TableName, Entry, false);
			}
		}	
	}
}

//Create localisation files inserts
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
    local name TagText;
    
    TagText = name(InString);
    switch (TagText)
    {
        case 'BSCFRAMEMOBBONUS':
            OutString = string(class'X2Ability_MeleeAttachments'.default.FRAME_BSC_BONUS);
            return true;
		case 'ADVFRAMEMOBBONUS':
            OutString = string(class'X2Ability_MeleeAttachments'.default.FRAME_ADV_BONUS);
            return true;
		case 'SUPFRAMEMOBBONUS':
            OutString = string(class'X2Ability_MeleeAttachments'.default.FRAME_SUP_BONUS);
            return true;
		case 'BSCSHEATHDET':
            OutString = string(int(class'X2Ability_MeleeAttachments'.default.SHEATH_BSC_DETECT * 100));
            return true;
		case 'ADVSHEATHDET':
            OutString = string(int(class'X2Ability_MeleeAttachments'.default.SHEATH_ADV_DETECT * 100));
            return true;
		case 'SUPSHEATHDET':
            OutString = string(int(class'X2Ability_MeleeAttachments'.default.SHEATH_SUP_DETECT * 100));
            return true;
		case 'BSCRAPPIERCE':
            OutString = string(class'X2Ability_MeleeAttachments'.default.RAPIER_BSC_PIERCE);
            return true;
		case 'ADVRAPPIERCE':
            OutString = string(class'X2Ability_MeleeAttachments'.default.RAPIER_ADV_PIERCE);
            return true;
		case 'SUPRAPPIERCE':
            OutString = string(class'X2Ability_MeleeAttachments'.default.RAPIER_SUP_PIERCE);
            return true;
		case 'BSCPOMMELDMG':
            OutString = string(class'X2Effect_PommelBladestorm'.default.POMMEL_BSC_DMG);
            return true;
		case 'ADVPOMMELDMG':
            OutString = string(class'X2Effect_PommelBladestorm'.default.POMMEL_ADV_DMG);
            return true;
		case 'SUPPOMMELDMG':
            OutString = string(class'X2Effect_PommelBladestorm'.default.POMMEL_SUP_DMG);
            return true;
		case 'BSCXGDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.BSC_XG_DMG);
            return true;
		case 'ADVXGDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.ADV_XG_DMG);
            return true;
		case 'SUPXGDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.SUP_XG_DMG);
            return true;
		case 'BSCCOATDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.BSC_COAT_BONUS);
            return true;
		case 'ADVCOATDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.ADV_COAT_BONUS);
            return true;
		case 'SUPCOATDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.SUP_COAT_BONUS);
            return true;
		case 'BSCREFDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.BSC_REF_DMG );
            return true;
		case 'ADVREFDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.ADV_REF_DMG);
            return true;
		case 'SUPREFDMG':
            OutString = string(class'X2Ability_MeleeAttachments'.default.SUP_REF_DMG);
            return true;
		case 'BSCREFRANGE':
            OutString = string(class'X2Ability_MeleeAttachments'.default.BSC_REFLECTOR_RANGE);
            return true;
		case 'ADVREFRANGE':
            OutString = string(class'X2Ability_MeleeAttachments'.default.ADV_REFLECTOR_RANGE);
            return true;
		case 'SUPREFRANGE':
            OutString = string(class'X2Ability_MeleeAttachments'.default.SUP_REFLECTOR_RANGE);
            return true;
		case 'BSCHILTAIM':
            OutString = string(class'X2Ability_MeleeAttachments'.default.BSC_HILT_AIM_BONUS);
            return true;
		case 'BSCHILTRADIUS':
            OutString = string(int(class'X2Ability_MeleeAttachments'.default.BSC_HILT_RADIUS * 0.67));
            return true;
		case 'BSCHILTUSES':
            OutString = string(class'X2Ability_MeleeAttachments'.default.BSC_HILT_USES);
            return true;
		case 'ADVHILTAIM':
            OutString = string(class'X2Ability_MeleeAttachments'.default.ADV_HILT_AIM_BONUS);
            return true;
		case 'ADVHILTRADIUS':
            OutString = string(int(class'X2Ability_MeleeAttachments'.default.ADV_HILT_RADIUS * 0.67));
            return true;
		case 'ADVHILTUSES':
            OutString = string(class'X2Ability_MeleeAttachments'.default.ADV_HILT_USES);
            return true;
		case 'SUPHILTAIM':
            OutString = string(class'X2Ability_MeleeAttachments'.default.SUP_HILT_AIM_BONUS);
            return true;
		case 'SUPHILTRADIUS':
            OutString = string(int(class'X2Ability_MeleeAttachments'.default.SUP_HILT_RADIUS * 0.67));
            return true;
		case 'SUPHILTUSES':
            OutString = string(class'X2Ability_MeleeAttachments'.default.SUP_HILT_USES);
            return true;
		default:
            return false;
    }
}
