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
import Network

class DogBreedViewController: UITableViewController{
    
    let tag = "DogBreedViewController"
    var breeds: [String] = []
    @IBOutlet var breedsTableView: UITableView!
    var dataController: DataController!
    
    let monitor = NWPathMonitor()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedsTableView.delegate = self
        breedsTableView.dataSource = self
        ///setupTableView()
        
        monitor.pathUpdateHandler = {
            path in
            if path.status == .satisfied {
                print("Connected to internet!")
            } else {
                print("No internet connection!")
                self.showAlert(title: "Error", message: "No internet connection!")
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkInternetConnection()
        if(breeds.count == 0){
            setupTableView()
        }
    }
    
    func checkInternetConnection(){
        let funcTag = "checkInternetConnection"
        print(tag, funcTag)
        

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
            label.text = "Loading breeds list.Please wait..!"
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
        let funcTag = "prepare for segue"
        
        guard let breedPhotoCollectionViewController = segue.destination as? BreedPhotoCollectionViewController else{return}
        let breedSelected: String = sender as! String
        breedPhotoCollectionViewController.selectedBreed = breedSelected
        breedPhotoCollectionViewController.dataController = dataController
    }

    
}
