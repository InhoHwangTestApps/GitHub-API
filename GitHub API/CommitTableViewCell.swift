//
//  CommitTableViewCell.swift
//  GitHub API
//
//  Created by Inho Hwang on 2021/2/22.
//

import UIKit

class CommitTableViewCell: UITableViewCell {

    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commitHashLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func bindWithViewModel(commitViewModel: CommitViewModel) {
        authorLabel.text = commitViewModel.authorName;
        commitHashLabel.text = commitViewModel.commitHash;
        messageLabel.text = commitViewModel.commitMessage;
    }

}
