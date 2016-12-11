//
//  ShowMemoryViewController.swift
//  TripEx
//
//  Created by Thomas Van Doorn  on 12/10/16.
//  Copyright © 2016 Darryl Lopez. All rights reserved.
//

import UIKit

class ShowMemoryViewController: UIViewController {

    @IBOutlet weak var memoryPhotoView: UIImageView!
    @IBOutlet weak var memoryTitleLabel: UILabel!
    @IBOutlet weak var memoryNoteArea: UITextView!
    
    var currMemory : TripMemory?
    var memPhotos = [MemoryPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currMemory = currMemory {
            //text stuff
            memoryTitleLabel.text = currMemory.memTitle
            memoryNoteArea.text = currMemory.memNote
            
            //photto stuff
            if let photosArray = currMemory.memPhotos?.allObjects as? [MemoryPhoto] {
                if photosArray.isEmpty{
                    print("empty array of photos")
                }else {
                    if let photo = photosArray.first {
                        if let memPhotoData = photo.memPhotoData as Data?{
                            memoryPhotoView.image = UIImage(data: memPhotoData, scale: 1.0)
                        }
                    }
                }
            }else {
                print("cant unwrap arraay of photos")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: Selector(("dismissFullscreenImage:")))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
}
