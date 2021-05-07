//
//  ItemsTableViewCell.swift
//  Market
//
//  Created by MYMACBOOK on 28.04.2021.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ item: Item) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = "\(item.price ?? 0.0) TL"
        
        if let link = item.imageLink {
            StorageManager.shared.downloadImages(imageUrl: link) { (image) in
                DispatchQueue.main.async {
                    self.itemImageView.image = image
                }
            }
        } else {
            DispatchQueue.main.async {
                self.itemImageView.image = UIImage(systemName: "imagePlaceholder")
            }
        }
    }
}
