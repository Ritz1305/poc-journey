//
//  HomeModel.swift
//  POCApp
//
//  Created by Ritesh on 05/11/20.
//  Copyright © 2020 Ritesh. All rights reserved.
//

import Foundation
import UIKit

struct Home: Codable {
    let title: String
    let rows: [Row]
}

struct Row: Codable {
    let title: String?
    let rowDescription: String?
    let imageURL: String?
    var image: UIImage?

    enum CodingKeys: String, CodingKey {
        case title
        case rowDescription = "description"
        case imageURL = "imageHref"
    }
}
