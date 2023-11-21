//
//  SNDataTransmissionService.swift
//  Awakening Stories
//
//  Created by Saurav Nagpal on 22/12/22.
//

import Foundation
import Combine

public enum SNNetworkError: Error {
    case paramterMissing(message: String)
    case responseInvalid(message: String)
    
    var description: String {
        switch self {
        case .paramterMissing(let message):
            return message
        case .responseInvalid(let message):
            return message
        }
    }
}

@available(iOS 13.0, *)
public protocol SNDataTransmissionService {
    @discardableResult
    func request<T: Decodable>(with request: SNNetworkRequest) -> (Future<T, SNNetworkError>)
}
