//
//  FavoriteDogsPhotoCollectionViewController.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/11/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteDogsPhotoCollectionViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate{
    
    let tag = "FavoriteDogsPhotoCollectionViewController"
    var dataController: DataController!
    @IBOutlet weak var favoriteDogsCollectionView: UICollectionView!
    var fetchedResultsController: NSFetchedResultsController<FavoriteDog>!
    
    override func viewDidLoad() {
        let funcTag = "viewDidLoad"
        setupCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupFetchedResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
        favoriteDogsCollectionView.dataSource = nil
    }
    
    func setupCollectionView(){
        favoriteDogsCollectionView.dataSource = self
        favoriteDogsCollectionView.delegate = self
        favoriteDogsCollectionView.allowsMultipleSelection = true
        
        if let flowLayout = favoriteDogsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let space:CGFloat = 3.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    
    func setupFetchedResultsController() {
        var funcTag = "setupFetchedResultsController"
        print(tag, funcTag)
        
        //TEST Fetching all photos and their count...
        //        let fetchRequestTemp:NSFetchRequest<Photo> = Photo.fetchRequest()
        //        do {
        //            let allPhotos = try self.dataController.viewContext.fetch(fetchRequestTemp)
        //            //print("Total photos in db: ", allPhotos.count)
        //        }
        //        catch {
        //            print("Error fetching all photos: \(error)")
        //        }
        
        let fetchRequest:NSFetchRequest<FavoriteDog> = FavoriteDog.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext:dataController.viewContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        print(tag, funcTag , "Fetched Objects count: ",fetchedResultsController.fetchedObjects?.count ?? 0)
    }
    
    func updateBackgroundView(count: Int){
        if(count==0){
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: favoriteDogsCollectionView.frame.width, height: favoriteDogsCollectionView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Images found in persistence storage!"
            favoriteDogsCollectionView.backgroundView = label
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        updateBackgroundView(count: count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let funcTag = "collectionView - cellForItemAt"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteImageCell", for: indexPath as IndexPath) as! FavoriteDogCollectionViewCell
        
        guard !(self.fetchedResultsController.fetchedObjects?.isEmpty)! else {
            print("images are already present.")
            return cell
        }
        
        // fetch core data
        let favDog = self.fetchedResultsController.object(at: indexPath)
        if favDog.image == nil {
            //print(FUNC_TAG, "photo.photoData is nil")
            DispatchQueue.global(qos: .background).async {
                let imageData = try? Data.init(contentsOf: URL(string:favDog.url!)!)
                print(funcTag, " imageData: ", imageData)
                DispatchQueue.main.async {
                    let image: UIImage = UIImage(data: imageData!)!
                    //cell.setImage(src: image)
                    cell.favoriteDogImageView.image = image
                }
            }
        } else {
            print(tag, funcTag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select item at: ", indexPath)
        let selectedImageToRemove = fetchedResultsController.object(at: indexPath)
        let imageUrl = selectedImageToRemove.url
        if let favoriteImages = fetchedResultsController.fetchedObjects {
            for image in favoriteImages {
                if image.url == imageUrl {
                    print("Found image url match to delete")
                    dataController.viewContext.delete(image)
                    do {
                        try? dataController.viewContext.save()
                        //Alert
                        let alert = UIAlertController(title: "Alert", message: "Image removed from favorites!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                    } catch {
                        print("Unable to remove the photo")
                    }
                }
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let FUNC_TAG = "controller didChange"
        
        switch type{
        case .insert:
            self.favoriteDogsCollectionView.insertItems(at: [newIndexPath!])
            print(FUNC_TAG, "inserting items")
        case .delete:
            self.favoriteDogsCollectionView.deleteItems(at: [indexPath!])
            print(FUNC_TAG, "deleting items")
        case .update:
            self.favoriteDogsCollectionView.reloadItems(at: [indexPath!])
            print(FUNC_TAG, "reloading items")
        case .move:
            break
        @unknown default:
            break
        }
    }
    
}
