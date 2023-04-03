//
//  ShopListsView.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-04-01.
//  Copyright © 2023 Jerry. All rights reserved.
//

import SwiftUI

class mastershoplistname: ObservableObject {
    @Published var mastershoplistname = ""
}
struct ShopListsView: View {

    @EnvironmentObject private var persistentStore: PersistentStore
    @ObservedObject var mastershoplistname: mastershoplistname

    // MARK: - @FetchRequest

    // this is the @FetchRequest that ties this view to CoreData Locations
    @FetchRequest(fetchRequest: ShopList.allShopListsFR())
    private var shoplists: FetchedResults<ShopList>

    // MARK: - @State and @StateObject Properties

    // state to trigger a sheet to appear to add a new location
@State private var isAddNewShopListSheetPresented = false

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 0) {

            Rectangle()
                .frame(height: 1)
            HStack {
                Text("Current Shopping list is \(MyDefaults().myMasterShopListName)")
                    .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .font(.headline)
            }

            List {
                Section(header: Text("Shopping Lists: \(shoplists.count)")) {
                    ForEach(shoplists) { shoplist in
                        NavigationLink(value:shoplist) {
                            ShopListRowView(shoplist: shoplist, mastershoplistname: mastershoplistname) { setmasterShopList(shoplistName: shoplist.name) }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())

            Divider()
        }
        .navigationBarTitle("Lists Available")
        .navigationDestination(for: ShopList.self) { shoplist in
            ModifyExistingShopListView(shoplist: shoplist)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: addNewButton)
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
        }
        .sheet(isPresented: $isAddNewShopListSheetPresented) {
            AddNewShopListView()
        }
        .onAppear { handleOnAppear() }
        .onDisappear { persistentStore.save() }
    }
    func handleOnAppear() {
        mastershoplistname.mastershoplistname = MyDefaults().myMasterShopListName
        if shoplists.count == 0 {
            // don't know what to do here with no ShopList?
//            let _ = ShopList.unknownLocation()
        }
    }
    // defines the usual "+" button to add a Location
    func addNewButton() -> some View {
        Button {
            isAddNewShopListSheetPresented = true
        } label: {
            Image(systemName: "plus")
        }
    }
    func setmasterShopList(shoplistName: String) {
        mastershoplistname.mastershoplistname = shoplistName
        MyDefaults().myMasterShopListName = shoplistName
    }

}

//struct ShopListsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopListsView()
//    }
//}
