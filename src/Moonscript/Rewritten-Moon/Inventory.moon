-- Inventory.moon

from Util import Require

PAPI = Require 'U_PAPI' -- Player API

S_DATA_STORE= Service 'DataStoreService'
INVENTORIES = S_DATA_STORE\GetDataStore 'Inventories'

class Inventory
  INVENTORIES: {}

  new: (plr) =>
    t = {
      Owner: plr

      INVENTORY: {}

      AddItem: (item) =>
        if item.__type == Item
          @insert item.Name, item
        else
          error '!'

      GetItem: (finder) =>
        if type(finder) == 'string'
          @INVENTORY[finder]
        elseif type(finder) == 'number'
          for item in *@INVENTORY
            item if item.Id == finder
        elseif type(finder) == 'table'
          {@GetItem newFinder for newFinder in *finder}

      GetItems: => @INVENTORY
    }

    @@INVENTORIES[plr] = setmetatable t, {
      __index: t
      __newindex: (key, vlaue) =>
        if v.__parent == Item
          @[key] = value
        else
          warn '?'
      __metatable: => rawget @, '__index'
    }
    @INVENTORY[plr]

  GetInventory: (plr) =>
    @@INVENTORIES[PAPI.GetUserId plr]

  SetInventory: (plr) =>
    @@INVENTORIES[PAPI.GetUserId plr] = t or @new PAPI.GetPlayer(plr).Name

  LoadInventory: (plr) =>
    S_DATA_STORE\GetDataStore('Inventory')\GetAsync PAPI.GetPlayer plr or @new PAPI.GetPlayer(plr).Name


  SaveInventory: (plr) =>
    S_DATA_STORE\GetDataStore('Inventory')\SetAsync PAPI.GetPlayer(plr).Name, @GetInventory plr
