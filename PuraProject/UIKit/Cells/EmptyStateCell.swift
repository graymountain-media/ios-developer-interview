//
//  EmptyStateCell.swift
//  SampleApp
//
//  Created by Jake Gray on 11/29/23.
//

import UIKit

enum EmptyState {
    case emptySearch
    case noResultsFound
}

class EmptyStateCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure(state: EmptyState) {
        switch state {
        case .emptySearch:
            iconImageView.image = UIImage(named: "dictionarySearch")
            messageLabel.text = NSLocalizedString("Explore definitions with ease!\n\n Just type your word into the search bar and let the app do the rest.", comment: "Empty search state message")
        case .noResultsFound:
            iconImageView.image = UIImage(named: "noResult")
            messageLabel.text = NSLocalizedString("No results found for that word! Try another!", comment: "Empty search results message")
        }
    }
    
}
