//
//  FirebaseRequest.swift
//  Grandparent Stories
//
//  Created by Saurav Nagpal on 20/05/22.
//

import Foundation
import FirebaseFirestore
import Combine

@available(iOS 13.0, *)
public final class SNFirebaseDataTransmissionService {
    private var stores = Set<AnyCancellable>()
    public init() {
    }
}

@available(iOS 13.0, *)
extension SNFirebaseDataTransmissionService: SNDataTransmissionService {
    //MARK: - iVar
    public func request<T>(with request: SNNetworkRequest) -> (Future<T, SNNetworkError>) where T : Decodable {
        return Future { promise in
            guard let firebaseQuery = self.getQueryFromRequest(request: request) else {
                promise(.failure(.paramterMissing(message: "Not valid parameter.")))
                return
            }
            firebaseQuery.executeQuery { response, error in
                do {
                    if let response = response, error == nil {
                        let resposneObject = try JSONDecoder().decode(T.self, from: response)
                        promise(.success(resposneObject))
                    }
                } catch {
                    print("repsonse not valid")
                    promise(.failure(.responseInvalid(message: "Not valid Json Resposne.")))
                }
            }
        }
    }
    
    fileprivate func getQueryFromRequest(request: SNNetworkRequest) -> SNFirebaseQuery? {
        guard let firebaseRequest = request as? SNFirebaseRequest else {
            return nil
        }
        do {
            return try SNFirebaseQueryBuilder.buildQuery(request: firebaseRequest)
        } catch {
            return nil
        }
    }
}
