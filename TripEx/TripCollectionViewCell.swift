//
//  TripCollectionViewCell.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/27/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class TripCollectionViewCell: UICollectionViewCell {
   
    
    var id:String!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
    }

    
    
}
