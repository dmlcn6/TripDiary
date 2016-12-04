//
//  PhotoCollectionViewCell.swift
//  TripEx
//
//  Created by Darryl Lopez on 11/22/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var id:String!
    
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
