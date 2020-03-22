//
//  ItemTableViewCell.swift
//  Assessment2
//
//  Created by Hin Wong on 3/6/20.
//  Copyright © 2020 Hin Wong. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBAction func completeButtonTapped(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
    
    var delegate: ItemTableViewCellDelegate?
    
    func toggleButton(_ isComplete: Bool) {
        let imageName = isComplete ? "complete" : "incomplete"
        completeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
}

extension ItemTableViewCell {
    func update(item: Item) {
        itemLabel.text = item.name
        toggleButton(item.isComplete)
    }
}

protocol ItemTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ItemTableViewCell)
}
