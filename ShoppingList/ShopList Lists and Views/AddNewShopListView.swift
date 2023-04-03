//
//  AddNewShopListView.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-04-01.
//  Copyright © 2023 Jerry. All rights reserved.
//

import SwiftUI

struct AddNewShopListView: View {

    @Environment(\.dismiss) private var dismiss

        // a draftLocation is initialized here, holding default values for
        // a new Location.
    @StateObject private var draftShopList: DraftShopList

    init(suggestedName: String? = nil, shoplist: ShopList? = nil) {
        let initialValue = DraftShopList(suggestedName: suggestedName)
        _draftShopList = StateObject(wrappedValue: initialValue)
    }
    var body: some View {
        NavigationStack {
            DraftShopListForm(draftShopList: draftShopList)
                .navigationBarTitle("Add New List")
                .navigationBarTitleDisplayMode(.inline)
                //.navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction, content: cancelButton)
                    ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!draftShopList.canBeSaved) }
                }
        }
    }
    // the cancel button
func cancelButton() -> some View {
    Button {
        dismiss()
    } label: {
        Text("Cancel")
    }
}

    // the save button
func saveButton() -> some View {
    Button {
        dismiss()
        ShopList.updateAndSave(using: draftShopList)
    } label: {
        Text("Save")
    }
}
}

struct AddNewShopListView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewShopListView()
    }
}
