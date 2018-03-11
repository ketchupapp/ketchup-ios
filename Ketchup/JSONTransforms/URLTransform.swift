//
//  URLTransform.swift
//  Ketchup
//
//  Created by Brian Dorfman on 2/25/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import Foundation
import ObjectMapper

open class URLTransform: TransformType {
    public typealias Object = URL
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> URL? {
        if let stringURL = value as? String {
            return URL(string: stringURL)
        }
        return nil
    }
    
    open func transformToJSON(_ value: URL?) -> String? {
        if let url = value {
            return url.absoluteString
        }
        return nil
    }
}
