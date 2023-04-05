//
//  CompactMainView.swift
//  ShoppingList
//
//  Created by Jerry on 5/6/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import SwiftUI

// rbq 2023-04-05
// Reworked this file so it basically works the same as
//      the RegularMainView except the list of the Regular
//      is turned into a TabView here.
//  These could be broken down even farther to make
//  maintenance a little easier.

// The shopListList enum was added to facilitate the
//  ShopListsView() which is a entity of shopping lists
//  so you can have more than one list, with different items and locations.


// ORIGINAL COMMENTS
// the CompactMainView is a tab view with five tabs.
// not much happens here, although do notice that each of the five views is
// wrapped in a NavigationStack.  this makes perfect sense in SwiftUI ... a
// NavigationStack can be a subview of a TabView, but don't ever make a TabView
// a subview of a NavigationStack !

struct CompactMainView: View {

    // what screen do you want to show 1st
    @State private var selection: NavigationItem = .shoppingList

    var body: some View {
        NavigationStack {
            switch selection {
            case .shopListList:
                ShopListsView()
            case .shoppingList:
                ShoppingListView()
            case .purchasedList:
                PurchasedItemsView()
            case .locationList:
                LocationsView()
            case .inStoreTimer:
                TimerView()
            case .preferences:
                PreferencesView()
            }
        }
        Spacer()
        Text("Selected Tag: \(selection.rawValue)")
            .foregroundColor(.clear)
            .frame(width: 0, height: 0)
        TabView(selection: $selection) {
            Rectangle()
                .tabItem { Label("Lists", systemImage: "list.bullet.rectangle.portrait") }
                .tag(NavigationItem.shopListList)
            Rectangle()
                .tabItem { Label("Shopping List", systemImage: "cart") }
                .tag(NavigationItem.shoppingList)
            Rectangle()
                .tabItem { Label("Purchased", systemImage: "purchased") }
                .tag(NavigationItem.purchasedList)
            Rectangle()
                .tabItem { Label("Locations", systemImage: "map") }
                .tag(NavigationItem.locationList)
            // rbq 2023-04-05 removed the timer since I don't really want it
            // but the ...more on the tabview with more that 5 tabs doesn't seem
            // to work and at this time, i do not feel like finding out why
            // TODO: fix more that 5 tabs
//            Rectangle()
//                .tabItem { Label("Stopwatch", systemImage: "stopwatch") }
//                .tag(NavigationItem.inStoreTimer)
            Rectangle()
                .tabItem { Label("Preferences", systemImage: "gear") }
                .tag(NavigationItem.preferences)
        } // end of TabView
        // This frame works on an iphone8
        // There s/b be a better was to put the tabview at
        //   the bottom of the screen.
        .frame(height: 40)
    } // end of var body: some View
}

