//
//  ShopListCodableProxy.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-03-31.
//  Copyright © 2023 Jerry. All rights reserved.
//

import Foundation

// this is a simple struct to extract only the fields of a ShopList
// that we would import or export in such a way that the result is Codable.
struct ShopListCodableProxy: Codable {
    var name: String

    init(from shoplist: ShopList) {
        name = shoplist.name
    }
}
