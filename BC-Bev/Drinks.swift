//
//  Drinks.swift
//  BC-Bev
//
//  Created by Chris Bond on 4/30/22.
//

import Foundation

class Drinks {
    
    struct Returned: Codable {
        var drinks: [Drink]
    }
    let alphabet = ["A", "B", "C","D","E","F","G", "H", "I", "J","K","L","M","N","O","P","Q","R","S", "T", "U", "V", "W", "X", "Y","Z"]
    var alphabetIndex = 0

    
    var drinkArray: [Drink] = []
    
    let urlBase = "https://thecocktaildb.com/api/json/v1/1/search.php?f="
    var urlString = ""
    var isFetching = false
    
    
    
    
    func getData(completed: @escaping () -> ()) {
        guard !isFetching else {
            print("Didnt Call hadnt fetched")
            completed()
            return
        }
        
        isFetching = true
        
        urlString = urlBase + alphabet[alphabetIndex]
        
        print("🕸🕸 We are accessing the url \(urlString)")
        
        alphabetIndex += 1
        
        guard let url = URL(string: urlString) else {
            print("🤬 ERROR: Couldn't create a URL from \(urlString)")
            isFetching = false
            completed()
            return
        }
        
        //Create Session
        let session = URLSession.shared
        
        //get data with .datatask method
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("🤬 ERROR: \(error.localizedDescription)")
            }
            //deal with data
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                self.drinkArray = self.drinkArray + returned.drinks
            } catch {
                print("🤬 JSON ERROR: \(error.localizedDescription)")
            }
            self.isFetching = false
            completed()
        }
        task.resume()
    }
    
    
}
