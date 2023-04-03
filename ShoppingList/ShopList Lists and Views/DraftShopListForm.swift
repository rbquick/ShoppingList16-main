//
//  DraftShopListForm.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-04-01.
//  Copyright © 2023 Jerry. All rights reserved.
//

import SwiftUI

struct DraftShopListForm: View {

    @ObservedObject var draftShopList: DraftShopList
    var dismissAction: (() -> Void)?

    // trigger for adding a new item at this Location
    @State private var isAddNewLocationSheetPresented = false
    // trigger for confirming deletion of the associated Location (if the
    // draft represents an existing Location that is not the Unknown Location)
    @State private var isConfirmDeleteShopListPresented = false
    
    // definition of whether we can offer a deletion option in this view
    // (it's a real location that's not the unknown shoplist)
    // rbq 2023-04-01 don't really care if this is unknown
    var shoplistCanBeDeleted: Bool = true

    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                HStack {
                    SLFormLabelText(labelText: "Name: ")
                    TextField("Shop List name", text: $draftShopList.shoplistName)
                }
            } // end of Section 1

            // Section 2:

            if shoplistCanBeDeleted {
                Section(header: Text("ShopList Management")) {
                    Button("Delete This ShopList") {
                        isConfirmDeleteShopListPresented = true // trigger confirmation dialog
                    }
                    .foregroundColor(Color.red)
                    .hCentered()
                    .confirmationDialog("Delete \'\(draftShopList.shoplistName)\'?", isPresented: $isConfirmDeleteShopListPresented, titleVisibility: .visible) {
                        Button("Yes", role: .destructive) {
                            if let shoplist = draftShopList.associatedShopList {
                                ShopList.delete(shoplist)
                                dismissAction?()
                            }
                        }
                    } message: {
                        Text("Are you sure you want tot delete the ShopList named \'\(draftShopList.shoplistName)\'? All Locations and items will be removed.  This action cannot be undone.")
                    }
                }
            } // end of Section 2

            // Section 3: Locations assigned to this ShopList, if we are editing a ShopList
            if let associatedShopList = draftShopList.associatedShopList {
                Section(header: LocationsListHeader()) {
                    SimpleLocationsList(shoplist: associatedShopList)
                }
            }
        } // end of Form
        .sheet(isPresented: $isAddNewLocationSheetPresented) {
            AddNewLocationView(shoplist: draftShopList.associatedShopList)
        }
    } // end of var body: some View

    var shoplistLocationCount: Int {
        if let shoplist = draftShopList.associatedShopList {
            return shoplist.locations.count
        }
        return 0
    }

    func LocationsListHeader() -> some View {
        HStack {
            Text("This Shoplist has \(shoplistLocationCount) Locations")
            Spacer()
            Button {
                isAddNewLocationSheetPresented = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// this is a quick way to see a list of items associated
// with a given location that we're editing.
struct SimpleLocationsList: View {

    @ObservedObject var shoplist: ShopList

    var body: some View {
        ForEach(shoplist.locations) { location in
            NavigationLink {
                ModifyExistingLocationView(location: location)
            } label: {
                HStack {
                    Text(location.name)
                }
            }
        }
    }
}

//struct DraftShopListForm_Previews: PreviewProvider {
//    static var previews: some View {
//        DraftShopListForm()
//    }
//}
