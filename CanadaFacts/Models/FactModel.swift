//
//  FactModel.swift
//  CanadaFacts
//
//  Created by Kiran Chowdary on 8/5/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//

import Foundation

struct FactModel: Decodable {
    let title: String?
    let description: String?
    let imageHref: URL?
}


