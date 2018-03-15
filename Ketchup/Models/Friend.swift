//
//  Friend.swift
//  Ketchup
//
//  Created by Brian Dorfman on 2/25/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import Foundation
import ObjectMapper

class Friend: Mappable {
    var id: Int!
    var name: String!
    var lastKetchup: Date?
    var avatarURL: URL?
    
    let requiredKeys = ["id", "name"]
    
    required init?(map: Map) {
        for key in requiredKeys {
            if map.JSON[key] == nil {
                return nil
            }
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        lastKetchup <- (map["last_ketchup"], DateTransform())
        avatarURL <- (map["avatar"], URLTransform())
    }
}
