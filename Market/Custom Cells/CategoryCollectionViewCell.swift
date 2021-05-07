//
//  CategoryCollectionViewCell.swift
//  Market
//
//  Created by MYMACBOOK on 27.04.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(_ category: Category) {
        nameLabel.text = category.name
        imageView.image = category.image
    }
}
