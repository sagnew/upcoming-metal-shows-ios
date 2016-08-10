//
//  ViewController.swift
//  UpcomingMetalShows
//
//  Created by Sam Agnew on 7/25/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit
import Kanna
import Alamofire


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var html: String? = nil
    var shows: [Show] = []
    
    let showConcertInfoSegueIdentifier = "ShowConcertInfoSegue"
    let textCellIdentifier = "ShowCell"
    
    @IBOutlet var metalShowTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        metalShowTableView.delegate = self
        metalShowTableView.dataSource = self
        gatherMetalShows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gatherMetalShows() -> Void {
        Alamofire.request(.GET, "http://nycmetalscene.com").responseString { response in
            print("Success: \(response.result.isSuccess)")
            self.html = response.result.value
            self.parseHTML(response.result.value!)
            
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            shows = []
            
            // Search for nodes by CSS
            for show in doc.css("td[id^='Text']") {
                
                // Get the link associated with this show.
                let link = show.css("a").first?["href"]
                
                // Strip the string of surrounding whitespace.
                let showString = show.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                if showString.characters.count > 2 {
                    // All text involving shows on this page currently start with the weekday.
                    // Weekday formatting is inconsistent, but the first three letters are always there.
                    let regex = try! NSRegularExpression(pattern: "^(mon|tue|wed|thu|fri|sat|sun)", options: [.CaseInsensitive])
                    
                    if regex.firstMatchInString(showString, options: [], range: NSMakeRange(0, showString.characters.count)) != nil {
                        let showSplit = showString.componentsSeparatedByString(":")
                        let date = showSplit[0]
                        
                        let venueSplit = showSplit.last!.componentsSeparatedByString(" at ")
                        var venue = ""
                        
                        let trimCharacterSet = NSMutableCharacterSet()
                        trimCharacterSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        trimCharacterSet.addCharactersInString("-")
                        
                        if venueSplit.count > 1 {
                            venue = venueSplit.last!.stringByTrimmingCharactersInSet(trimCharacterSet)
                        }
                        
                        let description = venueSplit[0].stringByTrimmingCharactersInSet(trimCharacterSet)
                        
                        print(showString + "\n")
                        if link != nil {
                            shows.append(Show(date: date, description: description, venue: venue, link: link!))
                        } else {
                            shows.append(Show(date: date, description: description, venue: venue, link: ""))
                        }
                        
                    }
                }
            }
            
            self.metalShowTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue time")
        if  segue.identifier == showConcertInfoSegueIdentifier,
            let destination = segue.destinationViewController as? ShowWebViewController,
            showIndex = metalShowTableView.indexPathForSelectedRow?.row {
            
            destination.url = shows[showIndex].link
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // pass any object as parameter, i.e. the tapped row
        performSegueWithIdentifier(showConcertInfoSegueIdentifier, sender: indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        let show = shows[row]
        
        cell.detailTextLabel?.text = show.date + "\n" + show.venue
        cell.textLabel?.text = show.description
        
        return cell
    }

}