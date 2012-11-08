function SmartBag_OnLoad()
	-- The I'm alive message
	print("<Smart Bag v0.1>")

	-- Register slash commands
	SlashCmdList["SMARTBAG"] = SmartBag_SlashCommand
	SLASH_SMARTBAG1 = "/smartbag"
	SLASH_SMARTBAG2 = "/sb"

    if (not SmartBagSettings) then
    SmartBagSettings = {}
    SmartBagSettings["AutoSellGrey"]=false
    SmartBagSettings["EnchangingBag"]=nil
    SmartBagSettings["MiningBag"]=nil
    SmartBagSettings["InscriptionBag"]=nil
    SmartBagSettings["HerbBag"]=nil
    SmartBagSettings["AutoSortGearSet"]=true
    SmartBagSettings["GearSetBag"]=nil
  end

end

-- Move a single item by name to the "targetbag"
function SortContainerItem(search,targetbag)
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      if item and item:find(search) then
        PickupContainerItem(bag,slot)
        if targetbag == 0 then PutItemInBackpack() else PutItemInBag(targetbag) end
      end
    end
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
       if targetbag == 0 then PutItemInBackpack() else PutItemInBag(targetbag) end
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
        if targetbag == 0 then PutItemInBackpack() else PutItemInBag(targetbag) end
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

function SortEquipmentSet(targetbag)
  for equipset = 1,GetNumEquipmentSets() do 
    name, icon, lessIndex = GetEquipmentSetInfo(equipset)
    itemArray = GetEquipmentSetItemIDs(name);
    for itemslot = 1,19 do 
      if GetItemInfo(itemArray[itemslot]) then
       SortContainerItem(GetItemInfo(itemArray[itemslot]),targetbag) 
      end
    end
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

function SmartBag_EventHandler(self, event, ...)
 if event == "MERCHANT_SHOW"then 
  if SmartBagSettings["AutoSellGrey"] == true then SellGrey() end
 end

 if event == "PLAYER_LOGOUT"then 
  
 end
end

-- Slash Command Handling
function SmartBag_SlashCommand(msg)
	-- if (msg == "") then print("Smart Bag!!") else print(msg) end
	SortItemsType(21,64)
	SortItemsType(23,16)
	SortItemsType(21,1024)
	--SortItemsRarity(22,4)
  --SortItemsRarity(22,3)
  SortItemsRarity(0,0)
  SortContainerItem("Big Iron Fishing Pole", 23)
  SortContainerItem("Hearthstone", 23)
  SortContainerItem("Wrap of Unity", 23)
  SortEquipmentSet(22)
  SortNonEquipmentSetItems(0,3)

  if SmartBagSettings["AutoSellGrey"] == true then print("True Story!!") else print("Negative!") end
  
  SmartBagSettingsWindow = CreateFrame("FRAME", "SmartBagSettingsWindow")
  SmartBagSettingsWindow:SetFrameStrata("BACKGROUND")
  SmartBagSettingsWindow:SetWidth(120)
  SmartBagSettingsWindow:SetHeight(64)
  SmartBagSettingsWindow:SetPoint("CENTER",0,0)
  local t = SmartBagSettingsWindow:CreateTexture(nil,"BACKGROUND")
  t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp")
  t:SetAllPoints(SmartBagSettingsWindow)
  SmartBagSettingsWindow.texture = t
 


end
