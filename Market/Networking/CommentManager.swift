//
//  CommentManager.swift
//  Market
//
//  Created by MYMACBOOK on 1.05.2021.
//

import Foundation

class CommentManager {
    
    static let shared = CommentManager()
    private init() {}
    
    //MARK: - Save comment to firestore
    func saveCommentToFirestore(_ comment: Comment) {
        FirebaseReference(.Comments).document(comment.id).setData(commentDictionaryForm(comment) as! [String : Any])
    }
    
    //MARK: - Helper functions
    func commentDictionaryForm(_ comment: Comment)
    -> NSDictionary {
        return NSDictionary(objects: [comment.id, comment.itemId, comment.ownerId, comment.date, comment.comment], forKeys: [kOBJECTID as NSCopying, kITEMID as NSCopying, kOWNERID as NSCopying, kDATE as NSCopying, kCOMMENT as NSCopying])
    }
    
    //MARK: Download Func
    func downloadCommentsFromFirebase(_ withItemId: String, completion: @escaping (_ commentArray: [Comment]) -> Void) {
        var commentArray: [Comment] = []
        
        FirebaseReference(.Comments).whereField(kITEMID, isEqualTo: withItemId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(commentArray)
                return
            }
            
            if !snapshot.isEmpty {
                for commentDict in snapshot.documents {
                    commentArray.append(Comment(dictionary: commentDict.data() as NSDictionary))
                }
                completion(commentArray)
            }
        }
    }
}
