//
//  Show.swift
//  UpcomingMetalShows
//
//  Created by Sam Agnew on 8/8/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import Foundation

struct Show {
    var date: String = ""
    var description: String = ""
    var venue: String = ""
    var link: String = ""
    
    init(date: String, description: String, venue: String, link: String) {
        self.date = date
        self.description = description
        self.venue = venue
        self.link = link
    }
}
