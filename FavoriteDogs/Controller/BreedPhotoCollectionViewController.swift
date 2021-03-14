//
//  BreedPhotoCollectionViewController.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/9/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BreedPhotoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let tag = "BreedPhotoCollectionViewController"
    var selectedBreed: String = ""
    var breedImages:[String] = []
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    @IBOutlet weak var breedPhotoCollectionView: UICollectionView!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<FavoriteDog>!

    
    override func viewDidLoad() {
        let funcTag = "viewDidLoad"
        print(tag, funcTag, "selectedBreed: ", selectedBreed)
        titleNavigationItem.title = selectedBreed
        setupCollectionView()
        getBreedImages()
    }
    
    
    func setupCollectionView(){
        breedPhotoCollectionView.dataSource = self
        breedPhotoCollectionView.delegate = self
        breedPhotoCollectionView.allowsMultipleSelection = true
        
        if let flowLayout = breedPhotoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let space:CGFloat = 3.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    
    func getBreedImages(){
        let funcTag = "getBreedImages"
        updateBackgroundView(load: true)
        DogClient.getImagesOfDogBreed(breed: selectedBreed){
            (imagesResponse, Error) in
            self.updateBackgroundView(load: false)
            print(self.tag, " ", funcTag, " Number of breed images: ", imagesResponse.count)
            self.breedImages = imagesResponse ?? []
            DispatchQueue.main.async {
                self.breedPhotoCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func backToBreedTable(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateBackgroundView(load: Bool){
        if load{
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: breedPhotoCollectionView.frame.width, height: breedPhotoCollectionView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "Very slow network connection!..Dogs are on their way..Please wait..!"
            breedPhotoCollectionView.backgroundView = label
        }else{
            breedPhotoCollectionView.backgroundView = nil
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.breedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let funcTag = "collectionView - cellForItemAt: "
        print(tag, funcTag, "Index: ", indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "breedImageCell", for: indexPath) as! BreedCollectionViewCell

        //Start and Show Activity Indicator..
        cell.breedImageActivityIndicator.isHidden = false
        cell.breedImageActivityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let imageData = try? Data.init(contentsOf: URL(string:self.breedImages[indexPath.row])!)
            print(funcTag, " imageData: ", imageData)
            DispatchQueue.main.async {
                let image: UIImage = UIImage(data: imageData!)!
                cell.setImage(src: image)
                
                //Stop and Hide Activity Indicator..
                cell.breedImageActivityIndicator.isHidden = true
                cell.breedImageActivityIndicator.stopAnimating()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let funcTag = "collectionView - didSelectItemAt"
        print("Adding selected Item: ", breedImages[indexPath.row], " to favorites")
        if(imageAlreadyExistsInFavorites(imageUrl: breedImages[indexPath.row])){
            //Dsiplay an alert that image already exists in persistance storage.
            self.showAlert(title: "Sorry", message: "Couldn't add because selected image already exists in favorites list!")
        }else{
            //Add to favorites
            let favoriteDog = FavoriteDog(context: self.dataController.viewContext)
            favoriteDog.id = UUID().uuidString
            favoriteDog.creationDate = Date()
            favoriteDog.image = nil
            favoriteDog.breed = selectedBreed
            favoriteDog.url = breedImages[indexPath.row]
            do {
                try self.dataController.viewContext.save()
                print(tag, funcTag, "Dog saved to favorites")
                //Alert
                let alert = UIAlertController(title: "Alert", message: "Image saved to favorites!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Problem saving photo to persistence storage!")
            }
        }
    }
    
    
    func imageAlreadyExistsInFavorites(imageUrl: String)->Bool {
            var funcTag = "imageAlreadyExistsInFavorites"
            print(tag, funcTag)
        
            let fetchRequest:NSFetchRequest<FavoriteDog> = FavoriteDog.fetchRequest()
            let predicate = NSPredicate(format: "url == %@", argumentArray: [imageUrl])
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext:dataController.viewContext,
                                                                  sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchedResultsController.performFetch()
            } catch {
                fatalError("The fetch could not be performed: \(error.localizedDescription)")
            }
            print(tag, funcTag , "Fetched Objects count: ",fetchedResultsController.fetchedObjects?.count ?? 0)
        if(fetchedResultsController.fetchedObjects?.count ?? 0 > 0){
            return true
        }else{
            return false
        }
    }
    
    
}
