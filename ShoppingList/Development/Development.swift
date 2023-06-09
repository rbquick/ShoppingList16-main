//
//  Development.swift
//  ShoppingList
//
//  Created by Jerry on 5/14/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import Foundation
import CoreData

// what i previously called a "Dev Tools" tab is now incorporated into the
// Preferences tab.  if you want to use SL16 as a real app (device or simulator),
// access to all the debugging stuff can be displayed or not by setting this global
// variable `kShowDevTools`. for now, we'll show this on the simulator
// and not on a device.

#if targetEnvironment(simulator)
	let kShowDevTools = true
#else
let kShowDevTools = false
#endif

// i used these constants and functions below during development to import and
// export Items and Locations via JSON.  these are the filenames for JSON output
// when dumped from the simulator and also the filenames in the bundle used to load sample data.
let kJSONDumpDirectory = "/Users/rbq/Desktop/"	// dumps to the Desktop: Adjust for your Username!
let kItemsFilename = "items.json"
let kLocationsFilename = "locations.json"
let kShopListsFilename = "shoplists.json"

// to write stuff out -- a list of Items and a list of Locations --
// the code is essentially the same except for the typing of the objects
// in the list.  so we use the power of generics:  we introduce
// (1) a protocol that demands that something be able to produce a simple
// Codable (struct) representation of itself -- a proxy as it were.
protocol CodableStructRepresentable {
	associatedtype DataType: Codable
	var codableProxy: DataType { get }
}

// and (2), knowing that Item and Location are NSManagedObjects, and we
// don't want to write our own custom encoder (eventually we will), we extend each to
// be able to produce a simple, Codable struct proxy holding only what we want to write out
// (ItemCodable and LocationCodable structs, respectively)
func writeAsJSON<T>(items: [T], to filename: String) where T: CodableStructRepresentable {
	let codableItems = items.map(\.codableProxy)
	let encoder = JSONEncoder()
	encoder.outputFormatting = .prettyPrinted
	var data = Data()
	do {
		data = try encoder.encode(codableItems)
	} catch let error as NSError {
		print("Error converting items to JSON: \(error.localizedDescription), \(error.userInfo)")
		return
	}
	
	// if in simulator, dump to files somewhere on your Mac (check definition above)
	// and otherwise if on device (or if file dump doesn't work) simply print to the console.
	#if targetEnvironment(simulator)
		let filepath = kJSONDumpDirectory + filename
		do {
			try data.write(to: URL(fileURLWithPath: filepath))
			print("List of items dumped as JSON to " + filename)
		} catch let error as NSError {
			print("Could not write to desktop file: \(error.localizedDescription), \(error.userInfo)")
			print(String(data: data, encoding: .utf8)!)
		}
	#else
		// prints to the console when running on a device
		print(String(data: data, encoding: .utf8)!)
	#endif
	
}

func populateDatabaseFromJSON(persistentStore: PersistentStore) {
	// it sure is easy to do this with HWS's Bundle extension (!)
    // rbq added shoplist 2023-03-31
    let codableShopLists: [ShopListCodableProxy] = Bundle.main.decode(from: kShopListsFilename)
    insertNewShopLists(from: codableShopLists)
	let codableLocations: [LocationCodableProxy] = Bundle.main.decode(from: kLocationsFilename)
	insertNewLocations(from: codableLocations)
	let codableItems: [ItemCodableProxy] = Bundle.main.decode(from: kItemsFilename)
	insertNewItems(from: codableItems)
	persistentStore.save()
}

func insertNewItems(from codableItems: [ItemCodableProxy]) {
	
	// get all Locations that are not the unknown location
	// group by name for lookup below when adding an item to a location
	let locations = Location.allUserLocations()
	let name2Location = Dictionary(grouping: locations, by: { $0.name })
	
	for codableItem in codableItems {
		let newItem = Item.addNewItem() // new UUID is created here
		newItem.name = codableItem.name
		newItem.quantity = codableItem.quantity
		newItem.onList = codableItem.onList
		newItem.isAvailable_ = codableItem.isAvailable
		newItem.dateLastPurchased_ = nil // never purchased
		
		// look up matching location by name
		// anything that doesn't match goes to the unknown location.
		if let location = name2Location[codableItem.locationName]?.first {
			newItem.location = location
		} else {
			newItem.location = Location.unknownLocation() // if necessary, this creates the Unknown Location
		}
		
	}
}
// rbq added 2023-03-31
func insertNewShopLists(from codableShopLists: [ShopListCodableProxy]) {
    for codableShopList in codableShopLists {
        let newShopList = ShopList.addNewShopList()
        newShopList.name = codableShopList.name
    }
}
// used to insert data from JSON files in the app bundle
func insertNewLocations(from codableLocations: [LocationCodableProxy]) {

    //  rbq added 2023-03-31
    // get all ShopLists
    // group by name for lookup below when adding an item to a location
    let shoplists = ShopList.allUserShopLists()
    let name2ShopList = Dictionary(grouping: shoplists, by: { $0.name })

	for codableLocation in codableLocations {
		let newLocation = Location.addNewLocation() // new UUID created here
		newLocation.name = codableLocation.name
		newLocation.visitationOrder = codableLocation.visitationOrder
		newLocation.red_ = codableLocation.red
		newLocation.green_ = codableLocation.green
		newLocation.blue_ = codableLocation.blue
		newLocation.opacity_ = codableLocation.opacity

        // rbq added 2023-03-31
        // look up matching location by name
        // anything that doesn't match goes to the unknown location.
        if let shoplist = name2ShopList[codableLocation.shoplistName]?.first {
            newLocation.shoplist = shoplist
        } else {
            // rbq 2023-03-31
            // if unknow, ????
//            newLocation.location = Location.unknownLocation() // if necessary, this creates the Unknown Location
        }
	}
}

	// MARK: - Useful Extensions re: CodableStructRepresentable

extension Location: CodableStructRepresentable {
	var codableProxy: some Encodable & Decodable {
		return LocationCodableProxy(from: self)
	}
}

extension Item: CodableStructRepresentable {
	var codableProxy: some Encodable & Decodable {
		return ItemCodableProxy(from: self)
	}
}
