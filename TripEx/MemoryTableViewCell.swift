//
//  MemoryTableViewCell.swift
//  TripEx
//
//  Created by Darryl Lopez on 12/8/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class MemoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
