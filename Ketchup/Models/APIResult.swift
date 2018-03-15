//
//  APIResult.swift
//  Ketchup
//
//  Created by Brian Dorfman on 3/14/18.
//  Copyright © 2018 Ketchup. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

/*
 All of our apis return a top level object that has either
 an errors key (which contains key values paramter that has error -> array of human readable error strings for that param)
 or a value key (which contains the returned value)

 This adds that parsing to Result via object mapper
 */
enum KetchupAPIError: Error {
    case singleErrorString(String)
    case parameterErrors([String: Any])
}

extension KetchupAPIError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .singleErrorString(let string):
            return string
        case .parameterErrors(let errorDict):
            return errorDict.flatMap { key, value -> String? in
                return "\(key): \(value)"
                }.joined(separator: "\n")
        }
    }
}

extension DataRequest {
    
    @discardableResult
    public func validateKetchupAPI() -> Self {
        var validStatusCodes = Set(200..<300)
        validStatusCodes.insert(401)
        validStatusCodes.insert(422)
        
        return validate(statusCode: validStatusCodes)
            .validate { (request, response, data) -> Request.ValidationResult in
                do {
                    guard let data = data else {
                        throw AFError.responseSerializationFailed(reason: .inputDataNil)
                    }
                    let json = try JSON(data: data)
                    
                    if let singleErrorString = json["error"].string {
                        throw KetchupAPIError.singleErrorString(singleErrorString)
                    } else if let errorDict = json["errors"].dictionary {
                        throw KetchupAPIError.parameterErrors(errorDict)
                    } else if !json["value"].exists() {
                        throw AFError.responseSerializationFailed(reason: .inputDataNil)
                    } else {
                        return .success
                    }
                } catch {
                    return .failure(error)
                }
        }
    }
}


//


//
//
//extension Result: ImmutableMappable {
//    public init(map: Map) throws {
//        if map.JSON["errors"] != nil {
//            self = .failure(KetchupAPIError.parameterErrors(try map.value("errors")))
//        } else if map.JSON["error"] != nil {
//            self = .failure(KetchupAPIError.singleErrorString(try map.value("error")))
//        } else if let value: Value = try map.value("value") as? Mappable {
//            self = .success(value)
//        }
//    }
//
//    public mutating func mapping(map: Map) {
//        // Unimplemented
//        // Don't need to ever reverse map this back to json
//    }
//}

