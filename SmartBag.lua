-- *********************************************
-- Addon Setup
-- *********************************************
function SmartBag_OnLoad()
	print("|cFF0066FF<SmartBag |cFFFFFF00v5.0|cFF0066FF>")
	SlashCmdList["SMARTBAG"] = SmartBag_SlashCommand
	SLASH_SMARTBAG1 = "/smartbag"
	SLASH_SMARTBAG2 = "/sb"

  if (not SmartBagSettings) then
    SmartBagSettings = {}
    SmartBagSettings["AutoSellGrey"]=false
    SmartBagSettings["SortGrey"]="0"
    SmartBagSettings["GearSetBag"]="0"
    SmartBagSettings["GearSetBag2"]="0"
    SmartBagSettings["FirstRun"] = "0"
    SmartBagSettings["Alerts"]=true
    SmartBagSettings["GreenSort"]="0"
    SmartBagSettings["OOCSorting"]=false
  end
  if (not SmartBagExtraSellItems) then
    SmartBagExtraSellItems = {}
  end
 
  if SmartBagSettings["Alerts"] == true or SmartBagSettings["Alerts"] == false then
  else
    SmartBagSettings["Alerts"] = true
  end
end

function ExecuteSorting(quiet)
  local iCache = UpdateItemCache()
  local sortStatus

  if quiet == true then 
    xquiet = SmartBagSettings["Alerts"]
    SmartBagSettings["Alerts"]=false
  end
  
  if SmartBagSettings["GearSetBag"] ~= "0" then
    SortEquipmentSets(SmartBagSettings["GearSetBag"],SmartBagSettings["GearSetBag2"],iCache)
  end
  
  if SmartBagSettings["GreenSort"] ~= "0" then
    SortRarity(2,SmartBagSettings["GreenSort"],iCache)
  end

  if SmartBagSettings["SellGrey"] == false then
    SmartBagESIExecute(iCache)
  else
    SellGrey(iCache)
  end

  if quiet == true then SmartBagSettings["Alerts"] = xquiet end
end

function SmartBag_EventHandler(self, event, ...)

 if event == "MERCHANT_SHOW" then
  ExecuteSorting()
 end

 if event == "PLAYER_REGEN_ENABLED" then
  if SmartBagSettings["OOCSorting"] == true then
    ExecuteSorting(true)
  end
 end

 if event == "ADDON_LOADED" then

  if SmartBagSettings["FirstRun"] == "0" then
    SmartBagSettings["FirstRun"] = "1"
    SmartBagSettingsWindow:Show() 
  end

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
  if  SmartBagSettings["GearSetBag2"] then 
    SetButttonText(KeepEquipmentButton2,SmartBagSettings["GearSetBag2"]) else
    SmartBagSettings["GearSetBag2"]="0"
    SetButttonText(KeepEquipmentButton2,SmartBagSettings["GearSetBag2"])
  end
  if  SmartBagSettings["GreenSort"] then 
    SetButttonText(GreenSortButton,SmartBagSettings["GreenSort"]) else
    SmartBagSettings["GreenSort"]="0"
    SetButttonText(GreenSortButton,SmartBagSettings["GreenSort"])
  end
  
  if SmartBagSettings["OOCSorting"] then
    SetButttonText(OOCSortButton,SmartBagSettings["OOCSorting"]) else
    SmartBagSettings["OOCSorting"]=true
    SetButttonText(OOCSortButton,SmartBagSettings["OOCSorting"])
  end

  SetButttonText(AlertTextButton,SmartBagSettings["Alerts"])

  if AlertTextButton:GetText() == nil then 
    SmartBagSettings["Alerts"] = true
    SetButttonText(AlertTextButton,SmartBagSettings["Alerts"])
  end
 end
end

function SmartBag_SlashCommand(msg)
  if SmartBagSettingsWindow:IsVisible() then SmartBagSettingsWindow:Hide() else SmartBagSettingsWindow:Show() end
end

-- *********************************************
-- Settings Window Functions
-- *********************************************

function SellGreyButton_OnClick()
   SmartBagSettings["AutoSellGrey"] = UpdateSettingChoice(SmartBagSettings["AutoSellGrey"])
   SetButttonText(SellGreyButton,SmartBagSettings["AutoSellGrey"])
end

function KeepEquipmentButton_OnClick()
  SmartBagSettings["GearSetBag"] = UpdateSettingChoice(SmartBagSettings["GearSetBag"])
  if SmartBagSettings["GearSetBag"] == SmartBagSettings["GearSetBag2"] then
    if SmartBagSettings["GearSetBag"] ~= "0" then
      SmartBagSettings["GearSetBag"] = UpdateSettingChoice(SmartBagSettings["GearSetBag"])
    end
  end
  SetButttonText(KeepEquipmentButton,SmartBagSettings["GearSetBag"])
end

function KeepEquipmentButton2_OnClick()
  SmartBagSettings["GearSetBag2"] = UpdateSettingChoice(SmartBagSettings["GearSetBag2"])
  if SmartBagSettings["GearSetBag2"] == SmartBagSettings["GearSetBag"] then
    if SmartBagSettings["GearSetBag2"] ~= "0" then
      SmartBagSettings["GearSetBag2"] = UpdateSettingChoice(SmartBagSettings["GearSetBag2"])
    end
  end
  SetButttonText(KeepEquipmentButton2,SmartBagSettings["GearSetBag2"])
end

function GreenSortButton_OnClick()
   SmartBagSettings["GreenSort"] = UpdateSettingChoice(SmartBagSettings["GreenSort"])
   SetButttonText(GreenSortButton,SmartBagSettings["GreenSort"])
end

function AlertTextButton_OnClick()
   SmartBagSettings["Alerts"] = UpdateSettingChoice(SmartBagSettings["Alerts"])
   SetButttonText(AlertTextButton,SmartBagSettings["Alerts"])
end
function OOCSortButton_OnClick()
  SmartBagSettings["OOCSorting"] = UpdateSettingChoice(SmartBagSettings["OOCSorting"])
  SetButttonText(OOCSortButton,SmartBagSettings["OOCSorting"])
end

function OkButton_OnClick()
  SmartBagSettingsWindow:Hide()
end

function ExtraSellItemButton_OnClick()
  SmartBagSettingsWindow:Hide()
  SmartBagExtraSellItemWindow:Show()
  SmartBagExtraSellItemWindowItemFrame:Show()
  SmartBagESIClearCancelButton()
end

-- *********************************************
-- Extra Sell Items Functions
-- *********************************************

function SmartBagScrollBarESI_Update()
  line = nil
  lineplusoffset = nil
  FauxScrollFrame_Update(SmartBagScrollBarESI,18,1,20)
     if table.getn(SmartBagExtraSellItems) < 19 then
      SmartBagScrollBarESI:Hide()
      for line=1,19 do
        if line <= table.getn(SmartBagExtraSellItems) then
          _G["SmartBagESIButton"..line]:SetText(SmartBagExtraSellItems[line])
          _G["SmartBagESIButton"..line]:Show()
        else
          _G["SmartBagESIButton"..line]:Hide()
        end
      end
    else
      for line=1,19 do
        lineplusoffset = line + FauxScrollFrame_GetOffset(SmartBagScrollBarESI)
        SmartBagScrollBarESI:Show()
        if lineplusoffset <= 50 then
          if SmartBagExtraSellItems[lineplusoffset] then
            _G["SmartBagESIButton"..line]:SetText(SmartBagExtraSellItems[lineplusoffset])
            _G["SmartBagESIButton"..line]:Show()
          else
            _G["SmartBagESIButton"..line]:Hide()
          end
        else
          _G["SmartBagESIButton"..line]:Hide()
        end
      end
    end
end

function  SmartBagExtraSellItemWindow_OnReceiveDrag()
  local cursorType, info1, info2  = GetCursorInfo()
  local addItemConfirm = 0
  if cursorType == "item" then
    iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(info2)
    for i,line in ipairs(SmartBagExtraSellItems) do
        if iname == SmartBagExtraSellItems[i] then
         print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFFFFFF00Item already in list - |r" .. iname)
         addItemConfirm = 1
         ClearCursor()
        end
    end
    if addItemConfirm == 0 then
      if ivendorPrice > 0 then
        SmartBagExtraSellItems[table.getn(SmartBagExtraSellItems) + 1] = iname
        SmartBagScrollBarESI_Update()
        print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFF66FF33Item Added To List - |r" .. iname)
        ClearCursor()
      else
        print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFFFFFF00Unable To Add Item - No Vendor Price - |r" .. iname)
        ClearCursor()
      end
    end
  end
end

function SmartBagESIClearButton()
  SmartBagExtraSellItemWindow:Hide()
  SmartBagExtraSellItemWindowItemFrame:Hide()
  SmartBagESIClearWindow:Show()
end

function SmartBagESIClearCancelButton()
  SmartBagESIClearWindow:Hide()
  SmartBagExtraSellItemWindow:Show()
  SmartBagExtraSellItemWindowItemFrame:Show()
  SmartBagScrollBarESI_Update()
end

function SmartBagESIClearListButton()
  SmartBagExtraSellItems = {}
  print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFFFF0000LIST CLEARED")
  SmartBagESIClearWindow:Hide()
  SmartBagExtraSellItemWindow:Show()
  SmartBagExtraSellItemWindowItemFrame:Show()
  SmartBagScrollBarESI_Update()
end

function SmartBagESIRemoveItem(self)
  local cursorType, info1, info2  = GetCursorInfo()
  if cursorType == "item" then
    SmartBagExtraSellItemWindow_OnReceiveDrag()
  else
    local target = self:GetText()
    for i,line in ipairs(SmartBagExtraSellItems) do
      if target == SmartBagExtraSellItems[i] then
        table.remove(SmartBagExtraSellItems, i)
        print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFFFF0000Item Removed From List - |r" .. target)
        SmartBagScrollBarESI_Update()
      end
    end
  end
end

function SmartBagESIAddButton()
  SmartBagExtraSellItemWindow:Hide()
  SmartBagESIAddWindow:Show()
end

function SmartBagESIOKButton()
  SmartBagExtraSellItemWindow:Hide()
  SmartBagSettingsWindow:Show()
end

function SmartBagESIAddAddButton()
  local addItemConfirm = 0
  for i,line in ipairs(SmartBagExtraSellItems) do
    if SmartBagESIAddWindowEditBox:GetText() == SmartBagExtraSellItems[i] then
     print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFFFFFF00Item already in list - |r" .. SmartBagESIAddWindowEditBox:GetText())
     addItemConfirm = 1
     ClearCursor()
    end
  end
  if addItemConfirm == 0 then
    SmartBagExtraSellItems[table.getn(SmartBagExtraSellItems) + 1] = SmartBagESIAddWindowEditBox:GetText()
    print("|cFF0066FF<SmartBag> |rExtra Sell Items: |cFF66FF33Item Added To List - |r" .. SmartBagESIAddWindowEditBox:GetText())
    SmartBagESIAddWindow:Hide()
    SmartBagExtraSellItemWindow:Show()
    SmartBagExtraSellItemWindowItemFrame:Show()
    SmartBagScrollBarESI_Update()
  end
end

function SmartBagESIAddCancelButton()
  SmartBagESIAddWindow:Hide()
  SmartBagExtraSellItemWindow:Show()
  SmartBagExtraSellItemWindowItemFrame:Show()
  SmartBagScrollBarESI_Update()
end

function SmartBagESIExecute(itemCache)
  local x = 0
  local totalsale = 0
  for bag = 0,NUM_BAG_SLOTS do
    for slot = 1,GetContainerNumSlots(bag) do
      for i,line in ipairs(SmartBagExtraSellItems) do
        if itemCache[bag][slot].name == SmartBagExtraSellItems[i] then
         PickupContainerItem(bag,slot)
         PickupMerchantItem(0)
         itemcount = tonumber(GetItemCount(ilink))
         totalsale = totalsale + (itemcount * tonumber(ivendorPrice))
         x = x + itemcount
        end
      end
      iname = nil
    end
  end
  if x > 0 and SmartBagSettings["Alerts"] == true then
    print("|cFF0066FF<SmartBag> |rTotal Items Sold: |cFF66FF33" .. x )
    print("|cFF0066FF<SmartBag> |rTotal Sale Price: |cFF66FF33" .. ConvertToWoWMoney(totalsale) )
  end
  ClearCursor()
end

function SmartBagESIAddCancelButton()
  SmartBagESIAddWindow:Hide()
  SmartBagExtraSellItemWindow:Show()
  SmartBagExtraSellItemWindowItemFrame:Show()
  SmartBagScrollBarESI_Update()
end

-- *********************************************
-- Sorting Functions
-- *********************************************
function SortContainerItem(search,targetbag,itemCache)
  numberOfFreeSlots, BagType = GetContainerNumFreeSlots(BagNumberConversion(targetbag))
  if numberOfFreeSlots >= 1 then
    for bag = 0,NUM_BAG_SLOTS do
      for slot = 1,GetContainerNumSlots(bag) do
        if itemCache[bag][slot].name == search then
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
  ClearCursor()
end

function SortRarity(targetrarity,targetbag,itemCache)
  for bag = 0,NUM_BAG_SLOTS do
    for slot = 1,GetContainerNumSlots(bag) do
      if itemCache[bag][slot].rarity == targetrarity and itemCache[bag][slot].class ~= "Trade Goods" then
        if targetbag == "1" then 
          PickupContainerItem(bag,slot)
          PutItemInBackpack() else
          PickupContainerItem(bag,slot)
          PutItemInBag(targetbag)
        end
      end
    end
  end
  if SmartBagSettings["Alerts"] == true then
  print("|cFF0066FF<SmartBag> |rGreen Items Sorted To: |cFF66FF33" .. GreenSortButton:GetText())
  end
  ClearCursor()
end

function SellGrey(itemCache)
  local x = 0
  local totalsale = 0
  for bag = 0,NUM_BAG_SLOTS do
    for slot = 1,GetContainerNumSlots(bag) do
      if itemCache[bag][slot].name and itemCache[bag][slot].rarity == 0 and itemCache[bag][slot].vendorPrice > 0 then
        PickupContainerItem(bag,slot)
        PickupMerchantItem(0)
        totalsale = totalsale + (itemCache[bag][slot].itemCount * itemCache[bag][slot].vendorPrice)
        x = x + itemCache[bag][slot].itemCount
      end

      for i,line in ipairs(SmartBagExtraSellItems) do
        if itemCache[bag][slot].name == SmartBagExtraSellItems[i] then
          PickupContainerItem(bag,slot)
          PickupMerchantItem(0)
          totalsale = totalsale + (itemCache[bag][slot].itemCount * itemCache[bag][slot].vendorPrice)
          x = x + itemCache[bag][slot].itemCount
        end
      end
    end
  end
  if x > 0 and SmartBagSettings["Alerts"] == true then
    print("|cFF0066FF<SmartBag> |rTotal Items Sold: |cFF66FF33" .. x )
    print("|cFF0066FF<SmartBag> |rTotal Sale Price: |cFF66FF33" .. ConvertToWoWMoney(totalsale) )
  end
  ClearCursor()
end

function SortEquipmentSet(targetbag, itemSet, itemCache)
  local x = 0
  local tarbag = tonumber(BagNumberConversion(targetbag))
  local status = {}
  for bag = 0,NUM_BAG_SLOTS do
    for slot = 1,GetContainerNumSlots(bag) do
      if itemCache[bag][slot].isSetItem == true and itemCache[bag][slot].itemSet == itemSet and bag ~= tarbag  then
        x = x + 1
      end
    end
  end
  local numberOfFreeSlots, BagType = GetContainerNumFreeSlots(tarbag)
  if numberOfFreeSlots >= x then
    for bag = 0,NUM_BAG_SLOTS do
      for slot = 1,GetContainerNumSlots(bag) do
        if itemCache[bag][slot].isSetItem == true and  itemCache[bag][slot].itemSet == itemSet and bag ~= tarbag then
          SortContainerItem(itemCache[bag][slot].name,targetbag,itemCache)
        end
      end
    end
    status.state = true
  else
    status.state = false
    status.reqSpace = x
    status.numberOfFreeSlots = numberOfFreeSlots
  end
  ClearCursor()
  return status
end

--- NEED to work on edge cases, but working in general.
--- Need to handle targetbag2 being "None"
--- Change sorting messages to list both bags

function SortEquipmentSets(targetbag,targetbag2,itemCache)
  local x = 0
  local tarbag = tonumber(BagNumberConversion(targetbag))
  local tarbag2 = tonumber(BagNumberConversion(targetbag2))
  local altMessage = false
  local numberOfFreeSlots2, BagType2
  local numberOfFreeSlotsTotal

  for bag = 0,4 do
    for slot = 1,GetContainerNumSlots(bag) do
      if itemCache[bag][slot].isSetItem == true and bag ~= tarbag  then
        x = x + 1
      end
    end
  end
  local numberOfFreeSlots, BagType = GetContainerNumFreeSlots(tarbag)
  numberOfFreeSlotsTotal = numberOfFreeSlots
  if targetbag2 ~= "0" then 
    numberOfFreeSlots2, BagType2 =  GetContainerNumFreeSlots(tarbag2)
    numberOfFreeSlotsTotal = numberOfFreeSlots + numberOfFreeSlots2
  end
  if numberOfFreeSlotsTotal >= x then
    for bag = 0,4 do
      for slot = 1,GetContainerNumSlots(bag) do
        if itemCache[bag][slot].isSetItem == true and bag ~= tarbag then
          if numberOfFreeSlots > 0 then
            SortContainerItem(itemCache[bag][slot].name,targetbag,itemCache)
            numberOfFreeSlots = numberOfFreeSlots - 1
          else
            SortContainerItem(itemCache[bag][slot].name,targetbag2,itemCache)
            altMessage = true
          end
        end
      end
    end
    if SmartBagSettings["Alerts"] == true then
      if altMessage == true then
        print("|cFF0066FF<SmartBag> |rGear Sorted To: |cFF66FF33" .. KeepEquipmentButton:GetText() .. "," .. KeepEquipmentButton2:GetText())
      else
        print("|cFF0066FF<SmartBag> |rGear Sorted To: |cFF66FF33" .. KeepEquipmentButton:GetText() )
      end
    end
  else
    if SmartBagSettings["Alerts"] == true then
      print("|cFF0066FF<SmartBag> |rEquipment Sorting: |cFFFFFF00Not Enough Free Space.")
      print("|cFF0066FF<SmartBag> |rEquipment Sorting: |cFFFFFF00Required Space: " .. x )
      print("|cFF0066FF<SmartBag> |rEquipment Sorting: |cFFFFFF00Available Space: " .. numberOfFreeSlots)
      print("|cFF0066FF<SmartBag> |rEquipment Sorting: |cFFFFFF00Target: " .. KeepEquipmentButton:GetText() )
    end
  end
  ClearCursor()
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
  if value == 1 then value = 0 end 
  if value == 20 then value = 1 end
  if value == 21 then value = 2 end
  if value == 22 then value = 3 end
  if value == 23 then value = 4 end
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

function WhatSet(itemname)
  local itemset = nil
  for equipset = 1,GetNumEquipmentSets() do 
    name, icon, lessIndex = GetEquipmentSetInfo(equipset)
    itemArray = GetEquipmentSetItemIDs(name);
    for itemslot = 1,19 do 
      if GetItemInfo(itemArray[itemslot]) then
        iname, ilink, iRarity, iLevel, ireqLevel, iclass, isubclass, imaxStack, iequipSlot, itexture, ivendorPrice = GetItemInfo(itemArray[itemslot])
        if itemname == iname then itemset = name
        end
      end
    end
  end
  return itemset
end

function UpdateItemCache(bankstate)
  local itemCache = {}
  local bagNum
  if bankstate == true then 
    bagNum = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
  else
    bagNum = NUM_BAG_SLOTS
  end
  for bag = 0,bagNum do
    itemCache[bag] = {}
    for slot = 1,GetContainerNumSlots(bag) do
      itemCache[bag][slot] = {}
      local item = GetContainerItemLink(bag,slot)
      if item then
        itemCache[bag][slot].name, itemCache[bag][slot].link, itemCache[bag][slot].rarity, itemCache[bag][slot].itemLevel, itemCache[bag][slot].levelReq , itemCache[bag][slot].class, itemCache[bag][slot].subClass, itemCache[bag][slot].maxStack, itemCache[bag][slot].equipSlot, itemCache[bag][slot].texture, itemCache[bag][slot].vendorPrice = GetItemInfo(item)
        texture, itemCache[bag][slot].itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(bag, slot)
        if IsSetItem(itemCache[bag][slot].name) == true then
          itemCache[bag][slot].isSetItem = true
          itemCache[bag][slot].itemSet = WhatSet(itemCache[bag][slot].name)
        end
      end
    end
  end
  if bankstate == true then
    itemCache[12] = {}
    for slot = 1,28 do
      itemCache[12][slot] = {}
      local item = GetContainerItemLink(-1,slot)
      if item then
        itemCache[12][slot].name, itemCache[12][slot].link, itemCache[12][slot].rarity, itemCache[12][slot].itemLevel, itemCache[12][slot].levelReq , itemCache[12][slot].class, itemCache[12][slot].subClass, itemCache[12][slot].maxStack, itemCache[12][slot].equipSlot, itemCache[12][slot].texture, itemCache[12][slot].vendorPrice = GetItemInfo(item)
        texture, itemCache[12][slot].itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(12, slot)
        if IsSetItem(itemCache[12][slot].name) == true then
          itemCache[12][slot].isSetItem = true
          itemCache[12][slot].itemSet = WhatSet(itemCache[12][slot].name)
        end
      end
    end
  end
  return itemCache
end