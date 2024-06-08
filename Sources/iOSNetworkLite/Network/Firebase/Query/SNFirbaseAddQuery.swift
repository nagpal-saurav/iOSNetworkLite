//
//  SNFirbaseAddQuery.swift
//  Mammer
//
//  Created by Saurav Nagpal on 27/05/23.
//

import Foundation
import FirebaseFirestore

struct SNFirbaseAddDocumentQuery: SNFirebaseQuery {
    fileprivate(set) var documentPath: String
    fileprivate(set) var postData: [String: Any]
    
    init(documentPath: String, postData: [String: Any]) {
        self.documentPath = documentPath
        self.postData = postData
    }
    
    func executeQuery(completion: @escaping QueryCompletion) {
        var documentRef: DocumentReference? = nil
        documentRef = Firestore.firestore().document(self.documentPath)
        documentRef?.setData(self.postData) { error in
            var isSucess: Bool = false
            if let error = error {
                completion(isSucess.data, error)
            } else {
                isSucess = true
                completion(isSucess.data, nil)
            }
        }
    }
}

extension Bool {
    var data: Data {
        return try! JSONEncoder().encode(self)
    }
}
