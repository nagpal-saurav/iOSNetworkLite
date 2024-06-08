//
//  SNFirebaseRequest.swift
//  Awakening Stories
//
//  Created by Saurav Nagpal on 23/12/22.
//

import Foundation

public enum FirbasePath: RequestPath {
    case collection(path: String)
    case document(path: String)
}

public enum SNFirebaseRequestMethod: RequestMethod {
    case fetch
    case fetchRandom
    case add
}

public struct SNFirebaseRestriction {
    var orderBy: String
    
    public init(orderBy: String) {
        self.orderBy = orderBy
    }
}

public class SNFirebaseRequest: SNNetworkRequest {
    public let path: RequestPath
    public let method: SNFirebaseRequestMethod
    public var queryParametersEncodable: NetworkEncodableData?
    public var queryRestriction: SNFirebaseRestriction?
    public let queryParameters: [String: Any]
    public let responseDecoder: ResponseDecoder
    
    public init(path: FirbasePath,
         method: SNFirebaseRequestMethod,
         queryParametersEncodable: NetworkEncodableData? = nil,
         queryRestriction: SNFirebaseRestriction? = nil,
         queryParameters: [String: Any] = [:],
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.method = method
        self.queryRestriction = queryRestriction
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.responseDecoder = responseDecoder
    }
}
