//
//  CommentCell.swift
//  Incopo
//
//  Created by Laurentiu Ile on 15.02.2021.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView! {
        didSet {
            commentTextView.isEditable = false
            commentTextView.isScrollEnabled = false 
        }
    }
}
