//
//  FactInfo.swift
//  CanadaFacts
//
//  Created by Kiran Chowdary on 8/5/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//

import Foundation

struct FactInfo: Decodable {
    let title: String
    var facts: [FactModel]

    enum CodingKeys: String, CodingKey {
        case title
        case facts = "rows"
    }
}

