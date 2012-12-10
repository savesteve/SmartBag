-- *********************************************
-- Addon Setup
-- *********************************************
function SmartBag_OnLoad()
	-- The I'm alive message
	print("<Smart Bag v0.83>")

	-- Register slash commands
	SlashCmdList["SMARTBAG"] = SmartBag_SlashCommand
	SLASH_SMARTBAG1 = "/smartbag"
	SLASH_SMARTBAG2 = "/sb"

  --Setup the settings table if we don't have one already
  if (not SmartBagSettings) then
  SmartBagSettings = {}
  SmartBagSettings["AutoSellGrey"]=false
  SmartBagSettings["SortGrey"]="0"
  SmartBagSettings["EnchangingBag"]="0"
  SmartBagSettings["MiningBag"]="0"
  SmartBagSettings["InscriptionBag"]="0"
  SmartBagSettings["HerbBag"]="0"
  SmartBagSettings["GearSetBag"]="0"
  SmartBagSettings["FirstRun"] = "0"
  SmartBagSettings["Alerts"]=true
  SmartBagSettings["BlueSort"]="0"
  SmartBagSettings["GreenSort"]="0"
  end
  if (not SmartBagExtraSellItems) then
  SmartBagExtraSellItems = {}
  SmartBagExtraSellItems[1] = "Scroll of Intellect II"
  SmartBagExtraSellItems[2] = "Scroll of Stamina II"
  SmartBagExtraSellItems[3] = "Callous Axe"
  end
  
  --Bug fix for Alert settings sometimes getting a wrong value.
  if SmartBagSettings["Alerts"] == true or SmartBagSettings["Alerts"] == false then
    --Goodtimes
  else
    SmartBagSettings["Alerts"] == true
  end


end

function ExecuteSorting(quiet)
  if quiet == true then 
    xquiet = SmartBagSettings["Alerts"]
    SmartBagSettings["Alerts"]=false
  end
  
  SortEquipmentSet(SmartBagSettings["GearSetBag"])
  SortRarity(2,SmartBagSettings["GreenSort"])
  
  if quiet == true then SmartBagSettings["Alerts"] = xquiet end

end

-- Event Handlers
function SmartBag_EventHandler(self, event, ...)
 if event == "MERCHANT_SHOW" then 
  if  SmartBagSettings["AutoSellGrey"] == true then 
    SellGrey()
  end
  ExecuteSorting()
 end

 if event == "PLAYER_LOGOUT" then 
  
 end

 if event == "PLAYER_REGEN_ENABLED" then
  ExecuteSorting(true)
 end

 if event == "ADDON_LOADED" then
  -- Show the settings window on first run
    if SmartBagSettings["FirstRun"] == "0" then
      SmartBagSettings["FirstRun"] = "1"
      SmartBagSettingsWindow:Show() end

  -- Sets the button text to their current values
  if  SmartBagSettings["AutoSellGrey"] then 
    SetButttonText(SellGreyButton,SmartBagSettings["AutoSellGrey"]) else
    SmartBagSettings["AutoSellGrey"] = false
    SetButttonText(SellGreyButton,SmartBagSettings["AutoSellGrey"])
  end
  if  SmartBagSettings["GearSetBag"] then 
    SetButttonText(KeepEquipmentButton,SmartBagSettings["GearSetBag"]) else
    SmartBagSettings["GearSetBag"]="0"
    SetButttonText(KeepEquipmentButton,SmartBagSettings["GearSetBag"])
  end
  if  SmartBagSettings["GreenSort"] then 
    SetButttonText(GreenSortButton,SmartBagSettings["GreenSort"]) else
    SmartBagSettings["GreenSort"]="0"
    SetButttonText(GreenSortButton,SmartBagSettings["GreenSort"])
  end
  
  SetButttonText(AlertTextButton,SmartBagSettings["Alerts"])
  
 end

end

-- Slash Commands
function SmartBag_SlashCommand(msg)
  if SmartBagSettingsWindow:IsVisible() then SmartBagSettingsWindow:Hide() else SmartBagSettingsWindow:Show() end
end

-- *********************************************
-- UI Functions
-- *********************************************

function SellGreyButton_OnClick()
   SmartBagSettings["AutoSellGrey"] = UpdateSettingChoice(SmartBagSettings["AutoSellGrey"])
   SetButttonText(SellGreyButton,SmartBagSettings["AutoSellGrey"])
end

function KeepEquipmentButton_OnClick()
   SmartBagSettings["GearSetBag"] = UpdateSettingChoice(SmartBagSettings["GearSetBag"])
   SetButttonText(KeepEquipmentButton,SmartBagSettings["GearSetBag"])
end

function GreenSortButton_OnClick()
   SmartBagSettings["GreenSort"] = UpdateSettingChoice(SmartBagSettings["GreenSort"])
   SetButttonText(GreenSortButton,SmartBagSettings["GreenSort"])
end

function AlertTextButton_OnClick()
   SmartBagSettings["Alerts"] = UpdateSettingChoice(SmartBagSettings["Alerts"])
   SetButttonText(AlertTextButton,SmartBagSettings["Alerts"])
end

function OkButton_OnClick()
  SmartBagSettingsWindow:Hide()
end

-- *********************************************
-- Sorting Functions
-- *********************************************

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
          if targetbag == "1" then 
            PickupContainerItem(bag,slot)
            PutItemInBackpack() else
            PickupContainerItem(bag,slot)
            PutItemInBag(targetbag)
          end
        end
      end
    end
  else
  end
  ResetCursor()
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
  if SmartBagSettings["Alerts"] == true then
    print("<SmartBag> Gear Sorted To: " .. KeepEquipmentButton:GetText() )
  end
  else
    if SmartBagSettings["Alerts"] == true then
      print("<SmartBag> Equipment Sorting: Not enough free space.")
      print("<SmartBag> Equipment Sorting: Required space: " .. x )
      print("<SmartBag> Equipment Sorting: Available space: " .. numberOfFreeSlots)
      print("<SmartBag> Equipment Sorting: Target: " .. KeepEquipmentButton:GetText() )
    end
  end
  ResetCursor()
end

function SortRarity(targetrarity,targetbag)
  --targetrarity 0-10 , targetbag 1(backpack),20-23(bags),IncSet 0/1
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      if item then
        iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(item)
        if iRarity == targetrarity and IsSetItem(iname) == false then
          if targetbag == "1" then 
            PickupContainerItem(bag,slot)
            PutItemInBackpack() else
            PickupContainerItem(bag,slot)
            PutItemInBag(targetbag)
          end
        end
      end
    end
  end
  if SmartBagSettings["Alerts"] == true then
  print("<SmartBag> Green Items Sorted To: " .. GreenSortButton:GetText())
  end
  ResetCursor()
end

function SellGrey()
  x = 0
  totalsale = 0
  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag,slot)
      if item then 
       iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(item)
      end
      if item and iRarity == 0 and ivendorPrice > 0 then
       PickupContainerItem(bag,slot)
       PickupMerchantItem(0)
       itemcount = tonumber(GetItemCount(ilink))
       totalsale = totalsale + (itemcount * tonumber(ivendorPrice))
       x = x + itemcount
      end
      -- for i,line in ipairs(SmartBagExtraSellItems) do
      --   if iname == SmartBagExtraSellItems[i] then
      --    PickupContainerItem(bag,slot)
      --    PickupMerchantItem(0)
      --    itemcount = tonumber(GetItemCount(ilink))
      --    totalsale = totalsale + (itemcount * tonumber(ivendorPrice))
      --    x = x + itemcount
      --   end
      -- end
    end
  end
  if x > 0 and SmartBagSettings["Alerts"] == true then
    print("<SmartBag> Total Items Sold: " .. x )
    print("<SmartBag> Total Sale Price: " .. ConvertToWoWMoney(totalsale) )
  end
  ResetCursor()
end

-- *********************************************
-- Utility Functions
-- *********************************************

function BagNumberConversion(value)
  if value == "1" then value = "0" end 
  if value == "20" then value = "1" end
  if value == "21" then value = "2" end
  if value == "22" then value = "3" end
  if value == "23" then value = "4" end
  return value
end

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

function ConvertToWoWMoney(number)
  if number > 9999 then
    gold = removeDecimal((number / 10000))
    goldtemp = gold * 10000
    silver = removeDecimal((number - goldtemp) / 100)
    silvertemp = silver * 100
    copper = number - goldtemp - silvertemp
    wowmoney = gold .. " gold " .. silver .. " silver " .. copper .. " copper"
  elseif number > 99 then
    silver = removeDecimal(number / 100)
    silvertemp = silver * 100
    copper = number - silvertemp
    wowmoney = silver .. " silver " .. copper .. " copper"
  elseif number then
    wowmoney = number .. " copper"
  end

  return wowmoney

end
 
function removeDecimal(number)
  local num = number
  local num2 = tostring(num)
  local found = nil
  for i=1,100000 do
    if string.sub(num2,i,i) == "." then
      found = i
    end
  end
  if type(found) == "number" then
    num2 = string.sub(num2,1,found-1)
  end
  num = tonumber(num2)
  return num
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

-- Tests the item and returns true if it is a member of any Gear Set in the equipment manager
function IsSetItem(itemname)
  itemsetstatus = false
  for equipset = 1,GetNumEquipmentSets() do 
    name, icon, lessIndex = GetEquipmentSetInfo(equipset)
    itemArray = GetEquipmentSetItemIDs(name);
    for itemslot = 1,19 do 
      if GetItemInfo(itemArray[itemslot]) then
        iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(itemArray[itemslot])
        if itemname == iname then itemsetstatus =true
        end
      end
    end
  end
  return itemsetstatus
end
