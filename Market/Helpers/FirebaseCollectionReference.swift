//
//  FirebaseCollectionReference.swift
//  Market
//
//  Created by MYMACBOOK on 26.04.2021.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
    case Comments
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
