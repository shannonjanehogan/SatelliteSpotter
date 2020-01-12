//
//  DetailsTableViewController.swift
//  SatelliteSpotter
//
//  Created by Reginald McDonald  on 2020-01-11.
//  Copyright © 2020 Reginald McDonald . All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var satelliteId: UILabel!
    
    @IBOutlet weak var countryOfOrigin: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var launchVehicle: UILabel!
    @IBOutlet weak var users: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    var satellite: Satellite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFeatures()
//        self.nameLabel.text = satellite!.name!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    func fillFeatures() {
        if let sat = satellite {
            if let satelliteName = sat.name {
                self.nameLabel.text = satelliteName
            }
            if let countryOfOrigin = sat.countryOfOrigin {
                self.countryOfOrigin.text = countryOfOrigin
            }
            if let launchDate = sat.dateOfLaunch {
                self.launchDate.text = launchDate
            }
            if let launchVehicle = sat.launchVehicle {
                self.launchVehicle.text = launchVehicle
            }
            if let users = sat.users {
                self.users.text = users
            }
            if let comments = sat.comments {
                self.comments.text = comments
            }
            self.satelliteId.text = String(sat.noradId)
            
        }
    }

}
