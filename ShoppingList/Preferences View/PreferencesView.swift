//
//  OperationTabView.swift
//  ShoppingList
//
//  Created by Jerry on 6/11/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
	
	// this view is a restructured version of the older DevToolTab to now handle
	// user preferences.  for the moment, the only preference we have is for
	// setting the number of days back in time to section out the item in the
	// PurchasedItemsView:
	// -- first section: items purchased within the last N days
	// -- second section: all other items purchased.
	// we'll allow N here to be 0 ... 10
	
	// in SL16, i have added a preference for whether to disable a running timer
	// when in the background; and i have cleaned up the view code so i can really
	// read and understand some of what was written three years ago (!)
	
	@EnvironmentObject private var persistentStore: PersistentStore
	
	@State private var confirmDataHasBeenAdded = false
    @State private var shoplistsAdded: Int = 0
	@State private var locationsAdded: Int = 0
	@State private var itemsAdded: Int = 0
	
	// user default. 0 = purchased today; 3 = purchased up to 3 days ago, ...
	@AppStorage(kPurchasedMostRecentlyKey)
	private var historyMarker = kPurchasedMostRecentlyDefaultValue
	
	// user default.  true ==> turn of timer (counting) when in the background.
	@AppStorage(kDisableTimerWhenInBackgroundKey)
	private var suspendTimerWhenInBackground = kDisableTimerWhenInBackgroundDefaultValue

    // rbq added 2023-03-30
    // this is the @FetchRequest that ties this view to CoreData Locations
    @FetchRequest(fetchRequest: ShopList.allShopListsFR())
    private var shoplists: FetchedResults<ShopList>
    @FetchRequest(fetchRequest: Location.allLocationsPreferences())
    private var locations: FetchedResults<Location>
    @FetchRequest(fetchRequest: Item.allItemsPreferences())
    private var items: FetchedResults<Item>
	var body: some View {
		Form {
			Section(header: Text("Purchased Items History Mark"),
							footer: Text("Sets the number of days to look backwards in time to separate out items purchased recently.")) {
				Stepper(value: $historyMarker, in: 0...10) {
					HStack {
						SLFormLabelText(labelText: "History mark: ")
						Text("\(historyMarker)")
					}
				}
			}
			
			Section(header: Text("Timer Preference"),
							footer: Text("Turn this on if you want the timer to pause, say, while you are on a phone call")) {
				Toggle(isOn: $suspendTimerWhenInBackground) {
					Text("Suspend when in background")
				}
			}
			
			if kShowDevTools {
				Section("Developer Actions") {
					List {
							// 1.  load sample data
						Button("Load Sample Data") {
							loadSampleData()
						}
						.hCentered()
						.disabled(Item.count() > 0)

							// 2. offload data as JSON
						Button("Write database as JSON") {
							writeDatabase()
						}
						.hCentered()
                        // rbq added 2023-03-30
                        // 3.  Delete sample data
                        Button("Delete All Data") {
                            deleteAllData()
                        }
                        .hCentered()
                        .disabled(ShopList.count() == 0)
					} // end of List
					.listRowSeparator(.automatic)
				} // end of Section
			} // end of if kShowDevTools
		} // end of Form
		.navigationBarTitle("Preferences")
		.alert("Data Added", isPresented: $confirmDataHasBeenAdded) {
			Button("OK", role: .none) { }
		} message: {
			Text("Sample data for the app (\(locationsAdded) locations and \(itemsAdded) shopping items) have been added.")
		}
	} // end of var body: some View
	
	func loadSampleData() {
        let currentShopListCount = ShopList.count() // rbq added 2023-03-31
		let currentLocationCount = Location.count() // what it is now
		let currentItemCount = Item.count() // what it is now
		populateDatabaseFromJSON(persistentStore: persistentStore)
        shoplistsAdded = ShopList.count() - currentShopListCount // rbq added 2023-03-31
		locationsAdded = Location.count() - currentLocationCount // now the differential
		itemsAdded = Item.count() - currentItemCount // now the differential
		confirmDataHasBeenAdded = true
	}
	
	func writeDatabase() {
		writeAsJSON(items: Item.allItems(), to: kItemsFilename)
		writeAsJSON(items: Location.allUserLocations(),
								to: kLocationsFilename)
	}
    // rbq added 2023-03-30
    // delete all the items on and off the list before the locations
    func deleteAllData() {
        print("Items On:  \(items.count)")
        for item in items {
            Item.delete(item)
        }
        print("Locations: \(locations.count)")
        for location in locations {
            Location.delete(location)
        }
        print("ShopLists: \(shoplists.count)")
        for shoplist in shoplists {
            ShopList.delete(shoplist)
        }
    }
}
