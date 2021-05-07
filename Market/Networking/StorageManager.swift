//
//  Downloader.swift
//  Market
//
//  Created by MYMACBOOK on 27.04.2021.
//

import Foundation
import FirebaseStorage

private let storage = Storage.storage()

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    func uploadImages(image: UIImage?, itemId: String, completion: @escaping (_ imageLink: String) -> Void) {
        let fileName = "ItemImages/" + itemId + "/" + ".jpg"
        let imageData = image!.jpegData(compressionQuality: 0.5)
                
        saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
            //it means we have successfully upload the image and get the link
            if let imageLink = imageLink {
                completion(imageLink)
            }
        }
    }

     func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink: String?) -> Void) {
        
        var task: StorageUploadTask!
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
        
        task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            task.removeAllObservers()
            
            if error != nil {
                print("Error uploading image", error!.localizedDescription)
                completion(nil)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
    }
    
    func downloadImages(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void) {
        var image: UIImage?
        let url = URL(string: imageUrl)
       
        if let url = url {
            let data = try? Data(contentsOf: url)
            if let data = data {
                image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Could not download image")
                completion(image)
            }
        }
    }
}
