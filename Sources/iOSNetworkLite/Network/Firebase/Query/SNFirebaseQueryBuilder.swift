//
//  SNFirebaseQueryBuilder.swift
//  Mammer
//
//  Created by Saurav Nagpal on 27/05/23.
//

import Foundation

struct SNFirebaseQueryBuilder {
    static func buildQuery(request: SNFirebaseRequest) throws -> SNFirebaseQuery? {
        switch request.method {
        case .fetch:
            return self.fetchQuery(request: request)
        case .add:
            return try self.addQuery(request: request)
        }
    }
}

//MARK: - Fetch
fileprivate extension SNFirebaseQueryBuilder {
    static func fetchQuery(request: SNFirebaseRequest) -> SNFirebaseQuery? {
        guard let firebasePath = request.path as? FirbasePath else {
            return nil
        }
        switch firebasePath {
        case .collection(let url):
            if request.queryParametersEncodable != nil {
                do {
                    if let queryDictionary = try request.queryParametersEncodable?.toDictionary() {
                        return FirebaseCollectionFetchQuery(collectionID: url, queryParameter: queryDictionary)
                    }
                } catch {
                    
                }
            } else {
                return FirebaseCollectionFetchQuery(collectionID: url, queryParameter: request.queryParameters)
            }
           
        case .document(let url):
            return FirebaseDocumentFetchQuery(documentPath: url)
        }
        return nil
    }
}

//MARK: - Add
fileprivate extension SNFirebaseQueryBuilder {
    static func addQuery(request: SNFirebaseRequest) throws -> SNFirebaseQuery? {
        guard let firebasePath = request.path as? FirbasePath else {
            return nil
        }
        let bodyParameters = try request.queryParametersEncodable?.toDictionary() ?? request.queryParameters
        switch firebasePath {
        case .collection(let url):
            return SNFirbaseAddDocumentQuery(documentPath: url, postData: bodyParameters)
        case .document(let url):
            return FirebaseDocumentFetchQuery(documentPath: url)
        }
    }
}
