//
//  ResponseResult.swift
//  CanadaFacts
//
//  Created by Kiran Chowdary on 8/5/18.
//  Copyright © 2018 Kiran Chowdary. All rights reserved.
//

import Foundation

enum ResponseResult<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}
