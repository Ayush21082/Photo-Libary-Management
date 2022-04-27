//
//  AlbumViewController.swift
//  Photo Libary Management
//
//  Created by Ayush Singh on 27/04/22.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    
    let cellReuseIdentifier = "cell"
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        


        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        
        cell.textLabel?.text = timeData[indexPath.row]
        cell.imageView?.image = albumImages[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

