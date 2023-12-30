//
//  FilterData.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 30/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

class MakeupFilter:Decodable {
    var filterName: String
    var filterId: Int
    var filterUIimage: String
    var filterTutorialImage: String
    var filterMakeupImage: String
    var filterCategories: [String]

    init(filterName: String, filterId: Int, filterUIimage: String, filterTutorialImage: String, filterMakeupImage: String, filterCategories: [String]) {
        self.filterName = filterName
        self.filterId = filterId
        self.filterUIimage = filterUIimage
        self.filterTutorialImage = filterTutorialImage
        self.filterMakeupImage = filterMakeupImage
        self.filterCategories = filterCategories
    }
}
func decodeJSONFromFile() {
    if let url = Bundle.main.url(forResource: "makeup_filters", withExtension: "json"),
        let data = try? Data(contentsOf: url) {
        do {
            let makeupFilters = try JSONDecoder().decode([MakeupFilter].self, from: data)
            for filter in makeupFilters {
                print("Filter Name: \(filter.filterName)")
                // Access other properties as needed
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}


