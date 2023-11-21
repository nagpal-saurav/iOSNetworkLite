//
//  SNFirebaseConfiguration.swift
//  Awakening Stories
//
//  Created by Saurav Nagpal on 23/12/22.
//

import Foundation

public class SNFirebaseConfiguration: SNNetworkConfiguration {
    public var queryParameters: NetworkQueryParameter
    
    public init(queryParameters: NetworkQueryParameter) {
        self.queryParameters = queryParameters
   }
}
