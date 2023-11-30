//
//  DefinitionCell.swift
//  SampleApp
//
//  Created by Jake Gray on 11/29/23.
//

import UIKit

class DefinitionCell: UITableViewCell {
    
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func configure(number: Int, definition: String) {
        numberLabel.text = String.localizedStringWithFormat("Definition %d", number)
        
        definitionLabel.text = definition
    }
    
}
