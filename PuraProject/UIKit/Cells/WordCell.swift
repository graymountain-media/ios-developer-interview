//
//  WordCell.swift
//  SampleApp
//
//  Created by Jake Gray on 11/29/23.
//

import UIKit

class WordCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(word: String) {
        label.text = String.localizedStringWithFormat("Word: %@", word.capitalized)
    }
    
}
