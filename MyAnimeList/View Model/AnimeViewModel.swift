//
//  AnimeViewModel.swift
//  MyAnimeList
//
//  Created by Rajkumar Gurunathan on 01/12/20.
//  Copyright © 2020 Rajkumar Gurunathan. All rights reserved.
//

import Foundation

struct AnimeListViewModel {
    let animes: [Anime]
}

extension AnimeListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.animes.count
    }
    
    func animeAtIndex(_ index: Int) -> AnimeViewModel {
        let anime = self.animes[index]
        return AnimeViewModel(anime)
    }
    
}

struct AnimeViewModel {
    private let anime: Anime
}

extension AnimeViewModel {
    init(_ anime: Anime) {
        self.anime = anime
    }
}

extension AnimeViewModel {
    
    var title: String {
        return self.anime.title
    }
    var imageUrl: String {
        return self.anime.image_url
    }
    var synopsis: String {
        return self.anime.synopsis
    }
    var type: String {
        return self.anime.type
    }
    var score: Float {
        return self.anime.score
    }
    var episodes: Int {
        return self.anime.episodes
    }
}

