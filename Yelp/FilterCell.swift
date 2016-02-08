//
//  FilterCell.swift
//  Yelp
//
//  Created by Che Chao Hsu on 2/6/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit

@objc protocol FilterCellDelegate {
    optional func filterCell(filterCell: FilterCell, didChangeValue value: Bool)
}

class FilterCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    weak var delegate: FilterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // 10:45 video
        filterSwitch.addTarget(self, action: "", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged() {
        // if delegate != nil {
        // call filterCell if delegate happen to implement filterCell
            delegate?.filterCell?(self, didChangeValue: filterSwitch.on)
    }
}
