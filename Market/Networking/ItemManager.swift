//
//  ItemManager.swift
//  Market
//
//  Created by MYMACBOOK on 30.04.2021.
//

import Foundation

class ItemManager {
    
    static let shared = ItemManager()
    private init() {}
    
    //MARK: Save items func
    func saveItemToFirestore(_ item: Item) {
        FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
    }

    //MARK: Helper functions
   func itemDictionaryFrom(_ item: Item) -> NSDictionary {
        return NSDictionary(objects: [item.id, item.categoryId ?? "", item.name ?? "", item.description ?? "", item.price ?? 0.0, item.imageLink ?? ""], forKeys: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINK as NSCopying])
    }

    //MARK: Download Func
    func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
        var itemArray: [Item] = []
        FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(itemArray)
                return
            }
            
            if !snapshot.isEmpty {
                for itemDict in snapshot.documents {
                    itemArray.append(Item(dictionary: itemDict.data() as NSDictionary))
                }
            completion(itemArray)
           }
        }
    }
    
  //MARK: - Will be called from BasketViewController
    func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) ->Void) {
        var count = 0
        var itemArray: [Item] = []
        
        if withIds.count > 0 {
            for itemId in withIds {
                FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        completion(itemArray)
                        return
                    }

                    if snapshot.exists {
                        itemArray.append(Item(dictionary: snapshot.data()! as NSDictionary))
                        count += 1
                    }
                    
                    if count == withIds.count {
                        completion(itemArray)
                    }
                }
            }
        } else {
            completion(itemArray)
        }
    }
}
