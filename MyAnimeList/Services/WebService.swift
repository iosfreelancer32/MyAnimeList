//
//  WebService.swift
//  MyAnimeList
//
//  Created by Rajkumar Gurunathan on 01/12/20.
//  Copyright © 2020 Rajkumar Gurunathan. All rights reserved.
//

import Foundation

class Webservice {
    
    func getAnimes(url: URL, completion: @escaping ([Anime]?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                
                let animeList = try? JSONDecoder().decode(AnimeList.self, from: data)
                
                if let animeList = animeList {
                    completion(animeList.results)
                }
                
            }
            
        }.resume()
        
    }
    
}
