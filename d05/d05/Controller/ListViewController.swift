//
//  ListViewController.swift
//  d05
//
//  Created by Audrey ROEMER on 4/2/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit
import MapKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ListTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Place.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! TableViewCell
        let place = Place.places[indexPath.row]
        cell.place = place
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.selectedIndex = 0;
        let controller = self.tabBarController?.selectedViewController as! MapViewController
        controller.centerMapOnLocation(location: Place.places[indexPath.row].coordinate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

