//
//  Anime.swift
//  MyAnimeList
//
//  Created by Rajkumar Gurunathan on 01/12/20.
//  Copyright © 2020 Rajkumar Gurunathan. All rights reserved.
//

import Foundation

struct AnimeList: Decodable {
    let results: [Anime]
}

struct Anime: Decodable {
    let title: String
    let image_url: String
    let synopsis: String
    let type: String
    let score: Float
    let episodes: Int
}
