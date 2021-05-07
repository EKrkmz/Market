//
//  CommentTableViewCell.swift
//  Market
//
//  Created by MYMACBOOK on 1.05.2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(comment: Comment) {
        nameLabel.text = comment.ownerId
        dateLabel.text = comment.date
        commentLabel.text = comment.comment
    }
}
