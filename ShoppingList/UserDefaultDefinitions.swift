//
//  UserDefaultDefinitions.swift
//  ShoppingList
//
//  Created by Jerry on 12/16/22.
//  Copyright © 2022 Jerry. All rights reserved.
//

import Foundation

// i collect all the keys and default values for what are to be the User Defaults.
// this is to be sure that all the strings defining the keys are in exactly one
// place and not scattered through the SwiftUI views when defining their
// local access to the user default.

// @AppStorage keys
let kShoppingListIsMultiSectionKey = "kShoppingListIsMultiSectionKey"
let kPurchasedListIsMultiSectionKey = "kPurchasedListIsMultiSectionKey"
let kPurchasedMostRecentlyKey = "kPurchasedMostRecentlyKey"
let kDisableTimerWhenInBackgroundKey = "kDisableTimerWhenInBackgroundKey"
let kMasterShopListNameKey = "kMasterShopListNameKey"

// @AppStorage default values
let kShoppingListIsMultiSectionDefaultValue = false
let kPurchasedListIsMultiSectionDefaultValue = false
let kPurchasedMostRecentlyDefaultValue = 3
let kDisableTimerWhenInBackgroundDefaultValue = false
let kMasterShopListNameDefaultValue = "Costco"

class MyDefaults {
    let defaults = UserDefaults.standard
    var myMasterShopListName: String {
        get { return defaults.string(forKey: kMasterShopListNameKey) ?? kMasterShopListNameDefaultValue }
        set { defaults.setValue(newValue, forKey: kMasterShopListNameKey) }
    }
}
