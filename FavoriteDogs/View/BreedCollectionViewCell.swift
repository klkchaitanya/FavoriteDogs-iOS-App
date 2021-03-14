//
//  BreedCollectionViewCell.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/9/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit

class BreedCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var breedImageActivityIndicator: UIActivityIndicatorView!
    
    func setImage(src: UIImage){
      breedImage.image = src
    }
}
