//
//  ViewController.swift
//  BC-Bev
//
//  Created by Chris Bond on 4/30/22.
//

import UIKit

class ListViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
//    var drinks = ["Beer", "Moskow Mule", "jack and Coke"]
    var drinks = Drinks()
    var myDrinks: [String: String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        drinks.getData {
            DispatchQueue.main.async {
                self.navigationItem.title = "Drinks Shown: \(self.drinks.drinkArray.count)"
                self.tableView.reloadData()
            }
        }
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("myDrinks").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            myDrinks = try jsonDecoder.decode(Dictionary.self, from: data)
            tableView.reloadData()

        } catch {
            print("ERROR: Could not load Data \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("myDrinks").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(myDrinks)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: could not save data \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.drink = drinks.drinkArray[selectedIndexPath.row]
            destination.myDrinks = myDrinks
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        myDrinks = source.myDrinks
        saveData()
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.drinkArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row + 1 == drinks.drinkArray.count && drinks.alphabetIndex < drinks.alphabet.count {
            drinks.getData {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Drinks Shown: \(self.drinks.drinkArray.count)"
                    self.tableView.reloadData()
                }
            }
        }
        
        cell.textLabel?.text = "\(drinks.drinkArray[indexPath.row].strDrink)"
        let drinkName = drinks.drinkArray[indexPath.row].strDrink
        if let drinkRating = myDrinks[drinkName] {
            cell.detailTextLabel?.text = drinkRating
        } else {
            cell.detailTextLabel?.text = "-"
        }
        return cell
    }
    
    
    
}

