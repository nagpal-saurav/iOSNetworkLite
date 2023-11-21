//
//  SNFirebaseFetchQuery.swift
//  Awakening Stories
//
//  Created by Saurav Nagpal on 30/12/22.
//

import Foundation
import FirebaseFirestore

struct FirebaseDocumentFetchQuery: SNFirebaseQuery {
    fileprivate(set) var documentPath: String
    
    init(documentPath: String) {
        self.documentPath = documentPath
    }
    
    func executeQuery(completion: @escaping QueryCompletion) {
        let documentRef = Firestore.firestore().document(self.documentPath)
        documentRef.getDocument() { (snapshot, error) in
            let response = snapshot?.data()
            if let response = response, let jsonData = try? JSONSerialization.data(withJSONObject:response){
                completion(jsonData, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}

struct FirebaseCollectionFetchQuery: SNFirebaseQuery {
    var collectionID: String
    var queryParameter: [String: Any]?
    var firebaseQuery: Query {
        let query = Firestore.firestore().collection(collectionID)
        if let queryParameter = queryParameter {
            for (key, value) in queryParameter {
                if value is String {
                    return query.whereField(key, isEqualTo: value)
                } else if let value = value as? [String: String] {
                    let findValue = value["value"] ?? ""
                    return query.whereField(key, arrayContains: findValue)
                }
            }
        }
        return query
    }
    
    init(collectionID: String, queryParameter: [String: Any]) {
        self.collectionID = collectionID
        self.queryParameter = queryParameter
    }
    
    func executeQuery(completion: @escaping QueryCompletion) {
        self.firebaseQuery.addSnapshotListener { (snapshot, error) in
            let response = snapshot?.documents.map { document in
                return document.data()
            }
            if let response = response, let jsonData = try? JSONSerialization.data(withJSONObject:response){
                completion(jsonData, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
