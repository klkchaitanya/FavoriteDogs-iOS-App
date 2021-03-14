//
//  DogBreedViewController.swift
//  FavoriteDogs
//
//  Created by Leela Krishna Chaitanya Koravi on 3/8/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DogBreedViewController: UITableViewController{
    
    var breeds: [String] = []
    @IBOutlet var breedsTableView: UITableView!
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedsTableView.delegate = self
        breedsTableView.dataSource = self
        ///setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(breeds.count == 0){
            setupTableView()
        }
    }
    
    func setupTableView(){
        let funcTag = "setupTableView"
        updateBackgroundView(load: true)
        DogClient.getAllBreeds(){
            (breedsResponse, error) in
            guard let breedsResp = breedsResponse else{
                self.showAlert(title: "Network Problem", message: "Something went wrong getting list of dog breeds!")
                return
            }
            self.updateBackgroundView(load: false)
            print(funcTag, " Number of breeds: ", breedsResponse?.count)
            self.breeds = breedsResponse ?? []
            DispatchQueue.main.async {
                self.breedsTableView.reloadData()
            }
        }
    }
    
    func updateBackgroundView(load: Bool){
        if load==false{
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: breedsTableView.frame.width, height: breedsTableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "Very slow network connection!"+"\n"+"Loading breeds list.Please wait..!"
            breedsTableView.backgroundView = label
        }else{
            breedsTableView.backgroundView = nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.breeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogBreedCell", for: indexPath) as! DogBreedTableViewCell
        let breed = self.breeds[indexPath.row]
        cell.dogBreedLabel?.text = breed
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected breed: ", breeds[indexPath.row] ?? "")
        self.performSegue(withIdentifier: "BreedTableToBreedCollectionSegue", sender: breeds[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let FUNC_TAG = "prepare for segue"
        
        guard let breedPhotoCollectionViewController = segue.destination as? BreedPhotoCollectionViewController else{return}
        let breedSelected: String = sender as! String
        breedPhotoCollectionViewController.selectedBreed = breedSelected
        breedPhotoCollectionViewController.dataController = dataController
    }

    
}
