//
//  CategoryManager.swift
//  Market
//
//  Created by MYMACBOOK on 30.04.2021.
//

import Foundation

class CategoryManager {
    
    static let shared = CategoryManager()
    private init() {}
    
    //MARK: - Download Category from firebase
    func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
        var categoryArray: [Category] = []
        FirebaseReference(.Category).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(categoryArray)
                return
            }
            if !snapshot.isEmpty {
                for categoryDict in snapshot.documents {
                    categoryArray.append(Category(dictionary: categoryDict.data() as NSDictionary))
                }
            }
            completion(categoryArray)
        }
    }

    //MARK: - Save Category Functions
    func saveCategoryToFirebase(category: Category) {
        let id = UUID().uuidString
        var c = category
        c.id = id

        FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category: c) as! [String : Any])
    }

    //MARK: - Helpers
    func categoryDictionaryFrom(category: Category) -> NSDictionary {
        return NSDictionary(objects: [category.id, category.name, category.imageName ?? ""], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
    }

    func createCategorySet() {
        //This method should be called only one time. So made sure of it with user defaults
         guard !UserDefaults.standard.bool(forKey: "didCreateCategories") else {
            return
        }
        UserDefaults.standard.setValue(true, forKey: "didCreateCategories")
        
        let womenClothing = Category(name: "Women", imageName: "womenCloth")
        let footWaer = Category(name: "Footwaer", imageName: "footWaer")
        let electronics = Category(name: "Electronics", imageName: "electronics")
        let menClothing = Category(name: "Men" , imageName: "menCloth")
        let health = Category(name: "Health", imageName: "health")
        let baby = Category(name: "Baby", imageName: "baby")
        let home = Category(name: "Home", imageName: "home")
        let car = Category(name: "Car", imageName: "car")
        let luggage = Category(name: "Bags", imageName: "luggage")
        let jewelery = Category(name: "Jewelery", imageName: "jewelery")
        let hobby =  Category(name: "Hobby", imageName: "hobby")
        let pet = Category(name: "Pet Product", imageName: "pet")
        let industry = Category(name: "Industry", imageName: "industry")
        let garden = Category(name: "Garden", imageName: "garden")
        let camera = Category(name: "Cameras", imageName: "camera")

        let arrayOfCategories = [womenClothing, footWaer, electronics, menClothing, health, baby, home, car, luggage, jewelery, hobby, pet, industry, garden, camera]

        for category in arrayOfCategories {
            saveCategoryToFirebase(category: category)
        }
    }    
}
