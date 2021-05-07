//
//  ItemViewController.swift
//  Market
//
//  Created by MYMACBOOK on 29.04.2021.
//

import UIKit
import FirebaseFirestore

class ItemViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var item: Item!
    var commentArray: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadComments()
    }
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = "Price: \(item.price ?? 0.0) TL"
            descriptionTextView.text = item.description
        }
    }
    
    //MARK: - Download Pictures & Comments
    private func downloadPictures() {
        if item != nil && item.imageLink != nil {
            StorageManager.shared.downloadImages(imageUrl: item.imageLink ?? "") { (image) in
                self.imageView.image = image
            }
        }
    }
    
    private func loadComments() {
        CommentManager.shared.downloadCommentsFromFirebase(item.id) { (allComments) in
            self.commentArray = allComments
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func addComment(_ sender: Any) {
        var comment = Comment()
        comment.id = UUID().uuidString
        comment.itemId = item.id
        comment.ownerId = USER1 // USER
        comment.date = dateFormatter()
        
        if let text = commentTextField.text {
            comment.comment = text
            CommentManager.shared.saveCommentToFirestore(comment)
            commentTextField.text = nil
            loadComments()
        } else {
            print("Please write a comment")
        }
    }
    
    @objc func addToBasketButtonPressed() {      //USER
        BasketManager.shared.downloadBasketFromFirestore(USER1) { (basketToAdd) in
            var basket = basketToAdd
            if basket == nil {
                self.createNewBasket()
            } else {
                basket!.itemIds.append(self.item.id)
                self.updateBasket(basket: basket!, withValues: [kITEMIDS : basket!.itemIds ?? [""]])
            }
        }
    }
    
    //MARK: Add to basket
    private func createNewBasket() {
        var newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = USER1 //USER
        newBasket.itemIds = [item.id]
        
        BasketManager.shared.saveBasketToFirestore(newBasket)
    }
    
    //MARK: Update to basket
    private func updateBasket(basket: Basket, withValues: [String:Any]) {
        BasketManager.shared.updateBasketInFirestore(basket, withValues: withValues) { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Added to basket", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

//MARK: Show comments
extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(comment: commentArray[indexPath.row])
        return cell
    }
}
