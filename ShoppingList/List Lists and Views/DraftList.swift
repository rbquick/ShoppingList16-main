//
//  DraftList.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-03-30.
//  Copyright © 2023 Jerry. All rights reserved.
//

import Foundation
import SwiftUI

    // **** see the more lengthy discussion over in DraftItem.swift as to why we are
    // using a class that's an ObservableObject.

class DraftShopList: ObservableObject {
    // the id of the List, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var id: UUID? = nil
    // all of the values here provide suitable defaults for a new Location
    @Published var shoplistName: String = ""

    init(shoplist: ShopList? = nil) {
        if let shoplist {
            id = shoplist.id
            shoplistName = shoplist.name
        }
    }

    // to do a save/commit of an Item, it must have a non-empty name
    var canBeSaved: Bool { shoplistName.count > 0 }

    // the associated location in Core Data, if any
var associatedShopList: ShopList? {
    if let id {
        return ShopList.object(withID: id)
    }
    return nil
}
}
