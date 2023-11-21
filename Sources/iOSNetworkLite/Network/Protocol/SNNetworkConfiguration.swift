//
//  SNNetworkConfiguration.swift
//  Grandparent Stories
//
//  Created by Saurav Nagpal on 19/05/22.
//

import Foundation
import CoreMedia
import Combine

public enum SupportedFramework {
    case firebase(configuration: SNNetworkConfiguration)
    case urlSession (baseURL: URL)
}

public protocol NetworkQueryParameter {
}

public protocol SNNetworkConfiguration {
    var queryParameters: NetworkQueryParameter { get }
}

public protocol NetworkCodableData: NetworkEncodableData, Decodable {
    init?(dict: [String: Any])
}

public protocol NetworkEncodableData: Encodable {
    func toDictionary() throws -> [String: Any]?
}

public extension NetworkEncodableData {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
