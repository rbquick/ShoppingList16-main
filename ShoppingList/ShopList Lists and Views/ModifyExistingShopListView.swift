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
        .navigationBarTitle("Modify Location")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: customBackButton)
        }
    }
    func customBackButton() -> some View {
            //...  see comments in ModifyExistingItemView about using
            // our own back button.
        Button {
            if draftShopList.associatedShopList != nil {
                ShopList.updateAndSave(using: draftShopList)
            }
            persistentStore.save()
            dismiss()
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}

//struct ModifyExistingShopListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifyExistingShopListView()
//    }
//}
