//
//  AnimeListCollectionViewController.swift
//  MyAnimeList
//
//  Created by Rajkumar Gurunathan on 01/12/20.
//  Copyright © 2020 Rajkumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData
class AnimeListCollectionViewController: UIViewController {
    
    @IBOutlet weak var animeCollectionView: UICollectionView!
    
    private var animeListVM: AnimeListViewModel!
    
    var selectedAnimeDetails: AnimeViewModel!
    var results: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To show title on left
        let titleTxt = "Anime List !"
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.text = titleTxt
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        if Reachability.isConnectedToNetwork(){
            onlineSetup()
        }else{
            offlineSetup()
        }
        
    }
    
    private func onlineSetup() {
    
        let url = URL(string: "https://api.jikan.moe/v3/search/anime?q=Naruto")!
        
        Webservice().getAnimes(url: url) { animes in
            
            if let animes = animes {
                
                self.animeListVM = AnimeListViewModel(animes: animes)
                
                DispatchQueue.main.async {
                    //Coredata
                    if self.saveAnimeInfo(){
                        self.save(animeList: self.animeListVM)
                    }
                    self.animeCollectionView.reloadData()
                }
            }
        }
    }
    
    private func offlineSetup() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Result")
        
        do {
          results = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(animeList: AnimeListViewModel) {
        
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      let managedContext = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Result", in: managedContext)!
      
        for anime in animeList.animes {
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(anime.title, forKeyPath: "title")
            person.setValue(anime.type, forKeyPath: "type")
            person.setValue(anime.synopsis, forKeyPath: "synopsis")
            person.setValue(anime.score, forKeyPath: "score")
            person.setValue(anime.episodes, forKeyPath: "episodes")

            let url = URL(string: anime.image_url)
            let data = try? Data(contentsOf: url!)
            let imageData = UIImage(data: data!)?.jpegData(compressionQuality: 1.0)
            person.setValue(imageData, forKeyPath: "image")
            
              do {
                try managedContext.save()
                results.append(person)
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "animedetails" {
            let animeDetailsViewController = segue.destination as! AnimeDetailsViewController
            animeDetailsViewController.animeListVM = self.selectedAnimeDetails
        }
    }
    
    private func saveAnimeInfo() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return true
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Result")
        
        do {
          results = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        if results.count > 0 {
            return false
        }else{
            return true
        }
    }
}

extension AnimeListCollectionViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if Reachability.isConnectedToNetwork(){
            if let animeList = self.animeListVM {
                return animeList.numberOfRowsInSection(section)
            }else{
                return 0
            }
        }else{
            
            return results.count
        }
        //Coredata
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeTableViewCell", for: indexPath) as? AnimeCollectionViewCell else {
            fatalError("AnimeTableViewCell not found")
        }
       if Reachability.isConnectedToNetwork(){
        let animeVM = self.animeListVM.animeAtIndex(indexPath.row)

        cell.titleLabel.text = animeVM.title

        let queue = DispatchQueue(label: "queuename", attributes: .concurrent)

              queue.async() { () -> Void in
                  let url = URL(string: animeVM.imageUrl)
                  let data = try? Data(contentsOf: url!)

                  DispatchQueue.main.async {
                    cell.animeImage.image = UIImage(data: data!)

                  }
              }

       }else{
        //CoreData
        cell.titleLabel.text = (results[indexPath.row].value(forKey: "title") as! String)
        cell.animeImage.image = UIImage(data:(results[indexPath.row].value(forKey: "image") as! Data))
        }
        
        return cell
    }

}

extension AnimeListCollectionViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAnimeDetails = self.animeListVM.animeAtIndex(indexPath.row)
        self.performSegue(withIdentifier: "animedetails", sender: nil)
    }
}
