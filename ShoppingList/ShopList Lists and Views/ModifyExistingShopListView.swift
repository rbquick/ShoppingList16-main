//
//  ModifyExistingShopListView.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-04-01.
//  Copyright © 2023 Jerry. All rights reserved.
//

import SwiftUI

struct ModifyExistingShopListView: View {

    @Environment(\.dismiss) var dismiss: DismissAction
    @EnvironmentObject private var persistentStore: PersistentStore

    @StateObject private var draftShopList: DraftShopList

    init(shoplist: ShopList) {
        _draftShopList = StateObject(wrappedValue: DraftShopList(shoplist: shoplist))
    }

    var body: some View {

        DraftShopListForm(draftShopList: draftShopList) {
            dismiss()
        }

    }
}

//struct ModifyExistingShopListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifyExistingShopListView()
//    }
//}
