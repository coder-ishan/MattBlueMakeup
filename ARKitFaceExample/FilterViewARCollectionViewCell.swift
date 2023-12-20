//
//  FilterViewARCollectionViewCell.swift
//  ARKitFaceExample
//
//  Created by Ishan Singh on 17/12/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

class FilterViewARCollectionViewCell: UICollectionViewCell {
    var indexPath : IndexPath?
   
    @IBOutlet weak var filterImage: UIImageView!
    
    // Add a method to handle tap gesture
       func addTapGesture(target: Any, action: Selector) {
           let tapGesture = UITapGestureRecognizer(target: target, action: action)
           filterImage.isUserInteractionEnabled = true
           filterImage.addGestureRecognizer(tapGesture)
       }
    
}
