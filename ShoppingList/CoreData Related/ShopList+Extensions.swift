//
//  List+Extensions.swift
//  ShoppingList
//
//  Created by Brian Quick on 2023-03-30.
//  Copyright © 2023 Jerry. All rights reserved.
//

import CoreData
import Foundation
import SwiftUI

extension ShopList {
    // MARK: - Fronting Properties

    // the name.  this fronts a Core Data optional attribute
    var name: String {
        get { name_ ?? "No Name" }
        set {
            name_ = newValue
            locations.forEach({ $0.objectWillChange.send() })
        }
    }

    // MARK: - Computed Properties

    // items: fronts Core Data attribute locations_ that is an NSSet, and turns it into
    // a Swift array
    var locations: [Location] {
        if let locations = locations_ as? Set<Location> {
            return locations.sorted(by: \.name)
        }
        return []
    }
        // itemCount: computed property from Core Data items
    var locationCount: Int { locations_?.count ?? 0 }

    // MARK: - Useful Fetch Request

    // a fetch request we can use in views to get all locations, sorted in name order.

    class func allShopListsFR() -> NSFetchRequest<ShopList> {
        let request: NSFetchRequest<ShopList> = ShopList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return request
    }

    // MARK: - Class Functions

        // this class variable must be set up when the app begins so that as a class,
        // we can find the persistent store and its context.
        // it has the type PersistentStore! which means that when it comes time to
        // actually use it, it will have been set and will be non-nil.
    static var persistentStore: PersistentStore!

    class func count() -> Int {
        return count(context: persistentStore.context)
    }

    // creates a new List having an id, but then it's the user's responsibility
    // to fill in the field values (and eventually save)
    class func addNewShopList() -> ShopList {
        let newShopList = ShopList(context: persistentStore.context)
        newShopList.id = UUID()
        return newShopList
    }

    class func delete(_ shoplist: ShopList) {
        // in the location entity, these are set to the unknownLocation
        // Since there s/b no unknown ShopList I do not think this has to be done.
        // CoreData should look after this or not allow it
        // let locationsAtThisList = shoplist.locations
        persistentStore.context.delete(shoplist)
        persistentStore.save()
    }

    class func updateAndSave(using draftShopList: DraftShopList) {
            // if the incoming list data represents an existing List, this is just
            // a straight update.  otherwise, we must create the new List here and add it
            // before updating it with the new values
        if let shoplist = draftShopList.associatedShopList {
            shoplist.updateValues(from: draftShopList)
        } else {
            let newShopList = ShopList(context: persistentStore.context)
            newShopList.id = UUID()
                // this places the new List at the start of the list,
                // so you can see it right away upon return to the ListsView
            newShopList.updateValues(from: draftShopList)
        }
        persistentStore.save()
    }
    class func object(withID id: UUID) -> ShopList? {
        return object(id: id, context: persistentStore.context) as ShopList?
    }

    // MARK: - Object Methods

    func updateValues(from draftShopList: DraftShopList) {

        // see explanation in the Location extension

        locations.forEach({ $0.objectWillChange.send()})

        // we make changes directly in Core Data
        name_ = draftShopList.shoplistName

    }
}  // end of extension List
