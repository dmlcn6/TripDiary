//
//  MemoryTripTitleCell.swift
//  TripEx
//
//  Created by Dominic Pilla on 12/9/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class MemoryTripTitleCell: UITableViewCell {
    
    @IBOutlet weak var memoryTripTitle: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectTripPressed(_ sender: Any) {
    }
}
