//
//  DogResponse.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/8/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit

struct breedsListResponse: Codable{
    let status: String
    let message: [String: [String]]
}

struct dogImagesResponse: Codable{
    let status: String
    let message: [String]
}
