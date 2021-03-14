//
//  DogClient.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/8/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit

class DogClient{
    
    static var tag = "DogClient"
    
    struct Breed{
        static var breedName = ""
    }
    
    enum Endpoints{
        
        static let base = "https://dog.ceo/api"
        
        case allBreeds
        case imagesOfBreed
        
        var stringValue:String {
            switch self{
            case .allBreeds:
                return Endpoints.base + "/breeds/list/all"
            case .imagesOfBreed:
                return Endpoints.base + "/breed/\(Breed.breedName)/images"
 
            }
        }
        
        var url:URL{
            return URL(string: stringValue)!
        }
    }
    
    
    //get all breeds of dogs
    class func getAllBreeds(completion: @escaping ([String]?, Error?)->Void)->Void{
        let funcTag = "getAllBreeds"
        taskForGetRequest(url: Endpoints.allBreeds.url , responseType: breedsListResponse.self) {
            response, error in
            if let response = response {
                print(funcTag, " Response status is: ", response.status)
                if response.status=="success"{
                let allBreeds = response.message.keys.map({$0})
                completion(allBreeds, nil)
                }else{
                  completion(nil, error)
                }
            } else {
                print(funcTag, error)
                completion(nil, error)
            }
        }
    }
    
    //get images of dogs of selected breed
    class func getImagesOfDogBreed(breed: String, completion: @escaping ([String], Error?)->Void)->Void{
        let funcTag = "getImagesOfDogBreed"
        Breed.breedName = breed
        taskForGetRequest(url: Endpoints.imagesOfBreed.url , responseType: dogImagesResponse.self) {
            response, error in
            if let response = response {
                print(funcTag, " Response status is: ", response.status)
                if response.status=="success"{
                let breedImages = response.message
                print(tag, " ", funcTag, " ", "Number of breed images: ", breedImages.count)
                completion(breedImages, nil)
                }else{
                    completion([], error)
                }
            } else {
                print(funcTag, error)
                completion([], error)
            }
        }
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?)->Void){
        let FUNC_TAG = "taskForGetRequest"
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            guard let data = data else {
                DispatchQueue.main.async{
                    print(FUNC_TAG, error)
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    print( FUNC_TAG, "responseObject: ", responseObject)
                    completion(responseObject, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    print( FUNC_TAG, "error: ", error)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
