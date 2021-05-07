//
//  BasketManager.swift
//  Market
//
//  Created by MYMACBOOK on 30.04.2021.
//

import Foundation

class BasketManager {
    
    static let shared = BasketManager()
    private init() {}
    
    //MARK: - Download items
    func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
        FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
    
            if !snapshot.isEmpty && snapshot.documents.count > 0 {
                let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                completion(basket)
            } else {
                completion(nil)
            }
        }
    }

    //MARK: - Save to Firebase
    func saveBasketToFirestore(_ basket: Basket) {
        FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
    }

    //MARK: Helper functions
    func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
        return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds ?? [""]], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying])
    }

    //MARK: - Update basket
    func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
        FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
            completion(error)
        }
    }
}
