-- *********************************************
-- Addon Setup
-- *********************************************
function SmartBag_OnLoad()
	-- The I'm alive message
	print("<Smart Bag v0.6>")

	-- Register slash commands
	SlashCmdList["SMARTBAG"] = SmartBag_SlashCommand
	SLASH_SMARTBAG1 = "/smartbag"
	SLASH_SMARTBAG2 = "/sb"

  --Setup the settings table if we don't have one already
  if (not SmartBagSettings) then
  SmartBagSettings = {}
  SmartBagSettings["AutoSellGrey"]=false
  SmartBagSettings["EnchangingBag"]="0"
  SmartBagSettings["MiningBag"]="0"
  SmartBagSettings["InscriptionBag"]="0"
  SmartBagSettings["HerbBag"]="0"
  SmartBagSettings["GearSetBag"]="0"
  SmartBagSettings["FirstRun"] = "0"
  end



end

-- Handle events
function SmartBag_EventHandler(self, event, ...)
 if event == "MERCHANT_SHOW" then 
  if SmartBagSettings["AutoSellGrey"] == true then SellGrey() end
  SortEquipmentSet(SmartBagSettings["GearSetBag"])

 end

 if event == "PLAYER_LOGOUT" then 
  
 end

 if event == "ADDON_LOADED" then
  -- Show the settings window on first run
    if SmartBagSettings["FirstRun"] == "0" then
      SmartBagSettings["FirstRun"] = "1"
      SmartBagSettingsWindow:Show() end

  -- Sets the button text to their current values
    SetButttonText(SellGreyButton,SmartBagSettings["AutoSellGrey"])
    SetButttonText(KeepEquipmentButton,SmartBagSettings["GearSetBag"])

 end

end

-- Slash Command Handling
function SmartBag_SlashCommand(msg)
  if SmartBagSettingsWindow:IsVisible() then SmartBagSettingsWindow:Hide() else SmartBagSettingsWindow:Show() end
end


-- *********************************************
-- Utility Functions
-- *********************************************

-- Move a single item by name to the "targetbag"
function SortContainerItem(search,targetbag)
  numberOfFreeSlots, BagType = GetContainerNumFreeSlots(BagNumberConversion(targetbag))
  if numberOfFreeSlots >= 1 then
    for bag = 0,4 do
      for slot = 1,GetContainerNumSlots(bag) do
        local item = GetContainerItemLink(bag,slot)
        if item then 
          iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(item)
        end
        if item and search == iname then
          
          PickupContainerItem(bag,slot)
          if targetbag == "1" then PutItemInBackpack() else PutItemInBag(targetbag) end
        end
      end
    end
  else
    
  end
end

-- Move all items into "targetbag" based on item rarity
function SortItemsRarity(targetbag,targetrarity)
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      if item then 
       iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(item)
  	  end
      if item and iRarity == targetrarity then
       PickupContainerItem(bag,slot)
       if targetbag == "1" then PutItemInBackpack() else PutItemInBag(targetbag) end
      end
    end
  end
end


-- Sort all items into "targetbag" based on what type of tradeskill bag they fit into 
function SortItemsType(targetbag,targetfamily)
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      local itemfamily = GetItemFamily(item)
      if item and itemfamily == targetfamily then
        PickupContainerItem(bag,slot)
        if targetbag == "1" then PutItemInBackpack() else PutItemInBag(targetbag) end
      end
    end
  end
end

function SellGrey()
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      if item then 
       iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(item)
      end
      if item and iRarity == 0 and ivendorPrice > 0 then
       PickupContainerItem(bag,slot)
       PickupMerchantItem(0)
      end
    end
  end
end

function WhatBag(search)
    for bag = 0,4 do
      for slot = 1,GetContainerNumSlots(bag) do
        local item = GetContainerItemLink(bag,slot)
        if item and item:find(search) then
        foundbag = bag
        foundslot = slot
        end
      end
    end
  return foundbag
end



-- Sort Equipement from sets into "targetbag"
function SortEquipmentSet(targetbag)
  x = 0
  for equipset = 1,GetNumEquipmentSets() do 
    name, icon, lessIndex = GetEquipmentSetInfo(equipset)
    itemArray = GetEquipmentSetItemIDs(name);
    for itemslot = 1,19 do 
      if GetItemInfo(itemArray[itemslot]) then
        iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(itemArray[itemslot])
        superbag = tonumber(WhatBag(iname))
        supertarget = tonumber(BagNumberConversion(targetbag))
        if IsEquippedItem(ilink) == 1 or superbag == supertarget then
          --Goodtimes 
        else
          x = x +1
        end        
      end
    end
  end
  numberOfFreeSlots, BagType = GetContainerNumFreeSlots(BagNumberConversion(targetbag))
  if numberOfFreeSlots >= x then
  for equipset = 1,GetNumEquipmentSets() do 
    name, icon, lessIndex = GetEquipmentSetInfo(equipset)
    itemArray = GetEquipmentSetItemIDs(name);
    for itemslot = 1,19 do 
      if GetItemInfo(itemArray[itemslot]) then
        iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(itemArray[itemslot])
        if IsEquippedItem(ilink) == 1 or WhatBag(iname) == BagNumberConversion(targetbag) then
          --Goodtimes
        else
          SortContainerItem(iname,targetbag)
        end        
      end
    end
  end
  else
    print("<SmartBag> Equipment Sorting: Not enough free space.")
    print("<SmartBag> Equipment Sorting: Required space: " .. x )
    print("<SmartBag> Equipment Sorting: Available space: " .. numberOfFreeSlots)
    print("<SmartBag> Equipment Sorting: Target bag: " .. KeepEquipmentButton:GetText() )
  end
end


-- Yeah... this doesn't work yet.....
function SortNonEquipmentSetItems(targetbag,rarity)
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      if item then 
       iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(item)
      end
      
      if item and iRarity == targetrarity then
        for equipset = 1,GetNumEquipmentSets() do 
        name, icon, lessIndex = GetEquipmentSetInfo(equipset)
        itemArray = GetEquipmentSetItemIDs(name);

        for itemslot = 1,19 do 
          print(GetItemInfo(itemArray[itemslot]))
        if GetItemInfo(itemArray[itemslot]) then
          if iname == GetItemInfo(itemArray[itemslot]) then print("Yes") else print("No") end
        end
        end
        end
      end
    end
  end
end

function BagNumberConversion(value)
  if value == "1" then value = "0" end 
  if value == "20" then value = "1" end
  if value == "21" then value = "2" end
  if value == "22" then value = "3" end
  if value == "23" then value = "4" end
  return value
end

-- *********************************************
-- UI Functions
-- *********************************************

function SetButttonText(button,value)
  if value == "0" then button:SetText("None") end
  if value == "1" then button:SetText("Backpack") end
  if value == "20" then button:SetText("Bag 1") end
  if value == "21" then button:SetText("Bag 2") end
  if value == "22" then button:SetText("Bag 3") end
  if value == "23" then button:SetText("Bag 4") end
  if value == true then button:SetText("Yes") end
  if value == false then button:SetText("No") end
end

function UpdateSettingChoice(value)
   if value == "0" then value = "1" 
    elseif value == "1" then value = "20" 
    elseif value == "20" then value = "21" 
    elseif value == "21" then value = "22" 
    elseif value == "22" then value = "23" 
    elseif value == "23" then value = "0" 
    elseif value == true then value = false
    elseif value == false then value = true
   end
   return value
end

function SellGreyButton_OnClick()
   SmartBagSettings["AutoSellGrey"] = UpdateSettingChoice(SmartBagSettings["AutoSellGrey"])
   SetButttonText(SellGreyButton,SmartBagSettings["AutoSellGrey"])
end

function KeepEquipmentButton_OnClick()
   SmartBagSettings["GearSetBag"] = UpdateSettingChoice(SmartBagSettings["GearSetBag"])
   SetButttonText(KeepEquipmentButton,SmartBagSettings["GearSetBag"])
  end

function OkButton_OnClick()
  SmartBagSettingsWindow:Hide()
end
