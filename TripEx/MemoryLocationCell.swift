//
//  MemoryLocationCell.swift
//  TripEx
//
//  Created by Dominic Pilla on 12/9/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class MemoryLocationCell: UITableViewCell {
    
    @IBOutlet weak var memoryLocation: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var findLocationPressed: UIButton!
}
