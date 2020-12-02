//
//  AnimeDetailsTableViewController.swift
//  MyAnimeList
//
//  Created by Rajkumar Gurunathan on 02/12/20.
//  Copyright © 2020 Rajkumar Gurunathan. All rights reserved.
//

import UIKit

class AnimeDetailsViewController: UIViewController {
    
    @IBOutlet weak var animeTitleLabel: UILabel!
    @IBOutlet weak var animePoster: UIImageView!
    @IBOutlet weak var animeSynopsys: UILabel!
    @IBOutlet weak var animeTypeLbl: UILabel!
    @IBOutlet weak var animeScoreLbl: UILabel!
    @IBOutlet weak var animeEpisodesLbl: UILabel!
    var animeListVM: AnimeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(animeListVM.title) Details"
        animeTitleLabel.text = animeListVM.title
        animeSynopsys.text = animeListVM.synopsis
        animeTypeLbl.text = "TYPE: \(animeListVM.type)"
        animeScoreLbl.text = "SCORE: \(animeListVM.score)"
        animeEpisodesLbl.text = "EPISODES: \(animeListVM.episodes)"
        let url = URL(string: animeListVM.imageUrl)
        let data = try? Data(contentsOf: url!)
        animePoster.image = UIImage(data: data!)
        
    }

    // MARK: - Table view data source

    

}
