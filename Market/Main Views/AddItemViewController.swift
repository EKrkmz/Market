//
//  AddItemViewController.swift
//  Market
//
//  Created by MYMACBOOK on 27.04.2021.
//

import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var category: Category!
    var itemImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func doneButton(_ sender: Any) {
        dismissKeayboard()
        
        if fieldsAreCompleted() {
            saveToFirebase()
        } else {
            let alert = UIAlertController(title: "Error", message: "All fields are required!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        itemImage = nil
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeayboard()
    }
    
    //MARK: - Helper functions
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    
    private func fieldsAreCompleted() -> Bool {
        return (titleTextField.text != "" && priceTextField.text != "" && descTextView.text != "")
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Save Item
    private func saveToFirebase() {
        activityIndicator.startAnimating()
        
        var item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text
        item.categoryId = category.id
        item.description = descTextView.text
        item.price = Double(priceTextField.text!)
        
        if itemImage != nil {
            StorageManager.shared.uploadImages(image: itemImage, itemId: item.id) { (imageLink) in
                item.imageLink = imageLink
                ItemManager.shared.saveItemToFirestore(item)
                
                self.activityIndicator.stopAnimating()
                self.popTheView()
            }
            
        } else {
            ItemManager.shared.saveItemToFirestore(item)
            popTheView()
        }
    }
    
    //MARK: Show Gallery
    private func showImageGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

//MARK: UIImagePickerControllerDelegate
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.itemImage = image
        dismiss(animated: true, completion: nil)
    }
}
