//
//  LocationJSON.swift
//  ShoppingList
//
//  Created by Jerry on 5/10/20.
//  Copyright © 2020 Jerry. All rights reserved.
//

import Foundation

// this is a simple struct to extract only the fields of a Location
// that we would import or export in such a way that the result is Codable.
struct LocationCodableProxy: Codable {
	var name: String
	var visitationOrder: Int
	var red: Double
	var green: Double
	var blue: Double
	var opacity: Double
    var shoplistName: String

	init(from location: Location) {
		name = location.name
		visitationOrder = location.visitationOrder
		red = location.red_
		green = location.green_
		blue = location.blue_
		opacity = location.opacity_
        shoplistName = location.shoplistName
	}
}
