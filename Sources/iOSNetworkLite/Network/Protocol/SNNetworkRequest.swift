//
//  EndPoint.swift
//  Awakening Stories
//
//  Created by Saurav Nagpal on 21/12/22.
//

import Foundation
import Combine

public protocol RequestMethod {
}

public protocol RequestPath {
}

public protocol NetworkCancellable {
    func cancel()
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

public protocol SNNetworkRequest {
    var path: RequestPath { get }
    var queryParametersEncodable: NetworkEncodableData? { get }
    var queryParameters: [String: Any] { get }
    var responseDecoder: ResponseDecoder { get }
}
