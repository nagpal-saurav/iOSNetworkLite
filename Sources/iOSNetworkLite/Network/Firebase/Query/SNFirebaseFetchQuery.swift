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

class FirebaseCollectionFetchQuery: SNFirebaseQuery {
    var collectionID: String
    var queryParameter: [String: Any]?
    var orderBy: String?
    
    var firebaseQuery: Query {
        var query = Firestore.firestore().collection(collectionID) as Query
        if let queryParameter = queryParameter {
            for (key, value) in queryParameter {
                if value is String {
                    query = query.whereField(key, isEqualTo: value)
                } else if let value = value as? [String: String] {
                    let findValue = value["value"] ?? ""
                    query = query.whereField(key, arrayContains: findValue)
                }
            }
        }
        if let orderBy = self.orderBy, orderBy.count > 0 {
            query = query.order(by: orderBy, descending: true)
        }
        return query
    }
    
    init(collectionID: String, queryParameter: [String: Any], orderBy: String? = nil) {
        self.collectionID = collectionID
        self.queryParameter = queryParameter
        self.orderBy = orderBy
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

class FirebaseCollectionFetchRandomQuery: FirebaseCollectionFetchQuery {
    
    override func executeQuery(completion: @escaping QueryCompletion) {
        self.firebaseQuery.addSnapshotListener { (snapshot, error) in
            let documentCount = snapshot?.documents.count ?? 0
            let randomNumber = Int.random(in: (0..<documentCount))
            let response: [String: Any]?
            if documentCount > randomNumber {
                response = snapshot?.documents[randomNumber].data()
            } else {
                response = snapshot?.documents.first?.data()
            }
            if let response = response, let jsonData = try? JSONSerialization.data(withJSONObject:response){
                completion(jsonData, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
