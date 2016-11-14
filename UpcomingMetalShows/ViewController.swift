//
//  ViewController.swift
//  UpcomingMetalShows
//
//  Created by Sam Agnew on 7/25/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var shows: [String] = []
    
    let textCellIdentifier = "ShowCell"
    
    @IBOutlet var metalShowTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        metalShowTableView.delegate = self
        metalShowTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        return cell
    }

}
