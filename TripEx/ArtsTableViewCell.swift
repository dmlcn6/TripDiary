//
//  ArtsTableViewCell.swift
//  TripEx
//
//  Created by Art Martin on 12/7/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class ArtsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var leftImg: UIButton!
    @IBOutlet weak var rightImg: UIButton!
    
    
    @IBOutlet weak var leftLbl: UILabel!
    @IBOutlet weak var rightLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //leftImg.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
       // rightImg.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        
        let size = CGSize(width: 125, height: 125)
        
        
        
        
        
        //leftImg.imageView?.contentMode = UIViewContentMode.scaleAspectFit;
        //rightImg.imageView?.contentMode = UIViewContentMode.scaleAspectFit;
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
